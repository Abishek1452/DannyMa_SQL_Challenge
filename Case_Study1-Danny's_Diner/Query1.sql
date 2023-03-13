/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT customer_id, SUM(menu.price) AS total_spent
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM dannys_diner.sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?

SELECT customer_id, MAX(menu.product_name) AS first_purchase_item
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY customer_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT menu.product_name, COUNT(*) AS num_purchases
FROM dannys_diner.sales
JOIN dannys_diner.menu using (product_id)
GROUP BY menu.product_name
ORDER BY num_purchases DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

SELECT customer_id, menu.product_name AS most_popular_item, COUNT(*) AS num_purchases
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY customer_id, menu.product_name
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM dannys_diner.sales s2
    WHERE s2.customer_id = sales.customer_id
    GROUP BY s2.product_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 6. Which item was purchased first by the customer after they became a member?

SELECT sales.customer_id, MAX(menu.product_name) AS first_purchase_item
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
JOIN dannys_diner.members ON sales.customer_id = members.customer_id AND sales.order_date >= members.join_date
GROUP BY sales.customer_id;


-- 7. Which item was purchased just before the customer became a member?

SELECT sales.customer_id, MAX(menu.product_name) AS last_purchase_item
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
LEFT JOIN dannys_diner.members ON sales.customer_id = members.customer_id AND sales.order_date >= members.join_date
WHERE members.customer_id IS NULL
GROUP BY sales.customer_id;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT sales.customer_id, COUNT(*) AS total_items, SUM(menu.price) AS total_spent
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
JOIN dannys_diner.members ON sales.customer_id = members.customer_id AND sales.order_date < members.join_date
GROUP BY sales.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT customer_id, SUM(CASE WHEN product_name = 'sushi' THEN price * 2 ELSE price END) * 10 AS points
FROM dannys_diner.sales
JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

SELECT sales.customer_id, SUM(CASE WHEN sales.order_date BETWEEN members.join_date AND members.join_date + INTERVAL '1 week' THEN menu.price * 20 ELSE menu.price * 10 END) AS points
FROM dannys_diner.sales
JOIN dannys_diner.menu using (product_id)
JOIN dannys_diner.members using (customer_id)
WHERE sales.customer_id IN ('A', 'B') AND sales.order_date <= '2021-01-31'
GROUP BY sales.customer_id;




