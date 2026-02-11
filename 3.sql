-- 1.

SELECT rating, COUNT(*) as pocet
FROM film
GROUP BY rating

-- 2.

SELECT customer.customer_id, COUNT(customer.last_name) AS pocet_last_name
FROM customer
GROUP BY customer.customer_id

-- 3.

SELECT customer.customer_id, SUM(payment.amount) AS soucet
FROM customer
	JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(payment.amount)
-- -- -- -- --
SELECT customer_id, SUM(amount) AS pocet
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount)

-- 4.

SELECT actor.first_name, actor.last_name, COUNT(*) AS pocet_hercu
FROM actor
GROUP BY actor.first_name, actor.last_name
HAVING actor.last_name = actor.last_name AND actor.first_name = actor.first_name
ORDER BY COUNT(*) DESC

-- 5.

SELECT YEAR(payment.payment_date) AS rok, MONTH(payment.payment_date) AS mesic, SUM(payment.amount) AS soucet 
FROM payment
GROUP BY YEAR(payment.payment_date), MONTH(payment.payment_date)
ORDER BY YEAR(payment.payment_date), MONTH(payment.payment_date)

-- 6.

SELECT store_id, COUNT(*)
FROM inventory
GROUP BY store_id
HAVING COUNT(*) > 2300

-- 7.

SELECT language_id
FROM film
GROUP BY language_id
HAVING MIN(length) > 46
ORDER BY language_id

-- 8.

SELECT YEAR(payment_date) AS rok, MONTH(payment_date) AS mesic, SUM(amount) AS soucet
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
HAVING SUM(amount) > 20000

-- 9.

SELECT rating
FROM film
WHERE length < 50
GROUP BY rating
HAVING SUM(length) > 250
ORDER BY rating DESC

-- 10.

SELECT language_id, COUNT(*) AS pocet
FROM film
GROUP BY language_id

-- 11.

SELECT language.name, COUNT(*) AS pocet
FROM film
	JOIN language ON film.language_id = language.language_id
GROUP BY language.name
-- -- --
SELECT language.language_id, language.name, COUNT(*) AS pocet
FROM film
	JOIN language ON film.language_id = language.language_id
GROUP BY language.language_id, language.name

-- 12.

SELECT language.language_id, language.name, COUNT(film.film_id) AS pocet_filmu
FROM language
	LEFT JOIN film ON language.language_id = film.language_id
GROUP BY language.language_id, language.name

-- 13.

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS pocet
FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name

-- 14.

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(DISTINCT inventory.film_id) AS pocet
FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
	LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name

-- 15.

SELECT actor.first_name, actor.last_name
FROM actor
	JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id , actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) > 20

-- 16.

SELECT customer.customer_id, customer.first_name, customer.last_name,
		COALESCE(SUM(payment.amount), 0) AS celkem, 
		COALESCE(MIN(payment.amount), 0) AS minimum, 
		COALESCE(MAX(payment.amount), 0) AS maximum,
		COALESCE(AVG(payment.amount), 0) AS prumer
FROM customer
	LEFT JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name

-- 17.

SELECT category.category_id, category.name, 
	AVG(CAST(film.length AS FLOAT)) AS delka_filmu
FROM category
	LEFT JOIN film_category ON category.category_id = film_category.category_id
	LEFT JOIN film ON film_category.film_id = film.film_id
GROUP BY category.category_id, category.name
ORDER BY category.category_id

-- 18.

SELECT film.film_id, film.title, SUM(payment.amount) AS prijem
FROM film
	LEFT JOIN inventory ON film.film_id = inventory.film_id
	LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
	LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.film_id, film.title
HAVING SUM(payment.amount) > 100

-- 19.

SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(DISTINCT film_category.category_id)
FROM actor
	LEFT JOIN film_actor ON actor.actor_id = film_actor.actor_id
	LEFT JOIN film_category ON film_actor.film_id = film_category.film_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name

-- 20.

SELECT address.address, city.city, country.country
FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
	LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
	LEFT JOIN film_actor ON inventory.film_id = film_actor.film_id
GROUP BY address.address, city.city, country.country
HAVING COUNT(DISTINCT film_actor.actor_id) < 40

-- 21.

SELECT film.film_id, film.title, COUNT(DISTINCT address.city_id)
FROM film
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON film_category.category_id = category.category_id
	LEFT JOIN inventory ON film.film_id = inventory.film_id
	LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
	LEFT JOIN customer ON rental.customer_id = customer.customer_id
	LEFT JOIN address ON customer.address_id = address.address_id
WHERE category.name = 'Horror'
GROUP BY film.film_id, film.title

-- 22.

SELECT customer.customer_id, COUNT(DISTINCT film_category.category_id)
FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
	LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
	LEFT JOIN film_category ON inventory.film_id = film_category.film_id
WHERE country.country = 'Poland'
GROUP BY customer.customer_id

-- 23.

SELECT language.name, COUNT(film.film_id)
FROM language
	LEFT JOIN film ON language.language_id = film.language_id AND film.length > 350
GROUP BY language.name

-- 24.

SELECT customer.customer_id, COALESCE(SUM(payment.amount), 0)
FROM customer
	LEFT JOIN rental ON customer.customer_id = rental.customer_id
		AND MONTH(rental.rental_date) = 6
	LEFT JOIN payment ON rental.rental_id = payment.rental_id 
GROUP BY customer.customer_id

-- 25.

SELECT category.category_id, category.name, COUNT(film.film_id)
FROM category
	LEFT JOIN film_category ON category.category_id = film_category.category_id
	LEFT JOIN film ON film_category.film_id = film.film_id
	LEFT JOIN language ON film.language_id = language.language_id AND language.name LIKE 'E%'
GROUP BY category.category_id, category.name
ORDER BY COUNT(film.film_id)

-- 26.

SELECT film.film_id, film.title, customer.last_name, COUNT(customer.customer_id)
FROM film
	LEFT JOIN inventory ON film.film_id = inventory.film_id
	LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
	LEFT JOIN customer ON rental.customer_id = customer.customer_id 
		AND customer.last_name = 'BELL'
WHERE film.length < 50
GROUP BY film.film_id, film.title, customer.last_name
HAVING COUNT(customer.customer_id) = 1

