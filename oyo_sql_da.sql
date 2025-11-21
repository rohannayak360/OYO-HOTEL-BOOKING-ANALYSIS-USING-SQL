select * from oyo_city,oyo_sales;


-- 1.	Start with some basic EDA - total records , No of Hotels & Total Cities etc.
SELECT 
  (SELECT COUNT(*) FROM oyo_sales) AS total_booking_records,
  (SELECT COUNT(*) FROM oyo_city) AS total_hotels,
  (SELECT COUNT(DISTINCT city) FROM oyo_city) AS total_cities;

-- 2.	No of  hotels in different cities
select city,count(*) as hotel_in_city
from oyo_city 
group by city 
order by hotel_in_city desc;

-- 3.	Average room rates of different cities
SELECT c.city,
ROUND(AVG((s.amount - s.discount) / NULLIF(s.no_of_rooms,0)),2) AS avg_rate_per_room
FROM oyo_sales s
JOIN oyo_city c ON s.hotel_id = c.hotel_id
GROUP BY c.city;

-- 4.	Cancellation rates of different cities
select c.city,
	count(*) as total_booking,
	sum(case when s.status = 'cancelled' Then 1 else 0 end) as cancelled_booking,
	Round(100* sum(case when s.status = 'cancelled' then 1 else 0 end)/ count(*),2) as cancellation_rate
from oyo_sales s
join oyo_city c on s.hotel_id=c.hotel_id  
group by c.city
order by cancellation_rate desc;

-- 5.	No of bookings of different cities in Jan Feb Mar Months.
select c.city,
	sum(case when month (str_to_date(s.date_of_booking,'%d-%m-%y')) = 1 Then 1 else 0 end) as Jan_booking,
	sum(case when month (str_to_date(s.date_of_booking,'%d-%m-%y')) = 1 Then 1 else 0 end) as Feb_booking,
	sum(case when month (str_to_date(s.date_of_booking,'%d-%m-%y')) = 1 Then 1 else 0 end) as March_booking
from oyo_sales s
join oyo_city c on s.hotel_id = c.hotel_id
group by c.city
order by c.city;

-- 6.	What is the total number of bookings and the average number of rooms per booking?
select count(*) as Total_number_Of_Booking , round(avg(no_of_rooms) ,2)as Average_number_per_booking
from oyo_sales;

-- 7.	What are the top 5 cities with the highest number of bookings?
select c.city,count(*)  as Booking_count
from oyo_sales s
join oyo_city c on s.hotel_id = c.hotel_id
group by city
order by booking_count desc
limit 5;

-- 8.	How do bookings distribute across different statuses (e.g., confirmed, canceled, pending)?
select status,count(*) as Booking_Distribution
from oyo_sales
group by status
order by Booking_Distribution desc;

-- 9.	What is the total revenue generated and the total discount given?
select sum(amount-discount) as Total_Revenue,sum(discount) as Total_Discount_Given,sum(amount) as total_gross_amount
from oyo_sales;

-- 10.	What is the average booking amount per city?
select c.city,round(avg(s.amount-s.discount),2) as Average_booking
from oyo_sales s
join oyo_city c on s.hotel_id = c.hotel_id
group by c.city
order by Average_Booking desc;

-- 11.	How many bookings were for single rooms vs. multiple rooms?
select 
	sum(case when no_of_rooms = 1 then 1 else 0 end)as Single_room,
    sum(case when no_of_rooms > 1 then 1 else 0 end) as Multiple_room
from oyo_sales;
-- 12.	What is the average length of stay (in days) for bookings?
select
	round(avg(datediff(
    str_to_date(check_out,'%d-%m-%y'),
    str_to_date(check_in,'%d-%m-%y')
    )),2) as average_length_of_stay_days
from oyo_sales;

-- 13.	Which customers have made the most bookings (top 10 by booking count)?
select customer_id, count(*) as Most_booking
from oyo_sales
group by customer_id
order by Most_booking desc
limit 10;

-- 14.	What is the average discount percentage applied to bookings?
select round(avg(100 * discount/ nullif(amount,0)),2) as avg_discount_get
from oyo_sales;

/*ALTER TABLE oyo_sales 
CHANGE COLUMN `ï»¿booking_id` booking_id INT;
ALTER TABLE oyo_city 
CHANGE COLUMN `ï»¿hotel_id` hotel_id INT;

SHOW COLUMNS FROM oyo_sales;
SHOW COLUMNS FROM oyo_city; */





