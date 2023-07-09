-- You have been asked to find the job titles of the highest-paid employees.
-- Your output should include the highest-paid title or multiple titles with the same salary.
-- Tables: worker, title
-- Note: group by generally comes before having
SELECT t.worker_title as best_paid_title
FROM title t
INNER JOIN worker w ON t.worker_ref_id = w.worker_id
GROUP BY t.worker_title
HAVING MAX(w.salary) = (SELECT MAX(salary) FROM worker);

-- Find the 3 most profitable companies in the entire world.
-- Output the result along with the corresponding company name.
-- Sort the result based on profits in descending order.
-- Table: forbes_global_2010_2014
SELECT company, SUM(profits) AS profits
FROM forbes_global_2010_2014
GROUP BY company
ORDER BY profits DESC
LIMIT 3;

-- Calculate each user's average session time. A session is defined as the time difference between a page_load and page_exit. 
-- For simplicity, assume a user has only 1 session per day and if there are multiple of the same events on that day, consider only the latest page_load and earliest page_exit,
-- with an obvious restriction that load time event should happen before exit time event . Output the user_id and their average session time.
-- Table: facebook_web_log
with all_user_sessions as (
    SELECT t1.user_id, t1.timestamp::date as date,
           min(t2.timestamp::TIMESTAMP) - max(t1.timestamp::TIMESTAMP) as session_duration
    FROM facebook_web_log t1
    JOIN facebook_web_log t2 ON t1.user_id = t2.user_id
    WHERE t1.action = 'page_load' 
      AND t2.action = 'page_exit' 
      AND t2.timestamp > t1.timestamp
    GROUP BY 1, 2) 
SELECT user_id, avg(session_duration)
FROM all_user_sessions
GROUP BY user_id

-- Write a query that returns the number of unique users per client per month
-- Table: fact_events
select client_id, EXTRACT(MONTH FROM time_id) AS month, count(distinct user_id) as users_num  from fact_events group by client_id, month; 

-- Write a query that will calculate the number of shipments per month. The unique key for one shipment is a combination of shipment_id and sub_id. 
-- Output the year_month in format YYYY-MM and the number of shipments in that month.
-- Table: amazon_shipment
select TO_CHAR(shipment_date, 'YYYY-MM') as year_month, count(shipment_id) as count from amazon_shipment group by year_month; 

-- You have been asked to find the 5 most lucrative products in terms of total revenue for the first half of 2022 (from January to June inclusive).
-- Output their IDs and the total revenue. Table: online_orders
SELECT product_id, sum(units_sold * cost_in_dollars) AS revenue
FROM online_orders
WHERE date BETWEEN '2022-01-01' AND '2022-06-30'
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 5;

