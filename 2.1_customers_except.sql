-- *"Identify customers who have rented 'Horror' films but not 'Family' films"*

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category cat ON cat.category_id = fc.category_id
WHERE TRIM(LOWER(cat.name)) = 'horror'
EXCEPT
SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category cat ON cat.category_id = fc.category_id
WHERE TRIM(LOWER(cat.name)) = 'family'