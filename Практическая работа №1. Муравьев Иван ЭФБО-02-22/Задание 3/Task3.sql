-- DROP FUNCTION public."1.1.3select_price_dynamic"();

CREATE OR REPLACE FUNCTION public."1.1.3select_price_dynamic"()
 RETURNS TABLE(
 	change_date timestamp without time zone,
 	new_price real,
 	price_change real,
 	change_percent real,
 	warning text
 )
 LANGUAGE plpgsql
AS $function$
begin
    return QUERY 
    select pd.change_date,
		   pd.new_price, 
           pd.new_price - re.price::real as price_change,
           (((pd.new_price - re.price) / re.price) * 100)::real as change_percent,
		case
           when ((pd.new_price - re.price) / re.price) * 100 > 20 then 'Цена изменилась более чем на 20%'
           else ''
       END AS warning
    from price_dynamic pd
    join real_estate re on pd.real_estate_id = re.real_estate_id;
end;
$function$
;
