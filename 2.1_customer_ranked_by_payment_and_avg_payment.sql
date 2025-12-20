
WITH sum_payment AS (
    SELECT
        p.customer_id,
        SUM(p.amount) AS total_amount
    FROM payment p
    GROUP BY p.customer_id
),
avg_payment AS (
    SELECT
        AVG(sp.total_amount) AS avg
    FROM sum_payment sp
),
total_amount_paid AS (
    SELECT
        c.customer_id,
        SUM(p.amount) AS total_amount
    FROM customer c
    JOIN payment p ON p.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
    c.customer_id,
    RANK() OVER (ORDER BY tap.total_amount DESC) AS customer_rank,
    tap.total_amount,
    avg_payment.avg,
    CASE
        WHEN  tap.total_amount >= avg_payment.avg THEN 1
        ELSE 0
    END AS is_higher_than_avg
FROM customer c
JOIN total_amount_paid tap ON tap.customer_id = c.customer_id
CROSS JOIN avg_payment;
