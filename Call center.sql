-- MySQL data cleaning and analysis using dataset from Real World Fake Data 

-- Create a database before importing the data, or may load into existing database

Create database dataproject2

Use dataproject2;

-- create table that will contain the csv file to be imported/used

Create table call_center (
	ID char(50),
    customer_name char (50),
    sentiment char (20),
    csat_score varchar(5),
    call_timestamp char(10),
    reason char(20),
    city char(25),
    state char(20),
    channel char(20),
    response_time char(20),
    call_duration_minutes INT,
    call_center char(20)
    
);

-- Check imported tables using below

select * from call_center;

-- time to clean the data
-- call_timestamp was stored as string char() datatype because in the excel file, it was stored in MM/DD/YYYY format, while the default format in MySQL is YYYY-mm-dd.
-- csat_score was imported as TEXT to make sure rows with null data are imported as well.

-- changing date format
Set sql_safe_updates = 0;
Update call_center set call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");
Set sql_safe_updates = 1;

-- manipulating empty cells

set sql_safe_updates = 0;
update call_center set csat_score = 0 where csat_score = '';
set sql_safe_updates = 1;

-- checking updated table

select * from call_center LIMIT 10;

select customer_name from call_center where csat_score = 0;

-- --------------------------------------------------------------------------------- --
-- --------------------------- Exploring our data ---------------------------------- --
-- --------------------------------------------------------------------------------- --

-- checking shape of data: no. of columns & row

select count(*) as rows_num from call_center;

select count(*) as cols_num from information_schema.columns where table_name = 'call_center';

-- checking the distinct values of columns

select distinct sentiment from call_center;

select distinct reason from call_center;

select distinct channel from call_center;

select distinct response_time from call_center;

select distinct call_center from call_center;

-- check the count and percentage from total of each of the distinct values

select sentiment, count(*), round((count(*)/(select count(*) from call_center)) *100,1) as pct from call_center group by 1 order by 3 desc;

select reason, count(*), round((count(*)/(select count(*) from call_center)) *100, 1) as pct from call_center group by 1 order by 3 desc;

select channel, count(*), round((count(*)/(select count(*) from call_center)) *100, 1) as pct from call_center group by 1 order by 3 desc;

select response_time, count(*), round((count(*)/(select count(*) from call_center)) *100, 1) as pct from call_center group by 1 order by 3 desc;

select call_center, count(*), round((count(*)/(select count(*) from call_center)) *100, 1) as pct from call_center group by 1 order by 3 desc;

select state, count(*) as total from call_center group by 1 order by 2 desc;

-- check the day with highest call volume

select dayname(call_timestamp) as call_day, count(*) as num_of_calls from call_center group by 1 order by 2 desc;

-- -------------------------------------- data aggregation -------------------------------------------

select min(csat_score) as min_score, max(csat_score) as max_score, round(avg(csat_score),1) as avg_score from call_center where csat_score != 0;

select min(call_timestamp) as earliest_date, max(call_timestamp) as most_recent from call_center;

select min(call_duration_minutes) as min_call_duration, max(call_duration_minutes) as max_call_duration, round(avg(call_duration_minutes),0) as avg_call_duration from call_center;

select call_center, response_time, count(*) as count from call_center group by 1,2 order by 1,3 desc;

select call_center, avg(call_duration_minutes) from call_center group by 1 order by 2 desc;

select channel, avg(call_duration_minutes) from call_center group by 1 order by 2 desc;

select state, count(*) from call_center group by 1 order by 2 desc;

select state, reason, count(*) from call_center group by 1,2 order by 1 desc;

select state, sentiment, count(*) from call_center group by 1,2 order by 1,3 desc;

select state, round(avg(csat_score),1) as avg_csat_score from call_center where csat_score !=0 group by 1 order by 2 desc;

select sentiment, avg(call_duration_minutes) from call_center group by 1 order by 2 desc;