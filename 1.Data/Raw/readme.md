# Data Sources

## Original Dataset
| Dataset | Source | Description | Records | Link |
|---------|---------|-------------|---------|------|
| Human Resources Data Set | Kaggle | Enterprise HR dataset with multi-departmental structure | 301 (subset) | [Kaggle Dataset v2](https://www.kaggle.com/datasets/rhuebner/human-resources-data-set/versions/2?select=core_dataset.csv) |

## Data Processing Notes
- Source data downloaded from Kaggle (Version 2 - multi-sheet Excel format)
- Legacy dataset format intentionally selected to demonstrate comprehensive data engineering capabilities
- Unstructured source data included data quality challenges typical of enterprise HR systems
- Complete analytics pipeline: SQL data engineering → Python statistical validation → Power BI visualization
- Dataset contains no personally identifiable information (PII)

## Repository Usage
1. Download original dataset from Kaggle link above
2. Review SQL scripts in `/SQL/` folder for data transformation logic
3. Python analysis connects directly to processed database
4. Power BI dashboard refreshes from cleaned data model
