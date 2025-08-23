-- Data Quality Checks

USE capstone;
-- counting no. of rows in all the tables
SELECT 'stg_core_hr' tbl, COUNT(*) FROM core_hr
UNION ALL SELECT 'stg_salary_grid', COUNT(*) FROM salary_grid
UNION ALL SELECT 'stg_production', COUNT(*) FROM production_staff
UNION ALL SELECT 'stg_recruiting_costs', COUNT(*) FROM recruiting_costs;

-- checking empty cells and missing values
SELECT
SUM(CASE WHEN Emp_ID IS NULL OR Emp_ID='' THEN 1 ELSE 0 END) AS id_nulls,
SUM(CASE WHEN Department IS NULL OR TRIM(Department)='' THEN 1 ELSE 0 END) AS dept_missing
FROM core_hr;

-- Department count
SELECT UPPER(TRIM(Department)) AS dept_norm, COUNT(*)
FROM core_hr
GROUP BY UPPER(TRIM(Department))
ORDER BY COUNT(*) DESC;

-- checking Duplicates by EmployeeID
SELECT Emp_ID, COUNT(*) c
FROM core_hr
GROUP BY Emp_ID
HAVING c>1
ORDER BY c DESC;

-- deleted the duplicate emp_id
DELETE FROM core_hr
WHERE Emp_ID = 1204033041
LIMIT 1;
