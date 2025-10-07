create database academic_stress_project;
use academic_stress_project;
select * from academic_stress_table;

# Average stress level by academic stage
select your_academic_stage as Academic_stage, round(avg(academic_stress_index_rate),2) as Average_academic_stress
from academic_stress_table group by Academic_stage order by Average_academic_stress desc;

# Stress vs study environment
select study_environment, count(*) as Student_count, round(avg(academic_stress_index_rate),2) as Average_stress_level
from academic_stress_table group by study_environment order by Average_stress_level desc;

# Top coping strategies used
select coping_strategy, count(*) as Strategy_usage
from academic_stress_table group by coping_strategy
order by Strategy_usage desc;

# Peer pressure vs stress correlation
select peer_pressure, round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by peer_pressure order by peer_pressure;

# Impact of academic competition on stress
select academic_competition_in_student_life_rate as Competition_level,
round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table
group by academic_competition_in_student_life_rate
order by Competition_level;

# Stress level of drinkers/smokers vs non users
select smoking_or_drinking_on_daily_basis, count(*) as Student_count,
round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by smoking_or_drinking_on_daily_basis;

# Highest stress coping strategies
select coping_strategy, round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by coping_strategy order by Average_stress desc;

# Correlation between home pressure and stress
select academic_pressure_at_home, round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by academic_pressure_at_home order by academic_pressure_at_home;

# Stress trend over time
select date(str_to_date(timestamp, '%d/%m/%Y %H:%i:%s')) as response_date,
round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by response_date order by response_date;

# Students facing extreme stress
select your_academic_stage, count(*) as High_stress_students
from academic_stress_table where academic_stress_index_rate>=4
group by your_academic_stage order by High_stress_students desc;

# Categorizing students into stress groups
select case
when academic_stress_index_rate <=2 then 'low stress'
when academic_stress_index_rate between 3 and 4 then 'medium stress'
else 'high stress'
end as Stress_group, count(*) as Student_count
from academic_stress_table group by Stress_group
order by Student_count desc;

# Multi factor stress impact
select peer_pressure, academic_pressure_at_home, academic_competition_in_student_life_rate,
round(avg(academic_stress_index_rate),2) as Average_stress, count(*) as Student_count
from academic_stress_table
group by peer_pressure, academic_pressure_at_home, academic_competition_in_student_life_rate
order by Average_stress desc;

# Risky combinations with health as a factor
select your_academic_stage, smoking_or_drinking_on_daily_basis,
round(avg(academic_stress_index_rate),2) as Average_stress, count(*) as Student_count
from academic_stress_table where academic_stress_index_rate>=4
group by your_academic_stage, smoking_or_drinking_on_daily_basis
order by Average_stress desc;

# Study environment vs coping strategy effectiveness
select study_environment, coping_strategy,
round(avg(academic_stress_index_rate),2) as Average_stress, count(*) as Student_count
from academic_stress_table group by study_environment, coping_strategy
order by Average_stress desc;

# Stress distribution across academic stages
select your_academic_stage,
sum(case when academic_stress_index_rate<=2 then 1 else 0 end) as Low_stress,
sum(case when academic_stress_index_rate between 3 and 4 then 1 else 0 end) as Medium_stress,
sum(case when academic_stress_index_rate>=5 then 1 else 0 end) as High_stress
from academic_stress_table group by your_academic_stage;

# Coping strategies by high-stress students
select coping_strategy, count(*) as High_stress_students
from academic_stress_table
where academic_stress_index_rate>=4
group by coping_strategy
order by High_stress_students desc;

# Factor with strongest impact
select 'Peer Pressure' as Factor,
	stddev(academic_stress_index_rate) as stress_variability
from academic_stress_table
group by peer_pressure
union
select 'Academic Pressure at Home',
	stddev(academic_stress_index_rate)
from academic_stress_table
group by academic_pressure_at_home
union
select 'Competition in Student Life',
	stddev(academic_stress_index_rate)
from academic_stress_table
group by academic_competition_in_student_life_rate
order by stress_variability desc;

