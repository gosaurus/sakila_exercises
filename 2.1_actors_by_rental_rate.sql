SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    AVG(fr.rental_rate) as avg_rental_rate
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film fr ON fr.film_id = fa.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING avg(fr.rental_rate) > 2.99
ORDER BY avg_rental_rate DESC;