# HR Analytics Capstone Project - SQL Analysis Phase

- [Project Overview](#-project-overview)
- [Database Structure](#database-structure)
- [Key Insights](#-key-business-insights-discovered)
- [Advanced SQL Techniques](#advanced-SQL-techniques-demonstrated)   
- [Deliverables](#-deliverables)
- [Business Value](#-business-value-demonstrated)


## 📊 Project Overview

This phase demonstrates comprehensive SQL skills through HR data analysis using 4 integrated datasets. The analysis focuses on employee demographics, performance metrics, salary equity, recruitment effectiveness, and retention patterns.

##  Database Structure

### Original Datasets (4 Tables)
- **`core_hr`** (309 records) - Employee demographics, employment details, compensation
  - Primary Key: Composite (Emp_FName, Emp_LName, Emp_ID)
  - Contains: All company employees with complete demographic and employment data
- **`production_staff`** (200 records) - Performance metrics and productivity data  
  - Primary Key: Composite (Emp_FName, Emp_LName)
  - Contains: Performance data for production department employees only
- **`salary_grid`** (12 records) - Position-based salary bands and market rates
  - Primary Key: Position
  - Contains: Market salary ranges for all company positions
- **`recruiting_costs`** (22 records) - Monthly recruitment expenses by source
  - Primary Key: Emp_Source
  - Contains: Annual recruitment costs broken down by month and source

### Data Quality Challenges Resolved
- **Excel preprocessing**: Converted dates to 'yyyy-mm-dd' format, replaced empty cells with '\N'
- **Duplicate removal**: Identified and eliminated duplicate records across all tables
- **Data matching issues**: Resolved name formatting inconsistencies using `UPPER(TRIM())` functions. Mismatch columns stating termination date but has stutus working.
- **NULL value preservation**: Performance metrics contain NULL values for 99 employees (non-production staff) where performance data is not applicable. NULLs preserved to maintain data integrity rather than imputing artificial values

##  Technical Implementation

### Master Datasets Created

#### 1. Employee Master Dataset (299 records)
**Purpose**: Comprehensive employee data integrating all sources  
**Primary Key**: Emp_ID (from core_hr)  
**Data Completeness**: 299 employees with demographics, 200 with performance metrics  

```sql
CREATE TABLE employee_master AS
SELECT 
    h.Emp_FName, h.Emp_LName, h.Emp_ID,
    h.Age, h.Sex, h.Department, h.Position, h.Pay,
    h.Hire_date, h.Termination_date, h.Emp_Status,
    -- Performance metrics: NULL for non-production employees (99 records)
    p.Performance_Score, p.Daily_Error_Rate, p.day_90_Complaints,
    s.sal_min, s.sal_mid, s.sal_max,
    DATEDIFF(COALESCE(h.Termination_date, CURDATE()), h.Hire_date) / 365.0 as tenure_years
FROM core_hr h
LEFT JOIN production_staff p ON 
    UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) AND 
    UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
LEFT JOIN salary_grid s ON h.Position = s.Position;
```

**NULL Value Handling Strategy**:
- Performance metrics (Performance_Score, Daily_Error_Rate, day_90_Complaints) contain NULL values for 99 employees
- **Rationale**: These employees are not in production roles where performance tracking occurs
- **Decision**: Preserved NULLs rather than imputing zeros to maintain data authenticity
- **Impact**: Analysis segmented by data availability (Complete vs. Limited profiles)

#### 2. Recruitment ROI Analysis
**Purpose**: Cost-effectiveness analysis of recruitment channels  
**Primary Key**: Emp_Source  
- Cost-per-hire calculations by recruitment source
- Performance correlation with recruitment channels
- Tenure and retention metrics by hiring source

#### 3. Department Analytics Summary  
**Purpose**: Management dashboard metrics by department  
**Primary Key**: Department  
- Headcount distribution and demographic breakdown
- Salary benchmarking against market rates
- Turnover rates and performance metrics by department

##  Data Relationships & Integrity

### Table Relationships
```
core_hr (309) ────┐
                  ├─── employee_master (299)
production_staff (200) ──┘         │
                                   │
salary_grid (12) ──────────────────┤
                                   │  
recruiting_costs (22) ──────────────┘
```

### Key Relationships
- **core_hr ← production_staff**: LEFT JOIN on name match (200/309 employees have performance data)
- **core_hr ← salary_grid**: LEFT JOIN on position match (salary bands for all positions)
- **core_hr ← recruiting_costs**: LEFT JOIN on recruitment source match
- **Data Completeness**: 67% of employees have complete profiles including performance metrics

### Primary Key Strategy
- **Source tables**: Used composite keys and business keys as provided
- **Master dataset**: Standardized on Emp_ID as primary key for referential integrity
- **Analysis tables**: Used appropriate business keys (Department, Emp_Source) for aggregations

## 📈 Key Business Insights Discovered

### Workforce Demographics
- **Total Employees**: 299 across 4 departments
- **Gender Distribution**: 174 Female, 125 Male
- **Age Demographics**: Analyzed across 4 age cohorts (Under 30, 30-45, 46-55, Over 55)
- **Diversity Metrics**: Race, marital status, and citizenship analysis

### Compensation Analysis
- **Pay Equity Assessment**: Identified employees below/above salary bands
- **Department Salary Variance**: Found widest gaps in Production (range 46) and IT/IS (44), while Sales showed highly consistent pay (range 6).
- **Performance-Pay Correlation**: Analyzed for 200 employees with performance data

### Retention & Performance
- **Turnover Analysis**: Department-wise retention rates
- **Termination Patterns**: Primary reasons for employee departures  
- **Manager Effectiveness**: Team performance and retention by manager
- **Performance Distribution**: High performers earn average of $54,424 vs low performers at $42,375. High/Average/Low performer categorization.

### Recruitment Efficiency
- **Cost-per-Hire**: Analysis across 8 recruitment sources
- **ROI by Source**: Investment vs. employee value correlation
- **Source Effectiveness**: Performance and tenure by recruitment channel

##  Advanced SQL Techniques Demonstrated

### Complex Joins & Data Integration
```sql
-- Multi-table joins with data quality handling
FROM core_hr h
LEFT JOIN production_staff p ON 
    UPPER(TRIM(h.Emp_FName)) = UPPER(TRIM(p.Emp_FName)) AND 
    UPPER(TRIM(h.Emp_LName)) = UPPER(TRIM(p.Emp_LName))
```

### Window Functions & Ranking
```sql
-- Performance ranking within departments
RANK() OVER (PARTITION BY Department ORDER BY Performance_Score DESC) as performance_rank
```

### Business Logic & Categorization
```sql
-- Dynamic performance categorization
CASE 
    WHEN Performance_Score >= 4 THEN 'High Performer'
    WHEN Performance_Score >= 3 THEN 'Average Performer'  
    ELSE 'Low Performer'
END as performance_category
```

### Date Calculations & Tenure Analysis
```sql
-- Employee tenure in years
DATEDIFF(COALESCE(Termination_date, CURDATE()), Hire_date) / 365.0 as tenure_years
```


### SQL Insights – Performance vs Pay

- Initial SQL queries suggested that **high performers were underpaid** compared to low performers.  
- Further investigation revealed that the `Performance_Score` column contained **hidden non-breaking spaces (0xA0)**, which caused filters like  
  `WHERE Performance_Score = 'Fully Meets'` to return zero results.  
- After cleaning the column with `TRIM/REPLACE`, the analysis changed significantly:  

  - **High performers (198 employees):** avg pay rate = 31, avg salary ≈ $45.9k  
  - **Low performers (33 employees):** avg pay rate = 33, avg salary ≈ $44.8k  
  - **Early-to-review (68 employees):** avg pay rate = 30, avg salary ≈ $52.7k  

- **Key takeaway:** pay differences across performance groups are subtle, and early-to-review employees actually appear to have the *highest average salaries*.  
- **Lesson learned:** Always validate categorical fields in SQL with `GROUP BY` and cleaning functions before drawing insights.



## 📊 Analysis Categories Performed

### 1. **Data Quality & Preparation**
- Row count validation across all tables
- Duplicate detection and removal
- Missing value assessment and documentation

### 2. **Demographic Analysis**
- Employee distribution by department, age, gender
- Race and ethnicity representation
- Marital status and citizenship patterns

### 3. **Compensation & Equity**
- Salary analysis by department and position
- Pay equity assessment against market bands
- Compensation variance investigation

### 4. **Performance Analytics**
- Performance distribution analysis
- Error rate and productivity metrics
- Performance-compensation correlation

### 5. **Retention & Turnover**
- Department-wise turnover rates
- Termination reason analysis
- Tenure patterns by various factors

### 6. **Recruitment Effectiveness**
- Cost-per-hire by source
- ROI analysis for recruitment investments
- Source quality assessment

### 7. **Management Insights**
- Manager effectiveness evaluation
- Team performance analysis
- Leadership impact on retention

## 🔄 Data Pipeline Summary

```
Raw Data → Data Cleaning → Table Creation → Quality Checks → Master Datasets → Business Analysis
```

1. **Data Preprocessing**: Excel cleanup and standardization
2. **Database Setup**: Table creation and data loading
3. **Quality Assurance**: Duplicate removal and validation
4. **Data Integration**: Complex multi-table joins with quality handling
5. **Business Intelligence**: Comprehensive analytical queries
6. **Export Preparation**: Clean datasets for Python analysis phase

## 📁 Deliverables

### SQL Scripts
- `01_database_setup.sql` - Database and table creation
- `02_data_loading.sql` - Data import statements  
- `03_data_quality_checks.sql` - Validation and cleanup queries
- `04_master_datasets.sql` - Integrated dataset creation
- `05_business_analysis.sql` - Core business intelligence queries
- `06_additional_insights.sql` - Demographic and supplementary analysis

### Datasets for Next Phase
- `employee_master_data.csv` (299 records, 31 columns)
- `recruitment_roi_analysis.csv` (22 sources analyzed)
- `department_summary.csv` (6 departments with KPIs)

### Documentation
- Query result screenshots for all major analyses
- Key findings summary with business implications
- Data quality assessment and resolution documentation

## 🎯 Business Value Demonstrated

- **Data Engineering**: Successfully integrated 4 disparate datasets
- **Problem Solving**: Resolved real-world data quality issues
- **Business Acumen**: Generated actionable HR insights
- **Technical Proficiency**: Advanced SQL techniques and optimization
- **Communication**: Clear documentation and insight presentation

## ➡️ Next Phase: Python Analysis

The cleaned and integrated datasets are now ready for advanced statistical analysis, predictive modeling, and enhanced visualization in Python.

---

*This analysis demonstrates real-world data engineering and business intelligence capabilities essential for data analyst roles.*
