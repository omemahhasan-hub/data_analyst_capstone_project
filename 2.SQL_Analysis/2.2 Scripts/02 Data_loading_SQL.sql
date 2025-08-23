-- Loading data into the tables

LOAD DATA LOCAL INFILE 'C:/Users/YOUSUF HASAN/OneDrive/Afrah/OneDrive/Desktop/Portfolio/Capstone_DA/New folder/production_staff.csv'
INTO TABLE production_staff
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Emp_FName, Emp_LName, Hire_date, Termination_date, Reason_Termination, Emp_Status, Department, Position, Pay,
 Manager_Name, Performance_Score, Abutments_Hour_Wk_1, Abutments_Hour_Wk_2, Daily_Error_Rate, day_90_Complaints);

LOAD DATA LOCAL INFILE 'C:/Users/YOUSUF HASAN/OneDrive/Afrah/OneDrive/Desktop/Portfolio/Capstone_DA/New folder/recruiting_costs.csv'
INTO TABLE recruiting_costs
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`Emp_Source`, `Jan`, `Feb`, `march`, `april`, `may`, `june`, `july`, `Aug`, `sep`,
 `oct`, `nov`, `decem`, `total`);


LOAD DATA LOCAL INFILE 'C:/Users/YOUSUF HASAN/OneDrive/Afrah/OneDrive/Desktop/Portfolio/Capstone_DA/New folder/core_dataset.csv'
INTO TABLE core_hr
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Emp_FName, Emp_LName, Emp_ID, State, Zip, DOB, Age, Sex, Marital_status, CitizenDesc, hisp_latina, RaceDesc, Hire_date, Termination_date, Reason_Termination, Emp_Status, Department, Position, Pay, Manager_Name, Emp_Source, Performance_Score);

LOAD DATA LOCAL INFILE 'C:/Users/YOUSUF HASAN/OneDrive/Afrah/OneDrive/Desktop/Portfolio/Capstone_DA/New folder/salary_grid.csv'
INTO TABLE core_hr
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Position , sal_min , sal_mid , sal_max , hour_min , hour_mid , hour_max 
);