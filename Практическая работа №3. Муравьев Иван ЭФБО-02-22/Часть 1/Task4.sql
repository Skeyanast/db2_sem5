CREATE OR REPLACE FUNCTION check_area()
RETURNS TRIGGER AS $$
DECLARE
    total_room_area NUMERIC; --Сумма площадей всех комнат
    total_property_area NUMERIC; --Общая площадь объекта недвижимости
    area_difference NUMERIC;
BEGIN
    SELECT COALESCE(SUM(area), 0) 
    INTO total_room_area
    FROM property_structure
    WHERE real_estate_id = NEW.real_estate_id;

    --Добавляем площадь новой комнаты из вставляемой записи
    total_room_area := total_room_area + NEW.area;
    SELECT area INTO total_property_area
    FROM real_estate
    WHERE real_estate_id = NEW.real_estate_id;
    IF total_room_area > total_property_area THEN
        area_difference := total_room_area - total_property_area;
        RAISE NOTICE 'Превышение общей площади на % м²', area_difference;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_area
BEFORE INSERT ON property_structure
FOR EACH ROW
EXECUTE FUNCTION check_area();