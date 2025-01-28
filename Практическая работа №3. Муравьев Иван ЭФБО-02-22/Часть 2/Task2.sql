-- Триггер: Проверка лимита бонуса

-- 1. Функция проверки лимита бонуса
CREATE OR REPLACE FUNCTION check_bonus_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT total_bonus FROM bonuses WHERE realtor_id = NEW.realtor_id) > 300000 THEN
        RAISE NOTICE 'Бонус риэлтора % превысил 300000 рублей!', NEW.realtor_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Триггер для проверки лимита бонуса
CREATE TRIGGER check_bonus_limit
AFTER INSERT ON sale
FOR EACH ROW
EXECUTE FUNCTION check_bonus_limit();