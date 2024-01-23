-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as gender_count
from hr_table
where age is not null and termdate = '0000-00-00'
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race, count(*) as no_of_employee_per_race
from hr_table
where age is not null and termdate = '0000-00-00'
group by race
order by no_of_employee_per_race desc;

-- 3. What is the age distribution of employees in the company?
select min(age) as youngest, max(age) as oldest
from hr_table
where age is not null and termdate = '0000-00-00';

select
    case
        when age between 18 and 24 then '18-24'
        when age between 25 and 34 then '25-34'
        when age between 35 and 44 then '35-44'
        when age between 45 and 54 then '45-54'
        else '55+'
    end as age_group,
    count(*) as count
from hr_table
where age is not null and termdate = '0000-00-00'
group by age_group
order by age_group;

-- 4. What is the age distribution for each gender?
SELECT
    gender,
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS count
FROM hr_table
WHERE age IS NOT NULL AND termdate = '0000-00-00'
GROUP BY gender, age_group
ORDER BY age_group, gender;

-- 5. How many employees work at headquarters versus remote locations?
select location, count(*) as count 
from hr_table
where age is not null and termdate = '0000-00-00'
group by location;

-- 6. What is the average length of employment for employees who have been terminated?
select round(avg(datediff(termdate, hire_date))/365,0) as avg_len_emp
from hr_table
where termdate <= curdate() and termdate <> '0000-00-00' and age >= 18;

-- 7. How does the gender distribution vary across departments?
select department, gender, count(*) as count
from hr_table
where age is not null and termdate = '0000-00-00'
group by department, gender
order by department;

-- 8. What is the distribution of job titles across the company?
select jobtitle, count(*) as count
from hr_table
where age is not null and termdate = '0000-00-00'
group by jobtitle
order by count desc; 

-- 9. Which department has the highest employee churn rate?
select department,
    total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
from (
    select department,
        count(*) as total_count,
        sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
    from hr_table
    where age is not null
    group by department
) as subquery
order by termination_rate desc;

-- 10. What is the distribution of employees across locations by city and state?
select location_state, count(*) as count
from hr_table
where age is not null and termdate = '0000-00-00'
group by location_state
order by count desc;

-- 11. How has the company's employee count changed over time based on hire and term dates?
select year,
    hires,
    terminations,
    hires - terminations as net_hires,
    round((hires - terminations)/hires * 100,2) as net_hire_percent
from (
    select year(hire_date) as year,
        count(*) as hires,
        sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
    from hr_table
    where age is not null
    group by YEAR(hire_date)
) as subquery
order by year asc;

-- Additional queries for employee count metrics

-- Current Employee Count
SELECT COUNT(*) AS current_employees
FROM hr_table
WHERE age IS NOT NULL AND termdate = '0000-00-00';

-- Total Terminated Employees
SELECT COUNT(*) AS terminated_employees
FROM hr_table
WHERE age IS NOT NULL AND termdate <> '0000-00-00';

-- Employee count distribution
-- Total, Active, and Terminated Employees
SELECT
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) AS active_employees,
    SUM(CASE WHEN termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS terminated_employees
FROM hr_table
WHERE age IS NOT NULL;
```