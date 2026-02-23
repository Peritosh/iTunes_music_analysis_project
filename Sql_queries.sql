-- =========================================
-- ITUNES MUSIC STORE ANALYSIS
-- =========================================

-- -------------------------------
-- 1. CUSTOMER ANALYTICS
-- -------------------------------

-- Q1: Customers who spent the most money
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
limit 10;

-- Q2: What is the average customer lifetime value?
SELECT 
    AVG(customer_total) AS avg_customer_lifetime_value
FROM (
    SELECT customer_id, SUM(total) AS customer_total
    FROM invoice
    GROUP BY customer_id
) AS sub;

-- Q3 : How many customers have made repeat purchases versus one-time purchases?
SELECT 
    CASE 
        WHEN invoice_count = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS purchase_type,
    COUNT(*) AS customer_count
FROM (
    SELECT customer_id, COUNT(*) AS invoice_count
    FROM invoice
    GROUP BY customer_id
) AS sub
GROUP BY purchase_type;

-- Q4 : Which country generates the most revenue per customer?
SELECT 
    c.country,
    SUM(i.total) / COUNT(DISTINCT c.customer_id) AS revenue_per_customer
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
GROUP BY c.country
ORDER BY revenue_per_customer DESC;

-- Q5 : Which customers haven't made a purchase in the last 6 months?
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    MAX(i.invoice_date) AS last_purchase
FROM customer c
JOIN invoice i 
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id
HAVING last_purchase < DATE_SUB(
    (SELECT MAX(invoice_date) FROM invoice),
    INTERVAL 6 MONTH
);


-- -------------------------------
-- 2. Sales & Revenue Analysis
-- -------------------------------

-- Q6 : What are the monthly revenue trends for the last two years?
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m') AS month,
    SUM(total) AS monthly_revenue
FROM invoice
GROUP BY month
ORDER BY month;

-- Q7 : What is the average value of an invoice (purchase)?
SELECT AVG(total) AS avg_invoice_value
FROM invoice;

-- Q8 : Which payment methods are used most frequently?
SELECT AVG(total) AS avg_invoice_value
FROM invoice;

-- Q9 : How much revenue does each sales representative contribute?
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    SUM(i.total) AS total_revenue
FROM employee e
JOIN customer c 
    ON e.employee_id = c.support_rep_id
JOIN invoice i 
    ON c.customer_id = i.customer_id
GROUP BY e.employee_id
ORDER BY total_revenue DESC;

-- Q10 : Which months or quarters have peak music sales?
SELECT 
    CONCAT(YEAR(invoice_date), '-Q', QUARTER(invoice_date)) AS quarter,
    SUM(total) AS revenue
FROM invoice
GROUP BY quarter
ORDER BY revenue DESC;


-- -------------------------------
-- 3.  Product & Content Analysis
-- -------------------------------

-- Q11 : Which tracks generated the most revenue?
SELECT 
    t.track_id,
    t.name AS track_name,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM invoice_line il
JOIN track t 
    ON il.track_id = t.track_id
GROUP BY t.track_id, t.name
ORDER BY total_revenue DESC;

-- Q12 : Which albums or playlists are most frequently included in purchases?
SELECT 
    al.album_id,
    al.title AS album_name,
    SUM(il.quantity) AS total_tracks_sold
FROM invoice_line il
JOIN track t 
    ON il.track_id = t.track_id
JOIN album al 
    ON t.album_id = al.album_id
GROUP BY al.album_id, al.title
ORDER BY total_tracks_sold DESC;

-- Q13 : Are there any tracks or albums that have never been purchased?
SELECT 
    t.track_id,
    t.name
FROM track t
LEFT JOIN invoice_line il 
    ON t.track_id = il.track_id
WHERE il.track_id IS NULL;

-- Q14 : What is the average price per track across different genres?
SELECT 
    g.genre_id,
    g.name AS genre_name,
    AVG(t.unit_price) AS avg_price
