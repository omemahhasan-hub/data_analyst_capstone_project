-- Master dataset - 1
-- Using all 4 datasets

USE capstone;
CREATE TABLE master_table AS
SELECT 
    -- Core identifiers
    h.Emp_FName, h.Emp_LName, h.Emp_ID,
    
    -- Demographics (from stg_production)
    h.Age, h.Sex, h.Marital_status, h.RaceDesc, h.hisp_latina, 
    h.CitizenDesc, h.State, h.Zip,
    
    -- Employment details (from stg_core_hr)
    h.Department, h.Position, h.Pay, h.Manager_Name,
    h.Hire_date, h.Termination_date, h.Reason_Termination, h.Emp_Status, h.Emp_Source,
    
    -- Performance & behavior - using the same source for consistency
    h.Performance_Score,
    ROUND(
        CASE REPLACE(REPLACE(TRIM(UPPER(h.Performance_Score)), '\r', ''), '\n', '')
            WHEN 'EXCEPTIONAL' THEN 5
            WHEN 'EXCEEDS' THEN 4
            WHEN 'FULLY MEETS' THEN 3
            WHEN '90-DAY MEETS' THEN 2.5
            WHEN 'NEEDS IMPROVEMENT' THEN 2
            WHEN 'PIP' THEN 1
            ELSE NULL
        END
    , 1) AS performance_score_num,
    
    -- Additional performance metrics (from stg_production)
    p.Daily_Error_Rate, 
    p.day_90_Complaints, p.Abutments_Hour_Wk_1, p.Abutments_Hour_Wk_2,
    
    -- Recruitment source (from stg_core_hr)
    h.Emp_Source as Recruitment_Source,
    
    -- Salary benchmarking (from stg_salary_grid)
    s.sal_min, s.sal_mid, s.sal_max,
    
    -- **NEW: Recruitment costs (from stg_recruiting_costs)**
    rc.Jan + rc.Feb + rc.march + rc.april + rc.may + rc.june + 
    rc.july + rc.Aug + rc.sep + rc.oct + rc.nov + rc.decem as total_recruitment_cost_by_source,
    
    -- Calculated fields
    ROUND(DATEDIFF(COALESCE(h.Termination_date, CURDATE()), h.Hire_date) / 365.0, 2) as tenure_years,
    CASE 
        WHEN h.Pay < s.sal_min THEN 'Below Range'
        WHEN h.Pay > s.sal_max THEN 'Above Range'
        ELSE 'Within Range' 
    END as pay_equity_status
    
FROM core_hr h
LEFT JOIN production_staff p ON 
    UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) AND 
    UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
LEFT JOIN salary_grid s ON h.Position = s.Position
LEFT JOIN recruiting_costs rc ON h.Emp_Source = rc.Emp_Source;



-- Master dataset -2
-- **This specifically uses the recruiting costs data!**

USE capstone;
CREATE TABLE master_table2 AS
SELECT 
    rc.Emp_Source,
    -- Recruitment costs
    rc.Jan, rc.Feb, rc.march, rc.april, rc.may, rc.june,
    rc.july, rc.Aug, rc.sep, rc.oct, rc.nov, rc.decem,
    rc.total AS total_recruitment_cost,
    
    -- Hiring effectiveness
    COUNT(h.Emp_FName) AS employees_hired_from_source,
    
    -- Cost per hire
    CASE WHEN COUNT(h.Emp_FName) > 0 
         THEN ROUND(rc.total / COUNT(h.Emp_FName), 2) 
         ELSE 0 END AS cost_per_hire,
    
    ROUND(AVG(
    CASE REPLACE(REPLACE(TRIM(UPPER(h.Performance_Score)), '\r', ''), '\n', '')
        WHEN 'EXCEPTIONAL' THEN 5
        WHEN 'EXCEEDS' THEN 4
        WHEN 'FULLY MEETS' THEN 3
        WHEN '90-DAY MEETS' THEN 2.5
        WHEN 'NEEDS IMPROVEMENT' THEN 2
        WHEN 'PIP' THEN 1
        ELSE NULL
    END
),1) AS avg_performance_score,
    
    ROUND(AVG(DATEDIFF(COALESCE(h.Termination_date, CURDATE()), h.Hire_date) / 365.0), 2) AS avg_tenure_by_source,
    SUM(CASE WHEN h.Termination_date IS NOT NULL THEN 1 ELSE 0 END) AS terminated_from_source,
    
    -- ROI calculation
    ROUND(AVG(h.Pay), 2) AS avg_salary_by_source

FROM recruiting_costs rc
LEFT JOIN core_hr h 
       ON rc.Emp_Source = h.Emp_Source
GROUP BY rc.Emp_Source, rc.Jan, rc.Feb, rc.march, rc.april, rc.may, rc.june,
         rc.july, rc.Aug, rc.sep, rc.oct, rc.nov, rc.decem, rc.total;

         
 
-- Master dataset - 3
-- Department-level metrics combining all datasets

USE capstone;
CREATE TABLE master_table3 AS
SELECT 
    h.Department,
    -- Headcount & demographics
    COUNT(*) AS total_employees,
    CONCAT(ROUND(AVG(h.Age), 1), ' ', 'yrs') AS avg_age,
    SUM(CASE WHEN h.Sex = 'Female' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN h.Sex = 'Male' THEN 1 ELSE 0 END) AS male_count,
    
    -- Performance & salary (using salary grid reference)
    ROUND(AVG(h.Pay), 1) AS avg_payrate,
     ROUND(AVG(s.sal_mid), 1) AS avg_market_salary,
    
    ROUND(AVG(
    CASE REPLACE(REPLACE(TRIM(UPPER(h.Performance_Score)), '\r', ''), '\n', '')
        WHEN 'EXCEPTIONAL' THEN 5
        WHEN 'EXCEEDS' THEN 4
        WHEN 'FULLY MEETS' THEN 3
        WHEN '90-DAY MEETS' THEN 2.5
        WHEN 'NEEDS IMPROVEMENT' THEN 2
        WHEN 'PIP' THEN 1
        ELSE NULL
    END
),1) AS avg_performance_score,
    -- Recruitment efficiency
    CONCAT('$', SUM(rc.total)) AS total_dept_recruitment_cost,
    
    -- Turnover
    ROUND(SUM(CASE WHEN h.Termination_date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS turnover_rate
    
FROM core_hr h
LEFT JOIN production_staff p 
       ON h.Emp_FName = p.Emp_FName AND h.Emp_LName = p.Emp_LName
LEFT JOIN salary_grid s 
       ON h.Position = s.Position
LEFT JOIN recruiting_costs rc 
       ON h.Emp_Source = rc.Emp_Source
GROUP BY h.Department;

