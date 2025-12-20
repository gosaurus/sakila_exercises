-- film by category and total rental revenue
    SELECT
        f.film_id,
        f.title,
        c.name,
        SUM(p.amount) AS total_revenue_per_title
        -- RANK() OVER (PARTITION BY c.name ORDER BY SUM(p.amount) DESC ) AS revenue_rank
    FROM film f
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category c ON c.category_id = fc.category_id
    JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
    JOIN payment p ON p.rental_id = r.rental_id
    GROUP BY f.film_id, f.title, c.name
    ORDER BY total_revenue_per_title DESC;