-- DATA ANALYSIS USING SQL ON HealthCare Database 
	    
-- Creating Database named Healthcare.
CREATE DATABASE Healthcare;

-- Selecting Healthcare database to query.
USE Healthcare;

-- Viewing Data on Database
SELECT * FROM healthcare;

-- Describing characteristics of table.
DESC Healthcare;

-- 1.  Counting Total Record in Database
SELECT COUNT(*) FROM Healthcare;		

-- 2. Finding maximum age of patient admitted.
select max(age) as Maximum_Age from Healthcare;

-- 3. Finding Average age of hospitalized patients.
select round(avg(age),0) as Average_Age from Healthcare;	

-- 4. Calculating Patients Hospitalized Age-wise from Maximum to Minimum
SELECT AGE, COUNT(AGE) AS Total
FROM Healthcare
GROUP BY age
ORDER BY AGE DESC;
	-- Findings : The output will display a list of unique ages present in the "Healthcare" table along with the count of occurrences for each age, sorted from oldest 	to youngest.
    
    
-- 5. Calculating Maximum Count of patients on basis of total patients hospitalized with respect to age.
SELECT AGE, COUNT(AGE) AS Total
FROM Healthcare
GROUP BY age
ORDER BY Total DESC,age DESC;

-- 6. Ranking Age on the number of patients Hospitalized   
SELECT AGE, COUNT(AGE) As Total, dense_RANK() OVER(ORDER BY COUNT(AGE) DESC, age DESC) as Ranking_Admitted 
FROM Healthcare
GROUP BY age
HAVING Total > Avg(age);

-- 7. Finding Count of Medical Condition of patients and lisitng it by maximum no of patients.
SELECT Medical_Condition, COUNT(Medical_Condition) as Total_Patients 
FROM healthcare
GROUP BY Medical_Condition
ORDER BY Total_patients DESC;
	

-- 8. Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them.    
SELECT Medical_Condition, Medication, COUNT(medication) as Total_Medications_to_Patients, RANK() OVER(PARTITION BY Medical_Condition ORDER BY COUNT(medication) DESC) as Rank_Medicine
FROM Healthcare
GROUP BY 1,2
ORDER BY 1; 
	
	

-- 9. Most preffered Insurance Provide  by Patients Hospatilized
SELECT Insurance_Provider, COUNT(Insurance_Provider) AS Total 
FROM Healthcare
GROUP BY Insurance_Provider
ORDER BY Total DESC;
	-- Findings : This information helps identify the most prevalent insurance providers among the patient population, offering valuable data for resource allocation, understanding coverage preferences, and potentially indicating trends in healthcare accessibility based on insurance networks
    

-- 10. Finding out most preffered Hospital 
SELECT Hospital, COUNT(hospital) AS Total 
FROM Healthcare
GROUP BY Hospital
ORDER BY Total DESC;
	    

-- 11. Identifying Average Billing Amount by Medical Condition.
SELECT Medical_Condition, ROUND(AVG(Billing_Amount),2) AS Avg_Billing_Amount
FROM Healthcare
GROUP BY Medical_Condition;
    

-- 12. Finding Billing Amount of patients admitted and number of days spent in respective hospital.
SELECT Medical_Condition, Name, Hospital, DATEDIFF(Discharge_date,Date_of_Admission) as Number_of_Days, 
SUM(ROUND(Billing_Amount,2)) OVER(Partition by Hospital ORDER BY Hospital DESC) AS Total_Amount
FROM Healthcare
ORDER BY Medical_Condition;
 
 
-- 13. Finding Total number of days sepnt by patient in an hospital for given medical condition
SELECT Name, Medical_Condition, ROUND(Billing_Amount,2) as Billing_Amount, Hospital, DATEDIFF(Discharge_Date, Date_of_Admission) as Total_Hospitalized_days
FROM Healthcare;


-- 14. Calculate the number of blood types of patients which lies betwwen age 20 to 45
SELECT Age, Blood_type, COUNT(Blood_Type) as Count_Blood_Type
FROM Healthcare
WHERE AGE BETWEEN 20 AND 45
GROUP BY 1,2;


-- 15. Find how many of patient are Universal Blood Donor and Universal Blood reciever
SELECT 
    (SELECT COUNT(*) FROM healthcare WHERE Blood_Type = 'O-') AS Universal_Blood_Donor, 
    (SELECT COUNT(*) FROM healthcare WHERE Blood_Type = 'AB+') AS Universal_Blood_Receiver;


-- 16. Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025?
SELECT DISTINCT Hospital, Count(*) as Total_Admitted
FROM healthcare
WHERE YEAR(Date_of_Admission) IN (2024, 2025)
GROUP BY 1
ORDER by Total_Admitted DESC; 
	
	
-- 17. Find the average, minimum and maximum billing amount for each insurance provider?
SELECT Insurance_Provider, ROUND(AVG(Billing_Amount),0) as Average_Amount, ROUND(Min(Billing_Amount),0) as Minimum_Amount, ROUND(Max(Billing_Amount),0) as Maximum_Amount
FROM healthcare
GROUP BY 1;
	

-- 18. Create a new column that categorizes patients as high, medium, or low risk based on their medical condition.
SELECT Name, Medical_Condition, Test_Results,
CASE 
		WHEN Test_Results = 'Inconclusive' THEN 'Need More Checks / CANNOT be Discharged'
        WHEN Test_Results = 'Normal' THEN 'Can take discharge, But need to follow Prescribed medications timely' 
        WHEN Test_Results =  'Abnormal' THEN 'Needs more attention and more tests'
        END AS 'Status'
FROM Healthcare;
	