FROM track t
JOIN genre g 
    ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name
ORDER BY avg_price DESC;

-- Q15 : How many tracks does the store have per genre and how does it correlate with sales?
SELECT 
    g.name AS genre_name,
    COUNT(DISTINCT t.track_id) AS total_tracks,
    COALESCE(SUM(il.quantity), 0) AS total_sold,
    COALESCE(SUM(il.unit_price * il.quantity), 0) AS total_revenue
FROM genre g
LEFT JOIN track t 
    ON g.genre_id = t.genre_id
LEFT JOIN invoice_line il 
    ON t.track_id = il.track_id
GROUP BY g.genre_id, g.name
ORDER BY total_revenue DESC;


-- -------------------------------
-- 4.  Artist & Genre Performance
-- -------------------------------

-- Q16 : Who are the top 5 highest-grossing artists?
SELECT 
    ar.artist_id,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM invoice_line il
JOIN track t 
    ON il.track_id = t.track_id
JOIN album al 
    ON t.album_id = al.album_id
JOIN artist ar 
    ON al.artist_id = ar.artist_id
GROUP BY ar.artist_id, ar.name
ORDER BY total_revenue DESC
LIMIT 5;

-- Q17 : Which music genres are most popular in terms of:
-- Number of tracks sold :
SELECT 
    g.genre_id,
    g.name AS genre_name,
    SUM(il.quantity) AS total_tracks_sold
FROM invoice_line il
JOIN track t 
    ON il.track_id = t.track_id
JOIN genre g 
    ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name
ORDER BY total_tracks_sold DESC;

-- Total revenue : 
SELECT 
    g.genre_id,
    g.name AS genre_name,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM invoice_line il
JOIN track t 
    ON il.track_id = t.track_id
JOIN genre g 
    ON t.genre_id = g.genre_id
GROUP BY g.genre_id, g.name
ORDER BY total_revenue DESC;

-- Q18 : Are certain genres more popular in specific countries?
SELECT 
    i.billing_country,
    g.name AS genre_name,
    SUM(il.quantity) AS total_sold,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM invoice_line il
JOIN invoice i 
    ON il.invoice_id = i.invoice_id
JOIN track t 
    ON il.track_id = t.track_id
JOIN genre g 
    ON t.genre_id = g.genre_id
GROUP BY i.billing_country, g.genre_id, g.name
ORDER BY i.billing_country, total_revenue DESC;


-- -------------------------------
-- 5.  Employee & Operational Efficiency
-- -------------------------------

-- Q19 : Which employees (support representatives) are managing the highest-spending customers?
SELECT *
FROM (
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        SUM(i.total) AS total_revenue,
        RANK() OVER (
            ORDER BY SUM(i.total) DESC
        ) AS revenue_rank
    FROM employee e
    JOIN customer c 
        ON e.employee_id = c.support_rep_id
    JOIN invoice i 
        ON c.customer_id = i.customer_id
    GROUP BY e.employee_id, e.first_name, e.last_name
) ranked
ORDER BY revenue_rank;

-- Q20 : What is the average number of customers per employee?
SELECT 
    AVG(customer_count) AS avg_customers_per_employee
FROM (
    SELECT 
        e.employee_id,
        COUNT(c.customer_id) AS customer_count
    FROM employee e
    LEFT JOIN customer c 
        ON e.employee_id = c.support_rep_id
    GROUP BY e.employee_id
) sub;

-- Q21 : Which employee regions bring in the most revenue?
SELECT 
    e.country,
    e.city,
    SUM(i.total) AS total_revenue
FROM employee e
JOIN customer c 
    ON e.employee_id = c.support_rep_id
JOIN invoice i 
    ON c.customer_id = i.customer_id
GROUP BY e.country, e.city
ORDER BY total_revenue DESC;


-- -------------------------------
-- 6.  Geographic Trends
-- -------------------------------

