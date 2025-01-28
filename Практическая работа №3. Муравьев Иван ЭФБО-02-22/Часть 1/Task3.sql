-- Триггер: Проверка состояния недвижимости
CREATE OR REPLACE FUNCTION check_real_estate_status()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM sale WHERE real_estate_id = NEW.real_estate_id) THEN
        RAISE EXCEPTION 'Невозможно добавить продажу: объект недвижимости уже продан.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_real_estate_status
BEFORE INSERT ON sale
FOR EACH ROW
EXECUTE FUNCTION check_real_estate_status();