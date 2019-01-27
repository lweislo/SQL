use sakila;
SELECT * FROM actor;

# * 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;

# * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, ' ',  last_name) 
AS 'Actor Name' 
FROM actor;

# * 2a. You need to find the ID number, first name, and last name of an actor, 
# of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE 'Joe';

# * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name 
FROM actor 
WHERE last_name 
LIKE "%GEN%";


# * 2c. Find all actors whose last names contain the letters `LI`. 
# This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name 
FROM actor 
WHERE last_name 
LIKE "%LI%" 
ORDER BY last_name, first_name;


# * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
# Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country 
WHERE country IN ("Afghanistan", "Bangladesh", "China");


# * 3a. create a column in the table `actor` named `description` 
# and use the data type `BLOB` (Make sure to research the type `BLOB`, 
# as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor ADD COLUMN description MEDIUMBLOB;
SELECT * from actor;

# * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
# Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;
SELECT * FROM actor;

# * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(actor_id) AS 'Number of actors' 
FROM actor 
GROUP BY last_name;

# * 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors
SELECT last_name, COUNT(actor_id) 
FROM actor 
GROUP BY last_name
HAVING COUNT(actor_id) > 1;


# * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
# Write a query to fix the record.
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'GROUCHO';
#Charnging Groucho to Harpo
UPDATE actor SET first_name = 'HARPO' WHERE actor_id=172;
#Checking it worked
SELECT * from actor WHERE actor_id=172;


# * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`.
#  It turns out that `GROUCHO` was the correct name after all! In a single query, 
# if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
# Changing Groucho back to Harpo
UPDATE actor SET first_name='GROUCHO' 
WHERE actor_id=172 AND first_name LIKE 'HARPO';
#Checking it worked
SELECT * from actor WHERE actor_id=172;


# * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;


# * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member.
#  Use the tables `staff` and `address`:
SELECT first_name, last_name, address, district, postal_code
FROM address a INNER JOIN staff s ON s.address_id=a.address_id;


# * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
# Use tables `staff` and `payment`.

SELECT CONCAT(first_name, ' ', last_name) AS 'Staff Member', CONCAT('$' , SUM(amount)) AS 'Total Sales'
FROM staff s
INNER JOIN payment p ON s.staff_id=p.staff_id 
GROUP BY s.staff_id;


# * 6c. List each film and the number of actors who are listed for that film. 
# Use tables `film_actor` and `film`. Use inner join.
SELECT film.title AS Film, count(film_actor.actor_id) AS Actors 
FROM film 
INNER JOIN film_actor 
ON film_actor.film_id = film.film_id
GROUP BY film.title;


# * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT COUNT(inventory.inventory_id) AS 'Copies of Hunchback Impossible'
FROM inventory 
INNER JOIN film 
ON film.film_id = inventory.film_id
WHERE film.title='HUNCHBACK IMPOSSIBLE';


# * 6e. Using the tables `payment` and `customer` and the `JOIN` command,
#  list the total paid by each customer. List the customers alphabetically by last name:
SELECT CONCAT(first_name, ' ', last_name) AS 'Customer', CONCAT('$', SUM(amount)) AS 'Total Bill'
FROM payment p
    JOIN customer c
    ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
    ORDER BY c.last_name;


# * 7a. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film f 
WHERE title LIKE 'K%' OR title like 'Q%'
AND title IN
    (SELECT title FROM film f JOIN language l
    ON f.language_id=l.language_id 
    WHERE l.name LIKE 'English');


# * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor'
FROM actor
WHERE actor_id IN
    (SELECT actor_id FROM film_actor 
    WHERE film_id IN
        (SELECT film_id FROM film
    WHERE title='ALONE TRIP'));


# * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT name AS 'Canadian Customer', email
FROM customer c
    JOIN customer_list cl
    ON c.customer_id = cl.id
    WHERE country = 'CANADA';


# * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title from film
WHERE film_id IN
    (SELECT film_id FROM film_category
    WHERE category_id IN
        (SELECT category_id FROM category
        WHERE name='FAMILY'));


# * 7e. Display the most frequently rented movies in descending order.
SELECT title, count(f.film_id) AS 'Rental Count' FROM film f
    JOIN inventory i
    ON f.film_id=i.film_id
    WHERE i.inventory_id IN
        (SELECT inventory_id
        FROM rental)
GROUP BY f.film_id
ORDER BY count(f.film_id) DESC, title ASC;

# * 7f. Write a query to display how much business, in dollars, each store brought in.
# The easy way
SELECT * from sales_by_store;
#Or the hard way
SELECT s.store_id, c.city, cy.country, CONCAT('$ ',SUM(p.amount)) AS 'Total Sales'
FROM payment p JOIN rental r on p.rental_id=r.rental_id
    JOIN inventory i ON r.inventory_id=i.inventory_id
        JOIN store s on i.store_id=s.store_id
            JOIN address a ON s.address_id=a.address_id
                JOIN city c on a.city_id=c.city_id
                    JOIN country cy ON c.country_id=cy.country_id
GROUP BY s.store_id
ORDER BY cy.country, c.city;

# * 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, city.city, country.country 
FROM store s 
    JOIN address a ON s.address_id = a.address_id
        JOIN city ON a.city_id = city.city_id
            JOIN country ON city.country_id=country.country_id;
# * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT c.name AS 'Film Category', CONCAT('$ ', SUM(p.amount)) AS  'Gross Revenue' FROM category c
LEFT JOIN film_category fc
    ON c.category_id = fc.category_id 
        LEFT JOIN inventory i
        ON fc.film_id = i.film_id
            LEFT JOIN rental r
            ON i.inventory_id=r.inventory_id
                LEFT JOIN payment p
                ON r.rental_id=p.rental_id
GROUP BY c.category_id;
# * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW genre_gross AS
SELECT c.name AS 'Film Category', CONCAT('$ ', SUM(p.amount)) AS  'Gross Revenue' FROM category c
LEFT JOIN film_category fc
    ON c.category_id = fc.category_id 
        LEFT JOIN inventory i
        ON fc.film_id = i.film_id
            LEFT JOIN rental r
            ON i.inventory_id=r.inventory_id
                LEFT JOIN payment p
                ON r.rental_id=p.rental_id
GROUP BY c.category_id;

# * 8b. How would you display the view that you created in 8a?
SELECT * FROM genre_gross;
# * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW genre_gross;