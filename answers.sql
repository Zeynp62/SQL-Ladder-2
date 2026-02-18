-- 32) How many rows are in the `pets` table?
SELECT
	COUNT(*)
FROM
	PETS;
-- 33) How many female pets are in the `pets` table?
SELECT
	COUNT(*) AS FEMALE_PETS_COUNT
FROM
	PETS
WHERE
	SEX ILIKE '%f%';
-- 34) How many female cats are in the `pets` table?
SELECT
	COUNT(*) AS FEMALE_CATS_COUNT
FROM
	PETS
WHERE
	SEX ILIKE '%F%'
	AND SPECIES ILIKE '%CAT%';
-- 35) What's the mean age of pets in the `pets` table?
SELECT
	AVG(AGE) AS AVG_AGE
FROM
	PETS;
-- 36) What's the mean age of dogs in the `pets` table?
SELECT
	AVG(AGE) AS DOGS_MEAN_AGE
FROM
	PETS
WHERE
	SPECIES = 'dog';
-- 37) What's the mean age of male dogs in the `pets` table?
SELECT
	AVG(AGE) AS MALE_DOGS_MEAN_AGE
FROM
	PETS
WHERE
	SPECIES = 'dog'
	AND SEX = 'M';
-- 38) What's the count, mean, minimum, and maximum of pet ages in the `pets` table?
--     * _NOTE:_ SQLite doesn't have built-in formulas for standard deviation or median!
SELECT
	COUNT(AGE) AS AGE_COUNT,
	AVG(AGE) AS AVG_AGE,
	MAX(AGE) AS MAX_AGE,
	MIN(AGE) AS MIN_AGE
FROM
	PETS;
-- 39) Repeat the previous problem with the following stipulations:
--     * Round the average to one decimal place.
--     * Give each column a human-readable column name (for example, "Average Age")
SELECT
	COUNT(AGE) AS AGE_COUNT,
	ROUND(AVG(AGE), 1) AS AVG_AGE,
	MAX(AGE) AS MAX_AGE,
	MIN(AGE) AS MIN_AGE
FROM
	PETS;
-- 40) How many rows in `employees_null` have missing salaries?
SELECT
	COUNT(*)
FROM
	EMPLOYEES_NULL
WHERE
	SALARY IS NULL;
-- 41) How many salespeople in `employees_null` having _non_missing_ salaries?
SELECT
	COUNT(*)
FROM
	EMPLOYEES_NULL
WHERE
	SALARY IS NOT NULL
	AND JOB='Sales';
-- 42) What's the mean salary of employees who joined the company after 2010?
-- Go back to the usual `employees` table for this one.
--     * _Hint:_ You may need to use the `CAST()` function for this.
--     To cast a string as a float, you can do `CAST(x AS REAL)`
SELECT
	AVG(CAST(SALARY AS REAL))
FROM
	EMPLOYEES
WHERE
	STARTDATE > '2010-12-31';
--without 
SELECT
	AVG(SALARY)
FROM
	EMPLOYEES
WHERE
	STARTDATE > '2010-12-31';
-- 43) What's the mean salary of employees in Swiss Francs?
--     * _Hint:_ Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.
SELECT
	AVG(ALARY * 0.97)
FROM
	EMPLOYEES;
-- 44) Create a query that computes the mean salary in USD as well as CHF.
-- Give the columns human-readable names (for example "Mean Salary in USD").
-- Also, format them with comma delimiters and currency symbols.
--     * _NOTE:_ Comma-delimiting numbers is only available for integers in SQLite,
-- so rounding (down) to the nearest dollar or franc will be done for us.
--     * _NOTE2:_ The symbols for francs is simply `Fr.` or `fr.`.
-- So an example output will look like `100,000 Fr.`.
SELECT
	ROUND(AVG(SALARY * 0.97))::MONEY AS AVG_SALARY_IN_CHF,
	ROUND(AVG(SALARY))::MONEY AS AVG_USD_SALARY
FROM
	EMPLOYEES;
-- 45) What is the average age of `pets` by species?
SELECT
	SPECIES,
	AVG(AGE) AS AVG_SPECIES_AGE
FROM
	PETS
GROUP BY
	SPECIES;
-- 46) Repeat the previous problem but make sure the species label is also displayed! Assume this behavior is always being asked of you any time you use `GROUP BY`.
SELECT
	SPECIES,
	AVG(AGE) AS AVG_SPECIES_AGE
FROM
	PETS
GROUP BY
	SPECIES;
-- 47) What is the count, mean, minimum, and maximum age by species in `pets`?
SELECT
	SPECIES,
	AVG(AGE) AS AVG_SPECIES_AGE,
	COUNT(AGE) AS COUNT_OF_SPECIES_AGE,
	MAX(AGE) AS MAX_OF_SPECIES_AGE,
	MIN(AGE) AS MIN_OF_SPECIES_AGE
FROM
	PETS
GROUP BY
	SPECIES;
-- 48) Show the mean salaries of each job title in `employees`.
SELECT
	JOB,
	AVG(SALARY) AS AVG_SALARY_OF_JOB
