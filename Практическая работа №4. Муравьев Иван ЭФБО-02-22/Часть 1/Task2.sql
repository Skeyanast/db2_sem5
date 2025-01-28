-- Триггер: Обновление статуса недвижимости
CREATE OR REPLACE FUNCTION update_real_estate_status()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE real_estate
        SET status = 0
        WHERE real_estate_id = NEW.real_estate_id;

    ELSIF TG_OP = 'DELETE' THEN
        UPDATE real_estate
        SET status = 1
        WHERE real_estate_id = OLD.real_estate_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для обновления статуса недвижимости
CREATE OR REPLACE TRIGGER update_real_estate_status_trigger
AFTER INSERT OR DELETE ON sale
FOR EACH ROW
EXECUTE FUNCTION update_real_estate_status();