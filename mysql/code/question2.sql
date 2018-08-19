# sql scirpt for question 2
# by Wenbo Ma

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