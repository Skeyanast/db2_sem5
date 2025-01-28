-- Триггер: Проверка разницы в цене
CREATE OR REPLACE FUNCTION difference_attention()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT ABS(price - NEW.sale_price) / price * 100 
        FROM real_estate 
        WHERE real_estate_id = NEW.real_estate_id) > 20 THEN
        RAISE NOTICE 'Разница между заявленной и продажной стоимостью более 20%%';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create or replace TRIGGER difference_attention
AFTER INSERT ON sale
FOR EACH ROW
EXECUTE FUNCTION difference_attention();