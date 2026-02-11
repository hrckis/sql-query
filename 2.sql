-- 1.

SELECT *
FROM city INNER JOIN country ON city.country_id = country.country_id -- INNER JOIN OR JUST JOIN

-- 2.

SELECT film.title, language.name
FROM film JOIN language ON film.language_id = language.language_id

-- 3.

SELECT rental_id
FROM rental JOIN customer ON rental.customer_id = customer.customer_id
WHERE customer.last_name = 'SIMPSON'

-- 4.

SELECT address
FROM address JOIN customer ON address.address_id = customer.address_id
WHERE customer.last_name = 'SIMPSON'

-- 5.

SELECT customer.first_name, customer.last_name, address.address, address.postal_code, city.city
FROM customer 
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id

-- 6.

SELECT customer.first_name, customer.last_name, city.city -- CANNOT ENTER CITY WITHOUT ADDRESS TABLE
FROM customer 
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id

-- 7.

SELECT rental.rental_id, 
	staff.first_name AS staff_first_name, 
	staff.last_name AS staff_last_name, 
	customer.first_name AS customer_first_name, 
	customer.last_name AS customer_last_name, 
	film.title
FROM rental 
	JOIN customer ON rental.customer_id = customer.customer_id
	JOIN staff ON rental.staff_id = staff.staff_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id

-- 8.

SELECT title, actor.first_name, actor.last_name
FROM film 
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY film.title

-- 9.

SELECT actor.first_name, actor.last_name, title
FROM actor 
	JOIN film_actor ON actor.actor_id = film_actor.actor_id
	JOIN film ON film_actor.film_id = film.film_id
ORDER BY actor.first_name, actor.last_name

-- 10.

SELECT film.title --, category.name
FROM film
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Horror'

-- 11.

SELECT store.store_id, staff.first_name, staff.last_name, 
	store_address.address AS store_address, staff_address.address AS staff_address, 
	store_city.city AS store_city, staff_city.city AS staff_city,
	store_country.country AS store_country, staff_country.country AS staff_country
FROM store
	JOIN staff ON store.manager_staff_id = staff.staff_id
	JOIN address store_address ON store.address_id = store_address.address_id
	JOIN address staff_address ON staff.address_id = staff_address.address_id
	JOIN city store_city ON store_address.city_id = store_city.city_id
	JOIN city staff_city ON staff_address.city_id = staff_city.city_id
	JOIN country store_country ON store_city.country_id = store_country.country_id
	JOIN country staff_country ON staff_city.country_id = staff_country.country_id

-- 12.

SELECT film.film_id, title, actor_id, category_id
FROM film
	JOIN film_actor ON film.film_id = film_actor.film_id
	-- JOIN actor ON film_actor.actor_id = actor.actor_id -- DO NOT NEED TO USE THIS TABLE!
	JOIN film_category ON film.film_id = film_category.film_id
	-- JOIN category ON film_category.category_id = category.category_id -- THIS ALSO!
-- WHERE film.film_id = 1 -- 60 WITH FILM_ID = 1 -- CARTESIAN PRODUCT!
ORDER BY film.film_id

-- 13.

SELECT DISTINCT actor.actor_id, category.category_id, actor.first_name, actor.last_name, category.name
FROM film
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
	JOIN category ON film_category.category_id = category.category_id
ORDER BY actor.actor_id

-- 14.

SELECT DISTINCT film.title
FROM film
	JOIN inventory ON film.film_id = inventory.film_id

-- 15.

SELECT DISTINCT actor.first_name, actor.last_name
FROM film
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Comedy'
-- ALREADY ORDERED BY DISTINCT BY FIRST_NAME

-- 16.

SELECT DISTINCT customer.first_name, customer.last_name --, film.title, country.country
FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Italy' AND film.title = 'MOTIONS DETAILS'

-- 17. 

SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = 'SEAN' AND actor.last_name = 'GUINESS' AND rental.return_date IS NULL

-- 18.

SELECT payment.payment_id, payment.amount, rental.rental_date
FROM payment
	LEFT JOIN rental ON payment.rental_id = rental.rental_id -- OUTER - OPTIONAL!

-- 19.

SELECT language.name, film.title
FROM language
	LEFT JOIN film ON language.language_id = film.language_id

-- 20.

SELECT film.film_id, film.title, language.name, original_language.name
FROM film
	JOIN language ON film.language_id = language.language_id
	LEFT JOIN language original_language ON film.original_language_id = original_language.language_id

-- 21.

SELECT film.title, customer.first_name, customer.last_name, film.length
FROM film
	LEFT JOIN inventory ON film.film_id = inventory.film_id
	LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
	LEFT JOIN customer ON rental.customer_id = customer.customer_id
WHERE (customer.first_name = 'TIM' AND customer.last_name = 'CARY') OR film.length = 48

-- 22.

SELECT film.title
FROM film
	LEFT JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IS NULL

-- 23.

SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
	LEFT JOIN payment ON rental.rental_id = payment.rental_id
WHERE payment.payment_id IS NULL

-- 24.

SELECT film.title, language.name
FROM film
	LEFT JOIN language ON film.language_id = language.language_id AND language.name LIKE 'I%'

-- 25.

SELECT customer.first_name, customer.last_name, payment.amount
FROM customer
	LEFT JOIN payment ON customer.customer_id = payment.customer_id AND payment.amount > 9

-- 26.

SELECT rental.rental_id, film.title, city.city, country.country
FROM rental
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	LEFT JOIN film ON inventory.film_id = film.film_id AND film.title LIKE '%U%'
	LEFT JOIN customer ON rental.customer_id = customer.customer_id
	LEFT JOIN address ON customer.address_id = address.address_id AND address.address LIKE '%A%'
	LEFT JOIN city ON address.city_id = city.city_id -- AND city.city LIKE '%A%'
	LEFT JOIN country ON city.country_id = country.country_id -- AND country.country LIKE '%A%'

-- 27.

SELECT DISTINCT film.title, customer.last_name
FROM film
	JOIN inventory ON film.film_id = inventory.film_id
	JOIN rental ON inventory.inventory_id = rental.inventory_id
	LEFT JOIN customer ON rental.customer_id = customer.customer_id 
	AND rental_date <= '2006-01-01'
ORDER BY film.title