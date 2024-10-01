-- DROP FUNCTION public.select_price_dynamic();

create or replace function public.select_price_dynamic()
RETURNS table (
	change_date timestamp,
	new_price real,
	price_change real,
	change_percent real,
	warning text
)
as $$
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
$$ language plpgsql;

select * from public.select_price_dynamic();
