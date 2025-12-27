-- Create a stored procedure that accepts a month and year as parameters
-- and returns the total rental revenue for that month. The report should
-- include a breakdown of revenue by film category and the average rental
-- duration for each category.

IF EXISTS
    (
        SELECT *
        FROM sys.objects
        WHERE type = 'P' AND name = 'GetTotalRentalRevenueForMonthYear'
    )
DROP PROCEDURE GetTotalRentalRevenueForMonthYear
GO

CREATE PROCEDURE GetTotalRentalRevenueForMonthYear
    @Month INT,
    @Year INT
AS
BEGIN
    WITH film_category_info AS (
        SELECT
            i.inventory_id, 
            cat.name
        FROM film_category fc
        INNER JOIN category cat ON cat.category_id = fc.category_id
        INNER JOIN film f ON f.film_id = fc.film_id
        INNER JOIN inventory i ON i.film_id = f.film_id
    ),
    rental_durations AS (
        SELECT
            rental_id,
            inventory_id,
            DATEDIFF(DAY, r.rental_date, r.return_date) AS rental_duration 
        FROM rental r
    )
    SELECT
        fci.name,
        SUM(p.amount) AS total_amount,
        AVG(rd.rental_duration) AS monthly_avg_rental_duration
    FROM payment p
    INNER JOIN rental_durations rd ON rd.rental_id = p.rental_id
    INNER JOIN film_category_info fci ON fci.inventory_id = rd.inventory_id
    WHERE MONTH(p.payment_date) = @Month AND YEAR(p.payment_date) = @Year
    GROUP BY fci.name
END;