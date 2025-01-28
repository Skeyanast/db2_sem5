-- 1. Представление "Переходы спортсменов"
CREATE VIEW athlete_transitions AS
SELECT a.full_name AS athlete, c.full_name AS coach, s.name AS sport,
       pc.training_start_date AS start_date, 
       COALESCE(NULLIF(a.training_start_date, pc.training_start_date), 'по настоящее время') AS end_date
FROM athletes a
JOIN previous_coaches pc ON a.athlete_id = pc.athlete_id
JOIN coaches c ON pc.coach_id = c.coach_id
JOIN sports s ON c.sport_id = s.sport_id;

-- 2. Представление "Ошибки данных для парных видов спорта"
CREATE VIEW pair_sport_errors AS
SELECT a.athlete_id, a.full_name, a.partner_id, s.name AS sport
FROM athletes a
JOIN coaches c ON a.current_coach_id = c.coach_id
JOIN sports s ON c.sport_id = s.sport_id
WHERE s.type = 'Парный' AND 
      (a.partner_id IS NULL OR NOT EXISTS (
          SELECT 1 FROM athletes p WHERE p.athlete_id = a.partner_id AND p.partner_id = a.athlete_id
      ));

-- 3. Представление "Спортсмены без контактных данных"
CREATE VIEW athletes_without_contacts AS
SELECT athlete_id, full_name, address
FROM athletes
WHERE mobile_phone IS NULL AND home_phone IS NULL;


INSERT INTO sports (name, type)
VALUES
('Бокс', 'Индивидуальный'),
('Теннис', 'Парный'),
('Бадминтон', 'Парный'),
('Шахматы', 'Индивидуальный'),
('Фехтование', 'Индивидуальный');

INSERT INTO coaches (full_name, sport_id, skill_level, current_rating)
VALUES
('Иванов Петр Сергеевич', 1, 'МС', 95),
('Сидоров Алексей Иванович', 2, 'КМС', 80),
('Кузнецов Дмитрий Владимирович', 3, 'МС', 88),
('Петрова Елена Николаевна', 4, 'МСМК', 90),
('Федоров Василий Сергеевич', 5, 'КМС', 70);

INSERT INTO athletes (athlete_id, full_name, birth_date, gender, skill_level, 
                      current_coach_id, training_start_date, current_rating, 
                      partner_id, address, mobile_phone, home_phone)
VALUES
(100001, 'Смирнов Александр Игоревич', '2000-05-10', 'М', 'КМС', 1, '2020-01-15', 85, 100002, 'ул. Ленина 12', '89012345678', NULL),
(100002, 'Козлова Анна Сергеевна', '2002-03-22', 'Ж', 'МС', 1, '2019-11-10', 92, 100001, 'ул. Гагарина 8', NULL, '1234567'),
(100003, 'Иванов Сергей Петрович', '1998-07-15', 'М', '2 разряд', 2, '2018-02-20', 70, NULL, 'ул. Советская 3', '89098765432', NULL),
(100004, 'Васильева Мария Павловна', '2001-10-05', 'Ж', 'МС', 3, '2017-06-25', 88, NULL, 'ул. Победы 5', NULL, NULL),
(100005, 'Сидоров Виктор Дмитриевич', '1999-12-12', 'М', '1 разряд', 4, '2019-09-15', 76, 100006, 'ул. Калинина 7', '89123456789', NULL),
(100006, 'Соколова Ирина Александровна', '2000-04-18', 'Ж', '2 разряд', 4, '2019-09-15', 70, 100005, 'ул. Мира 14', NULL, '8765432');

INSERT INTO previous_coaches (coach_id, athlete_id, training_start_date)
VALUES
(2, 100001, '2018-01-01'),
(3, 100002, '2018-06-01'),
(4, 100003, '2017-09-01'),
(1, 100004, '2019-01-01'),
(5, 100005, '2020-03-01');


UPDATE athletes_without_contacts
SET mobile_phone = '12345678901'
WHERE athlete_id = 1;
