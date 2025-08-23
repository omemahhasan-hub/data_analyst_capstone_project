-- Master dataset - 1
-- Using all 4 datasets
USE capstone;
SELECT 
    -- Core identifiers
    h.Emp_FName, h.Emp_LName, h.Emp_ID,
    
    -- Demographics (from production)
    h.Age, h.Sex, h.Marital_status, h.RaceDesc, h.hisp_latina, 
    h.CitizenDesc, h.State, h.Zip,
    
    -- Employment details (from core_hr)
    h.Department, h.Position, h.Pay, h.Manager_Name,
    h.Hire_date, h.Termination_date, h.Reason_Termination, h.Emp_Status,
    
    -- Performance & behavior (from core_hr)
    p.Performance_Score, p.Daily_Error_Rate, 
    p.day_90_Complaints, p.Abutments_Hour_Wk_1, p.Abutments_Hour_Wk_2,
    
    -- Recruitment source (from both core_hr and production)
    COALESCE(h.Emp_Status, p.Emp_Status) as Recruitment_Source,
    
    -- Salary benchmarking (from salary_grid)
    s.sal_min, s.sal_mid, s.sal_max,
    
    -- **NEW: Recruitment costs (from recruiting_costs)**
    rc.Jan + rc.Feb + rc.march + rc.april + rc.may + rc.june + 
    rc.july + rc.Aug + rc.sep + rc.oct + rc.nov + rc.decem as total_recruitment_cost_by_source,
    -- Calculated fields
    DATEDIFF(COALESCE(h.Termination_date, CURDATE()), h.Hire_date) / 365.0 as tenure_years,
    CASE 
        WHEN h.Pay < s.sal_min THEN 'Below Range'
        WHEN h.Pay > s.sal_max THEN 'Above Range'
        ELSE 'Within Range' 
    END as pay_equity_status
FROM core_hr h
left JOIN production_staff p ON     UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) AND 
    UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
left JOIN salary_grid s ON h.Position = s.Position
left JOIN recruiting_costs rc ON h.Emp_Source = rc.Emp_Source;



-- Master dataset -2
-- **This specifically uses the recruiting costs data!**
SELECT 
    rc.Emp_Source,
    
    -- **Recruitment costs (from recruiting_costs)**
    rc.Jan, rc.Feb, rc.march, rc.april, rc.may, rc.june,
    rc.july, rc.Aug, rc.sep, rc.oct, rc.nov, rc.decem,
    rc.total as total_recruitment_cost,
    
    -- **Hiring effectiveness**
    COUNT(h.Emp_FName) as employees_hired_from_source,    
    -- **Cost per hire**
    CASE WHEN COUNT(h.Emp_FName) > 0 
         THEN ROUND(rc.total / COUNT(h.Emp_FName), 2) 
         ELSE 0 END as cost_per_hire,
    
    -- **Quality metrics**
    round(AVG(h.Performance_Score),2) as avg_performance_by_source,
    round(AVG(DATEDIFF(COALESCE(h.Termination_date, CURDATE()), h.Hire_date) / 365.0),2) as avg_tenure_by_source,
    SUM(CASE WHEN h.Termination_date IS NOT NULL THEN 1 ELSE 0 END) as terminated_from_source,
    
    -- **ROI calculation**
    round(AVG(h.Pay),2) as avg_salary_by_source
FROM recruiting_costs rc
LEFT JOIN core_hr h ON rc.Emp_Source = h.Emp_Source
GROUP BY rc.Emp_Source, rc.Jan, rc.Feb, rc.march, rc.april, rc.may, rc.june,
         rc.july, rc.Aug, rc.sep, rc.oct, rc.nov, rc.decem, rc.total;
         
         
 
-- Master dataset - 3
-- Department-level metrics combining all datasets
SELECT 
    h.Department,
    
    -- Headcount & demographics
    COUNT(*) as total_employees,
    concat(round(AVG(h.Age),1),' ','yrs') as avg_age,
    COUNT(CASE WHEN h.Sex = 'F' THEN 1 END) as female_count,
    COUNT(CASE WHEN h.Sex = 'M' THEN 1 END) as male_count,
    
    -- Performance & salary (using salary grid reference)
    round(AVG(h.Pay),1) as avg_payrate,
    concat('$',round(AVG(s.sal_mid),1)) as avg_market_salary,
    round(AVG(h.Performance_Score),1) as avg_performance_score,
    
    -- **Recruitment efficiency**
    concat('$',SUM(rc.total)) as total_dept_recruitment_cost,
    
    -- Turnover
    ROUND(SUM(CASE WHEN h.Termination_date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as turnover_rate
    
FROM core_hr h
LEFT JOIN production_staff p ON h.Emp_FName = p.Emp_FName AND h.Emp_LName = p.Emp_LName
LEFT JOIN salary_grid s ON h.Position = s.Position
LEFT JOIN recruiting_costs rc ON h.Emp_Source = rc.Emp_Source
GROUP BY h.Department;
 