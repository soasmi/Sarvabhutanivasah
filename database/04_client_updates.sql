-- Database Migration Script
-- IMPORTANT: Run this script in your Supabase SQL Editor to apply the client updates.

-- 1. Add 'Partial' to payment_status ENUM
-- Note: ALTER TYPE cannot run inside a transaction block in some Postgres versions, 
-- so it is executed independently.
ALTER TYPE public.payment_status ADD VALUE IF NOT EXISTS 'Partial';

DO $$
DECLARE
    v_b1_id UUID;
    v_b1_gf_id UUID;
    v_b2_id UUID;
BEGIN
    -- 2. Rename 'Gauri Sadan' to 'Building 1'
    UPDATE public.buildings 
    SET name = 'Building 1' 
    WHERE name = 'Gauri Sadan'
    RETURNING id INTO v_b1_id;

    -- If Building 1 exists, get Ground Floor ID and update rooms
    IF v_b1_id IS NOT NULL THEN
        SELECT id INTO v_b1_gf_id FROM public.floors WHERE building_id = v_b1_id AND floor_number = 0 LIMIT 1;
        
        IF v_b1_gf_id IS NOT NULL THEN
            -- Delete related records to prevent foreign key constraint errors
            DELETE FROM public.payment_transactions WHERE booking_id IN (
                SELECT id FROM public.bookings WHERE room_id IN (
                    SELECT id FROM public.rooms WHERE room_number IN ('G-1', 'G-2', 'G-3', 'G-4') AND floor_id = v_b1_gf_id
                )
            );
            
            DELETE FROM public.booking_status_history WHERE booking_id IN (
                SELECT id FROM public.bookings WHERE room_id IN (
                    SELECT id FROM public.rooms WHERE room_number IN ('G-1', 'G-2', 'G-3', 'G-4') AND floor_id = v_b1_gf_id
                )
            );

            DELETE FROM public.bookings WHERE room_id IN (
                SELECT id FROM public.rooms WHERE room_number IN ('G-1', 'G-2', 'G-3', 'G-4') AND floor_id = v_b1_gf_id
            );

            -- Delete G-1 to G-4
            DELETE FROM public.rooms WHERE room_number IN ('G-1', 'G-2', 'G-3', 'G-4') AND floor_id = v_b1_gf_id;
            
            -- Insert Hall-1 (if not exists)
            INSERT INTO public.rooms (id, floor_id, room_number, category, base_tariff)
            VALUES ('building_1_hall_1', v_b1_gf_id, 'Hall-1', 'Hall', 5000.00)
            ON CONFLICT (id) DO NOTHING;
        END IF;
    END IF;

    -- 3. Create 'Building 2' (Katyayani Sadan placeholder)
    IF NOT EXISTS (SELECT 1 FROM public.buildings WHERE name = 'Building 2') THEN
        INSERT INTO public.buildings (name, total_floors, svg_asset_name)
        VALUES ('Building 2', 0, 'building_2.svg')
        RETURNING id INTO v_b2_id;
    END IF;
END $$;

-- 4. Create Expenses Table
CREATE TABLE IF NOT EXISTS public.expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payee TEXT NOT NULL,
    purpose TEXT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    payment_mode public.payment_mode NOT NULL,
    created_by UUID NOT NULL REFERENCES public.user_profiles(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS on expenses
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can view expenses
CREATE POLICY "View expenses" ON public.expenses FOR SELECT USING (true);

-- Policy: Managers and Swami Ji can insert expenses
CREATE POLICY "Insert expenses" ON public.expenses FOR INSERT WITH CHECK (
    auth.uid() = created_by
);
