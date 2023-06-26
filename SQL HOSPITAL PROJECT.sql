-- We first need to create a database for our dataset
CREATE DATABASE HOSPITAL
------------------------------------------------------------
------------------------------------------------------------

-- Selecting the database to use.
USE HOSPITAL

------------------------------------------------------------
------------------------------------------------------------
-- Let's see the overview  of our dataset
select * from Hospital_ER

------------------------------------------------------------
------------------------------------------------------------
-- Let's see the top 10 records of our dataset
select top 10 * from Hospital_ER

------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
-- EXPLORATORY DATA ANALYSIS
------------------------------------------------------------
-- Q1.What are the names of columns in my dataset?
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'hospital_er'

------------------------------------------------------------
------------------------------------------------------------
-- Q3. How many null values I have in each column  in dataset?

SELECT
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN patient_id IS NULL THEN 1 ELSE 0 END) AS null_patient_id,
    SUM(CASE WHEN patient_gender IS NULL THEN 1 ELSE 0 END) AS null_patient_gender,
    SUM(CASE WHEN patient_age IS NULL THEN 1 ELSE 0 END) AS null_patient_age,
    SUM(CASE WHEN patient_first_inital IS NULL THEN 1 ELSE 0 END) AS null_patient_first_inital,
    SUM(CASE WHEN patient_last_name IS NULL THEN 1 ELSE 0 END) AS null_patient_last_name,
    SUM(CASE WHEN patient_admin_flag IS NULL THEN 1 ELSE 0 END) AS null_patient_admin_flag,
    SUM(CASE WHEN patient_waittime IS NULL THEN 1 ELSE 0 END) AS null_patient_waittime,
    SUM(CASE WHEN patient_race IS NULL THEN 1 ELSE 0 END) AS null_patient_race,
    SUM(CASE WHEN department_referral IS NULL THEN 1 ELSE 0 END) AS null_department_referral
FROM Hospital_ER

--Inference:
--There is no null value in dataset.

------------------------------------------------------------
------------------------------------------------------------
--Q4. Converting the Datatype of patient_age column
ALTER TABLE Hospital_er
ALTER COLUMN patient_age INT

--Inference:
--I have converted percentage_age colu,mn from varchar to INT.

------------------------------------------------------------
------------------------------------------------------------
-- Descriptives of Numerical column
------------------------------------------------------------
--Q5. Descriptives on patient age?
SELECT 
    MIN(patient_age) AS Min_patient_age,
    MAX(patient_age) AS Max_patient_age,
	ROUND(AVG(patient_age),0) AS Avg_patient_age,
    ROUND(STDEV(patient_age),0) AS Stdev_patient_age,
    COUNT(patient_age) AS Count_patient_age
	from Hospital_ER
--Inference:
--1. Minimum age of a patient is 1 year
--2. Maximum age of patient is 79 year
--3. Average Patient Age is 39 year
--4. Total number of patients are 9216

------------------------------------------------------------
------------------------------------------------------------
--Q 6. Descriptives on patient_waittime?

SELECT 
    MIN(patient_waittime) AS Min_patient_waittime,
    MAX(patient_waittime) AS Max_patient_waittime,
	ROUND(AVG(patient_waittime),0) AS Avg_patient_waittime,
    ROUND(STDEV(patient_waittime),0) AS stddev_patient_waittime
from Hospital_ER

--Inference:
--1. Minimum patient waiting time is 10 minutes
--2. Maximum patient waiting time is 60 minutes
--3. Average patient waiting time is 30 minutes
--4. Standard deviation in  patient waiting time is 15 minutes.

------------------------------------------------------------
------------------------------------------------------------
-- Descripives on Categorical Column
------------------------------------------------------------
--Q7.What are the number of people with same last name? 
SELECT
    patient_last_name AS patient_last_name,
    COUNT(*) AS Frequency
FROM Hospital_ER
GROUP BY patient_last_name

------------------------------------------------------------
------------------------------------------------------------
--Q8.In which department people are being refferd to most and least? 

SELECT
    department_referral AS department_referral,
    COUNT(department_referral) AS Frequency
