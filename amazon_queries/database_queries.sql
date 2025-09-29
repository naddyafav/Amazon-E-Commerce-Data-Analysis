-- What is the national average spent among 2021-2022?
SELECT ROUND(AVG(total_spent), 0) AS national_avg_spent,
FROM purchase_dm
WHERE YEAR(last_purchase) = 2022;

