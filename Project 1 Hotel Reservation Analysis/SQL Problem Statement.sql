# Creating the database with name HotelM

CREATE DATABASE HotelM;
USE HotelM;

# Importing the table through import table wizard
# Displaying the table

SELECT * FROM hotelm.hotelreservation;

# QUERIES
#1. What is the total number of reservations in the dataset?

SELECT COUNT(Booking_ID)
FROM hotelreservation;

#2. Which meal plan is the most popular among guests?

SELECT MAX(type_of_meal_plan)
FROM hotelreservation;

#3. What is the average price per room for reservations involving children?

SELECT AVG(avg_price_per_room) AS avg_price_per_room
FROM hotelreservation
WHERE no_of_children > 0;

#4. How many reservations were made for the year 20XX (replace XX with the desired year)?

SELECT COUNT(*) AS num_reservations_2018
FROM hotelreservation
WHERE (arrival_date) = 2018;

#5. What is the most commonly booked room type?

SELECT MAX(room_type_reserved)
FROM hotelreservation;

#6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?

SELECT COUNT(*) AS num_weekend_reservations
FROM hotelreservation
WHERE no_of_weekend_nights > 0;

#7. What is the highest and lowest lead time for reservations?

SELECT MAX(lead_time) AS highest_lead_time, MIN(lead_time) AS lowest_lead_time
FROM hotelreservation;

#8. What is the most common market segment type for reservations?

SELECT market_segment_type, COUNT(*) AS segment_count
FROM hotelreservation
GROUP BY market_segment_type
ORDER BY segment_count DESC
LIMIT 1;

#9. How many reservations have a booking status of "Confirmed"?

SELECT COUNT(*) AS num_confirmed_reservations
FROM hotelreservation
WHERE booking_status = 'not canceled';

#10. What is the total number of adults and children across all reservations?

SELECT SUM(no_of_adults) AS total_adults, SUM(no_of_children) AS total_children
FROM hotelreservation;

#11. What is the average number of weekend nights for reservations involving children?

SELECT AVG(no_of_weekend_nights) AS avg_weekend_nights_with_children
FROM hotelreservation
WHERE no_of_children > 0;

#12. How many reservations were made in each month of the year?

SELECT
EXTRACT(MONTH FROM arrival_date) AS month,
COUNT(*) AS num_reservations
FROM
hotelreservation
GROUP BY
EXTRACT(MONTH FROM arrival_date)
ORDER BY MONTH;

SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'hotelreservation' AND COLUMN_NAME = 'arrival_date';

UPDATE hotelreservation
SET arrival_date = STR_TO_DATE(arrival_date, '%d-%m-%Y');

SET SQL_SAFE_UPDATES = 0;

#13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?

SELECT room_type_reserved, AVG(total_nights) AS avg_nights_per_room_type
FROM (
    SELECT room_type_reserved, SUM(no_of_weekend_nights + no_of_week_nights) AS total_nights
    FROM hotelreservation
    GROUP BY room_type_reserved
	) AS subquery
GROUP BY room_type_reserved;

#14. For reservations involving children, what is the most common room type, and what is the average price for that room type?

WITH ChildrenReservations AS (
    SELECT room_type_reserved, COUNT(*) AS num_reservations
    FROM hotelreservation
    WHERE no_of_children > 0
    GROUP BY room_type_reserved
    ORDER BY num_reservations DESC
    LIMIT 1
)

SELECT cr.room_type_reserved, AVG(avg_price_per_room) AS avg_price_for_room_type
FROM ChildrenReservations cr
JOIN hotelreservation yt ON cr.room_type_reserved = yt.room_type_reserved
WHERE yt.no_of_children > 0
GROUP BY cr.room_type_reserved;

#15. Find the market segment type that generates the highest average price per room.

SELECT market_segment_type, AVG(avg_price_per_room) AS avgprice_per_room
FROM hotelreservation
GROUP BY market_segment_type
ORDER BY avgprice_per_room DESC
LIMIT 1;


