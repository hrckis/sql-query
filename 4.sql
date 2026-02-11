-- 1.

SELECT film.film_id, film.title
FROM film
WHERE film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 1
)

-- 2.

SELECT film.film_id
FROM film
WHERE film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 1
)

-- 3.

SELECT film.film_id, film.title
FROM film
WHERE film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 1
) AND film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 10
)

-- 4.

SELECT film.film_id, film.title
FROM film
WHERE film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 1 OR film_actor.actor_id = 10
)

-- 5.

SELECT film.film_id
FROM film
WHERE film.film_id NOT IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 1
)

-- 6.

SELECT film.film_id, film.title
FROM film
WHERE film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	WHERE film_actor.actor_id = 1 OR film_actor.actor_id = 10
) AND NOT (
	film.film_id IN (
		SELECT film_actor.film_id
		FROM film_actor
		WHERE film_actor.actor_id = 1
	) AND film.film_id IN (
		SELECT film_actor.film_id
		FROM film_actor
		WHERE film_actor.actor_id = 10
	)
)

-- 7.

SELECT film.film_id, film.title
FROM film
WHERE film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.first_name LIKE 'PENELOPE'
	AND actor.last_name LIKE 'GUINESS'
) AND film.film_id IN (
	SELECT film_actor.film_id
	FROM film_actor
	JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.first_name LIKE 'CHRISTIAN'
	AND actor.last_name LIKE 'GABLE'
)

-- 8.

SELECT film.film_id, film.title
FROM film
WHERE film.film_id NOT IN (
	SELECT film_actor.film_id
	FROM film_actor
	JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.first_name LIKE 'PENELOPE'
	AND actor.last_name LIKE 'GUINESS'
)

-- 9.

SELECT customer.first_name, customer.last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id
	WHERE film.title = 'GRIT CLOCKWORK' 
	AND MONTH(rental.rental_date) = 5 
) AND customer_id IN (
	SELECT customer_id
	FROM rental
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id
	WHERE film.title = 'GRIT CLOCKWORK' 
	AND MONTH(rental.rental_date) = 6
)

-- 11.

SELECT customer.first_name, customer.last_name
FROM customer
WHERE customer.last_name IN (
	SELECT actor.last_name
	FROM actor
)

-- 12.

SELECT f1.title
FROM film f1
WHERE f1.length IN (
	SELECT f2.length
	FROM film f2
	WHERE f1.film_id != f2.film_id
)

-- 13.

SELECT f1.title
FROM film f1
WHERE f1.length < ANY (
	SELECT f2.length
	FROM film f2
	JOIN film_actor ON f2.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.first_name LIKE 'BURT' AND
	actor.last_name LIKE 'POSEY'
)

-- 14.

SELECT actor.first_name, actor.last_name
FROM actor
WHERE 50 > ANY (
	SELECT film.length
	FROM film
	JOIN film_actor ON film.film_id = film_actor.film_id
	WHERE film_actor.actor_id = actor.actor_id
)

-- 15.

SELECT DISTINCT film.film_id, film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental r1 ON inventory.inventory_id = r1.inventory_id
WHERE EXISTS (
	SELECT * FROM inventory
	JOIN rental r2 ON inventory.inventory_id = r2.inventory_id
	WHERE film.film_id = inventory.film_id 
	AND r1.rental_id != r2.rental_id
)

-- 16.

SELECT DISTINCT film.film_id, film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental r1 ON inventory.inventory_id = r1.inventory_id
WHERE EXISTS (
	SELECT * FROM inventory
	JOIN rental r2 ON inventory.inventory_id = r2.inventory_id
	WHERE film.film_id = inventory.film_id 
	AND r1.customer_id != r2.customer_id
)

-- 17.

SELECT customer.customer_id
FROM customer
JOIN rental r1 ON customer.customer_id = r1.rental_id
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN film f1 ON i1.film_id = f1.film_id
WHERE EXISTS (
	SELECT * FROM rental r2
	JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
	JOIN film f2 ON i2.film_id = f2.film_id
	WHERE customer.customer_id = r2.customer_id AND
	f1.film_id != f2.film_id AND r1.return_date >= r2.rental_date AND
	r1.rental_date <= r2.return_date
)

-- 18.

-- 19.

SELECT f1.title
FROM film f1
WHERE f1.length < ALL (
	SELECT f2.length
	FROM film f2
	JOIN film_actor ON f2.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.first_name LIKE 'BURT' AND
	actor.last_name LIKE 'POSEY'
)

SELECT actor.first_name, actor.last_name
FROM actor
WHERE 180 > ALL (
	SELECT length
	FROM film JOIN film_actor ON film.film_id = film_actor.film_id
	WHERE film_actor.actor_id = actor.actor_id
) AND actor_id IN (SELECT actor_id FROM film_actor)

SELECT customer.customer_id
FROM customer
WHERE customer.customer_id IN (
	SELECT rental.customer_id
	FROM rental
	GROUP BY rental.customer_id, MONTH(rental.rental_date)
	HAVING COUNT(*) <= 3
)

SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (
	SELECT customer_id
	FROM rental
	GROUP BY customer_id, MONTH(rental_date)
	HAVING COUNT(*) > 3
)

SELECT customer.customer_id
FROM customer
WHERE NOT EXISTS (
	SELECT * FROM rental
	WHERE rental.customer_id = customer.customer_id AND 
	MONTH(rental.rental_date) NOT  BETWEEN 6 AND 8 -- INCLUDED! 
) AND customer.customer_id IN (
	SELECT rental.customer_id FROM rental)

-- TEST

SELECT i.iid
FROM z_institution i
WHERE i.name LIKE '%CHEMIE%' AND (
	SELECT COUNT(*)
	FROM z_article_institution ai
	JOIN z_article a ON ai.aid = a.aid
	JOIN z_year_field_journal yfj ON a.jid = yfj.jid
	WHERE yfj.ranking = 'DECIL' AND yfj.year = 2017 AND ai.iid = i.iid
) > (
	SELECT COUNT(*)
	FROM z_article_institution ai
	JOIN z_article a ON ai.aid = a.aid
	JOIN z_year_field_journal yfj ON a.jid = yfj.jid
	WHERE yfj.ranking = 'DECIL' AND yfj.year = 2020 AND ai.iid = i.iid
)

SELECT ff.fid, ff.name
FROM z_field_ford ff
WHERE NOT EXISTS (
	SELECT *
	FROM z_year_field_journal yfj
	JOIN z_journal j ON yfj.jid = j.jid
	JOIN z_article a ON j.jid = a.jid
	JOIN z_article_institution ai ON a.aid = ai.aid
	JOIN z_institution i ON ai.iid = i.iid
	WHERE ff.fid = yfj.fid AND yfj.year = 2017 
	AND i.town = 'BRNO'
)
ORDER BY ff.fid

-- 1. HARD!

SELECT sub.ids, COUNT(*) AS pocet_lidi
FROM (
	SELECT ff.fid AS ids, COUNT(*) AS pocet
	FROM z_field_ford ff
	JOIN z_field_of_science fs ON ff.sid = fs.sid
	JOIN z_year_field_journal yfj ON ff.fid = yfj.fid
	JOIN z_article a ON yfj.jid = a.jid
	JOIN z_article_author aa ON a.aid = aa.aid
	WHERE yfj.ranking = 'DECIL' AND fs.name = 'NATURAL SCIENCES'
	GROUP BY ff.fid, aa.rid
	HAVING COUNT(*) >= 5
) AS sub
GROUP BY sub.ids