# Early warning - students with all pressures >=4
select your_academic_stage, count(*) as Critical_students
from academic_stress_table where peer_pressure>=4
and academic_pressure_at_home>=4
and academic_competition_in_student_life_rate>=4
group by your_academic_stage
order by Critical_students desc;

# Stress index vs each factor
select peer_pressure, academic_pressure_at_home, academic_competition_in_student_life_rate,
round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table
group by peer_pressure, academic_pressure_at_home, academic_competition_in_student_life_rate
having count(*)>2
order by Average_stress desc;

# Time based stress trends with environment filter
select date(str_to_date(timestamp, '%d/%m/%Y %H:%i:%s')) as response_date,
study_environment, round(avg(academic_stress_index_rate),2) as Average_stress,
count(*) as responses from academic_stress_table
group by response_date, study_environment
order by response_date, Average_stress desc;

# Coping strategies used by at least 25 students
select coping_strategy, count(*) as Usage_count, round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by coping_strategy
having count(*)>25
order by Usage_count desc;

# Study environments with average stress more than equal to 4
select study_environment, count(*) as Student_count, round(avg(academic_stress_index_rate),2) as Average_stress
from academic_stress_table group by study_environment having avg(academic_stress_index_rate)>=4
order by Average_stress desc;

# Rank students by stress within each academic index
select your_academic_stage, timestamp, academic_stress_index_rate,
rank() over(partition by your_academic_stage order by academic_stress_index_rate desc) as Stress_rank
from academic_stress_table;

# Average stress compared to stage average
select your_academic_stage, timestamp, academic_stress_index_rate, avg(academic_stress_index_rate)
over (partition by your_academic_stage) as Stage_average_stress from academic_stress_table
order by your_academic_stage, academic_stress_index_rate desc;

# Running average stress per environment
select study_environment, date(str_to_date(timestamp, '%d/%m/%Y %H:%i:%s')) as response_date,
academic_stress_index_rate, avg(academic_stress_index_rate) over (partition by study_environment
order by str_to_date(timestamp, '%d/%m/%Y %H:%i:%s') rows between 3 preceding and current row) as Moving_Average_Stress
from academic_stress_table;

# Top coping strategy per academic stage top 3
select * from (select your_academic_stage, coping_strategy, count(*) as Usage_count,
rank() over (partition by your_academic_stage order by count(*) desc) as Strategy_rank
from academic_stress_table group by your_academic_stage, coping_strategy) t
where Strategy_rank <= 3;

# Competition ranking within academic stage
select your_academic_stage, timestamp, academic_competition_in_student_life_rate,
dense_rank() over (partition by your_academic_stage order by academic_competition_in_student_life_rate desc)
as Competition_rank from academic_stress_table;

# Academic stages where at least one student is in the top 10% stress level
with RankedStress as (select your_academic_stage, timestamp, academic_stress_index_rate, percent_rank() over(
partition by your_academic_stage order by academic_stress_index_rate desc) as Stress_percentile
from academic_stress_table)
select your_academic_stage, count(*) as high_stress_students from RankedStress where Stress_percentile>=0.9
group by your_academic_stage having count(*)>0
order by high_stress_students desc;

# Stored Procedure
delimiter $$

create procedure GetTopCopingStrategies(in stress_threshold int, in top_limit int)
begin
	select coping_strategy,
		count(*) as Strategy_usage,
        round(avg(academic_stress_index_rate),2) as Average_stress
	from academic_stress_table
	where academic_stress_index_rate >= stress_threshold
	group by coping_strategy
	order by Strategy_usage desc
	limit top_limit;
end$$

delimiter ;

# Stored procedure 2
delimiter $$

create procedure CompareStressByStage(in stage_name varchar(50))
begin
	select your_academic_stage,
		count(*) as student_count,
        round(avg(academic_stress_index_rate),2) as Average_stress,
        round(avg(peer_pressure),2) as Average_peer_pressure,
        round(avg(academic_pressure_at_home),2) as Average_academic_pressure_home,
        round(avg(academic_competition_in_student_life_rate),2) as Average_competition
	from academic_stress_table
    where your_academic_stage = stage_name
    group by your_academic_stage;
end$$

delimiter ;