-- Триггер: Логирование операций
CREATE TABLE journal (
    operation_time TIMESTAMP DEFAULT now(),
    operation_type VARCHAR(10),            
    user_name VARCHAR(50)                  
);

CREATE OR REPLACE FUNCTION log_sale_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO journal (operation_time, operation_type, user_name)
    VALUES (now(), TG_OP, current_user); -- Логируем пользователя

    RETURN NEW; -- Для AFTER триггера
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER log_sale_insert
AFTER INSERT OR UPDATE OR DELETE ON sale
FOR EACH ROW
EXECUTE FUNCTION log_sale_insert();

-- Пример вставки данных о продаже
INSERT INTO sale (sale_id, real_estate_id, sale_date, realtor_id, sale_price, realtor_commission)
VALUES (28, 29, '2024-06-02 12:00', 2, 1000000, 2.5);