-- Триггер: Форматирование контактного телефона
CREATE OR REPLACE FUNCTION format_contact_phone()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.contact_phone) = 11 AND NEW.contact_phone ~ '^[0-9]{11}$' THEN
        NEW.contact_phone := 
            '+7 (' || SUBSTRING(NEW.contact_phone FROM 2 FOR 3) || ') ' ||  
            SUBSTRING(NEW.contact_phone FROM 5 FOR 3) || ' ' ||
            SUBSTRING(NEW.contact_phone FROM 8 FOR 2) || ' ' ||
            SUBSTRING(NEW.contact_phone FROM 10 FOR 2);
    ELSE
        RAISE EXCEPTION 'Некорректный формат номера телефона: %', NEW.contact_phone;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера для форматирования номера телефона
CREATE TRIGGER format_contact_phone
BEFORE INSERT OR UPDATE ON realtor
FOR EACH ROW
EXECUTE FUNCTION format_contact_phone();