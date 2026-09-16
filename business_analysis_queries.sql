
-- =====================================================================
-- ESTATEWISE REALTY ANALYTICS PROJECT
-- BUSINESS ANALYSIS QUERIES
-- =====================================================================


-- =====================================================================
-- BEGINNER LEVEL
-- =====================================================================


-- Q1. list all properties in pune with property_type = apartment.

select *
from properties
where city = 'Pune'
  and property_type = 'Apartment';


-- Q2. display all bookings through broker referral.

select *
from property_bookings
where sales_channel = 'Broker Referral';


-- Q3. find all distinct builders.

select distinct builder
from properties;


-- Q4. find properties with base_price above ₹1.5 crore,
-- and display them in descending order of price.

select *
from properties
where base_price > 15000000
order by base_price desc;


-- Q5. find all bookings where the discount is greater than 5%.

select *
from property_bookings
where discount_pct > 5;


-- Q6. display project_name, city and bhk for properties
-- having an amenities_score of 9 or 10.

select project_name,
       city,
       bhk
from properties
where amenities_score in (9, 10);


-- Q7. find the total number of bookings.

select count(*) as total_bookings
from property_bookings;



-- =====================================================================
-- INTERMEDIATE LEVEL
-- =====================================================================


-- Q8. calculate the total sale value by city.

select p.city,
       sum(pb.sale_price) as total_sale_value
from properties p
join property_bookings pb
    on p.property_id = pb.property_id
group by p.city
order by total_sale_value desc;


-- Q9. find the top 5 buyers based on total amount spent.

select buyer_id,
       buyer_name,
       sum(sale_price) as total_amount
from property_bookings
group by buyer_id,
         buyer_name
order by total_amount desc
limit 5;


-- Q10. calculate the average discount percentage for each sales channel.

select sales_channel,
       avg(discount_pct) as avg_discount_pct
from property_bookings
group by sales_channel;


-- Q11. find the number of bookings and total sale value for each agent.

select agent_name,
       count(*) as no_of_bookings,
       sum(sale_price) as total_sale_value
from property_bookings
group by agent_name
order by total_sale_value desc;


-- Q12. find all properties that have never been booked.

select p.property_id,
       p.project_name,
       p.city,
       p.property_type
from properties p
left join property_bookings pb
    on p.property_id = pb.property_id
where pb.property_id is null;


-- Q13. calculate year-wise and month-wise total sale value
-- across 2024 and 2025.

select year(booking_date) as year,
       month(booking_date) as month,
       sum(sale_price) as total_sale
from property_bookings
where booking_date >= '2024-01-01'
  and booking_date < '2026-01-01'
group by year(booking_date),
         month(booking_date)
order by year,
         month;


-- Q14. find builders whose total sale value exceeds ₹50 crore.

select p.builder,
       sum(pb.sale_price) as total_sale
from properties p
join property_bookings pb
    on p.property_id = pb.property_id
group by p.builder
having sum(pb.sale_price) > 500000000
order by total_sale desc;


-- Q15. find the single highest-value booking in each city.

with highest_booking as
(
    select p.city,
           pb.property_id,
           pb.sale_price,
           row_number() over
           (
               partition by p.city
               order by pb.sale_price desc
           ) as rnk
    from properties p
    join property_bookings pb
        on p.property_id = pb.property_id
)
select *
from highest_booking
where rnk = 1;


-- Q16. find the number of unique buyers in each city.

select p.city,
       count(distinct pb.buyer_id) as unique_buyers
from properties p
join property_bookings pb
    on p.property_id = pb.property_id
group by p.city
order by unique_buyers desc;



-- =====================================================================
-- ADVANCED LEVEL
-- =====================================================================


-- Q17. rank builders based on their total sale value.

select p.builder,
       sum(pb.sale_price) as total_sale,
       dense_rank() over
       (
           order by sum(pb.sale_price) desc
       ) as rnk
from properties p
join property_bookings pb
    on p.property_id = pb.property_id
group by p.builder
order by rnk;


-- Q18. find the top-performing agent by total sale in each city.

with agent_sales as
(
    select p.city,
           pb.agent_name,
           sum(pb.sale_price) as total_sale_value,
           row_number() over
           (
               partition by p.city
               order by sum(pb.sale_price) desc
           ) as rnk
    from properties p
    join property_bookings pb
        on p.property_id = pb.property_id
    group by p.city,
             pb.agent_name
)
select *
from agent_sales
where rnk = 1;


