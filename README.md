# Anonymous_Sales_2019
Domain: Sales Transactions

Created by : Rubén Padilla Aguilar

Posted on : 2-5-2023

Tools used: MS SQL Server and Tableau

Purpose of the project: Data Cleansing and Exploration with SQL and Visualization with Tableau.

Concepts used : CTE's, Managing Tables and Views, Modifying Data, Temp Tables, Aggregate Functions, Converting Data Types.

**Dataset Info:**
1. The dataset was downloaded from Kaggle under the name "SalesAnalysis" by Serdar Ozturk.
2. The dataset is a compilation of 12 tables, each containing data for a specific month of the year 2019.
3. Each table has between 9,000 to 26,000 records with data and columns with the features: Order ID, Product, Quantity Ordered, Price Each, Order Date and Purchase Address.
4. The data was dirty with Missing Values and Mismatched Values.

**Business problem:**
In a hypothetical scenario, a company aims to analyze a large amount of data collected in the past year so that they can make data-driven decisions related to customer behavior. To complete this task, they want to clean the data and perform an exploratory analysis with Microsoft SQL Server to determine if the collected information is useful and relevant. If so, they want to create a beautiful dashboard in Tableau. To accomplish these different processes, they provide some examples of what they would like to know, such as the monetary value and quantity of the processed orders, the top 10 sales and locations using the available variables, and the distribution of sales by month, identify customers with high purchases for a royalty, among others.

**Objective of the Cleaning process:**
1. Prepare the data correctly to be able to implement it in the following processes such as exploration, analysis and visualization.

**Objectives of the Exploration process:**
1. Categorizing information from multiple variables based on their relevance to sales analysis.
2. Comparing the data in monetary value and quantity using different variables such as the month, city, product and so fourth.
3. Distinguishing important data such as the most or least ordered product, the best months in sales and so on.
4. Questioning about how to get new insights, how can improve this data in the future, etcetera.
5. Identify some recomendations for the hypothetical company of the Business Problem.

**Main Results:**
1. Tables for Quantity of products ordered for each one, Number of states from where customers placed orders, Top 10 most ordered products of the year, Value and quantity generated for each product by month, Total value of each order, Money generated in orders each month, Monetary value of each product in the state with the lowest overall monetary value, and People with the possibility to gain a royalty.
2. The most ordered product in the year was 'AAA Batteries (4-pack)' with a quantity of 31,017 and the best sales occurred in December.
3. The month with the most money generated was December and the best selling product was the MacBook Pro Laptop with a relative distribution of 23.6%.
4. The MacBook Pro Laptop is the most expensive product with a price difference of $700.01 compared to the second most expensive product, and the best sales for this product occurred in December.
5. The state of California (CA) sold 11,000 MacBook Pro Laptops, making it the best state in terms of sales for this product.
6. The people with the possibility to gain a royalty were those who bought more than one MacBook Pro Laptop since it is the most expensive product. Their Order_ID's are 181069, 181544, 200528, and 210292.
7. The states with the least monetary value in terms of orders was Maine (ME).

**Recomendations of the analysis:**
1. Create a Star Schema recolecting more data about customers, orders, sales and more.
