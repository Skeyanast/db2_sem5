-- DROP FUNCTION public."1.1.4square_diffs_check"();

CREATE OR REPLACE FUNCTION public."1.1.4square_diffs_check"()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
	invalid_address text;
	area_difference real;
begin
	for invalid_address, area_difference in
		select re.address,
			   re.area - (
				select sum(ps.area)
				from property_structure ps
				where ps.real_estate_id = re.real_estate_id
			   ) as area_difference
		from real_estate re
		where re.area <> (
			select sum(ps.area)
			from property_structure ps
			where ps.real_estate_id = re.real_estate_id
		)
	loop 
		raise notice 'Некорректная площадь для объекта по адресу %', invalid_address;
		raise notice 'Размер расхождения: %', area_difference;
	end loop;
	if not found then
		raise notice 'Некорректных площадей продажи объектов нет';
	end if;
end;

$function$
;