use capstone;
 -- Pay rate
SELECT Department,
       COUNT(*) as employees,
       ROUND(AVG(Pay), 0) as avg_salary,
       ROUND(MIN(Pay), 0) as min_salary,
       ROUND(MAX(Pay), 0) as max_salary,
       ROUND(MAX(Pay) - MIN(Pay), 0) as salary_range
FROM core_hr 
GROUP BY Department 
ORDER BY avg_salary DESC;


-- Performance by department (using window functions)
SELECT 
    h.Department,
    h.Emp_FName,
    h.Pay,
    p.Performance_Score,
    RANK() OVER (PARTITION BY h.Department ORDER BY p.Performance_Score DESC) as performance_rank,
    RANK() OVER (PARTITION BY h.Department ORDER BY h.Pay DESC) as salary_rank
FROM core_hr h
JOIN production_staff p ON 
    UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) AND 
    UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
WHERE p.Performance_Score IS NOT NULL
order by performance_rank desc;



-- Performance Categories and count
select distinct(Performance_Score) as per_sc, count(*) as total from production_staff
group by per_sc;



-- Performance vs compensation correlation
SELECT 
     CASE 
        WHEN p.Performance_Score IN ('Fully Meets', 'Exceeds')
             THEN 'High Performer'
        ELSE 'Low Performer'
    END AS performance_category,
    
    COUNT(*) AS employee_count,
    ROUND(AVG(h.Pay), 0) AS avg_payrate,
    ROUND(AVG(p.Daily_Error_Rate), 2) AS avg_error_rate,
    CONCAT('$', ROUND(AVG(s.sal_mid), 0)) AS avr_sal,
    
    -- Count only "Below Avg" employees
    SUM(CASE WHEN pe.pay_equity_status = 'Below Range' THEN 1 ELSE 0 END) AS below_avg_count

FROM core_hr h
LEFT JOIN production_staff p 
    ON UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) 
   AND UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
LEFT JOIN salary_grid s 
    ON h.Position = s.Position
LEFT JOIN recruiting_costs rc 
    ON h.Emp_Source = rc.Emp_Source
LEFT JOIN master_table pe   -- ✅ join the table with pay_equity_status
    ON h.Emp_ID = pe.Emp_ID   -- (replace with the correct join key!)

GROUP BY performance_category;



-- Turnover analysis by department
SELECT Department,
       COUNT(*) as total_employees,
       SUM(CASE WHEN Termination_date IS NOT NULL THEN 1 ELSE 0 END) as terminated_count,
       ROUND(SUM(CASE WHEN Termination_date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as turnover_rate,
       round(AVG(DATEDIFF(COALESCE(Termination_date, CURDATE()), Hire_date) / 365.0),1) as avg_tenure_years
FROM core_hr 
GROUP BY Department 
ORDER BY turnover_rate DESC;



-- Termination reasons analysis
SELECT Reason_Termination,
       COUNT(*) as termination_count,
       concat(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM core_hr WHERE Termination_date IS NOT NULL), 1),'%') as percentage
FROM core_hr 
WHERE Termination_date IS NOT NULL
GROUP BY Reason_Termination 
ORDER BY termination_count DESC;



-- Cost per hire by recruitment source
SELECT 
    rc.Emp_Source,
    rc.total as total_cost,
    COUNT(h.Emp_FName) as employees_hired,
    CASE WHEN COUNT(h.Emp_FName) > 0 
         THEN ROUND(rc.total / COUNT(h.Emp_FName), 0) 
         ELSE 0 END as cost_per_hire,
    round(AVG(h.Pay),1) as avg_pay_rate,
    concat(round(AVG(DATEDIFF(COALESCE(h.Termination_date, CURDATE()), h.Hire_date) / 365.0),1),' ','yrs') as avg_tenure
FROM recruiting_costs rc
LEFT JOIN core_hr h ON rc.Emp_Source = h.Emp_Source
GROUP BY rc.Emp_Source, rc.total 
ORDER BY cost_per_hire;



-- ROI analysis - recruitment investment vs employee value
    SELECT 
     rc.Emp_Source,
    COUNT(h.Emp_FName) as employees_hired,
    ROUND(rc.total, 0) as recruitment_cost,
    ROUND(SUM(h.Pay), 0) as total_annual_salaries,
    ROUND(SUM(h.Pay) / rc.total, 1) as salary_to_cost_ratio
FROM recruiting_costs rc
LEFT JOIN core_hr h ON rc.Emp_Source = h.Emp_Source
WHERE h.Emp_FName IS NOT NULL
GROUP BY rc.Emp_Source, rc.total
ORDER BY salary_to_cost_ratio DESC;



-- managers count
select Manager_Name, count(*) as total_employee_under from core_hr
group by Manager_Name
order by total_manager desc;



-- Manager effectiveness analysis
SELECT 
    h.Manager_Name,
    COUNT(*) as team_size,
    round(AVG(p.Performance_Score),1) as avg_team_performance_score,
    ROUND(AVG(h.Pay), 0) as avg_team_pay_rate,
    SUM(CASE WHEN h.Termination_date IS NOT NULL THEN 1 ELSE 0 END) as team_turnover,
    ROUND(SUM(CASE WHEN h.Termination_date IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) as turnover_rate
FROM core_hr h
LEFT JOIN production_staff p ON 
    UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) AND 
    UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
GROUP BY h.Manager_Name
HAVING COUNT(*) >= 3  -- Only managers with 3+ reports
ORDER BY team_size desc, avg_team_performance_score DESC;
