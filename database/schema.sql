-- Sarvabhutanivasah Database Schema
-- Supabase PostgreSQL

-- Enable the btree_gist extension for our overlapping bookings exclusion constraint
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- 1. ENUMS
CREATE TYPE user_role AS ENUM ('Manager', 'Swami Ji');
CREATE TYPE booking_status AS ENUM ('Reserved', 'Checked-In', 'Checked-Out', 'Completed', 'Cancelled');
CREATE TYPE payment_status AS ENUM ('Paid', 'Unpaid');
CREATE TYPE payment_mode AS ENUM ('Cash', 'Online');

-- 2. TABLES

-- User Profiles (Linked to auth.users)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    role user_role NOT NULL DEFAULT 'Swami Ji',
    contact_number TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Buildings
CREATE TABLE public.buildings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    total_floors INTEGER NOT NULL,
    svg_asset_name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Floors
CREATE TABLE public.floors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES public.buildings(id) ON DELETE CASCADE,
    floor_number INTEGER NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Rooms
-- Note: SVG Room ID is used as the primary identifier (e.g., 'room_101') to link directly with SVG
CREATE TABLE public.rooms (
    id TEXT PRIMARY KEY, 
    floor_id UUID NOT NULL REFERENCES public.floors(id) ON DELETE CASCADE,
    room_number TEXT NOT NULL,
    category TEXT NOT NULL,
    base_tariff NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Guests
CREATE TABLE public.guests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    phone_number TEXT NOT NULL,
    identity_document_type TEXT,
    identity_document_number TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Bookings
CREATE TABLE public.bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id TEXT NOT NULL REFERENCES public.rooms(id),
    guest_id UUID NOT NULL REFERENCES public.guests(id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status booking_status NOT NULL DEFAULT 'Reserved',
    tariff_at_booking NUMERIC(10, 2) NOT NULL, -- Captured tariff
    total_amount NUMERIC(10, 2) NOT NULL,
    payment_status payment_status NOT NULL DEFAULT 'Unpaid',
    created_by UUID NOT NULL REFERENCES public.user_profiles(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_dates CHECK (check_out_date > check_in_date),
    -- Exclude overlapping active bookings for the same room
    CONSTRAINT no_overlapping_bookings EXCLUDE USING gist (
        room_id WITH =,
        daterange(check_in_date, check_out_date) WITH &&
    ) WHERE (status != 'Cancelled')
);

-- Booking Status History
CREATE TABLE public.booking_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,
    previous_status booking_status,
    new_status booking_status NOT NULL,
    changed_by UUID NOT NULL REFERENCES public.user_profiles(id),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Payment Transactions
CREATE TABLE public.payment_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES public.bookings(id) ON DELETE CASCADE,
    amount NUMERIC(10, 2) NOT NULL,
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_mode payment_mode NOT NULL,
    recorded_by UUID NOT NULL REFERENCES public.user_profiles(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Audit Logs
CREATE TABLE public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id),
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    old_data JSONB,
    new_data JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- App Settings
CREATE TABLE public.app_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by UUID REFERENCES public.user_profiles(id)
);


-- 3. ROW LEVEL SECURITY (RLS)

-- Enable RLS on all tables
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.buildings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.floors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- Helper function to check if current user is a Manager
CREATE OR REPLACE FUNCTION public.is_manager()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_profiles 
    WHERE id = auth.uid() AND role = 'Manager'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Policies for user_profiles
CREATE POLICY "Users can view their own profile and Managers can view all"
ON public.user_profiles FOR SELECT
USING (auth.uid() = id OR public.is_manager());

CREATE POLICY "Managers can insert/update user_profiles"
ON public.user_profiles FOR ALL
USING (public.is_manager())
WITH CHECK (public.is_manager());

-- General Policies for Swami Ji (Read-Only) and Manager (Full Access)

-- Buildings
CREATE POLICY "Anyone authenticated can view buildings" ON public.buildings FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage buildings" ON public.buildings FOR ALL USING (public.is_manager());

-- Floors
CREATE POLICY "Anyone authenticated can view floors" ON public.floors FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage floors" ON public.floors FOR ALL USING (public.is_manager());

-- Rooms
CREATE POLICY "Anyone authenticated can view rooms" ON public.rooms FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage rooms" ON public.rooms FOR ALL USING (public.is_manager());

-- Guests
CREATE POLICY "Anyone authenticated can view guests" ON public.guests FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage guests" ON public.guests FOR ALL USING (public.is_manager());

-- Bookings
CREATE POLICY "Anyone authenticated can view bookings" ON public.bookings FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage bookings" ON public.bookings FOR ALL USING (public.is_manager());

-- Booking Status History
CREATE POLICY "Anyone authenticated can view booking history" ON public.booking_status_history FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can insert booking history" ON public.booking_status_history FOR INSERT WITH CHECK (public.is_manager());

-- Payment Transactions
CREATE POLICY "Anyone authenticated can view payments" ON public.payment_transactions FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage payments" ON public.payment_transactions FOR ALL USING (public.is_manager());

-- Audit Logs (Append only for Managers, Read for Managers)
CREATE POLICY "Managers can view audit logs" ON public.audit_logs FOR SELECT USING (public.is_manager());
CREATE POLICY "Managers can insert audit logs" ON public.audit_logs FOR INSERT WITH CHECK (public.is_manager());

-- App Settings
CREATE POLICY "Anyone authenticated can view settings" ON public.app_settings FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage settings" ON public.app_settings FOR ALL USING (public.is_manager());


-- 4. REALTIME SETUP
-- Enable Realtime for relevant tables
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime;
COMMIT;
ALTER PUBLICATION supabase_realtime ADD TABLE public.buildings;
ALTER PUBLICATION supabase_realtime ADD TABLE public.floors;
ALTER PUBLICATION supabase_realtime ADD TABLE public.rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bookings;
ALTER PUBLICATION supabase_realtime ADD TABLE public.payment_transactions;


-- 5. TRIGGERS

-- Trigger to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_user_profiles_updated_at BEFORE UPDATE ON public.user_profiles FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER set_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
CREATE TRIGGER set_app_settings_updated_at BEFORE UPDATE ON public.app_settings FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Trigger for Audit Logging
CREATE OR REPLACE FUNCTION public.log_audit_event()
RETURNS TRIGGER AS $$
DECLARE
    v_old_data JSONB;
    v_new_data JSONB;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        v_old_data := to_jsonb(OLD);
        v_new_data := to_jsonb(NEW);
        INSERT INTO public.audit_logs (user_id, action, table_name, record_id, old_data, new_data)
        VALUES (auth.uid(), 'UPDATE', TG_TABLE_NAME, NEW.id::text, v_old_data, v_new_data);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := to_jsonb(OLD);
        INSERT INTO public.audit_logs (user_id, action, table_name, record_id, old_data)
        VALUES (auth.uid(), 'DELETE', TG_TABLE_NAME, OLD.id::text, v_old_data);
        RETURN OLD;
    ELSIF (TG_OP = 'INSERT') THEN
        v_new_data := to_jsonb(NEW);
        INSERT INTO public.audit_logs (user_id, action, table_name, record_id, new_data)
        VALUES (auth.uid(), 'INSERT', TG_TABLE_NAME, NEW.id::text, v_new_data);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Attach audit trigger to important tables
CREATE TRIGGER audit_bookings_trigger AFTER INSERT OR UPDATE OR DELETE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();
CREATE TRIGGER audit_payments_trigger AFTER INSERT OR UPDATE OR DELETE ON public.payment_transactions FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();
CREATE TRIGGER audit_guests_trigger AFTER INSERT OR UPDATE OR DELETE ON public.guests FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();
CREATE TRIGGER audit_settings_trigger AFTER INSERT OR UPDATE OR DELETE ON public.app_settings FOR EACH ROW EXECUTE FUNCTION public.log_audit_event();
