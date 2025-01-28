-- DROP FUNCTION public."1.1.2check_date"();

CREATE OR REPLACE FUNCTION public."1.1.2check_date"()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
	v_invalid_address text;
begin
	for v_invalid_address in
		select re.address
		from real_estate re 
		join sale s on re.real_estate_id = s.real_estate_id
		where s.sale_date < re.listing_date
	loop 
		raise notice 'Некорректная дата продажи для объекта по адресу %', v_invalid_address;
	end loop;
	
	if not found then
		raise notice 'Некорректных дат продажи объектов нет';
	end if;
end;
$function$
;
