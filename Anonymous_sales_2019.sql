-- Planteamiento de los objetivos que quiero lograr con esta base de datos

-- Limpiar y ordenar la base de datos para permitir un exploramiento más sencillo de los datos

-- Determinar el top 10 de productos más vendidos en cada mes y en la totalidad del año
-- Determinar el total de ventas de cada producto en cada mes y en la totalidad del año
-- A que zonas es que se venden más cantidad productos y productos más caros
-- En que fechas hay una mayor cantidad de ventas monetarias y de cantidad
-- En que horarios es que se vende más y una mayor cantidad de dinero
-- Crear una temp table o view para las ventas anuales
-- Determinar el top de meses en cuanto a cantidad y valor de ventas

-- DATA CLEAN

-- Changing table names for ease of use
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

-- With all tables in a good condition, create of a view with all the tables
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

-- ***Crear tablas más pequeñas en base a esta (productos, cliente, ordenes de compra, fechas)

-- Datos necesarios para hacer gráficos en Tableau


-- DATA EXPLORATION

-- Use of Joins to compare quantitys


-- Ver el top de dinero ganado por orden con la view

-- Comparación de cantidades, precios, ventas, sacar variables para precio total

--