-- 1 Функция определения категории спортсмена
CREATE OR REPLACE FUNCTION get_athlete_category(birth_date DATE)
RETURNS VARCHAR AS $$
DECLARE
    age INT;
BEGIN
    age := EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date));

    IF age <= 9 THEN RETURN 'Д-1 Дети I';
    ELSIF age BETWEEN 10 AND 11 THEN RETURN 'Д-2 Дети II';
    ELSIF age BETWEEN 12 AND 13 THEN RETURN 'Ю-1 Юниоры I';
    ELSIF age BETWEEN 14 AND 15 THEN RETURN 'Ю-2 Юниоры II';
    ELSIF age BETWEEN 16 AND 18 THEN RETURN 'М Молодежь';
    ELSIF age BETWEEN 19 AND 34 THEN RETURN 'ВЗ Взрослые';
    ELSE RETURN 'С Сеньоры';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 2. Функция форматирования полного имени в сокращенный вид
CREATE OR REPLACE FUNCTION format_full_name(full_name TEXT)
RETURNS TEXT AS $$
DECLARE
    parts TEXT[];
BEGIN
    parts := string_to_array(full_name, ' ');

    IF array_length(parts, 1) = 3 THEN
        RETURN parts[1] || ' ' || LEFT(parts[2], 1) || '.' || LEFT(parts[3], 1) || '.';
    ELSE
        RETURN '#############';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 3. Функция форматирования номера телефона в старндартизированный вид
CREATE OR REPLACE FUNCTION format_phone_number(phone_number TEXT)
RETURNS TEXT AS $$
DECLARE
    clean_number TEXT;
BEGIN
    clean_number := regexp_replace(phone_number, '\D', '', 'g');

    IF LENGTH(clean_number) = 11 THEN
        RETURN '8-' || SUBSTR(clean_number, 2, 3) || '-' || SUBSTR(clean_number, 5, 3) ||
               '-' || SUBSTR(clean_number, 8, 2) || '-' || SUBSTR(clean_number, 10, 2);
    ELSIF LENGTH(clean_number) = 10 THEN
        RETURN '8-' || SUBSTR(clean_number, 1, 3) || '-' || SUBSTR(clean_number, 4, 3) ||
               '-' || SUBSTR(clean_number, 7, 2) || '-' || SUBSTR(clean_number, 9, 2);
    ELSIF LENGTH(clean_number) = 7 THEN
        RETURN '8-XXX-' || SUBSTR(clean_number, 1, 3) || '-' || SUBSTR(clean_number, 4, 2) || '-' || SUBSTR(clean_number, 6, 2);
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;