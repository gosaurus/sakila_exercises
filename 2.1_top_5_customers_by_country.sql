-- window function exercise
-- For each country, who are the top 5 customers based on the total amount they have paid,
-- and how does their total amount paid compare to the average amount paid by customers
-- in their country? (what a silly question? how can I compare total amount with average amount)

WITH customers_payments_with_country_info AS ( 
    SELECT
        c.customer_id,
        TRIM(co.country) as country,
        p.amount
    FROM customer c
    INNER JOIN payment p ON p.customer_id = c.customer_id
    INNER JOIN address a ON a.address_id = c.address_id
    INNER JOIN city ci ON ci.city_id = a.city_id
    INNER JOIN country co ON co.country_id = ci.country_id
),
average_amount_by_country AS (
    SELECT
        cc.country,
        AVG(cc.amount) AS average 
   FROM customers_payments_with_country_info cc
   GROUP BY cc.country
),
ranked_customers_by_country AS ( 
    SELECT
        cc.customer_id,
        cc.country,
        SUM(cc.amount) AS total_paid_by_customer,
        RANK() OVER (PARTITION BY cc.country ORDER BY SUM(cc.amount) DESC) AS rank_by_country
    FROM customers_payments_with_country_info cc
    GROUP BY cc.customer_id, cc.country
)
SELECT
    rc.customer_id,
    rc.country,
    rc.rank_by_country,
    ac.average,
    CASE
        WHEN rc.total_paid_by_customer > ac.average THEN 1
        ELSE 0
    END AS is_high_than_country_avg
FROM ranked_customers_by_country rc
INNER JOIN average_amount_by_country ac ON ac.country = rc.country
WHERE rank_by_country >= 1 and rank_by_country <= 5;