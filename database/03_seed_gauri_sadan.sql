-- Seed script for Gauri Sadan Building, Floors, and Rooms
-- This script safely inserts the static layout provided.

DO $$
DECLARE
    v_building_id UUID;
    v_ground_floor_id UUID;
    v_first_floor_id UUID;
    v_second_floor_id UUID;
    i INT;
    v_room_id TEXT;
    v_room_num TEXT;
BEGIN
    -- 1. Create Building
    INSERT INTO public.buildings (name, total_floors, svg_asset_name)
    VALUES ('Gauri Sadan', 3, 'gauri_sadan.svg')
    RETURNING id INTO v_building_id;

    -- 2. Create Floors
    INSERT INTO public.floors (building_id, floor_number, name)
    VALUES (v_building_id, 0, 'Ground Floor')
    RETURNING id INTO v_ground_floor_id;

    INSERT INTO public.floors (building_id, floor_number, name)
    VALUES (v_building_id, 1, 'First Floor')
    RETURNING id INTO v_first_floor_id;

    INSERT INTO public.floors (building_id, floor_number, name)
    VALUES (v_building_id, 2, 'Second Floor')
    RETURNING id INTO v_second_floor_id;

    -- 3. Create Ground Floor Rooms (G-1 to G-4, 2 BED, 1200)
    FOR i IN 1..4 LOOP
        v_room_num := 'G-' || i;
        v_room_id := 'gauri_sadan_g' || i;
        INSERT INTO public.rooms (id, floor_id, room_number, category, base_tariff)
        VALUES (v_room_id, v_ground_floor_id, v_room_num, '2 BED', 1200.00);
    END LOOP;

    -- 4. Create First Floor Rooms (101 to 116, 6 BED, 1500)
    FOR i IN 101..116 LOOP
        v_room_num := i::TEXT;
        v_room_id := 'gauri_sadan_' || i;
        INSERT INTO public.rooms (id, floor_id, room_number, category, base_tariff)
        VALUES (v_room_id, v_first_floor_id, v_room_num, '6 BED', 1500.00);
    END LOOP;

    -- 5. Create Second Floor Rooms (201 to 216, 6 BED, 1500)
    FOR i IN 201..216 LOOP
        v_room_num := i::TEXT;
        v_room_id := 'gauri_sadan_' || i;
        INSERT INTO public.rooms (id, floor_id, room_number, category, base_tariff)
        VALUES (v_room_id, v_second_floor_id, v_room_num, '6 BED', 1500.00);
    END LOOP;

END $$;
