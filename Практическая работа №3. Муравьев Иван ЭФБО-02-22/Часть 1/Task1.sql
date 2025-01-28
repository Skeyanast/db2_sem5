-- Триггер: Обновление статуса нежвижимости
CREATE OR REPLACE FUNCTION update_real_estate_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE real_estate
    SET status = 0
    WHERE real_estate_id = NEW.real_estate_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_sale_insert
AFTER INSERT ON sale
FOR EACH ROW
EXECUTE FUNCTION update_real_estate_status();