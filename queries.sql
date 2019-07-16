#SQL QUERIES
#a: Show the reservation number and the location ID of all rentals on 5/20/2015

#1st solution (Assuming we want rentals that have 05/20/2015 as the pickup date)
select reservation_id as 'Reservation Number',  p_loc as 'Location Picked', r_loc as 'Location Returned'
from  reservations, locations
where p_date='2015-05-20' and p_loc=loc_id;

#2nd option (If we want to include also Rentals that were completed on 05/20/2015)
select reservation_id as 'Reservation Number',  p_loc as 'Location Picked', r_loc as 'Location Returned'
from  reservations, locations
where (p_date='2015-05-20' or r_date='2015-05-20') and p_loc=loc_id;

#=======================================================================================================================================

#b: Show the first and the last name and the mobile phone number of these customers that have rented a car in the category that has label = 'luxury'
-- If we want to see which customers have made more than one "Luxury" reservation, we can remove the "distinct" operator
select distinct first_name, last_name, mobile
from reservations, cars, customers, categories
where categories.cat_label='Luxury' and reservations.cust_id=customers.id and cars.VIN=reservations.VIN and cars.cat_id=categories.cat_id;

#=========================================================================================================================================

#c:Show the total amount of rentals per location ID (pick up)

select sum(amount) as 'Total Amount', p_loc as 'Location'
from reservations
group by p_loc;

#==========================================================================================================================================

#d: Show the total amount of rentals per car's category ID and month
-- We could also use cat_id instead of cat_label, but it would be less interpretable
select sum(amount) as 'Total Amount', cat_label as 'Vehicle Label', monthname(p_date) as 'Month', extract(year from reservations.p_date) as 'Year'
from reservations, cars, categories
where reservations.vin=cars.vin and categories.cat_id=cars.cat_id
group by cat_label, Month, Year
order by year asc, monthname(p_date) asc;

#===========================================================================================================================================

#e: For each rental‟s state (pick up) show the top renting category

select State, Label as 'Top Renting Category'
from (
select lstate as State, count(cars.cat_id) as TotalCount, categories.cat_label as Label
from reservations, locations, cars, categories
where reservations.p_loc=locations.loc_id and cars.VIN=reservations.VIN AND categories.cat_id=cars.cat_id
group by State, Label
order by State
) as question_5
group by State;

-- ALTERNATIVE USING create view

create view question_5 (State, TotalCount, Label) as
select lstate as State, count(cars.cat_id) as TotalCount, categories.cat_label as Label
from reservations, locations, cars, categories
where reservations.p_loc=locations.loc_id and cars.VIN=reservations.VIN AND categories.cat_id=cars.cat_id
group by State, Label
order by State;

select State, Label as 'Top Renting Category'
from question_5
group by State;


#===================================================================================================================================

#f: Show how many rentals there were in May 2015 in „NY‟, „NJ‟ and „CA‟ (in three columns)

# Number of rentals in NY, NJ, CA based on pickup_location
create view rent_pickup1(Receipt, State, Country) as
select count(reservation_id) as Receipt, lstate, lcountry
from reservations, locations
where (p_date like '2015-05%' or r_date like '2015-05%') and (lstate='NewYork' or lstate='NewJersey' or lstate='California') 
and p_loc = loc_id
group by lstate, lcountry;

select * 
from (
select sum(NY) as NY, sum(NJ) as NJ, sum(CA) as CA
from (
select max(case when State='NewYork' then receipt end) as NY, max(case when State='NewJersey' then receipt end) as NJ, max(case when State='California' then receipt end) as CA
from rent_pickup1
) as rent_pickup2
) as rent_pickup3;


#==========================================================================================================================================

#g:For each month of 2015, count how many rentals had amount greater than this month's average rental amount

create view question_7(Reservation, Amount, Months) as
select reservation_id, amount, monthname(p_date) as Month
from reservations
where p_date like '2015%';

select t1.Months, t2.Average,
count(case when Amount > Average then 1 end) as 'Greater than average'
from question_7 as t1
join (
select Months, avg(Amount * 1.0) as Average
from question_7
group by Months
) as t2 on t1.Months = t2.Months
group by Months;

#====================================================================================================================================

#h: For each month of 2015, show the percentage change of the total amount of rentals over the total amount of rentals of the same month of 2014

select month2015 as 'Month', concat(round((reservation2015-reservation2014)/reservation2014*100),'%') as Percentage_Change
from (
	select count(reservation_id) as reservation2015, monthname(p_date) as Month2015
	from reservations
	where year(p_date)='2015'
    group by Month2015
) as Year_2015 join (
	select count(reservation_id) as reservation2014, monthname(p_date) as Month2014
	from reservations
	where year(p_date)='2014'
    group by Month2014
) as Year_2014
where Year_2015.Month2015=Year_2014.Month2014;

#======================================================================================================================================

#i For each month of 2015, show in three columns: the total rentals‟ amount of the previous months, the 
#total rentals‟ amount of this month and the total rentals‟ amount of the following months:

create view question_9 as
select sum(amount) as Total_Amount, month(p_date) as Month_of_2015
from reservations 
where year(p_date)='2015'
group by Month_of_2015
order by Month_of_2015;

select amounts_table.Month_2015, amounts_table.Previous_Months as 'Previous Months Total Amount', amounts_table.Current_Month_Amount, 
sum(NextMonth.Total_Amount) as 'Next Months Total Amount' 
from (select  question_9.Month_of_2015 AS  Month_2015, sum(Previous.Total_Amount) as Previous_Months, question_9.Total_Amount as Current_Month_Amount 
from question_9
left join question_9 as Previous on question_9.Month_of_2015 > Previous.Month_of_2015
group by Month_2015 ) as amounts_table
left join question_9 as NextMonth on amounts_table.Month_2015 < NextMonth.Month_of_2015
group by Month_2015;

#=====================================================================================================================================================================================================

