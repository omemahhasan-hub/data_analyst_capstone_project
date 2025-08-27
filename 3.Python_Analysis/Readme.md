# HR Analytics Capstone Project - Python Analysis Phase

- [Project Overview](#-project-overview)
- [Skills Demonstrated](#-skills-demonstrated)
- [Technical Implementation](#-technical-implementation)
- [Key Business Insights](#-key-business-insights-discovered)
- [Visualizations Created](#-visualizations-created)
- [Advanced Python Techniques](#advanced-python-techniques-demonstrated)
- [Business Value](#-business-value-demonstrated)

## 📊 Project Overview

This phase builds upon the SQL foundation to deliver advanced statistical analysis and business visualizations. Using direct MySQL integration, the Python analysis validates SQL findings, generates professional charts, and provides deeper insights into HR patterns through pandas and statistical analysis.

**Key Differentiator**: Direct database integration eliminates CSV dependencies and ensures real-time analytics capability - demonstrating enterprise-ready data pipeline skills.

**Technology Stack**: Python | Pandas | Matplotlib | Seaborn | MySQL Connector | Statistical Analysis

## 🎯 Skills Demonstrated

| Technical Skills | Business Skills | Tools Mastered |
|-----------------|----------------|----------------|
| Statistical Analysis | ROI Calculation | MySQL Integration |
| Data Visualization | Risk Assessment | Pandas/Matplotlib |
| Correlation Analysis | Executive Reporting | Business Intelligence |
| Database Integration | Cost-Benefit Analysis | Seaborn/Statistical Modeling |
| Data Pipeline Design | Strategic Insights | Real-time Analytics |

## 🔧 Technical Implementation

### Database Integration
Direct MySQL connectivity eliminates CSV dependencies and ensures real-time data access:

```python
import mysql.connector
import pandas as pd

# Direct database connection
conn = mysql.connector.connect(
    host="localhost", user="root", 
    password="password", database="capstone"
)

# Load master datasets
df1 = pd.read_sql("SELECT * FROM master_table1", conn)  # Employee master (299 records)
df2 = pd.read_sql("SELECT * FROM master_table2", conn)  # Recruitment ROI (22 sources)
df3 = pd.read_sql("SELECT * FROM master_table3", conn)  # Department summary (6 depts)
```

### Data Analysis Framework
**Statistical Validation**: Confirmed SQL insights through pandas calculations and correlation analysis  
**Business Logic Implementation**: Performance categorization, pay equity status, risk assessment  
**Visualization Strategy**: Professional charts focused on executive decision-making  

## 📈 Key Business Insights Discovered

### Compensation Equity Deep Dive
**Gender Pay Gap Validation**:
- Male employees: $33/hour average (125 employees)
- Female employees: $29/hour average (174 employees)  
- **Pay ratio confirmed**: 88% across all departments
- **Annual impact**: $8,320 average difference per employee (~$1.45M total gap across 174 female employees)

**Pay Band Analysis**:
- **76.9% (230) of workforce** paid below salary bands (retention risk)
- **Production Department**: Largest equity gaps identified
- **Employees below band**: 230 employees flagged as flight risks

### Department Performance Patterns
**Turnover Rate Analysis**:
- **Production**: 39.3% turnover rate (critical intervention needed)
- **IT Department**: 24.4% turnover despite highest salaries ($79,063 avg)
- **Sales**: 12.9% turnover (most stable department)

**Performance-Compensation Link**:
- High performers earn **5% premium** over average performers
- Age correlation: **46-55 group** commands highest salaries ($60,391)
- Manager impact: **Webster Butler's team** shows 60% turnover (leadership issue)

### Recruitment ROI Optimization
**Cost-Effectiveness Rankings**:
- **Employee Referrals**: $0 cost, 3.2 performance score (optimal ROI)
- **Information Professional Society**: Low cost, 3.3 performance score
- **CareerBuilder**: $7,790 cost for single hire (Only one hired)

**Strategic Insight**: Low-cost and free recruitment sources deliver superior performance compared to expensive channels.

### Workforce Correlation Analysis
**Key Relationships Identified**:
 **Tenure–Performance (0.15):** Slight positive correlation — employees with longer tenure tend to perform marginally better.  
 **Tenure–Pay (0.12):** Weak positive relationship — tenure has only a small influence on pay levels.  
 **Performance–Pay (0.04):** Almost no correlation — strong performance is not strongly rewarded through pay in this dataset.  

 *Business Insight:* Current compensation strategy may not effectively incentivize or reward high performance.

## 📊 Visualizations Created

### 1. Gender Pay Equity Analysis
**Type**: Box plot comparison  
**Finding**: $8,320 annual gap confirmed across departments  
**Business Impact**: Quantifies legal compliance risk and retention threat

### 2. Department Turnover Analysis
**Type**: Bar chart  
**Finding**: Production 39% turnover requires immediate intervention  
**Business Impact**: Identifies $3.9 million annual productivity loss

### 3. Pay Equity Department Breakdown
**Type**: Multi-dimensional scatter plot with bubble sizing   
**Finding**: Production shows largest pay equity gaps  
**Business Impact**: Prioritizes HR audit focus and budget allocation

### 4. Recruitment ROI Effectiveness
**Type**: Bar chart  
**Finding**: Employee referrals provide optimal cost-performance ratio  
**Business Impact**: 84 hired with $0 cost from 8 sources

### 5. Performance-Compensation Analysis
**Type**: Box plot by performance categories  
**Finding**: 5% pay premium validates merit-based compensation  
**Business Impact**: Supports expanded performance-based pay structure

### 6. Correlation Matrix Analysis
**Type**: Statistical heatmap  
**Finding**: Key relationships between tenure, performance, and pay  
**Business Impact**: Informs predictive retention modeling

### 7. Demographics and Diversity Analysis
**Type**: Pie chart 
**Finding**: Employee Distribution by Race/Ethnicity with majority of Whites 63.2% and Natives and Hispanic as minority with 1.3% each
**Business Impact**: Needs more diversity


##  Advanced Python Techniques Demonstrated

### Statistical Analysis & Business Logic
```python
# Pay equity categorization
df['pay_equity_status'] = df.apply(lambda row: 
    'Above Band' if row['Pay'] > row['sal_max'] else
    'Within Band' if row['Pay'] >= row['sal_min'] else
    'Below Band', axis=1)

# Performance correlation analysis
correlation_matrix = df[['tenure_years', 'Performance_Score', 'Pay']].corr()
```

### Advanced Visualization Techniques
```python
# Multi-dimensional scatter plot with business context
plt.scatter(df['cost_per_hire'], df['avg_performance_by_source'],
           s=df['employees_hired_from_source']*50, 
           c=df['avg_performance_by_source'], cmap='RdYlGn',
           alpha=0.7, edgecolors='black')
```

### Data Quality & Integration
**Missing Value Strategy**: Preserved NULL values for non-production employees (performance metrics)  
**Data Validation**: Cross-referenced Python calculations with SQL results  
**Business Context**: Added reference lines and quadrant analysis for executive interpretation

## 📊 Analysis Categories Performed

### 1. **Statistical Validation**
- Confirmed SQL insights through independent pandas calculations
- Correlation analysis between key business metrics
- Distribution analysis across demographic segments

### 2. **Visualization Development** 
- Professional charts for executive presentation
- Multi-dimensional analysis with business context
- Color-coding and sizing for intuitive interpretation

### 3. **Risk Assessment**
- Flight risk employee identification
- Department-specific retention threats
- Manager effectiveness evaluation

### 4. **ROI Analysis**
- Recruitment source cost-effectiveness quantification
- Performance-based compensation validation
- Workforce optimization recommendations

## 📁 Project Deliverable

**Analysis Notebook**: `hr_analytics_capstone.ipynb` - Complete end-to-end analysis with:
- Database connectivity and data validation
- Statistical analysis and correlation studies
- Professional visualizations for executive presentation  
- Business insights and ROI calculations
- Clean datasets optimized for BI dashboard development

## 🎯 Business Value Demonstrated

### Quantified Impact
**Cost Optimization**:
- $7,790 cost for single hire (Only one hired)
- $3.9 million annual productivity loss in Production department
- $8,320 per employee pay equity gap quantification

**Risk Mitigation**:
- 128 high performing employees identified as flight risks
- Department-specific turnover interventions prioritized
- Manager training needs quantified (Webster Butler team)

### Strategic Insights
- **Evidence-based hiring**: Data-driven recruitment channel optimization
- **Compensation strategy**: Performance-pay correlation validates merit increases
- **Retention planning**: Department-specific intervention strategies developed

## ➡️ Next Phase: BI Dashboard Development

Validated insights and clean datasets ready for interactive dashboard creation, completing the comprehensive analytics pipeline from database to executive presentation.

---

*This analysis demonstrates statistical validation skills, business visualization capabilities, and end-to-end data pipeline development essential for senior data analyst roles.*
