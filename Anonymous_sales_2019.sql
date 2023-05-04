-- CLEANING DATA

-- Changing tables names for ease of use
Exec SP_RENAME 'sales.dbo.Sales_April_2019', 'April';
Exec SP_RENAME 'sales.dbo.Sales_August_2019', 'August';
Exec SP_RENAME 'sales.dbo.Sales_December_2019', 'December';
Exec SP_RENAME 'sales.dbo.Sales_February_2019', 'February';
Exec SP_RENAME 'sales.dbo.Sales_January_2019', 'January';
Exec SP_RENAME 'sales.dbo.Sales_July_2019', 'July';
Exec SP_RENAME 'sales.dbo.Sales_June_2019', 'June';
Exec SP_RENAME 'sales.dbo.Sales_March_2019', 'March';
Exec SP_RENAME 'sales.dbo.Sales_May_2019', 'May';
Exec SP_RENAME 'sales.dbo.Sales_November_2019', 'November';
Exec SP_RENAME 'sales.dbo.Sales_October_2019', 'October';
Exec SP_RENAME 'sales.dbo.Sales_September_2019', 'September';

-- General observation of the data in the tables
SELECT *
FROM sales.dbo.April

-- Queries of this data cannot be displayed due to the Text Data Type of the columns
SELECT *
FROM sales.dbo.April
WHERE Order_ID = '176558'

-- With new queries, the data is observed to have null values and non-matching values
SELECT *
FROM sales.dbo.April
WHERE CONVERT(NVARCHAR(10),Order_ID) = N'176558'

SELECT *
FROM sales.dbo.April
ORDER BY CONVERT(NVARCHAR(10),Order_ID) DESC

SELECT *
FROM sales.dbo.April
ORDER BY CONVERT(NVARCHAR(10),Order_ID) ASC

-- The unmatched values are found in each feature of the affected row, so the unmatched values are cleaned up
SELECT *
FROM sales.dbo.April
WHERE CONVERT(NVARCHAR(10),Order_ID) = N'Order ID'

DELETE FROM sales.dbo.April
WHERE CONVERT(NVARCHAR(10),Order_ID) = N'Order ID'

-- Nulls are also found in every feature in the affected row, so nulls are cleaned up
SELECT *
FROM sales.dbo.April
WHERE Order_ID IS NULL

DELETE FROM sales.dbo.April
WHERE Order_ID IS NULL

-- All data was imported to SSMS as a Text Data Type, so it is necesary to Standardize the Format of the Columns 
ALTER TABLE sales.dbo.April
ALTER COLUMN Order_ID VARCHAR(10) NOT NULL;
ALTER TABLE sales.dbo.April
ALTER COLUMN Order_ID INT NOT NULL;

ALTER TABLE sales.dbo.April
ALTER COLUMN Product VARCHAR(50) NOT NULL

ALTER TABLE sales.dbo.April
ALTER COLUMN Quantity_Ordered VARCHAR(10) NOT NULL;
ALTER TABLE sales.dbo.April
ALTER COLUMN Quantity_Ordered SMALLINT NOT NULL;

ALTER TABLE sales.dbo.April
ALTER COLUMN Price_Each VARCHAR(20) NOT NULL;
ALTER TABLE sales.dbo.April
ALTER COLUMN Price_Each DECIMAL(10,2) NOT NULL;

ALTER TABLE sales.dbo.April
ALTER COLUMN Order_Date VARCHAR(20) NOT NULL;

ALTER TABLE sales.dbo.April
ALTER COLUMN Purchase_Address VARCHAR(100) NOT NULL;

-- Break out Order Date into individual columns (Order Time and Order Date)
ALTER TABLE sales.dbo.April
ADD N_Order_Time TIME(2);
UPDATE sales.dbo.April
SET N_Order_Time = CONVERT(TIME(2),Order_Date);
ALTER TABLE sales.dbo.April
ADD N_Order_Date DATE;
UPDATE sales.dbo.April
SET N_Order_Date = CONVERT(DATE,Order_Date);