-- Q22 : Which countries or cities have the highest number of customers?
        -- Country
SELECT 
    country,
    COUNT(customer_id) AS total_customers
FROM customer
GROUP BY country
ORDER BY total_customers DESC;

        -- City
SELECT 
    city,
    country,
    COUNT(customer_id) AS total_customers
FROM customer
GROUP BY city, country
ORDER BY total_customers DESC;

-- Q23 : How does revenue vary by region?
SELECT 
    billing_country,
    SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_country
ORDER BY total_revenue DESC;

-- Q24 : Are there any underserved geographic regions (high users, low sales)?
WITH region_stats AS (
    SELECT 
        c.country,
        COUNT(DISTINCT c.customer_id) AS total_customers,
        SUM(i.total) AS total_revenue,
        SUM(i.total) / COUNT(DISTINCT c.customer_id) AS revenue_per_customer
    FROM customer c
    JOIN invoice i 
        ON c.customer_id = i.customer_id
    GROUP BY c.country
)
SELECT *
FROM region_stats
ORDER BY revenue_per_customer ASC;


-- -------------------------------
-- 7.  Customer Retention & Purchase Patterns
-- -------------------------------

-- Q25 : What is the distribution of purchase frequency per customer?
SELECT 
    purchase_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT 
        customer_id,
        COUNT(invoice_id) AS purchase_count
    FROM invoice
    GROUP BY customer_id
) sub
GROUP BY purchase_count
ORDER BY purchase_count;

-- Q26 : How long is the average time between customer purchases?
SELECT 
    AVG(DATEDIFF(next_invoice_date, invoice_date)) 
        AS avg_days_between_purchases
FROM (
    SELECT 
        customer_id,
        invoice_date,
        LEAD(invoice_date) OVER (
            PARTITION BY customer_id 
            ORDER BY invoice_date
        ) AS next_invoice_date
    FROM invoice
) sub
WHERE next_invoice_date IS NOT NULL;

-- Q27 : What percentage of customers purchase tracks from more than one genre?
WITH customer_genre_count AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT t.genre_id) AS genre_count
    FROM customer c
    JOIN invoice i 
        ON c.customer_id = i.customer_id
    JOIN invoice_line il 
        ON i.invoice_id = il.invoice_id
    JOIN track t 
        ON il.track_id = t.track_id
    GROUP BY c.customer_id
)
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN genre_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS percentage_multi_genre_customers
FROM customer_genre_count;


-- -------------------------------
-- 8.  Operational Optimization
-- -------------------------------

-- Q28 : What are the most common combinations of tracks purchased together?
SELECT 
    t1.name AS track_1,
    t2.name AS track_2,
    COUNT(*) AS times_purchased_together
FROM invoice_line il1
JOIN invoice_line il2
    ON il1.invoice_id = il2.invoice_id
    AND il1.track_id < il2.track_id
JOIN track t1
    ON il1.track_id = t1.track_id
JOIN track t2
    ON il2.track_id = t2.track_id
GROUP BY t1.track_id, t2.track_id
ORDER BY times_purchased_together DESC
LIMIT 10;

-- Q29 : Are there pricing patterns that lead to higher or lower sales?
SELECT 
    t.unit_price,
    SUM(il.quantity) AS total_sold,
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM track t
JOIN invoice_line il
    ON t.track_id = il.track_id
GROUP BY t.unit_price
ORDER BY t.unit_price;

-- Q30 : Which media types (e.g., MPEG, AAC) are declining or increasing in usage?
SELECT 
    YEAR(i.invoice_date) AS year,
    mt.name AS media_type,
    SUM(il.quantity) AS total_sold
FROM invoice_line il
JOIN invoice i
    ON il.invoice_id = i.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN media_type mt
    ON t.media_type_id = mt.media_type_id
GROUP BY year, mt.name
ORDER BY year, total_sold DESC;