-- Q19. calculate the running cumulative monthly sale value
-- across 2024 and 2025.

with monthly_sales as
(
    select year(booking_date) as year,
           month(booking_date) as month,
           sum(sale_price) as monthly_sales
    from property_bookings
    where booking_date >= '2024-01-01'
      and booking_date < '2026-01-01'
    group by year(booking_date),
             month(booking_date)
)
select year,
       month,
       monthly_sales,
       sum(monthly_sales) over
       (
           order by year, month
           rows between unbounded preceding and current row
       ) as cumulative_sales
from monthly_sales
order by year,
         month;


-- Q20. find buyers whose total spending is greater than
-- the average spending across all buyers.

select buyer_id,
       buyer_name,
       sum(sale_price) as total_spend
from property_bookings
group by buyer_id,
         buyer_name
having sum(sale_price) >
(
    select avg(total_spend)
    from
    (
        select buyer_id,
               sum(sale_price) as total_spend
        from property_bookings
        group by buyer_id
    ) as buyer_spend
);


-- Q21. calculate year-over-year (yoy) growth percentage
-- in total sales for each city.

with yearly_sales as
(
    select p.city,
           year(pb.booking_date) as year,
           sum(pb.sale_price) as total_sale
    from properties p
    join property_bookings pb
        on p.property_id = pb.property_id
    group by p.city,
             year(pb.booking_date)
),
previous_sales as
(
    select city,
           year,
           total_sale,
           lag(total_sale) over
           (
               partition by city
               order by year
           ) as previous_year_sales
    from yearly_sales
)
select city,
       year,
       total_sale,
       previous_year_sales,
       round(
           (total_sale - previous_year_sales) * 100.0
           / nullif(previous_year_sales, 0),
           2
       ) as growth_percentage
from previous_sales
order by city,
         year;


-- Q22. find ready to move properties with zero bookings.
-- flag them as aging inventory and display the oldest properties first.

select p.property_id,
       p.city,
       p.year_built,
       p.possession_status,
       'Aging Inventory' as inventory_flag
from properties p
left join property_bookings pb
    on p.property_id = pb.property_id
where p.possession_status = 'Ready to Move'
group by p.property_id,
         p.city,
         p.year_built,
         p.possession_status
having count(pb.property_id) = 0
order by p.year_built asc;


-- Q23. segment buyers into premium, mid and budget categories
-- based on their total spending and count the number of buyers
-- in each segment.

with buyer_spending as
(
    select buyer_id,
           buyer_name,
           sum(sale_price) as total_spend
    from property_bookings
    group by buyer_id,
             buyer_name
),
buyer_segments as
(
    select buyer_id,
           buyer_name,
           total_spend,
           case
               when total_spend >= 1000000 then 'Premium'
               when total_spend >= 500000 then 'Mid'
               else 'Budget'
           end as tier
    from buyer_spending
)
select tier,
       count(*) as buyer_count
from buyer_segments
group by tier;


-- Q24. compare the average sale price of ready to move
-- and under construction properties by property type.

select p.property_type,
       p.possession_status,
       avg(pb.sale_price) as avg_sale_price
from properties p
join property_bookings pb
    on p.property_id = pb.property_id
where p.possession_status in
      ('Ready to Move', 'Under Construction')
group by p.property_type,
         p.possession_status
order by p.property_type,
         p.possession_status;


-- Q25. find the single best-performing month by total sale
-- for every city across both years.

with monthly_city_sales as
(
    select p.city,
           year(pb.booking_date) as year,
           month(pb.booking_date) as month,
           sum(pb.sale_price) as total_sale
    from properties p
    join property_bookings pb
        on p.property_id = pb.property_id
    group by p.city,
             year(pb.booking_date),
             month(pb.booking_date)
),
ranked_months as
(
    select city,
           year,
           month,
           total_sale,
           row_number() over
           (
               partition by city
               order by total_sale desc
           ) as rnk
    from monthly_city_sales
)
select *
from ranked_months
where rnk = 1;


-- =====================================================================
-- END OF ESTATEWISE REALTY PROJECT
-- =====================================================================