-- Break out Purchase Address into individual columns (Street Address, City, State Code, Postal Code)
ALTER TABLE sales.dbo.April
ADD street_address VARCHAR(20);
UPDATE sales.dbo.April
SET Street_Address = SUBSTRING(Purchase_Address,1,CHARINDEX(',',Purchase_Address) -1);

ALTER TABLE sales.dbo.April
ADD City VARCHAR(20);
UPDATE sales.dbo.April
SET City = LTRIM(PARSENAME(REPLACE(Purchase_Address,',','.'),2))

ALTER TABLE sales.dbo.April
ADD State_Cod VARCHAR(10);
UPDATE sales.dbo.April
SET State_Cod = RTRIM(LTRIM(LEFT(PARSENAME(REPLACE(Purchase_Address,',','.'),1),4)));

ALTER TABLE sales.dbo.April
ADD Postal_Cod VARCHAR(10);
UPDATE sales.dbo.April
SET Postal_Cod = LTRIM(RIGHT(PARSENAME(REPLACE(Purchase_Address,',','.'),1),6));

-- After displaying the rest of the tables, they have the same problem with null and non-matching values, so the same type of changes made to this table apply

-- Creation of a view to store data with all the tables in a good condition for later visualizations in Tableau 
CREATE VIEW view_sales2019 AS
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.January
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.February
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.March
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.April
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.May
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.June
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.July
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.August
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.September
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.October
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.November
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.December

SELECT *
FROM sales.dbo.view_sales2019


-- DATA EXPLORATION

-- Creation of a temporary table to speed up the query execution concentrating the data of different tables and avoid using the view previously created
DROP TABLE IF EXISTS #Temp_sales2019
CREATE TABLE #Temp_sales2019 (
	Order_ID INT,
	Product VARCHAR(50),
	Quantity_Ordered SMALLINT,
	Price_Each DECIMAL(10,2),
	N_Order_Date DATE,
	N_Order_Time TIME(2),
	Street_Address VARCHAR(20),
	City VARCHAR(20),
	State_Cod VARCHAR(10),
	Postal_Cod VARCHAR(10))

INSERT INTO #Temp_sales2019
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.January
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.February
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.March
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.April
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.May
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.June
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.July
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.August
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.September
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.October
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.November
UNION ALL
SELECT Order_ID, Product, Quantity_Ordered, Price_Each, N_Order_Date, N_Order_Time, street_address, City, State_Cod, Postal_Cod
FROM sales.dbo.December

SELECT *
FROM #Temp_sales2019

-- EXPLORATION OF QUANTITY NUMBERS
-- How many products were ordered of each one?
SELECT 
	Product,
	COUNT(Product) AS Number_Product
FROM #Temp_sales2019
GROUP BY Product
ORDER BY 2 DESC

-- In how many states consumers ordered?
SELECT
	COUNT(DISTINCT State_Cod) AS Number_States
FROM #Temp_sales2019

-- Top 10 most ordered products of the year
SELECT TOP 10
	Product,
	SUM(Quantity_Ordered) AS total
FROM #Temp_sales2019 
GROUP BY Product
ORDER BY total DESC

-- Order quantity by month of the most ordered product in the year (AAA Batteries (4-pack))
SELECT
	Product,
	SUM(Quantity_Ordered) AS Quantity,
	DATENAME(mm, N_Order_Date) AS Order_Month
FROM #Temp_sales2019 
WHERE Product like 'AAA%'
GROUP BY Product, DATENAME(mm, N_Order_Date)
ORDER BY Quantity DESC

-- EXPLORATION OF MONETARY NUMBERS
-- Value and quantity generated for each product by month
SELECT
	Product,
	MONTH(N_Order_Date) AS Month,
	DATENAME(mm, N_Order_Date) AS Order_Month,
	SUM(Quantity_Ordered) AS Quantity,
	SUM(Quantity_Ordered*Price_Each) AS Value_Ordered
FROM #Temp_sales2019
GROUP BY MONTH(N_Order_Date), Product, DATENAME(mm, N_Order_Date)
ORDER BY MONTH(N_Order_Date) ASC, SUM(Quantity_Ordered*Price_Each) DESC

