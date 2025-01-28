-- Триггер: Управление бонусами риэлторов

-- 1. Создание таблицы бонусов
CREATE TABLE bonuses (
    realtor_id INT PRIMARY KEY,
    total_bonus NUMERIC DEFAULT 0
);

-- 2. Функция для обновления бонуса риэлтора
CREATE OR REPLACE FUNCTION update_realtor_bonus()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM bonuses WHERE realtor_id = NEW.realtor_id) THEN
        UPDATE bonuses
        SET total_bonus = total_bonus + (NEW.sale_price * 0.05)
        WHERE realtor_id = NEW.realtor_id;
    ELSE
        INSERT INTO bonuses (realtor_id, total_bonus)
        VALUES (NEW.realtor_id, NEW.sale_price * 0.05);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Триггер для обновления бонуса
CREATE TRIGGER insert_bonus
AFTER INSERT ON sale
FOR EACH ROW
EXECUTE FUNCTION update_realtor_bonus();

-- 4. Пример вставки данных о продаже
INSERT INTO sale (sale_id, real_estate_id, sale_date, realtor_id, sale_price, realtor_commission)
VALUES (21, 31, '2024-06-02 12:00:00', 2, 1000000, 2.5);