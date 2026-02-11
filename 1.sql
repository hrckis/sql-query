-- 1.

SELECT customer.email
FROM customer
WHERE customer.active = 0

-- 2.

SELECT film.title, film.description
FROM film
WHERE film.rating = 'G'
ORDER BY film.title DESC

-- 3.

SELECT *
FROM payment
WHERE payment.payment_date >= '2006-01-01' AND payment.amount < 2

-- 4.

SELECT film.description
FROM film
WHERE film.rating IN ('G', 'PG')

-- 5.

SELECT film.description
FROM film
WHERE film.rating IN ('G', 'PG', 'PG-13')

-- 6.

SELECT film.description
FROM film
WHERE film.rating NOT IN ('G', 'PG', 'PG-13')

-- 7.

SELECT *
FROM film
WHERE film.length > 50 AND (film.rental_duration IN (3, 5))

-- 8.

SELECT film.title
FROM film
WHERE (film.title LIKE '%RAINBOW%' OR film.title LIKE 'TEXAS%') AND film.length > 70

-- 9.

SELECT film.title --, film.description, film.rental_duration
FROM film
WHERE film.description LIKE '%AND%' 
	AND film.length BETWEEN 80 AND 90 
	AND film.rental_duration % 2 = 1

-- 10.

SELECT DISTINCT film.special_features
FROM film
WHERE film.replacement_cost BETWEEN 14 AND 16
-- ORDER BY film.special_features 

-- 11.

SELECT *
FROM film
WHERE (film.rental_duration >= 4 AND film.rating = 'PG') 
	OR (film.rental_duration < 4 AND film.rating != 'PG')

-- 12.

SELECT *
FROM address
WHERE address.postal_code IS NOT NULL

-- 13.

SELECT DISTINCT customer.customer_id
FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental.return_date IS NULL

-- 14.

SELECT payment.payment_id, YEAR(payment.payment_date), MONTH(payment.payment_date), DAY(payment.payment_date)
FROM payment

-- 15.

SELECT film.title
FROM film
WHERE LEN(film.title) != 20

-- 16.

SELECT rental.rental_id, DATEDIFF(minute, rental.rental_date, rental.return_date)
FROM rental
WHERE rental.return_date IS NOT NULL

-- 17.

SELECT customer.customer_id, customer.first_name + ' ' + customer.last_name
FROM customer
WHERE customer.active = 1

-- 18.

SELECT address.address, COALESCE(address.postal_code, '(NULL)')
FROM address

-- 19.

SELECT rental.rental_id, CAST(rental.rental_date AS VARCHAR) + ' - ' + 
		CAST(rental.return_date AS VARCHAR)
FROM rental
WHERE rental.rental_date IS NOT NULL

-- 20.

SELECT rental.rental_id, CAST(rental.rental_date AS VARCHAR) + COALESCE(' - ' + 
		CAST(rental.return_date AS VARCHAR), '')
FROM rental

-- 21.

SELECT COUNT(*)
FROM film

-- 22.

SELECT COUNT(DISTINCT film.rating)
FROM film

-- 23.

SELECT COUNT(*), COUNT(address.postal_code), COUNT(DISTINCT address.postal_code)
FROM address

-- 24.

SELECT MIN(film.length), 
	MAX(film.length), 
	AVG(CAST(film.length AS FLOAT)), 
	SUM(CAST(film.length AS FLOAT)) / COUNT(CAST(film.length AS FLOAT))
FROM film

-- 25.

SELECT COUNT(*), SUM(payment.amount)
FROM payment
WHERE YEAR(payment.payment_date) = 2005

-- 26.

SELECT SUM(LEN(film.title))
FROM film