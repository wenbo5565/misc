
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

*Question 2**

<img src = "https://github.com/wenbo5565/misc/blob/master/mysql/question/question2.PNG" width="70%" height="70%">

```sql
# get distinct user_id from web
create table web
select distinct user_id as w_id
		from q2_web;
        
# get distinct user_id from mobile
create table mob
select distinct user_id as m_id
		from q2_mob;
        
# outer join web and mob
create table out_join
select * from web left join mob on w_id = m_id
union
select * from web right join mob on w_id = m_id;

# get percentage for web only, mobile only and both
select 
	100*sum(case when m_id is null then 1 else 0 end)/count(*) as web_only,
    sum(case when w_id is null then 1 else 0 end)/count(*) as mob_only,
    sum(case when m_id is not null and w_id is not null then 1 else 0 end)/count(*) as both_
from out_join;
```



**Question 3**

<img src = "https://github.com/wenbo5565/misc/blob/master/mysql/question/question3.PNG" width="70%" height="70%">

```sql
select user_id,date
from
	(select user_id,date,
	row_number() over (partition by user_id order by date) as purchase_time
	from q3) tmp
where purchase_time = 10
order by user_id;
```
