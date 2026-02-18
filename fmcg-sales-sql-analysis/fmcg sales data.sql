SELECT * FROM revision.`sql assignmnt`;

-- CHECKING FOR DUPLICATES
select SALES_ID, count(*)from `sql assignmnt`
group by SALES_ID
having count(*)>1;

-- checking data type
describe `sql assignmnt`;

-- adding column named territory to diffenciate anglophone and francophone
ALTER TABLE `sql assignmnt`
ADD COLUMN TERRITORY TEXT;

UPDATE `sql assignmnt`
SET TERRITORY =
CASE
when COUNTRIES in ("ghana", "nigeria") then "Anglophone"
when COUNTRIES in("benin", "togo", "senegal") then "Francophone"
end;

-- ADDING BRAND CATEGORY COLUMN TO DIFF(MALT, BEER)
ALTER TABLE `sql assignmnt`
ADD COLUMN BRAND_CATEGORY TEXT;

UPDATE`sql assignmnt`
SET BRAND_CATEGORY=
CASE
WHEN BRANDS IN ("trophy", "budweiser", "castle lite", "eagle lager", "hero") then "beer"
WHEN BRANDS IN ("beta malt", "grand malt") then "malt"
end;

-- Question 1(total profit for 3 years for both territories
select sum(profit) as Total_profit
from`sql assignmnt`;
-- answer:105,587,420

-- Question 2(compare total profit between anglophone and francophone)
select sum(profit) as total_profit from `sql assignmnt`
where TERRITORY= "francophone"
group by TERRITORY;
-- answer :63,198,160

select sum(profit) as total_profit from `sql assignmnt`
where TERRITORY= "anglophone"
group by TERRITORY;
-- answer:42,389,260
-- THE FRANCOPHONE MADE MORE PROFIT THAN ANGLOPHONE

-- question 3(country with highet profit in 2019)
select COUNTRIES, sum(profit) as total_profit from `sql assignmnt`t
where years=2019
group by COUNTRIES
order by total_profit desc
limit 1;
-- answer:Ghana

-- question 4(year with highest profit)
select YEARS, sum(profit) as total_profit from `sql assignmnt`
group by YEARS;
-- answer: 2017

-- question 5(Which month in the three years was the least profit generated?)
select MONTHS, sum(profit) from `sql assignmnt`
group by MONTHS;
-- answer:April

-- question 6(What was the minimum profit in the month of December 2018?)
select PROFIT from `sql assignmnt`
where MONTHS="december" and YEARS="2018"
group by PROFIT;
-- answer: 38,150

-- question 7(Compare the profit in percentage for each of the month in 2019
SELECT MONTHS, SUM(PROFIT) AS month_profit,
    100.0 * SUM(PROFIT) / (SELECT SUM(PROFIT)
        FROM `sql assignmnt`
        WHERE YEARS = 2019) AS profit_percentage_2019
FROM `sql assignmnt`
WHERE YEARS = 2019
GROUP BY MONTHS
ORDER BY MONTHS;
-- answer;Januar-10.86986, August-9.93596, July-9.81118, April-9.49849c, November-8.91268, June-8.89093, May-8.57101,March-8.42971,October-7.39791,December-6.82466,Septembe-6.30441,Februar-4.55319
-- JANUARY MADE THE HIGHEST PERCENTAGE PROFIT WHILE FEBRUARY MASDE THE LEAST.

-- question 8(Which particular brand generated the highest profit in Senegal?)
select  BRANDS, sum(profit) as total_profit from `sql assignmnt`
group by BRANDS;
-- answer ;castle lite

-- question 9(Calculate profit over the month)
select MONTHS, sum(profit) from `sql assignmnt`
group by MONTHS;
-- answer: March 9066130,February 9028450,June 8828440,November 8820330,December 8787290,July 8787010,May 8772250,October 8767100,August 8730940,January 8722990,September	8702660,April	8573830
-- MARCH HAD THE HIGHEST PROFIT OF 9,066,130 WHILE APRIL HAS THE LEAST OF 8,573,830

-- question 10(Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries)
SELECT BRANDS, SUM(QUANTITY) AS total_quantity
FROM `sql assignmnt`
WHERE YEARS >=2018
  AND TERRITORY="francophone"
GROUP BY BRANDS;
-- answer ;Trophy(52,899), hero(50,846),eagle lager(50,630)

-- question 11(Find out the top two choice of consumer brands in Ghana.)
SELECT BRANDS, SUM(QUANTITY) AS total_quantity
FROM `sql assignmnt`
WHERE COUNTRIES = 'Ghana'
GROUP BY BRANDS
ORDER BY total_quantity DESC
LIMIT 2;
-- answer eagle lager and castle lite

-- question 12(Find out the details of beers consumed in the past three years in the most oil reached country in West Africa)
SELECT BRAND_CATEGORY, SUM(QUANTITY) AS total_quantity, SUM(PROFIT) AS TOTAL_PROFIT
FROM `sql assignmnt`
WHERE COUNTRIES = 'Nigeria'
  AND BRAND_CATEGORY="BEER"
GROUP BY BRAND_CATEGORY
ORDER BY total_quantity DESC;
-- answer total quantity of beers consumed in Nigeria(129,260), total profit made(18,119,580)

-- question 13(Favorites malt brand in Anglophone region between 2018 and 2019.)
select BRANDS, sum(quantity) from `sql assignmnt`
where YEARS between 2018 and 2019
and TERRITORY="anglophone"
and BRAND_CATEGORY="malt"
group by BRANDS;
-- answer; grand malt with 33,221 quantity sold

-- question 14(Which brands sold the highest in 2019 in Nigeria?)
select brands, sum(quantity) from `sql assignmnt`
where countries="Nigeria"
and years=2019
group by brands;
-- answer;hero

-- question 15 (Favorites brand in South-South region in Nigeria.)
select brands, sum(quantity) from `sql assignmnt`
where region="southsouth"
and countries="nigeria"
group by brands;
-- answer ;eaglelager with 4551 quantity sold

-- question 16(Beer consumption in Nigeria.)
SELECT SUM(QUANTITY) AS total_beer_quantity
FROM `sql assignmnt`
WHERE COUNTRIES = 'Nigeria'
AND BRAND_CATEGORY="beer";
-- answer; a total of 129,260 units of beer was consumed in Nigeris within the 3years

-- question 17(Level of consumption of Budweiser in the regions in Nigeria .)
SELECT REGION, SUM(QUANTITY) AS budweiser_quantity
FROM `sql assignmnt`
WHERE COUNTRIES = 'Nigeria'
AND BRANDS = 'budweiser'
GROUP BY REGION
ORDER BY budweiser_quantity DESC;
-- ANSWER; 
-- west 4620
-- northcentral 4498
-- southsouth 4328
-- northeast 4320
-- northwest 4274
-- Southeast 4113

-- QUESTION 18(Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)
SELECT REGION, SUM(QUANTITY) AS budweiser_quantity_2019
FROM `sql assignmnt`
WHERE COUNTRIES = 'Nigeria'
  AND BRANDS = 'budweiser'
  AND YEARS = 2019
GROUP BY REGION
ORDER BY budweiser_quantity_2019 DESC;
-- ANSWER;
-- Southeast 1821
-- northeast 990
-- northwest948
-- west	884
-- southsouth847
-- (the strongest Budweiser base is the Southeast region, followed by northeast and northwest)

-- QUESTION 19(Country with the highest consumption of beeR)
SELECT COUNTRIES, SUM(QUANTITY) FROM `sql assignmnt`
WHERE BRAND_CATEGORY="BEER"
GROUP BY COUNTRIES;
-- ANSWER:SENEGAL(129,875)

-- QUESTION 20(Highest sales personnel of Budweiser in Senegal)
SELECT SALES_REP, SUM(QUANTITY) FROM `sql assignmnt`
WHERE COUNTRIES="SENEGAL"
AND BRANDS ="BUDWEISER"
GROUP BY SALES_REP;
-- ANSWER;JONES

-- QUESTION 21(Country with the highest profit of the fourth quarter in 2019)
SELECT COUNTRIES, SUM(PROFIT) FROM `sql assignmnt`
WHERE YEARS=2019
AND MONTHS IN("OCTOBER", "NOVEMBER","DECEMBER")
GROUP BY COUNTRIES;
-- ANSWER:GHANA






