-- "Which film categories have the most rentals for films with 
-- a rental rate higher than 2.99
SELECT
    cat.name,
    SUM(rs.rental_count) AS total_rentals
FROM film_category fc
INNER JOIN category cat ON cat.category_id = fc.category_id
INNER JOIN (
    SELECT
        i.film_id,
        count(r.rental_id) AS rental_count
    FROM rental r
    INNER JOIN inventory i ON i.inventory_id = r.inventory_id
    INNER JOIN film f ON f.film_id = i.film_id
    WHERE f.rental_rate > 2.99
    GROUP BY i.film_id
) AS rs ON rs.film_id = fc.film_id
GROUP BY cat.name
ORDER BY total_rentals DESC;