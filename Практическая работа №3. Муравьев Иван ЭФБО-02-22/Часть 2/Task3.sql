-- Триггер: Проверка паспортных данных риэлторов

-- 1. Добавление колонки для паспортных данных
ALTER TABLE realtor
ADD COLUMN passport_data VARCHAR(15);

-- 2. Функция проверки формата паспортных данных
CREATE OR REPLACE FUNCTION passport_check()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.passport_data !~ '^[0-9]{4} [0-9]{6}$' THEN
        RAISE EXCEPTION 'Некорректный формат паспортных данных: %.', NEW.passport_data;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Триггер для проверки паспортных данных
CREATE TRIGGER passport_check
BEFORE INSERT OR UPDATE ON realtor
FOR EACH ROW
EXECUTE FUNCTION passport_check();

-- 4. Пример вставки данных о риэлторе
INSERT INTO realtor (realtor_id, passport_data)
VALUES (101, '1234 567890');