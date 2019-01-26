use sakila;
SELECT * FROM actor;

# * 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name from actor;

# * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name, ' ',  last_name) as 'Actor Name' from actor;

# * 2a. You need to find the ID number, first name, and last name of an actor, 
# of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name LIKE 'Joe';

# * 2b. Find all actors whose last name contain the letters `GEN`:

SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

# * 2c. Find all actors whose last names contain the letters `LI`. 
# This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name;

# * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
# Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");
# * 3a. You want to keep a description of each actor. 
# You don't think you will be performing queries on a description, 
# so create a column in the table `actor` named `description` 
# and use the data type `BLOB` (Make sure to research the type `BLOB`, 
# as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor ADD COLUMN description BLOB;
SELECT * from actor;

# * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
# Delete the `description` column.
ALTER TABLE actor DROP COLUMN description;
SELECT * FROM actor;

# * 4a. List the last names of actors, as well as how many actors have that last name.

SELECT DISTINCT last_name, COUNT(actor_id) FROM actor GROUP BY last_name;

# * 4b. List last names of actors and the number of actors who have that last name, 
# but only for names that are shared by at least two actors
SELECT DISTINCT last_name, COUNT(actor_id) 
FROM actor 
WHERE COUNT(actor_id) > 1
GROUP BY last_name;


# * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
# Write a query to fix the record.
SELECT actor_id, last_name FROM actor WHERE first_name = 'GROUCHO';
UPDATE actor SET first_name = 'HARPO' WHERE actor_id=172;
SELECT * from actor WHERE actor_id=172;
# * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`.
#  It turns out that `GROUCHO` was the correct name after all! In a single query, 
# if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name='GROUCHO' WHERE actor_id=172 and first_name LIKE 'HARPO';
SELECT * from actor WHERE actor_id=172;
# * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

# * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member.
#  Use the tables `staff` and `address`:
SELECT staff.first_name, staff.last_name, address.address, address.district, address.postal_code
FROM address INNER JOIN staff ON staff.address_id=address.address_id;

# * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
# Use tables `staff` and `payment`.

SELECT staff.first_name, staff.last_name, SUM(payment.amount) 
FROM staff INNER JOIN payment ON staff.staff_id=payment.staff_id 
GROUP BY staff.staff_id;

# * 6c. List each film and the number of actors who are listed for that film. 
# Use tables `film_actor` and `film`. Use inner join.
SELECT film.title AS Film, count(film_actor.actor_id) AS Actors from film INNER JOIN film_actor 
ON film_actor.film_id = film.film_id
GROUP BY film.title;

# * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT COUNT(inventory.inventory_id) from inventory INNER JOIN film 
ON film.film_id = inventory.film_id
WHERE film.title='HUNCHBACK IMPOSSIBLE';

# * 6e. Using the tables `payment` and `customer` and the `JOIN` command,
#  list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name, customer.last_name, SUM(payment.amount)
FROM payment JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

# * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
#  As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
# Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT film.title FROM film WHERE film.title LIKE 'K%' OR film.title like 'Q%'
AND film.title IN
(SELECT film.title FROM film JOIN language
ON film.language_id=language.language_id 
WHERE language.name LIKE 'English');

# * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

# * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

# * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

# * 7e. Display the most frequently rented movies in descending order.

# * 7f. Write a query to display how much business, in dollars, each store brought in.

# * 7g. Write a query to display for each store its store ID, city, and country.

# * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

# * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

# * 8b. How would you display the view that you created in 8a?

# * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

