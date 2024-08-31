drop database zomato;
select * from sheet1;
desc sheet2;

alter table sheet1 add constraint foreign key sheet1(country_code) references sheet2(countryid);
##alter table sheet1 add constraint
create table zomato as select * from sheet1;
select * from zomato;
select count(restaurantid) from zomato;
create table country as select * from sheet2;
select * from country;
desc country;
desc zomato;
alter table zomato add constraint pk primary key(restaurantid);
ALTER TABLE zomato
MODIFY COLUMN country_code int;
alter table zomato add constraint foreign key zomato (country_code)  references country (countryid);
CREATE INDEX zomato_country_code ON country(countryid);
desc conversion_rate;



ALTER TABLE zomato ENGINE=InnoDB;
select distinct currency from zomato;
create table currency (
currency varchar (255) primary key,
USD_Rate double
);
insert into currency values ('	Indian Rupees(Rs.)	 ',0.012);
insert into currency values ('	Dollar($)	 ',1),(	'Pounds(Œ£)	 ',1.24),('	NewZealand($)	 ',0.6),('	Emirati Diram(AED)	 ',0.27),('	Brazilian Real(R$)	 ',0.2),('	Turkish Lira(TL)	 ',0.05),('	Qatari Rial(QR)	 ',0.27),
('	Rand(R)	 ',0.051),('	Botswana Pula(P)	 ',0.073),('	Sri Lankan Rupee(LKR)	 ',0.0034),('	Indonesian Rupiah(IDR)	 ',0.000067);
select * from currency;
desc conversion_rate;
desc zomato;
select * from conversion_rate;
alter table currency rename to conversion_rate;
alter table zomato add constraint foreign key zomato (Currency)  references conversion_rate (currency);
truncate currency;
use zomato;


CREATE INDEX zomato_currency_code ON currency(currency);
select * from zomato;
select distinct currency from zomato order by currency;
select average_cost_for_two from zomato order by average_cost_for_two desc;
alter table zomato add constraint cfk foreign key zomato (Currency) references conversion_rate (currency);

##Total Number of Restaurant##
select count(restaurantid) as Total_Restaurant from zomato;
##Total number of country###
select count(country_name) as Total_Country from country;
##Total number of city##
select count( distinct(city)) as Total_City from zomato;
##Total number of locality##
select count(distinct(locality)) as Total_Locality from zomato;
##Total number of cuisines##
select count(distinct(cuisines)) as Total_Couisines from zomato;
##date table
select year(Datekey_Opening) years,
month(Datekey_Opening)  months,
day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,concat('Q',Quarter(Datekey_Opening))as quarter,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,
dayname(datekey_opening)dayname, 

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case when monthname(datekey_opening)='January' then 'FM10' 
when monthname(datekey_opening)='January' then 'FM11'
when monthname(datekey_opening)='February' then 'FM12'
when monthname(datekey_opening)='March' then 'FM1'
when monthname(datekey_opening)='April'then'FM2'
when monthname(datekey_opening)='May' then 'FM3'
when monthname(datekey_opening)='June' then 'FM4'
when monthname(datekey_opening)='July' then 'FM5'
when monthname(datekey_opening)='August' then 'FM6'
when monthname(datekey_opening)='September' then 'FM7'
when monthname(datekey_opening)='October' then 'FM8'
when monthname(datekey_opening)='November' then 'FM9'
when monthname(datekey_opening)='December'then 'FM10'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters

from zomato;

##count of restaurant based on city and country.

select c.country_name, z.city, count( distinct z.restaurantid) as Total_Restaurant
from zomato z
join country c
on z.country_code = c.countryid
group by country_name, city;

#Numbers of Resturants opening based on Year , Quarter , Month.
select year(Datekey_Opening) as Year, quarter(Datekey_Opening) as Quarter, monthname(Datekey_Opening) as Month, count(distinct restaurantid) as Total_Restaurant
from zomato
group by year(Datekey_Opening), quarter(Datekey_Opening), monthname(Datekey_Opening)
order by year(Datekey_Opening), quarter(Datekey_Opening), monthname(Datekey_Opening);

#Count of Resturants based on Average Ratings.
select case 
when Rating <=2 then "0-2"
when Rating <=3 then "2-3"
when Rating <=4 then "3-4"
when Rating <=5 then "4-5"
end Rating_range, count(restaurantid)
from zomato
group by Rating_range
order by Rating_range;

#Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select case
when Price_range = 1 then "0-500"
when Price_range = 2 then "500-3000"
when Price_range = 3 then "3000-10000"
when Price_range = 4 then ">10000"
end Price_Bucket,
count(restaurantid) as Total_Restaurant
from zomato
group by Price_Bucket
order by Price_Bucket;

#Percentage of Resturants based on "Has_Table_booking"
select Has_Table_booking, concat(round(count(Has_Table_booking)/100,0),"%") as Total_Table_Booking
from zomato
group by Has_Table_booking;

#Percentage of Resturants based on "Has_Online_delivery"
select Has_Online_delivery, concat(round(count(Has_Online_delivery)/100,0),"%") as Total_Online_delivery
from zomato
group by Has_Online_delivery;

# highest rating restaurants in each country 
select c.country_name, z.restaurantname, max(z.Rating) as Highest_Rating
from zomato z
join country c
on z.country_code = c.countryid
group by c.country_name, z.restaurantname
order by Highest_Rating desc;


##Number of restaurant by cuisines
select Cuisines, count(restaurantid) as Total_Restaurant
from zomato
group by Cuisines
order by Total_Restaurant desc;

# top 5 restaurants who has more number of votes
select c.country_name, z.city, max(Votes) as Maximum_Votes
from zomato z
join country c
on z.country_code = c.countryid
group by c.country_name, z.city
limit 5;


select price_range, min(Average_Cost_for_two), max(Average_Cost_for_two)
from zomato
group by price_range
order by price_range;

truncate conversion_rate;







######ruff query
select avg(Average_Cost_for_two)
from zomato;
update zomato set Average_Cost_for_two = (select round(avg(Average_Cost_for_two),0) from zomato)
where restaurantid in (select restaurantid
from zomato
where Average_Cost_for_two = 0);

select restaurantid
from zomato
where Average_Cost_for_two = 0;






