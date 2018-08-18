
**Question 1**

<img src = "https://github.com/wenbo5565/misc/blob/master/mysql/question/question1.PNG" width="70%" height="70%">

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

**Question 3**

<img src = "https://github.com/wenbo5565/misc/blob/master/mysql/question/question2.JPG" width="70%" height="70%">

```sql
select user_id,date
from
	(select user_id,date,
	row_number() over (partition by user_id order by date) as purchase_time
	from q3) tmp
where purchase_time = 10
order by user_id;
```
