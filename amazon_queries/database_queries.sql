-- What is the national average spent among 2021-2022?
SELECT ROUND(AVG(total_spent), 0) AS national_avg_spent,
FROM purchase_dm
WHERE YEAR(last_purchase) = 2022;

-- What states have higher orders per respondent than the national average?
SELECT   `Q-demos-state` AS state,
ROUND(AVG(total_spent), 0) AS avg_spent_per_respondent
FROM purchase_dm
WHERE YEAR(last_purchase) = 2022
GROUP BY `Q-demos-state`
  
HAVING AVG(total_spent) > (
  SELECT AVG(total_spent)
  FROM purchase_dm
  WHERE YEAR(last_purchase) = 2022
)
ORDER BY avg_spent_per_respondent DESC;

-- What states have lower orders per respondent than the national average?
SELECT `Q-demos-state` AS state,
ROUND(AVG(total_spent), 0) AS avg_spent_per_respondent
FROM purchase_dm
WHERE YEAR(last_purchase) = 2022
GROUP BY `Q-demos-state`
  
HAVING AVG(total_spent) < (
  SELECT AVG(total_spent)
  FROM purchase_dm
  WHERE YEAR(last_purchase) = 2022
)
ORDER BY avg_spent_per_respondent ASC;

-- What states represent the top 10 in average spent?
SELECT 
    `Q-demos-state` AS state,
    ROUND(AVG(total_spent), 0) AS avg_spent_per_respondent
FROM
    purchase_dm
WHERE
    YEAR(last_purchase) = 2022
GROUP BY `Q-demos-state`
HAVING AVG(total_spent) > (SELECT 
        AVG(total_spent)
    FROM
        purchase_dm
    WHERE
        YEAR(last_purchase) = 2022)
ORDER BY avg_spent_per_respondent DESC
LIMIT 11;

-- What states represent the bottom 10 in average spent?
SELECT
  `Q-demos-state` AS state,
  ROUND(AVG(total_spent), 0) AS avg_spent_per_respondent
FROM purchase_dm
WHERE YEAR(last_purchase) = 2022
GROUP BY `Q-demos-state`
HAVING AVG(total_spent) < (
    SELECT AVG(total_spent)
    FROM purchase_dm
    WHERE YEAR(last_purchase) = 2022
)
ORDER BY avg_spent_per_respondent ASC
LIMIT 10;

-- What key demographics represent the top 10% of respondants?
SELECT  d.`Survey ResponseID` AS survey_response_id,
  d.total_spent,
  d.orders,
  d.first_purchase,
  d.last_purchase,
  d.`Q-demos-age`    AS age_group,
  d.`Q-demos-income` AS income_band,
  d.`Q-demos-state`  AS state,
  d.`Q-demos-gender`  AS gender
FROM purchase_dm AS d
ORDER BY
  d.total_spent DESC,
  d.orders DESC,
  d.first_purchase ASC,
  d.`Survey ResponseID` ASC
LIMIT 500;

-- What are the quartly stats?
SELECT YEAR(order_date) AS yr,
  QUARTER(order_date) AS qtr,
  ROUND(SUM(purchase_amount), 0) AS total_spent
FROM purchase_rid
GROUP BY YEAR(order_date), QUARTER(order_date)
ORDER BY yr, qtr;

-- Do buying patterns differ by gender throughout the year?
SELECT YEAR(order_date) AS yr,
  MONTH(order_date) AS mo,
  `Q-demos-gender` AS gender,
  ROUND(SUM(purchase_amount) / COUNT(DISTINCT `Survey ResponseID`), 0) AS avg_spent_per_customer
FROM purchase_rid
GROUP BY YEAR(order_date), MONTH(order_date), `Q-demos-gender`
ORDER BY yr, mo, gender;

