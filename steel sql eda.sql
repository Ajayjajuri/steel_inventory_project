## EDA using SQL
create database steel_project ;
use steel_project ;
select * from steelset;
alter table steelset change column date date date ;

#  understanding the data 

select count(distinct(Customer_Name)) as Customer_Name_unique from steelset;
#There are 1016 unique customers


## First Moment Business Decision / Measures of Central Tendency
# mean
SELECT AVG(quantity) AS mean_quantity
FROM steelset;
#The avg qunatity of production is 5.92

SELECT AVG(rate) AS mean_rate
FROM steelset;
# the mean/avg rate of the steel sold is 48523.58 rupees


# median
SELECT quantity AS median_quantity
FROM (
SELECT quantity, ROW_NUMBER() OVER (ORDER BY quantity) AS row_num,
COUNT(*) OVER () AS total_count
FROM steelset
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;
 
 # the middle most quantity sold is 3.9
 
 SELECT rate AS median_rate
FROM (
SELECT rate, ROW_NUMBER() OVER (ORDER BY rate) AS row_num,
COUNT(*) OVER () AS total_count
FROM steelset
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;
 
 # the middle most cost value is 45700
 
 
# mode
SELECT Type AS mode_Type
FROM (
SELECT Type, COUNT(*) AS frequency
FROM steelset
GROUP BY Type
ORDER BY frequency DESC
LIMIT 1
) AS subquery;
# full length  are the most oftenly sold type of steel rods

select * from steelset;
SELECT Length AS mode_Length
FROM (
SELECT length, COUNT(*) AS frequency
FROM steelset
GROUP BY length
ORDER BY frequency DESC
LIMIT 1
) AS subquery;
# length of 12 meter is the most oftenly sold type of steel rods

SELECT Customer_Name AS mode_CustomerName
FROM (
SELECT Customer_Name, COUNT(*) AS frequency
FROM steelset
GROUP BY Customer_Name
ORDER BY frequency DESC
LIMIT 1
) AS subquery;
# contractor 11 is the customer who bought the steel rods more oftenly
SELECT Quantity AS mode_Quantity
FROM (
SELECT Quantity, COUNT(*) AS frequency
FROM steelset
GROUP BY Quantity
ORDER BY frequency DESC
LIMIT 1
) AS subquery;
# quantity of 2 is sold more

#Second Moment Business Decision / Measures of Dispersion
# Standard Deviation of Column4
SELECT STDDEV(Quantity) AS Quantity_stddev
FROM steelset;
# quantity of products is not much widely dispersed as the std dev is 6.7

SELECT STDDEV(rate) AS rate_stddev
FROM steelset;
# The rate of the products are more  widely dispersed as stddev is 9642.98

desc steelset;

# Third Moment Business Decision / Skewness

SELECT
(
SUM(POWER(quantity- (SELECT AVG(quantity) FROM steelset), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(quantity) FROM steelset), 3))
) AS skewness
FROM steelset;
# a skewness of 2.2 indicates the quantity is lightly right skewed

SELECT
(
SUM(POWER(rate- (SELECT AVG(rate) FROM steelset), 3)) /
(COUNT(*) * POWER((SELECT STDDEV(rate) FROM steelset), 3))
) AS skewness
FROM steelset;
# a skewness of 0.7 indicates the rate of prodcuts is normally distriibuted

select max(quantity) from steelset;
# 42.68 is the max quantity sold 
select min(quantity) from steelset;

#Fourth Moment Business Decision / Kurtosis
SELECT
(
(SUM(POWER(quantity - (SELECT AVG(quantity) FROM steelset), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(quantity) FROM steelset), 4))) - 3
) AS kurtosis
FROM steelset;
# the kutosis value of 5 for quantity shows it is lightly tailed and have less outliers
#leptokurtic

SELECT
(
(SUM(POWER(rate - (SELECT AVG(rate) FROM steelset), 4)) /
(COUNT(*) * POWER((SELECT STDDEV(rate) FROM steelset), 4))) - 3
) AS kurtosis
FROM steelset;
# the kutosis value of 0 for rate shows it is mesokurtic and normally distirbuted

# the kurtosis value of 953 for sales says there's a high difference in products prices

#Typecasting
desc steelset;

alter table  steelset modify column date date date;
alter table steelset change column date date date ;

#Handling Duplicates
select count(*) as dupli_count from steelset having count(*) > 1;
# count duplicates by column
SELECT  fy,COUNT(*) as duplicate_count
FROM steelset
GROUP BY fy
HAVING COUNT(*) > 1;

# handling duplicates by distinct values method
CREATE TABLE temp_steelset AS
SELECT DISTINCT *
FROM  steelset;
select count(*) from steelset;
desc temp_steelset;
# there were 33015 rows when loaded 
TRUNCATE TABLE steelset;