FROM Hospital_ER
GROUP BY department_referral
ORDER BY Frequency desc

--Inference:
--1.Most people were reffered to General Practice and their frequency were 5400
--2.Least people were reffered to General Practice and their frequency were 86

------------------------------------------------------------
------------------------------------------------------------
--Q9.What are the count of different patient race who visited the hospital and there frequency?
SELECT
    patient_race AS patient_race ,
    COUNT(patient_race ) AS Frequency
FROM Hospital_ER
GROUP BY patient_race 
ORDER BY Frequency desc

--Inference:
--1.Different races of patitients which visited hospital were White,African American,Two or More Races,Asian,Declined to Identify,Pacific Islander and Native American/Alaska Native
--2.White people visited maximum and there frequency were 2571
--3.Native American/Alaska Native visited the Lears and there frequency were 498.

------------------------------------------------------------
------------------------------------------------------------
-- Q10. How many Duplicated rows I have in my dataset?
SELECT date, patient_id, patient_gender, patient_age,  patient_first_inital, patient_last_name, patient_admin_flag, patient_waittime, patient_race, department_referral, COUNT(*) AS count
FROM Hospital_ER
GROUP BY date, patient_id, patient_gender, patient_age,  patient_first_inital, patient_last_name, patient_admin_flag, patient_waittime, patient_race, department_referral
HAVING COUNT(*) > 1

--Inference:
--There are no duplicate rows in dataset

------------------------------------------------------------
------------------------------------------------------------
-- Q11. How many rows do we have in our dataset?
Select Count(*)  as Rows_count from Hospital_ER

--Inference:
--1. there are total 9216 rows in dataset

------------------------------------------------------------
------------------------------------------------------------
-- Q12. How many columns do we have in our dataset?

Select Count(*) as Column_count 
From information_schema.columns
Where table_name='Hospital_ER'

--Infernce:
--1. I have total 10 columns in my dataset

------------------------------------------------------------
------------------------------------------------------------
--Q13. How many years of data do we have and percentage per year?
--select * from Hospital_ER
--select year(date) from Hospital_ER
--select COUNT(*) as cou from hospital_er
--select Round(count(*)*100/ (select count(*) from hospital_er)*100,2) from hospital_er

SELECT YEAR(date) AS years, COUNT(*) AS counts, ROUND((COUNT(*)*100 / 
(SELECT COUNT(*) FROM hospital_er)) , 1) AS pct
FROM hospital_er
GROUP BY YEAR(date)

--Inference:
--1. We have 2 years of data that is 2019 and 2020
--2. We have 47% data of year 2019 and 53% of 2020

------------------------------------------------------------
------------------------------------------------------------
--Q14. What day of the week has the highest number of patient visits?
SELECT DATENAME(WEEKDAY, date) AS visit_day, COUNT(*) AS number_of_visits
FROM hospital_er
GROUP BY DATENAME(WEEKDAY, date)
ORDER BY number_of_visits DESC

--Infernce:
--1.Highest Number of patients visited hospital on Monday and their frequency was 1377
--2. Least Number of people visited hospital on Friday and their frequency was 1260

------------------------------------------------------------
------------------------------------------------------------
--Q15. What time of the day do we have the most patient visits?
SELECT DATEPART(HOUR, date) AS hour_of_day, COUNT(*) AS number_of_visits
FROM hospital_er
GROUP BY DATEPART(HOUR, date)
ORDER BY number_of_visits DESC

--Infernce:
--1.Highest Number of patients visited hospital at 23:00 and their frequency was 436
--2. Least Number of people visited hospital at 10:00 and their frequency was 349

------------------------------------------------------------
------------------------------------------------------------
--Q16. What are the unique values in our patient gender?
SELECT DISTINCT PATIENT_GENDER FROM Hospital_ER

--Infernce:
--We have 3 patient gender that is F,M, NC
------------------------------------------------------------
------------------------------------------------------------
--Q17. What are the unique values in our patient gender?
SELECT patient_gender, COUNT(*) AS counts
FROM hospital_er
GROUP BY patient_gender

--Infernce:
--F patients were 4487
--Nc patients were 24
--M patients were 4705


