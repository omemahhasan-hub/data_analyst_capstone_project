# HR Analytics Capstone Project – End-to-End Data Pipeline

**Comprehensive Analytics Solution: Raw Data → SQL Processing → Statistical Validation → Business Intelligence**

Transforming unstructured HR datasets into actionable business intelligence, identifying 32.6% turnover rate, pay equity gaps, and recruitment optimization opportunities through a complete data analytics pipeline.

- [Executive Summary](#executive-summary)
- [Technical Architecture](#technical-architecture)
- [Repository Structure](#repository-structure)
- [Business Impact Analysis](#business-impact-analysis)
- [Technical Implementation](#technical-implementation)
- [Data Governance & Quality](#data-governance--quality)
- [Skills Demonstrated](#skills-demonstrated)
- [Getting Started](#getting-started)

---

## Executive Summary

This capstone project demonstrates proficiency across the complete data analytics lifecycle, from data engineering through statistical analysis to executive-level business intelligence. The solution processes multi-format HR datasets to deliver strategic insights on workforce retention, compensation equity, and recruitment ROI optimization.

**Key Deliverables:**
- Automated data pipeline processing 301 employee records across 6 departments
- Statistical analysis identifying 32.6% annual productivity impact from turnover
- Executive dashboards enabling data-driven HR strategy decisions
- Documented methodology ensuring reproducible analytical processes

---

## Technical Architecture

### Data Pipeline Overview
```
Source Data (Multi-Sheet Excel) 
    ↓ Extract & Transform
SQL Database (Staging & Master Tables)
    ↓ Statistical Analysis
Python Analytics Engine (Direct DB Integration)
    ↓ Visualization & Reporting
Power BI Dashboards (Interactive Executive Views)
```

### Technology Stack
- **Database**: MySQL for data warehousing and staging
- **Analytics**: Python 3.x (pandas, matplotlib, seaborn, mysql-connector)
- **Business Intelligence**: Microsoft Power BI with advanced DAX measures
- **Data Volume**: 301 employee records, 22 recruitment channels, 11-year historical span

---

## Repository Structure
```
HR-Analytics-Capstone/
├── SQL/                 # Data engineering and warehouse design
├── Python/              # Statistical analysis and validation
├── PowerBI/             # Interactive dashboards and KPI tracking
├── docs/                # Documentation and exported reports
└── README.md           # Project overview and technical specifications
```

---

## Business Impact Analysis

### Financial Insights Delivered
- **Turnover Cost Analysis**: $3.9M annual productivity loss identified in Production department (39% turnover rate)
- **Pay Equity Assessment**: $8,320 average gender pay differential identified (88% female-to-male compensation ratio)
- **Recruitment ROI Optimization**: $50K+ potential annual savings through channel reallocation
- **Risk Mitigation**: 230 employees (76.9%) flagged as flight risks due to below-band compensation

### Strategic Recommendations
- **Retention Strategy**: Targeted intervention in Production department could yield $1.2M annual savings
- **Compensation Review**: Pay equity adjustments to reduce compliance risk and improve retention
- **Recruitment Reallocation**: Shift budget from high-cost channels (CareerBuilder: $7.8K/hire) to referral programs
- **Management Development**: Address leadership gaps contributing to disproportionate team turnover

---

## Technical Implementation

### Phase 1: SQL Data Engineering
- **Data Wrangling**: Comprehensive cleansing and standardization of unstructured source datasets
- **ETL Pipeline**: Automated extraction, transformation, and loading of multi-format datasets
- **Data Warehouse Design**: Normalized schema with derived metrics for analytical efficiency
- **Data Quality Management**: Validation rules, constraint implementation, and integrity checks

### Phase 2: Python Statistical Analysis
- **Database Integration**: Direct MySQL connectivity eliminating file-based dependencies
- **Correlation Analysis**: Statistical validation of compensation, performance, and retention relationships
- **ROI Calculations**: Quantitative analysis of recruitment channel effectiveness
- **Visualization**: Professional-grade charts supporting executive decision-making

### Phase 3: Power BI Business Intelligence
- **Dashboard Development**: Interactive KPI tracking with drill-through capabilities
- **DAX Optimization**: Custom measures ensuring consistency with SQL analytical layer
- **Executive Storytelling**: Bookmark-driven narratives for strategic presentations
- **Data Model Alignment**: Resolved calculation discrepancies between SQL and DAX implementations

---

## Data Governance & Quality

### Quality Assurance Process
During implementation, calculation discrepancies were identified between SQL queries and DAX measures. Resolution included:

- **Cross-Platform Validation**: Python verification of SQL and DAX calculations
- **Logic Standardization**: Unified calculation methodology across all analytical layers  
- **Documentation**: Comprehensive technical specifications ensuring reproducible results

This multi-layer validation ensures analytical accuracy and stakeholder confidence in reported insights.

---

## Skills Demonstrated

**Data Engineering**: SQL database design, ETL pipeline development, data quality management  
**Statistical Analysis**: Python-based correlation analysis, ROI modeling, predictive insights  
**Business Intelligence**: Power BI dashboard development, DAX programming, executive reporting  
**Business Translation**: Converting technical findings into strategic recommendations with quantified impact  
**Project Management**: End-to-end delivery from requirements through executive presentation  

---

## Getting Started

Each phase includes detailed documentation and setup instructions:

- **[SQL Implementation Guide](2.SQL_Analysis/2.1 Readme.md)** - Database setup and ETL procedures
- **[Python Analysis Documentation](3.Python_Analysis/Readme.md)** - Statistical methods and validation processes  
- **[Power BI Dashboard Guide](PowerBI/README.md)** - Dashboard functionality and KPI definitions

---

*This project demonstrates the complete data analytics value chain: transforming raw organizational data into strategic business intelligence that drives measurable organizational outcomes.*
