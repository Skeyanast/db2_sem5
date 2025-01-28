-- 1. Процедура вывода списка спортсменов с их тренерами и датой начала тренировок
CREATE OR REPLACE PROCEDURE list_athletes_and_coaches()
LANGUAGE plpgsql AS $$
BEGIN
    FOR record IN
        SELECT a.full_name AS athlete, c.full_name AS coach, a.training_start_date
        FROM athletes a
        JOIN coaches c ON a.current_coach_id = c.coach_id
    LOOP
        RAISE NOTICE '% - Тренер: % (Начало: %)', record.athlete, record.coach, record.training_start_date;
    END LOOP;
END;
$$;

-- 2. Процедура отображения пары спортсменов, занимающихся парными видами спорта
CREATE OR REPLACE PROCEDURE list_pair_athletes()
LANGUAGE plpgsql AS $$
BEGIN
    FOR record IN
        SELECT s.name AS sport, a1.full_name AS athlete1, a2.full_name AS athlete2, c.full_name AS coach
        FROM athletes a1
        JOIN athletes a2 ON a1.partner_id = a2.athlete_id
        JOIN coaches c ON a1.current_coach_id = c.coach_id
        JOIN sports s ON c.sport_id = s.sport_id
        WHERE s.type = 'Парный' AND a1.athlete_id < a2.athlete_id
    LOOP
        RAISE NOTICE '%: % - % (% тренер)', record.sport, record.athlete1, record.athlete2, record.coach;
    END LOOP;
END;
$$;

-- 3. Процедура обновления рейтинга тренеров на основе средней оценки их спортсменов
CREATE OR REPLACE PROCEDURE calculate_coach_ratings()
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE coaches c
    SET current_rating = (
        SELECT COALESCE(AVG(a.current_rating), 0)
        FROM athletes a
        WHERE a.current_coach_id = c.coach_id
          OR EXISTS (
              SELECT 1
              FROM previous_coaches pc
              WHERE pc.coach_id = c.coach_id
                AND pc.training_start_date >= CURRENT_DATE - INTERVAL '1 year'
                AND pc.athlete_id = a.athlete_id
          )
    );
END;
$$;