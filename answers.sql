-- 32) How many rows are in the `pets` table?
SELECT COUNT(*) FROM pets;
-- 33) How many female pets are in the `pets` table?
SELECT COUNT(*) AS female_count FROM pets WHERE sex ILIKE '%f%';
-- 34) How many female cats are in the `pets` table?
SELECT COUNT(*) AS female_count FROM pets WHERE sex ILIKE '%f%' AND species ILIKE '%cat%';
-- 35) What's the mean age of pets in the `pets` table?
SELECT AVG(age) AS mean_age FROM pets;
-- 36) What's the mean age of dogs in the `pets` table?
SELECT AVG(age) AS dogs_mean_age FROM pets WHERE species='dog';
-- 37) What's the mean age of male dogs in the `pets` table?
SELECT AVG(age) AS male_dogs_mean_age FROM pets WHERE species='dog' AND sex='M';
-- 38) What's the count, mean, minimum, and maximum of pet ages in the `pets` table?
--     * _NOTE:_ SQLite doesn't have built-in formulas for standard deviation or median!
SELECT COUNT(age) AS age_count,AVG(age) AS avg_age,MAX(age)AS max_age,MIN(age)AS min_age FROM pets;

-- 39) Repeat the previous problem with the following stipulations:
--     * Round the average to one decimal place.
--     * Give each column a human-readable column name (for example, "Average Age")
SELECT COUNT(age) AS age_count, ROUND(AVG(age),1) AS avg_age,MAX(age)AS max_age,MIN(age)AS min_age FROM pets;
-- 40) How many rows in `employees_null` have missing salaries?
SELECT COUNT(*) FROM employees_null WHERE salary IS NULL;
-- 41) How many salespeople in `employees_null` having _non_missing_ salaries?
SELECT COUNT(*) FROM employees_null WHERE salary IS NOT NULL AND job ILIKE '%Sales%';
-- 42) What's the mean salary of employees who joined the company after 2010?
-- Go back to the usual `employees` table for this one.
--     * _Hint:_ You may need to use the `CAST()` function for this.
--     To cast a string as a float, you can do `CAST(x AS REAL)`
SELECT AVG(CAST(salary AS REAL)) 
FROM employees
WHERE startdate > '2010-12-31';
--without 
SELECT AVG(salary) 
FROM employees
WHERE startdate > '2010-12-31';
-- 43) What's the mean salary of employees in Swiss Francs?
--     * _Hint:_ Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.
select  salary*0.97 from employees;

-- 44) Create a query that computes the mean salary in USD as well as CHF.
-- Give the columns human-readable names (for example "Mean Salary in USD").
-- Also, format them with comma delimiters and currency symbols.
--     * _NOTE:_ Comma-delimiting numbers is only available for integers in SQLite,
-- so rounding (down) to the nearest dollar or franc will be done for us.
--     * _NOTE2:_ The symbols for francs is simply `Fr.` or `fr.`.
-- So an example output will look like `100,000 Fr.`.
select  ROUND(AVG(salary*0.97))::money AS avg_salary_in_chf, ROUND(AVG(salary))::money AS avg_usd_salary from employees;
-- ## Aggregating Statistics with GROUP BY
-- 45) What is the average age of `pets` by species?
SELECT species,
    AVG(age) AS avg_species_age
FROM pets
GROUP BY species;
-- 46) Repeat the previous problem but make sure the species label is also displayed! Assume this behavior is always being asked of you any time you use `GROUP BY`.
SELECT species,
    AVG(age) AS avg_species_age
FROM pets
GROUP BY species;
-- 47) What is the count, mean, minimum, and maximum age by species in `pets`?
SELECT species,
    AVG(age) AS avg_species_age,
	COUNT(age) AS count_of_species_age,
	MAX(age) AS max_of_species_age,
	MIN(age) AS min_of_species_age
FROM pets
GROUP BY species;
-- 48) Show the mean salaries of each job title in `employees`.
SELECT job,
    AVG(salary) AS avg_salary_of_job
FROM employees
GROUP BY job;
-- 49) Show the mean salaries in New Zealand dollars of each job title in `employees`.
--     * _NOTE:_ 1 USD = 1.65 NZD.
SELECT job,
    AVG(salary*1.65) AS avg_salary_of_job_in_new_zeeland_dollar
FROM employees
GROUP BY job;
-- 50) Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.
SELECT job,
    AVG(salary) AS avg_salary_per_job_title,
	MAX(salary) AS max_salary_for_job_title,
	MIN(salary) AS min_salary_for_job_title,
	COUNT(*) 
FROM employees
GROUP BY job;

-- 51) Show the mean salaries of each job title in `employees` sorted descending by salary.
SELECT job,
    AVG(salary) AS avg_salary_per_job_title,
	MAX(salary) AS max_salary_for_job_title,
	MIN(salary) AS min_salary_for_job_title
FROM employees
GROUP BY job
ORDER BY AVG(salary) DESC;

-- 52) What are the top 5 most common first names among `employees`?
SELECT
    firstname,
    COUNT(*) AS name_count
FROM employees
GROUP BY firstname
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 53) Show all first names which have exactly 2 occurrences in `employees`.
SELECT
    firstname,
    COUNT(*) AS name_count
FROM employees
GROUP BY firstname
HAVING COUNT(*) = 2;
-- 54) Take a look at the `transactions` table to get a idea of what it contains.
-- Note that a transaction may span multiple rows if different items are purchased
-- as part of the same order. The employee who made the order is also given by their ID.
SELECT * FROM transactions;

-- 55) Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.
SELECT
    order_id,
    customer,
    SUM(quantity) AS total_items
FROM transactions
GROUP BY order_id, customer
ORDER BY total_items DESC
LIMIT 5;
-- 56) Show the total cost of each transaction.
--     * _Hint:_ The `unit_price` column is the price of _one_ item. The customer may have purchased multiple.
--     * _Hint2:_ Note that transactions here span multiple rows if different items are purchased.
SELECT
    order_id,
    customer,
    SUM(unit_price * quantity) AS total_transaction_cost
FROM transactions
GROUP BY order_id, customer
ORDER BY order_id;
-- 57) Show the top 5 transactions in terms of total cost.
SELECT
    order_id,
    customer,
    SUM(unit_price * quantity) AS total_transaction_cost
FROM transactions
GROUP BY order_id, customer
ORDER BY SUM(unit_price * quantity) DESC
LIMIT 5;

-- 58) Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)
SELECT
    customer,
    SUM(unit_price * quantity) AS total_revenue
FROM transactions
GROUP BY customer
ORDER BY total_revenue DESC
LIMIT 5;
-- 59) Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)
SELECT
    employee_id,
    SUM(unit_price * quantity) AS total_revenue
FROM transactions
GROUP BY employee_id
ORDER BY total_revenue DESC
LIMIT 5;


-- 60) Which customer worked with the largest number of employees?
--     * _Hint:_ This is a tough one! Check out the `DISTINCT` keyword.
SELECT
    customer,
    COUNT(DISTINCT employee_id) AS number_of_employees_worked_with
FROM transactions
GROUP BY customer
ORDER BY COUNT(DISTINCT employee_id) DESC
LIMIT 1;


-- 61) Show all customers who've done more than $80,000 worth of business with us.
SELECT
    customer,
    SUM(unit_price * quantity) AS total_revenue
FROM transactions
GROUP BY customer
HAVING SUM(unit_price * quantity) > 80000
ORDER BY SUM(unit_price * quantity) DESC;
