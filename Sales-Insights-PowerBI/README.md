## Sales Insights Data Analysis Project

### Data Analysis Using SQL

1. Show all customer records

    `SELECT * FROM customers;`

1. Show total number of customers

    `SELECT count(*) FROM customers;`

1. Show transactions for Chennai market (market code for chennai is Mark001

    `SELECT * FROM transactions where market_code='Mark001';`

1. Show distrinct product codes that were sold in chennai

    `SELECT distinct product_code FROM transactions where market_code='Mark001';`

1. Show transactions where currency is US dollars

    `SELECT * from transactions where currency="USD"`

1. Show transactions in 2020 join by date table

    `SELECT transactions.*, date.* FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020;`

1. Show total revenue in year 2020,

    `SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and transactions.currency="INR\r" or transactions.currency="USD\r";`
	
1. Show total revenue in year 2020, January Month,

    `SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020 and and date.month_name="January" and (transactions.currency="INR\r" or transactions.currency="USD\r");`

1. Show total revenue in year 2020 in Chennai

    `SELECT SUM(transactions.sales_amount) FROM transactions INNER JOIN date ON transactions.order_date=date.date where date.year=2020
and transactions.market_code="Mark001";`


Data Analysis Using Power BI
============================

1. Formula to create norm_amount column

`= Table.AddColumn(#"Filtered Rows", "norm_amount", each if [currency] = "USD" or [currency] ="USD#(cr)" then [sales_amount]*75 else [sales_amount], type any)`

2. Calculate Profit margin percentage

`Profit Margin % = DIVIDE([Total Profit Margin], 'Base Measures'[Revenue], 0)`

3. Calculate Profit margin contribution percentage

`Profit Margin Contribution % = DIVIDE([Total Profit Margin], CALCULATE([Total Profit Margin], ALL('sales_v2 products'), ALL('sales_v2 customers'), ALL('sales_v2 markets')))`

5. Revenue contribution percentage

`Revenue Contribution % = DIVIDE('Base Measures'[Revenue], CALCULATE('Base Measures'[Revenue], ALL('sales_v2 customers'), ALL('sales_v2 markets'), ALL('sales_v2 products')))`

7. Calculate last year revenue

`Revenue LY = CALCULATE('Base Measures'[Revenue], SAMEPERIODLASTYEAR('sales_v2 date'[date]))`


## Power BI Dashboard screenshots

![sales_insights-1](https://user-images.githubusercontent.com/78271544/180880244-621df1fd-a24f-4f95-96ec-6e586c3cb65b.png)

##

![sales_insights-2](https://user-images.githubusercontent.com/78271544/180880953-97f69423-c0e0-4b74-ac2f-0ce2c1a89eef.png)


