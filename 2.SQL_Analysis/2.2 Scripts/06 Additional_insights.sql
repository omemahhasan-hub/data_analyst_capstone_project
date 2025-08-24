use capstone;
-- female/male count
select 
(select count(*) from master_table) as total_emp,
(select count(*) from master_table where sex = 'Female' ) as fem_count,
(select count(*) from master_table where sex = 'Male' ) as male_count;



-- marital status of employees
select 
(select count(*) from master_table) as total_emp,
((select count(*) from master_table where Marital_status = 'Married' )/ 299 ) * 100 as married,
(select count(*) from master_table where Marital_status = 'Single' ) as single,
(select count(*) from master_table where Marital_status = 'Divorced' ) as divorced;



-- race distribution
select distinct(RaceDesc) as race, count(*) as total from master_table
group by race
order by total desc;



-- pay range percentage 
select distinct(pay_equity_status) as pay_range, count(*) as total, round((count(*)/299) *100 ,1) as percet
from master_table
group by pay_range



-- citizenship
select count(*) as us_citizen from master_table 
group by CitizenDesc
having CitizenDesc='US Citizen'
