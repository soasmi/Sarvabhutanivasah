-- Add room_svg_mapping table to store visual mappings
CREATE TABLE public.room_svg_mapping (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES public.buildings(id) ON DELETE CASCADE,
    room_id TEXT NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
    svg_element_index INTEGER NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(building_id, room_id),
    UNIQUE(building_id, svg_element_index)
);

-- Enable RLS
ALTER TABLE public.room_svg_mapping ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone authenticated can view mappings" ON public.room_svg_mapping FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Managers can manage mappings" ON public.room_svg_mapping FOR ALL USING (public.is_manager());

-- Trigger for updated_at
CREATE TRIGGER set_room_svg_mapping_updated_at BEFORE UPDATE ON public.room_svg_mapping FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Add to Realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.room_svg_mapping;
