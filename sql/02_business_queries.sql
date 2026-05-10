-- BUSINESS QUESTION: What is our overall late delivery rate?
SELECT
    COUNT(*)                                                AS total_orders,
    
    SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END)
                                                            AS late_orders,
    
    SUM(CASE WHEN late_delivery_risk = 0 THEN 1 ELSE 0 END)
                                                            AS on_time_orders,
    
    ROUND(
        100.0 * SUM(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    )                                                       AS late_delivery_pct

FROM fact_orders;

-- BUSINESS QUESTION: Which shipping modes are worst for delays?
SELECT
    shipping_mode,
    COUNT(*)                                                AS total_shipments,
    SUM(late_delivery_risk)                                 AS late_count,
    ROUND(AVG(delay_days), 2)                               AS avg_delay_days,
    ROUND(100.0 * SUM(late_delivery_risk) / COUNT(*), 2)    AS late_pct,
    ROUND(SUM(sales_per_customer), 2)                       AS total_revenue
FROM fact_orders
GROUP BY shipping_mode
ORDER BY late_pct DESC;

-- BUSINESS QUESTION: Which departments are profit drains?
SELECT
    p.department_name,
    count(DISTINCT f.order_id) AS total_orders,
    round(sum(f.order_item_quantity)) AS units_sold,
    round(sum(f.sales_per_customer)) AS total_revenue,
    round(sum(f.order_profit_per_order)) AS total_profit,
    round(
        100.0 * sum(f.order_profit_per_order)
        /nullif(sum(f.sales_per_customer), 0), 2) AS profit_margin_pct
FROM fact_orders f
JOIN dim_product p
ON f.product_card_id = p.product_card_id
GROUP BY p.department_name
ORDER BY total_profit DESC;

-- BUSINESS QUESTION: Which markets/regions are most at-risk?
SELECT
    f.market,
    f.order_region,
    COUNT(*)                                                AS order_count,
    ROUND(SUM(f.sales_per_customer), 2)                     AS revenue,
    ROUND(SUM(f.order_profit_per_order), 2)                 AS profit,
    ROUND(AVG(f.delay_days), 2)                             AS avg_delay,
    ROUND(100.0 * SUM(f.late_delivery_risk) / COUNT(*), 1)  AS late_pct

FROM fact_orders f

GROUP BY f.market, f.order_region
ORDER BY late_pct DESC
LIMIT 15;

-- BUSINESS QUESTION: Is revenue growing or declining by month?
SELECT
    d.year,
    d.month_num,
    d.month_name,
    count(DISTINCT f.order_id) AS orders,
    round(sum(f.sales_per_customer), 2) AS monthly_revenue,
    round(sum(f.order_profit_per_order), 2) AS monthly_profit,
    round(avg(f.delay_days), 2) AS avg_delays
FROM fact_orders f
JOIN dim_date d
ON date(f.order_date) = date(f.order_date)
GROUP BY d.year, d.month_num, d.month_name
ORDER BY d.year, d.month_num;

-- BUSINESS QUESTION: What is our cumulative revenue over time?
SELECT
    d.year,
    d.month_num,
    d.month_name,
    round(sum(f.sales_per_customer), 2) AS monthly_revenue,
    round(
        sum(sum(f.sales_per_customer)) OVER (
            PARTITION BY d.year
            ORDER BY d.month_num
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2) AS ytd_revenue
FROM fact_orders f
JOIN dim_date d
ON date(f.order_date) = date(d.order_date)
GROUP BY d.year, d.month_num, d.month_name
ORDER BY d.year, d.month_num;

-- BUSINESS QUESTION: Who are our top 10% customers by revenue?

WITH customer_revenue AS (
    SELECT
        f.customer_id,
        c.customer_segment,
        c.customer_country,
        ROUND(SUM(f.sales_per_customer), 2)     AS total_revenue,
        COUNT(DISTINCT f.order_id)              AS order_count

    FROM fact_orders f
    JOIN dim_customer c 
        ON f.customer_id = c.customer_id

    GROUP BY f.customer_id, c.customer_segment, c.customer_country
)

SELECT
    customer_id,
    customer_segment,
    customer_country,
    total_revenue,
    order_count,
    
    RANK() OVER (ORDER BY total_revenue DESC)   AS revenue_rank,
    
    NTILE(10) OVER (ORDER BY total_revenue DESC) AS revenue_decile
    -- Decile 1 = top 10% of customers

FROM customer_revenue
ORDER BY revenue_rank
LIMIT 20;

-- BUSINESS QUESTION: Which customer segment is most hurt by late deliveries?

SELECT
    c.customer_segment,
    COUNT(*)                                                AS total_orders,
    
    SUM(CASE WHEN f.delivery_status = 'Late Delivery'       THEN 1 ELSE 0 END)
                                                            AS late_deliveries,
    SUM(CASE WHEN f.delivery_status = 'Advance Shipping'    THEN 1 ELSE 0 END)
                                                            AS advance_shipping,
    SUM(CASE WHEN f.delivery_status = 'Shipping On Time'    THEN 1 ELSE 0 END)
                                                            AS on_time,
    SUM(CASE WHEN f.delivery_status = 'Shipping Canceled'   THEN 1 ELSE 0 END)
                                                            AS cancelled,
    
    ROUND(
        100.0 * SUM(CASE WHEN f.delivery_status = 'Late Delivery' 
                         THEN 1 ELSE 0 END) / COUNT(*), 1
    )                                                       AS late_pct

FROM fact_orders f
JOIN dim_customer c 
    ON f.customer_id = c.customer_id

GROUP BY c.customer_segment
ORDER BY late_pct DESC;





