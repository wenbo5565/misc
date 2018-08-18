select user_id,date
from
	(select user_id,date,
	row_number() over (partition by user_id order by date) as purchase_time
	from q3) tmp
where purchase_time = 10
order by user_id;