-- Total value of each order
SELECT
	Order_ID,
	State_Cod,
	City,
	Quantity_Ordered,
	Price_Each,
	SUM(Quantity_Ordered*Price_Each) OVER(PARTITION BY Order_ID) AS Total	
FROM #Temp_sales2019
ORDER BY 1,2

-- Money generated in orders each month
SELECT
	DATENAME(mm, N_Order_Date) AS Order_Month,
	SUM(Quantity_Ordered*Price_Each) AS Total	
FROM #Temp_sales2019 
GROUP BY DATENAME(mm, N_Order_Date)
ORDER BY Total DESC

-- Relative distribution of money by product in the month with most money generated (December)
SELECT
	Product,
	DATENAME(mm, N_Order_Date) AS Order_Month,
	SUM(Quantity_Ordered*Price_Each) AS Total,
	(SUM(Quantity_Ordered*Price_Each)/
		(SELECT
			SUM(Quantity_Ordered*Price_Each) AS Total
		FROM #Temp_sales2019 
		WHERE DATENAME(mm, N_Order_Date) = 'December'
		GROUP BY DATENAME(mm, N_Order_Date)))
		*100 AS Percent_Total
FROM #Temp_sales2019
WHERE DATENAME(mm, N_Order_Date) = 'December'
GROUP BY Product, DATENAME(mm, N_Order_Date)
ORDER BY Total DESC

-- How expensive is the Macbook compare with the other products?
SELECT
	DISTINCT Product,
	Price_Each
FROM #Temp_sales2019
ORDER BY 2 DESC

-- Comparison of money generated each month by the most money generated and expensive product (Macbook Pro Laptop)
SELECT
	DATENAME(mm, N_Order_Date) AS Order_Month,
	SUM(Quantity_Ordered*Price_Each) AS Total	
FROM #Temp_sales2019 
WHERE Product = 'Macbook Pro Laptop'
GROUP BY Product, DATENAME(mm, N_Order_Date)
ORDER BY Total DESC

-- What State has more orders of Macbooks?
SELECT
	State_Cod,
	City,
	SUM(Quantity_Ordered) AS Total
FROM #Temp_sales2019
WHERE Product like 'Macbook%'
GROUP BY State_Cod, City
ORDER BY 3 DESC;

-- If the company wants to give some royalty to people who buy more than one Macbook Pro laptop because it's the most expensive product and December has the biggest sales of the year, they can view the data of those people with the query below
WITH cte_Royal (Order_ID, Product, State_Cod, City, Street_Address, Postal_Cod, Quantity_Ordered, Price_Each, Total) AS
(SELECT
	Order_ID,
	Product,
	State_Cod,
	City,
	Street_Address,
	Postal_Cod,
	Quantity_Ordered,
	Price_Each,
	SUM(Quantity_Ordered*Price_Each) OVER(PARTITION BY Order_ID) AS Total
FROM #Temp_sales2019)

SELECT *,
	CASE WHEN Quantity_Ordered >= 2 and Product like 'Macbook Pro%'
		THEN 'Royalty'
	ELSE
		'-'
	END AS Royalty
FROM cte_Royal
WHERE CASE WHEN Quantity_Ordered >= 2 and Product like 'Macbook Pro%'
		THEN 'Royalty'
	ELSE
		'-'
	END = 'Royalty'
ORDER BY 1,2

-- States with the least monetary value in terms of orders
SELECT
	State_Cod,
	City,
	SUM(Quantity_Ordered*Price_Each) AS Total	
FROM #Temp_sales2019 
GROUP BY State_Cod, City
ORDER BY 3

-- The monetary value of each product in the state with the lowest overall monetary value
SELECT
	Product,
	State_Cod,
	City,
	street_address,
	SUM(Quantity_Ordered*Price_Each) AS Total	
FROM #Temp_sales2019 
WHERE State_Cod = 'ME' and street_address like '%main%'
GROUP BY Product, State_Cod, City, street_address
ORDER BY Total DESC