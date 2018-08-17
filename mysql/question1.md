Question 1

<img src = "https://github.com/wenbo5565/misc/blob/master/mysql/question/question1.PNG" width="60%" height="60%">

```sql
select user_id, previous_time
from
	(select user_id, time_stamp,
	LAG(time_stamp,1) over (partition by user_id order by time_stamp) as previous_time,
	row_number() over (partition by user_id order by time_stamp desc) as order_desc
	from q1) tmp
where order_desc = 1
order by user_id
limit 10;
```
