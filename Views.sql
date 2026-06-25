-- VIEWS
CREATE OR REPLACE VIEW vw_customers_pending_orders AS
SELECT store.customers.name, store.orders.total
FROM store.orders
         JOIN store.customers ON store.orders.customer_id = store.customers.id
WHERE store.orders.status = 'pending';

CREATE OR REPLACE VIEW vw_orders_per_customer AS
SELECT store.customers.name AS customer_name, COUNT(store.orders.id) AS total_orders
FROM store.customers
         LEFT JOIN store.orders ON store.customers.id = store.orders.customer_id
GROUP BY customer_name
ORDER BY total_orders DESC;