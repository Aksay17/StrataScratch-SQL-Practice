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

-- Meta/Facebook has developed a new programing language called Hack.To measure the popularity 
-- of Hack they ran a survey with their employees. The survey included data on previous programing familiarity as well as the number 
-- of years of experience, age, gender and most importantly satisfaction with Hack. Due to an error location data was not collected, 
-- but your supervisor demands a report showing average popularity of Hack by office location. 
-- Luckily the user IDs of employees completing the surveys were stored. Based on the above, find the average popularity of the Hack per office location.
-- Output the location along with the average popularity. Tables: facebook_employees, facebook_hack_survey
select e.location, avg(h.popularity) from facebook_employees e join facebook_hack_survey h on e.id = h.employee_id 
group by e.location;

-- Find the average number of bathrooms and bedrooms for each city’s property types.
-- Output the result along with the city name and the property type.
-- Table: airbnb_search_details
select city, property_type, avg(bathrooms), avg(bedrooms) 
from airbnb_search_details
group by city, property_type

-- Find order details made by Jill and Eva.
-- Consider the Jill and Eva as first names of customers.
-- Output the order date, details and cost along with the first name.
-- Order records based on the customer id in ascending order.
-- Tables: customers, orders
select c.first_name, o.order_date, o.order_details, o.total_order_cost from customers c join orders o on c.id = o.cust_id 
where first_name = 'Jill' or first_name = 'Eva' order by c.id;

-- Find the number of Apple product users and the number of total users with a device and group the counts by language. 
-- Assume Apple products are only MacBook-Pro, iPhone 5s, and iPad-air. Output the language along with the total number 
-- of Apple users and users with any device. Order your results based on the number of total users in descending order.
-- Tables: playbook_events, playbook_users
SELECT users.language,
       COUNT (DISTINCT CASE
                           WHEN device IN ('macbook pro',
                                           'iphone 5s',
                                           'ipad air') THEN users.user_id
                           ELSE NULL
                       END) AS n_apple_users,
       COUNT(DISTINCT users.user_id) AS n_total_users
FROM playbook_users users
INNER JOIN playbook_events events ON users.user_id = events.user_id
GROUP BY users.language
ORDER BY n_total_users DESC;

-- Find the activity date and the pe_description of facilities with the name 'STREET CHURROS' and with a score of less than 95 points.
-- Table: los_angeles_restaurant_health_inspections
SELECT activity_date, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE facility_name = 'STREET CHURROS' AND score < 95;

-- Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase
-- within 7 days of any other of their purchases. Output a list of user_ids of these returning active users.
-- Table: amazon_transactions
SELECT DISTINCT(a1.user_id)
FROM amazon_transactions a1
JOIN amazon_transactions a2 ON a1.user_id=a2.user_id
AND a1.id <> a2.id
AND a2.created_at::date-a1.created_at::date BETWEEN 0 AND 7
ORDER BY a1.user_id

-- Compare each employee's salary with the average salary of the corresponding department.
-- Output the department, first name, and salary of employees along with the average salary of that department.
-- Table: employee
SELECT 
        department, 
        first_name, 
        salary, 
        AVG(salary) over (PARTITION BY department) 
FROM employee;

-- We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. 
-- Find the current salary of each employee assuming that salaries increase each year. Output their id, first name, last name, 
-- department ID, and current salary. Order your list by employee ID in ascending order.
-- Table: ms_employee_salary
select id, first_name, last_name, max(salary), department_id from ms_employee_salary 
group by id, first_name, last_name, department_id order by id

-- Find the number of workers by department who joined in or after April.
-- Output the department name along with the corresponding number of workers.
-- Sort records based on the number of workers in descending order.
-- Table: worker
select department, count(worker_id) from worker where joining_date > '2014-04-01' group by department order by count(worker_id) desc; 
