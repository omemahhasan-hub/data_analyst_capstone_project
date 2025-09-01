# Power BI Implementation - HR Analytics Dashboard

**Interactive Business Intelligence Solution for Executive Decision Making**

Transforms validated HR analytics into executive-ready dashboards with drill-through capabilities and strategic KPI tracking.

## Table of Contents
- [Dashboard Overview](#dashboard-overview)
- [Technical Implementation](#technical-implementation)
- [Data Quality & Troubleshooting](#data-quality--troubleshooting)
- [Key Features](#key-features)
- [Business Value](#business-value)
- [Files & Setup](#files--setup)

---

## Dashboard Overview

### Executive Dashboards Delivered
- **Workforce Intelligence**: Department performance, turnover analysis, demographic insights
- **Financial Impact Assessment**: Pay equity analysis, recruitment ROI, cost optimization
- **Strategic Planning View**: Risk indicators, retention forecasting, management effectiveness

**Data Integration**: MySQL → Power BI (301 employees, 6 departments, live refresh capability)

---

## Technical Implementation

### Data Model Architecture
- **Star Schema Design**: Optimized analytical performance with enforced referential integrity
- **Calculated Columns**: Annual salary standardization, tenure categorization, performance groupings
- **Cross-Platform Validation**: DAX measures verified against SQL and Python findings

### 🔧 Technical Notes
- Created calculated columns (e.g., Annual Salary) for consistent financial analysis
- Designed custom DAX measures:
  - Turnover Rate: `DIVIDE(Terminated Employees, Total Employees) * 100`
  - Pay Equity Ratio: `DIVIDE([Female Avg Pay], [Male Avg Pay]) * 100`
  - Below Band Risk: `COUNTROWS(FILTER(Employees, [Salary] < [Band_Min]))`
- Implemented conditional formatting and bookmarks for executive navigation

---

## Data Quality & Troubleshooting

### Hidden Character Data Quality Challenge
**Problem Identified**: Performance_Score filtering inconsistencies between SQL and Power BI outputs.

**Root Cause Analysis**:
- Direct filters `WHERE Performance_Score = 'Fully Meets'` returned 0 rows
- GROUP BY showed category existed with 12 employees
- Investigation revealed non-breaking spaces (0xA0) and hidden Unicode characters

**Diagnostic Process**:
```sql
-- Identified the issue using LENGTH() and HEX() functions
SELECT Performance_Score, LENGTH(Performance_Score), HEX(Performance_Score)
FROM core_hr 
GROUP BY Performance_Score;
```

**Solution Implemented**:
- Applied robust filtering with `LIKE '%Fully Meets%'` and `TRIM()` functions
- Documented data cleaning requirement for production deployment
- Recommended permanent fix: `UPDATE core_hr SET Performance_Score = TRIM(REPLACE(Performance_Score, CHAR(160), ''));`

**Professional Takeaway**: Demonstrates data wrangling expertise and quality assurance methodology essential for production analytics environments.

---

## Key Features

### Interactive Analytics
- **Bookmark Navigation**: Guided executive presentation flow
- **Drill-Through Analysis**: Department → Team → Individual insights
- **Dynamic Filtering**: Multi-dimensional workforce analysis
- **Conditional Formatting**: Automated risk indicators and performance thresholds

### Strategic KPIs Visualized
- **Financial Impact**: $6.28M annual turnover cost, $8,320 gender pay gap, recruitment ROI analysis
- **Risk Assessment**: 230 employees below pay bands, manager effectiveness correlation
- **Performance Intelligence**: High performer premiums, department benchmarking

---

## Business Value

### Strategic Intelligence Delivered
- **Retention Strategy**: Production department intervention 
- **Recruitment Optimization**: Channel reallocation potential ($50K+ annual savings)
- **Pay Equity Action Plan**: Compliance risk mitigation with quantified financial impact
- **Management Development**: Data-driven leadership effectiveness assessment

---

## Files & Setup

### Deliverables
- **[HR_Analytics_Executive_Dashboard.pbix](https://github.com/omemahhasan-hub/data_analyst_capstone_project/blob/main/4.%20Power_BI_Dashboard/4.2%20BI_dashboard_HR/capstone_BI_HR.pbix)** - Complete interactive dashboard
**[Dashboard Screenshots]** - Executive presentation visuals

  **[View Full High-Resolution Dashboard for best quality (PDF)](https://github.com/omemahhasan-hub/data_analyst_capstone_project/raw/main/4.%20Power_BI_Dashboard/4.2%20BI_dashboard_HR/capstone_BI_HR.pdf)**
 
 **Executive Overview**  
![Dashboard 1](https://github.com/omemahhasan-hub/data_analyst_capstone_project/raw/main/4.%20Power_BI_Dashboard/4.3%20Screenshots_Dashboard/HR_dashboard_overview_1.PNG)  

**Finance Trends**  
![Dashboard 2](https://github.com/omemahhasan-hub/data_analyst_capstone_project/raw/main/4.%20Power_BI_Dashboard/4.3%20Screenshots_Dashboard/HR_dashboard_finance_2.PNG)  


### Requirements
- Power BI Desktop (latest version)
- MySQL connector for data refresh
- Database credentials (provided separately)

### Usage
1. Open `.pbix` file in Power BI Desktop
2. Configure database connection for live refresh
3. Use bookmarks for executive presentation navigation

---

## Skills Demonstrated

**Business Intelligence Development**: Interactive dashboard design, data storytelling, executive communication  
**Data Management**: Star schema implementation, data quality assurance, cross-platform validation  
**Advanced Analytics**: DAX programming, performance optimization, statistical measure development  
**Problem-Solving**: Real-world data quality challenges with documented resolution methodology  

---

*Professional BI implementation demonstrating end-to-end analytical capabilities from data engineering through executive presentation.*