FROM
	EMPLOYEES
GROUP BY
	JOB;
-- 49) Show the mean salaries in New Zealand dollars of each job title in `employees`.
--     * _NOTE:_ 1 USD = 1.65 NZD.
SELECT
	JOB,
	AVG(SALARY * 1.65) AS AVG_SALARY_OF_JOB_IN_NEW_ZEELAND_DOLLAR
FROM
	EMPLOYEES
GROUP BY
	JOB;
-- 50) Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.
SELECT
	JOB,
	AVG(SALARY) AS AVG_SALARY_PER_JOB_TITLE,
	MAX(SALARY) AS MAX_SALARY_FOR_JOB_TITLE,
	MIN(SALARY) AS MIN_SALARY_FOR_JOB_TITLE,
	COUNT(*)
FROM
	EMPLOYEES
GROUP BY
	JOB;
-- 51) Show the mean salaries of each job title in `employees` sorted descending by salary.
SELECT
	JOB,
	AVG(SALARY) AS AVG_SALARY_PER_JOB_TITLE,
	MAX(SALARY) AS MAX_SALARY_FOR_JOB_TITLE,
	MIN(SALARY) AS MIN_SALARY_FOR_JOB_TITLE
FROM
	EMPLOYEES
GROUP BY
	JOB
ORDER BY
	AVG(SALARY) DESC;
-- 52) What are the top 5 most common first names among `employees`?
SELECT
	FIRSTNAME,
	COUNT(*) AS NAME_COUNT
FROM
	EMPLOYEES
GROUP BY
	FIRSTNAME
ORDER BY
	COUNT(*) DESC
LIMIT
	5;
-- 53) Show all first names which have exactly 2 occurrences in `employees`.
SELECT
	FIRSTNAME,
	COUNT(*) AS NAME_COUNT
FROM
	EMPLOYEES
GROUP BY
	FIRSTNAME
HAVING
	COUNT(*) = 2;
-- 54) Take a look at the `transactions` table to get a idea of what it contains.
-- Note that a transaction may span multiple rows if different items are purchased
-- as part of the same order. The employee who made the order is also given by their ID.
SELECT
	*
FROM
	TRANSACTIONS;
-- 55) Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.
SELECT
	ORDER_ID,
	CUSTOMER,
	SUM(QUANTITY) AS TOTAL_ITEMS
FROM
	TRANSACTIONS
GROUP BY
	ORDER_ID,
	CUSTOMER
ORDER BY
	TOTAL_ITEMS DESC
LIMIT
	5;
-- 56) Show the total cost of each transaction.
--     * _Hint:_ The `unit_price` column is the price of _one_ item. The customer may have purchased multiple.
--     * _Hint2:_ Note that transactions here span multiple rows if different items are purchased.
SELECT
	ORDER_ID,
	CUSTOMER,
	SUM(UNIT_PRICE * QUANTITY) AS TOTAL_TRANSACTION_COST
FROM
	TRANSACTIONS
GROUP BY
	ORDER_ID,
	CUSTOMER
ORDER BY
	ORDER_ID;
-- 57) Show the top 5 transactions in terms of total cost.
SELECT
	ORDER_ID,
	CUSTOMER,
	SUM(UNIT_PRICE * QUANTITY) AS TOTAL_TRANSACTION_COST
FROM
	TRANSACTIONS
GROUP BY
	ORDER_ID,
	CUSTOMER
ORDER BY
	SUM(UNIT_PRICE * QUANTITY) DESC
LIMIT
	5;
-- 58) Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)
SELECT
	CUSTOMER,
	SUM(UNIT_PRICE * QUANTITY) AS TOTAL_REVENUE
FROM
	TRANSACTIONS
GROUP BY
	CUSTOMER
ORDER BY
	TOTAL_REVENUE DESC
LIMIT
	5;
-- 59) Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)
SELECT
	EMPLOYEE_ID,
	SUM(UNIT_PRICE * QUANTITY) AS TOTAL_REVENUE
FROM
	TRANSACTIONS
GROUP BY
	EMPLOYEE_ID
ORDER BY
	TOTAL_REVENUE DESC
LIMIT
	5;
-- 60) Which customer worked with the largest number of employees?
--     * _Hint:_ This is a tough one! Check out the `DISTINCT` keyword.
SELECT
	CUSTOMER,
	COUNT(DISTINCT EMPLOYEE_ID) AS NUMBER_OF_EMPLOYEES_WORKED_WITH
FROM
	TRANSACTIONS
GROUP BY
	CUSTOMER
ORDER BY
	COUNT(DISTINCT EMPLOYEE_ID) DESC
LIMIT
	1;
-- 61) Show all customers who've done more than $80,000 worth of business with us.
SELECT
	CUSTOMER,
	SUM(UNIT_PRICE * QUANTITY) AS TOT_REV
FROM
	TRANSACTIONS
GROUP BY
	CUSTOMER
HAVING
	SUM(UNIT_PRICE * QUANTITY) > 80000
ORDER BY
	SUM(UNIT_PRICE * QUANTITY) DESC;