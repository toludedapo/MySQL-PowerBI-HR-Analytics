-- Create a new database named HR
create database HR;

-- Switch to the HR database
use HR;

-- Select all records from the hr_table
select * from hr_table;

-- Data Cleaning Section

-- Change the datatype of the emp_id column to varchar(20) and make it not null
alter table hr_table
change column ï»¿id emp_id varchar(20) not null;

-- Display the structure of the hr_table
describe hr_table;

-- Set sql_safe_updates to 0 to allow updates without safe mode restrictions

set sql_safe_updates = 0;

-- Update the birthdate column, converting string dates to the datetime format
update hr_table
set birthdate = 
    case
        when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
        when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
        else null
    end;

-- Modify the datatype of the birthdate column from string to date
alter table hr_table
modify column birthdate date;

-- Update the hire_date column, converting string dates to the datetime format
update hr_table
set hire_date =
    case
        when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
        when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
        else null
    end;

-- Modify the datatype of the hire_date column from string to date
alter table hr_table
modify column hire_date date;

-- Update the termdate column, converting string dates to the datetime format
UPDATE hr_table
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE TRUE;

-- Modify the datatype of the termdate column from string to date
alter table hr_table
modify column termdate date;

-- Add a new column age to hr_table with datatype int
alter table hr_table
add column age int;

-- Update the age column with the calculated age based on birthdate
update hr_table
set age = timestampdiff(YEAR, birthdate, curdate());

-- Display all records from hr_table
select * from hr_table;

-- Count the number of records where age is less than 18
select count(*)
from hr_table
where age < 18;

-- Update the age column, setting it to null for records with age less than 18
update hr_table
set age = 
    case
        when timestampdiff(YEAR, birthdate, curdate()) < 18 then null
        else timestampdiff(YEAR, birthdate, curdate())
    end;
