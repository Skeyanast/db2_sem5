-- Триггер: Управление бонусами риэлторов
CREATE OR REPLACE FUNCTION manage_realtor_bonus()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF EXISTS (SELECT 1 FROM bonuses WHERE realtor_id = NEW.realtor_id) THEN
            UPDATE bonuses
            SET total_bonus = total_bonus + (NEW.sale_price * 0.05)
            WHERE realtor_id = NEW.realtor_id;
        ELSE
            INSERT INTO bonuses (realtor_id, total_bonus)
            VALUES (NEW.realtor_id, NEW.sale_price * 0.05);
        END IF;
    END IF;

    IF TG_OP = 'DELETE' THEN
        UPDATE bonuses
        SET total_bonus = total_bonus - (OLD.sale_price * 0.05)
        WHERE realtor_id = OLD.realtor_id;

        DELETE FROM bonuses WHERE total_bonus <= 0;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER insert_bonus
AFTER INSERT OR DELETE ON sale
FOR EACH ROW
EXECUTE FUNCTION manage_realtor_bonus();