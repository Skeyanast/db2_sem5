-- 1. Запрс спортсменов с их текущими тренерами и видами спорта
SELECT a.full_name AS athlete, c.full_name AS coach, s.name AS sport
FROM athletes a
JOIN coaches c ON a.current_coach_id = c.coach_id
JOIN sports s ON c.sport_id = s.sport_id
ORDER BY a.full_name;

-- 2. Запрос спортсменов, которые занимаются у одного тренера
SELECT a.full_name AS athlete, c.full_name AS coach
FROM athletes a
JOIN coaches c ON a.current_coach_id = c.coach_id
WHERE a.athlete_id NOT IN (SELECT athlete_id FROM previous_coaches);

-- 3. Запрос спортсменов, которые занимались разными видами спорта
SELECT DISTINCT a.full_name, s.name AS sport
FROM athletes a
JOIN previous_coaches pc ON a.athlete_id = pc.athlete_id
JOIN coaches c ON pc.coach_id = c.coach_id
JOIN sports s ON c.sport_id = s.sport_id;

-- 4. Запрос рейтингов тренеров
SELECT c.full_name AS coach, 
       ROUND((COUNT(CASE WHEN a.skill_level IN ('КМС', 'МС') THEN 1 END)::NUMERIC /
       COUNT(a.athlete_id))::NUMERIC, 2) AS coach_rating
FROM coaches c
LEFT JOIN athletes a ON c.coach_id = a.current_coach_id
GROUP BY c.full_name
ORDER BY coach_rating DESC;

-- 5. Запрос для вывода количества спортсменов для каждого вида спорта
SELECT s.name AS sport, COUNT(a.athlete_id) AS athlete_count
FROM sports s
LEFT JOIN coaches c ON s.sport_id = c.sport_id
LEFT JOIN athletes a ON c.coach_id = a.current_coach_id
GROUP BY s.name;