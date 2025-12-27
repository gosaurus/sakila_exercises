-- Create a stored procedure that accepts a category ID as a parameter and
-- returns the top 5 rented films in that category along with the
-- total number of rentals for each film.

-- 1. count all films by number of rentals
-- 2. join with category and order by rental count desc
-- 3. select top 5 rows

IF EXISTS
    (
        SELECT *
        FROM sys.objects
        WHERE type = 'P' AND name = 'GetTop5FilmsForGivenCategory'
    )
DROP PROCEDURE GetTop5FilmsForGivenCategory
GO

CREATE PROCEDURE GetTop5FilmsForGivenCategory
    @CategoryName VARCHAR(25)
AS
BEGIN
    SELECT TOP 5
        cat.name,
        rs.title,
        rs.rental_count
    FROM film_category fc
    INNER JOIN category cat ON cat.category_id = fc.category_id
    INNER JOIN (
        SELECT  
            f.title,
            f.film_id,
            COUNT(r.rental_id) AS rental_count
        FROM rental r
        INNER JOIN inventory i ON i.inventory_id = r.inventory_id
        INNER JOIN film f ON f.film_id = i.film_id
        GROUP BY f.title, f.film_id
    ) AS rs ON rs.film_id = fc.film_id
    WHERE 
        LOWER(cat.name) = LOWER(@CategoryName)
    ORDER BY
        rs.rental_count DESC
END;