INSERT INTO steelset
SELECT * FROM temp_steelset;
select count(*) from steelset;
# now there are 32977 rows 
DROP TABLE temp_steelset;

# Zero & near Zero Variance features
ALTER TABLE `steel_project`.`steelset` 
CHANGE COLUMN `Dia group` `Dia_group` TEXT NULL DEFAULT NULL ;

select * from steelset;
SELECT
VARIANCE(dia) AS dia_variance,
VARIANCE(dia_group) AS diagrp_variance,
VARIANCE(grade) AS grade_variance
FROM steelset;

# there are no zero variance present , so we will keep the data as it is



select count(distinct(grade)) from steelset;


# Zero & near Zero Variance features
SELECT
VARIANCE(quantity) AS quantity_variance,
VARIANCE(final_cost) AS cost_variance,
VARIANCE(final_sales) AS sales_variance
FROM mio_dataset;

# Missing Values
#  in this data we cant use as null because its an emtpy space so we just use ' '
SELECT
COUNT(*) AS total_rows,
SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS Quantity_missing,
SUM(CASE WHEN rate IS NULL THEN 1 ELSE 0 END) AS rate_missing
FROM steelset;


# deleting method
delete from steelset where quantity is null;
delete from steelset where rate is null;
# we can delete the rows having the missing values but  it is not a good approach we may lose important data , so imputation is a good approach

UPDATE STEELSET
SET quantity = (SELECT quantity AS mode_quantity
FROM (
SELECT quantity, COUNT(*)
 AS frequency
FROM steelset
GROUP BY quantity
ORDER BY frequency DESC
LIMIT 1
) as subquery)
WHERE quantity = '';



# outlier treatment using ntile method



UPDATE steelset AS e
JOIN (
    SELECT
        quantity,
        NTILE(4) OVER (ORDER BY quantity) AS quantity_quartile
    FROM steelset
) AS subquery ON e.quantity = subquery.quantity 
SET e.quantity = (
    SELECT AVG(quantity)
    FROM (
        SELECT
            quantity,
            NTILE(4) OVER (ORDER BY quantity) AS quantity_quartile
        FROM steelset
    ) AS temp
    WHERE temp.quantity_quartile = subquery.quantity_quartile
)
WHERE subquery.quantity_quartile IN (1, 4);



update steelset as f 
join ( select rate, ntile(4) over(order by rate) as rate_quartile
from steelset ) as subquery on f.rate= subquery.rate
set f.rate = (select avg(rate) from (select rate , ntile(4) over(order by rate)
 as rate_quartile from steelset) as temp where temp.rate_quartile =
 subquery.rate_quartile ) where subquery.rate_quartile in (1,4);
 
 update steelset as g join (select rate, ntile(4) over(order by rate)
 as rate_quartile from steelset) as subquery on g.rate = subquery.rate
 set g.rate = (select avg(rate) from (select rate, ntile(4) over(order by rate) 
 as rate_quartile from steelset) as mat where mat.rate_quartile =
 subquery.rate_quartile ) where subquery.rate_quartile in (1,4) ;


#correlation
select distinct(dia_group) as unique_dia from steelset ;
select corr(dia, dia_group) as correlation from steelset;

select * from mio_dataset;

# normalizaion
create table steelset_scaled as 
select ( (rate- min_rate)/(max_rate-min_rate)) as scaled_rate from (select rate, (select min(rate) from steelset) as min_rate,
(select max(rate) from steelset ) as max_rate from steelset ) as scaled_rate;

select * from steelset_scaled;

create table steel_quantity_scaled as select (quantity- min_quantity)/(max_quantity -min_quantity) from (select quantity ,
(select max(quantity) from steelset) as max_quantity, (select min(quantity) from steelset ) as min_quantity from steelset) as scaled_quantity;
select * from steel_quantity_scaled;

# dummy variable creation 

select grade , case when grade= '500d' then 1 else 0 end as 'is 500d', case when grade = '550d' then 1 else 0 end as 'is 550d'
from steelset;


#discretization/ binning / grouping 

 SELECT rate AS median_rate
FROM (
SELECT rate, ROW_NUMBER() OVER (ORDER BY rate) AS row_num,
COUNT(*) OVER () AS total_count
FROM steelset
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;
 
 
 select rate ,case when rate<45700 then 'low'  when rate = 45700 then 'medium' when rate >45700 then 'high' else 'unknown' end as rate_group from steelset;

 select quantity ,case when quantity<3.91 then 'low qty' when quantity =3.91 then 'medium qty' 
 when quantity >3.91 then 'high qty' else 'unknown' end as quantity_group from steelset;

# transformation

create table  rate_trans as select rate , log(rate) as rate_log, sqrt(rate) as rate_sqrt from steelset;

select * from rate_trans;
















