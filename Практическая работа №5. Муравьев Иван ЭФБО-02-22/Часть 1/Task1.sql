-- Отношение "Виды спорта"
CREATE TABLE sports (
    sport_id SERIAL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    type VARCHAR(10) CHECK (type IN ('Индивидуальный', 'Парный')) NOT NULL
);

-- Отношение "Тренеры"
CREATE TABLE coaches (
    coach_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    sport_id INT REFERENCES sports(sport_id),
    skill_level VARCHAR(10) NOT NULL,
    current_rating INT CHECK (current_rating >= 0) DEFAULT 0
);

-- Отношение "Спортсмены"
CREATE TABLE athletes (
    athlete_id INT PRIMARY KEY,
    full_name VARCHAR(40) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('М', 'Ж')) NOT NULL,
    skill_level VARCHAR(10),
    current_coach_id INT REFERENCES coaches(coach_id),
    training_start_date DATE NOT NULL,
    current_rating INT DEFAULT 0 CHECK (current_rating >= 0),
    partner_id INT REFERENCES athletes(athlete_id),
    address VARCHAR(40) NOT NULL,
    mobile_phone VARCHAR(11),
    home_phone VARCHAR(11)
);

-- Отношение "Предыдущие тренеры"
CREATE TABLE previous_coaches (
    record_id SERIAL PRIMARY KEY,
    coach_id INT REFERENCES coaches(coach_id),
    athlete_id INT REFERENCES athletes(athlete_id),
    training_start_date DATE NOT NULL
);