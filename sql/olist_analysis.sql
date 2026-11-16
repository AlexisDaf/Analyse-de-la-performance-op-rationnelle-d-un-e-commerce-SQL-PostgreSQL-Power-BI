SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM order_reviews;
SELECT COUNT(*) FROM product_category_name_translation;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    COUNT(*) AS total_orders,
    COUNT(order_approved_at) AS approved_orders,
    COUNT(order_delivered_carrier_date) AS carrier_dates,
    COUNT(order_delivered_customer_date) AS delivered_dates
FROM orders;

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

CREATE VIEW vw_orders_delivery AS

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    EXTRACT(
        DAY FROM order_approved_at - order_purchase_timestamp
    ) AS approval_days,
    EXTRACT(
        DAY FROM order_delivered_carrier_date - order_approved_at
    ) AS processing_days,
    EXTRACT(
        DAY FROM order_delivered_customer_date - order_delivered_carrier_date
    ) AS shipping_days,
    EXTRACT(
        DAY FROM order_delivered_customer_date - order_purchase_timestamp
    ) AS delivery_days,
    EXTRACT(
        DAY FROM order_delivered_customer_date - order_estimated_delivery_date
    ) AS delay_days,
    CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS is_late
FROM orders;

SELECT *
FROM vw_orders_delivery
LIMIT 20;

SELECT
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(100.0 * AVG(is_late), 2) AS late_delivery_rate
FROM vw_orders_delivery
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

  SELECT
    is_late,
    COUNT(*) AS total_orders
FROM vw_orders_delivery
WHERE order_status = 'delivered'
GROUP BY is_late
ORDER BY is_late;

CREATE VIEW vw_order_sales AS
SELECT
    order_id,
    COUNT(*) AS number_of_items,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT seller_id) AS number_of_sellers,
    ROUND(SUM(price), 2) AS product_value,
    ROUND(SUM(freight_value), 2) AS freight_value,
    ROUND(SUM(price + freight_value), 2) AS total_order_value
FROM order_items
GROUP BY order_id;

SELECT *
FROM vw_order_sales
LIMIT 20;

SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(number_of_items), 2) AS avg_items_per_order,
    ROUND(AVG(total_order_value), 2) AS avg_order_value
FROM vw_order_sales;

CREATE VIEW vw_order_performance AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,

    c.customer_city,
    c.customer_state,

    s.number_of_items,
    s.number_of_products,
    s.number_of_sellers,
    s.product_value,
    s.freight_value,
    s.total_order_value,

    d.approval_days,
    d.processing_days,
    d.shipping_days,
    d.delivery_days,
    d.delay_days,
    d.is_late
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN vw_order_sales s
    ON o.order_id = s.order_id
LEFT JOIN vw_orders_delivery d
    ON o.order_id = d.order_id;

SELECT *
FROM vw_order_performance
LIMIT 20;

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM vw_order_performance;

SELECT
    customer_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(total_order_value), 2) AS avg_order_value,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(100.0 * AVG(is_late), 2) AS late_delivery_rate
FROM vw_order_performance
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY total_orders DESC;

CREATE VIEW vw_order_reviews AS
SELECT
    order_id,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(*) AS number_of_reviews
FROM order_reviews
GROUP BY order_id;

SELECT *
FROM vw_order_reviews
LIMIT 20;

SELECT COUNT(*) AS orders_with_review
FROM vw_order_reviews;

CREATE OR REPLACE VIEW vw_order_performance AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,

    c.customer_city,
    c.customer_state,

    s.number_of_items,
    s.number_of_products,
    s.number_of_sellers,
    s.product_value,
    s.freight_value,
    s.total_order_value,

    d.approval_days,
    d.processing_days,
    d.shipping_days,
    d.delivery_days,
    d.delay_days,
    d.is_late,

    r.avg_review_score,
    r.number_of_reviews
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN vw_order_sales s
    ON o.order_id = s.order_id
LEFT JOIN vw_orders_delivery d
    ON o.order_id = d.order_id
LEFT JOIN vw_order_reviews r
    ON o.order_id = r.order_id;

SELECT *
FROM vw_order_performance
LIMIT 20;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM vw_order_performance;
WITH delivery_analysis AS (
    SELECT
        order_id,
        delay_days,
        avg_review_score,
        CASE
            WHEN delay_days <= 0 THEN 'On time'
            WHEN delay_days <= 3 THEN '1-3 days late'
            WHEN delay_days <= 7 THEN '4-7 days late'
            ELSE '8+ days late'
        END AS delivery_status
    FROM vw_order_performance
    WHERE order_status = 'delivered'
      AND delay_days IS NOT NULL
      AND avg_review_score IS NOT NULL)
