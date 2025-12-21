-- return all rentals by customer
IF EXISTS (
    SELECT * FROM sys.objects
    WHERE type = 'P' AND name = 'GetCustomerRentalHistory'
)
    DROP PROCEDURE GetCustomerRentalHistory;
GO

CREATE PROCEDURE GetCustomerRentalHistory
    @CustomerID INT
AS
BEGIN
    SELECT
        c.first_name,
        c.last_name,
        c.email,
        f.title,
        r.rental_date,
        r.return_date
    FROM
        customer c
        INNER JOIN rental r ON c.customer_id = r.customer_id
        INNER JOIN inventory i ON r.inventory_id = i.inventory_id
        INNER JOIN film f ON i.film_id = f.film_id
    WHERE
        c.customer_id = @CustomerID
    ORDER BY
        r.rental_date DESC;
END;