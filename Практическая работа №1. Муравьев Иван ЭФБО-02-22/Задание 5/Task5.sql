-- DROP FUNCTION public."1.1.5realtor_commission"();

CREATE OR REPLACE FUNCTION public."1.1.5realtor_commission"()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
	sales_price double precision;
begin
	for sales_price in
		select s.sale_price
		from sale s
		loop
			update sale
			set realtor_commission = sale_price * 0.02
			where sale_price < 1000000;

			update sale
			set realtor_commission = sale_price * 0.019
			where sale_price > 1000000 and sale_price < 3000000;

			update sale
			set realtor_commission = sale_price * 0.017
			where sale_price > 3000000;
		end loop;
end;

$function$
;
