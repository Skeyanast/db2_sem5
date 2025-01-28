-- Задание 2: Журналирование изменений цен на объекты недвижимости
CREATE TABLE price_history (
    change_date TIMESTAMP DEFAULT now(),
    real_estate_id INT,       
    new_price NUMERIC,           
    PRIMARY KEY (change_date, real_estate_id)
);

CREATE OR REPLACE FUNCTION log_price_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO price_history (change_date, real_estate_id, new_price)
        VALUES (now(), NEW.real_estate_id, NEW.price);

    ELSIF TG_OP = 'UPDATE' AND NEW.price IS DISTINCT FROM OLD.price THEN
        INSERT INTO price_history (change_date, real_estate_id, new_price)
        VALUES (now(), NEW.real_estate_id, NEW.price);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_price_changes
AFTER INSERT OR UPDATE ON real_estate
FOR EACH ROW
EXECUTE FUNCTION log_price_changes();