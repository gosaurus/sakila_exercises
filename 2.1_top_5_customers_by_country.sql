-- window function exercise
-- For each country, who are the top 5 customers based on the total amount they have paid,
-- and how does their total amount paid compare to the average amount paid by customers
-- in their country?

SELECT
    c.customer_id,
    p.amount,
    SUM(p.amount) AS total_paid_by_customer
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN city ci ON ci.city_id = a.city_id
INNER JOIN country co ON co.country_id = ci.country_id
GROUP BY c.customer_id
ORDER BY SUM(p.amount) DESC;