SELECT
    delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(avg_review_score), 2) AS avg_review_score
FROM delivery_analysis
GROUP BY delivery_status
ORDER BY
    CASE
        WHEN delivery_status = 'On time' THEN 1
        WHEN delivery_status = '1-3 days late' THEN 2
        WHEN delivery_status = '4-7 days late' THEN 3
        WHEN delivery_status = '8+ days late' THEN 4
    END;

SELECT *
FROM products
LIMIT 10;

SELECT *
FROM product_category_name_translation
LIMIT 10;

CREATE VIEW vw_products AS
SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english AS category_name
FROM products p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name;

SELECT *
FROM vw_products
LIMIT 20;

SELECT
    p.category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
LEFT JOIN vw_products p
    ON oi.product_id = p.product_id
GROUP BY p.category_name
ORDER BY revenue DESC;

SELECT
    p.category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(op.delivery_days), 2) AS avg_delivery_days,
    ROUND(
        100.0 * AVG(op.is_late),
        2
    ) AS late_delivery_rate,
    ROUND(
        AVG(op.avg_review_score),
        2
    ) AS avg_review_score
FROM order_items oi
LEFT JOIN vw_products p
    ON oi.product_id = p.product_id
LEFT JOIN vw_order_performance op
    ON oi.order_id = op.order_id
WHERE op.order_status = 'delivered'
GROUP BY p.category_name
ORDER BY revenue DESC;

SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(op.delivery_days), 2) AS avg_delivery_days,
    ROUND(
        100.0 * AVG(op.is_late),
        2
    ) AS late_delivery_rate,
    ROUND(
        AVG(op.avg_review_score),
        2
    ) AS avg_review_score
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
LEFT JOIN vw_order_performance op
    ON oi.order_id = op.order_id
WHERE op.order_status = 'delivered'
GROUP BY
    s.seller_id,
    s.seller_state
HAVING COUNT(DISTINCT oi.order_id) >= 10
ORDER BY revenue DESC;

CREATE VIEW vw_seller_performance AS
SELECT
    s.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(op.delivery_days), 2) AS avg_delivery_days,
    ROUND(
        100.0 * AVG(op.is_late),
        2
    ) AS late_delivery_rate,
    ROUND(
        AVG(op.avg_review_score),
        2
    ) AS avg_review_score
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
LEFT JOIN vw_order_performance op
    ON oi.order_id = op.order_id
WHERE op.order_status = 'delivered'
GROUP BY
    s.seller_id,
    s.seller_state;

SELECT *
FROM vw_seller_performance
ORDER BY revenue DESC
LIMIT 20;

CREATE VIEW vw_category_performance AS
SELECT
    p.category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(op.delivery_days), 2) AS avg_delivery_days,
    ROUND(
        100.0 * AVG(op.is_late),
        2
    ) AS late_delivery_rate,
    ROUND(
        AVG(op.avg_review_score),
        2
    ) AS avg_review_score
FROM order_items oi
LEFT JOIN vw_products p
    ON oi.product_id = p.product_id
LEFT JOIN vw_order_performance op
    ON oi.order_id = op.order_id
WHERE op.order_status = 'delivered'
GROUP BY p.category_name;

SELECT *
FROM vw_category_performance
ORDER BY revenue DESC
LIMIT 20;

SELECT COUNT(*) AS rows_order_performance
FROM vw_order_performance;

SELECT COUNT(*) AS rows_seller_performance
FROM vw_seller_performance;

SELECT COUNT(*) AS rows_category_performance
FROM vw_category_performance;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM vw_order_performance;

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE total_order_value IS NULL
    ) AS missing_order_value,
    COUNT(*) FILTER (
        WHERE delivery_days IS NULL
    ) AS missing_delivery_days,
    COUNT(*) FILTER (
        WHERE avg_review_score IS NULL
    ) AS missing_review_score
FROM vw_order_performance;

SELECT
    MIN(total_order_value) AS min_order_value,
    MAX(total_order_value) AS max_order_value,
    ROUND(AVG(total_order_value), 2) AS avg_order_value
FROM vw_order_performance;

SELECT
    MIN(delivery_days) AS min_delivery_days,
    MAX(delivery_days) AS max_delivery_days,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM vw_order_performance
WHERE order_status = 'delivered';

SELECT
    MIN(avg_review_score) AS min_review_score,
    MAX(avg_review_score) AS max_review_score
FROM vw_order_performance;