-- DROP FUNCTION public."1.1.1adjust_building_prices"();

CREATE OR REPLACE FUNCTION public."1.1adjust_building_prices"()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_real_estate_id INTEGER;
    v_listing_date TIMESTAMP;
    v_avg_rating NUMERIC;
    v_current_price NUMERIC;
BEGIN
    FOR v_real_estate_id, v_listing_date, v_avg_rating, v_current_price IN
        SELECT re.real_estate_id, re.listing_date, AVG(ev.score), re.price
        FROM real_estate re
        JOIN evaluation ev ON re.real_estate_id = ev.real_estate_id
            GROUP BY re.real_estate_id, re.listing_date, re.price
    LOOP
        IF age(v_listing_date::DATE) > INTERVAL '6 months' AND v_avg_rating < 6 THEN
            UPDATE real_estate
            SET price = v_current_price * 0.95
            WHERE real_estate.real_estate_id = v_real_estate_id;
        END IF;
  
        IF age(v_listing_date::DATE) > INTERVAL '9 months' AND v_avg_rating < 5 THEN
            UPDATE real_estate
            SET price = v_current_price * 0.90
            WHERE real_estate.real_estate_id = v_real_estate_id;
        END IF;

        IF age(v_listing_date::DATE) > INTERVAL '12 months' AND v_avg_rating < 4 THEN
            UPDATE real_estate
            SET price = v_current_price * 0.80
            WHERE real_estate.real_estate_id = v_real_estate_id;
        END IF;
    END LOOP;
END;
$function$
;