-- 1. Ограничение внешнего ключа
ALTER TABLE athletes
ADD CONSTRAINT fk_current_coach FOREIGN KEY (current_coach_id) REFERENCES coaches(coach_id);

-- 2. Функция проверки изменения текущего тренера спортсмена
CREATE OR REPLACE FUNCTION log_coach_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.current_coach_id <> OLD.current_coach_id THEN
        INSERT INTO previous_coaches (coach_id, athlete_id, training_start_date)
        VALUES (OLD.current_coach_id, OLD.athlete_id, OLD.training_start_date);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_coach_change
BEFORE UPDATE ON athletes
FOR EACH ROW EXECUTE FUNCTION log_coach_change();

-- 3. Функция автоматического увеличения рейтинга тренера на 20 при повышении уровня мастерства спортсмена
CREATE OR REPLACE FUNCTION increase_coach_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.skill_level > OLD.skill_level THEN
        UPDATE coaches
        SET current_rating = current_rating + 20
        WHERE coach_id = NEW.current_coach_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_increase_coach_rating
AFTER UPDATE ON athletes
FOR EACH ROW EXECUTE FUNCTION increase_coach_rating();

-- 4. Функция проверки условий перед вставкой или обновлением данных о спортсменах
CREATE OR REPLACE FUNCTION validate_athlete_fields()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.current_rating < 0 THEN
        RAISE EXCEPTION 'Рейтинг спортсмена не может быть отрицательным';
    END IF;

    IF NEW.gender NOT IN ('М', 'Ж') THEN
        RAISE EXCEPTION 'Пол спортсмена должен быть М или Ж';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_athlete_fields
BEFORE INSERT OR UPDATE ON athletes
FOR EACH ROW EXECUTE FUNCTION validate_athlete_fields();