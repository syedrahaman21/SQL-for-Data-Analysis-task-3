use ecommerce;
go

SELECT * FROM dbo.customers;
select * from products
select * from transactions

select customerid,customername
from customers 

select productid,ProductName, price
from products

--Add tax column (say 18%) to each product price
select productid, productname, price, price * 1.18 as price_with_tax
from products

--10% discount for each products
select productname, format(price,'n2'),format(price *0.90,'n2') as discount_price
from products

-- WHERE SYNTAX
-- get all customers from Asia
select customername, region 
from customers
where Region= 'asia'

-- get all products with price less than 100
select productname,price
from products
where Price < 100

-- get all transactions where amount is between 500 and 1000
select transactionid, transactiondate,totalvalue
from transactions
where TotalValue between 500 and 1000

--ORDER BY SYNTAX
-- show all customers sorted by region

select customername, region
from customers
order by Region

--show products sorted by price (low to high)

select productname, price
from products
order by Price asc

-- show transactions sorted by amount (highest first)

select transactionid, transactiondate, totalvalue
from transactions
order by TotalValue desc

--GROUP BY AND AGG FUNCTIONS
--show total revenue from all transactions

select  SUM(totalvalue) as total_revenue
from transactions

--show total amount spent by each customer

select customerid, SUM(totalvalue) as total_spent
from transactions
group by CustomerID

-- show average price of all products

select  AVG (price) avg_product_price
from products

--JOINS 
-- Use inner join to show customer names and total spent

select c.CustomerName, sum(t.totalvalue) as total_spent
from dbo.customers c
inner join dbo.transactions t on 
c.CustomerID = t.customerid
group by c.CustomerName;

-- Use left join to find customers with no transactions

select c.customerID, c.customername
from customers c
left join transactions t on
c.CustomerID = t.CustomerID
where t.TransactionID is null

-- show all transactions along with customer names and product names

select t.transactionid,c.CustomerName,p.ProductName, t.totalvalue
from transactions t
inner join customers c on t.CustomerID=c.CustomerID
inner join products p on t.ProductID=p.ProductID

--SUBQUERY CLAUSE
-- find customers who spent more than the average transaction value:

select * 
from customers
where CustomerID in (
select CustomerID
from transactions
group by CustomerID
having SUM(TotalValue) > (
select AVG(totalvalue)
from transactions));

-- show each customer with their total spending:

select customername,
(select format(SUM(totalvalue),'n2')
from transactions
where transactions.CustomerID = customers.CustomerID) as total_spent
from customers

-- CREATE VIEW SYNTAX
-- product sales summary

CREATE VIEW PRODUCT_SALES AS
select p.productid,p.productname,
SUM(t.quantity) as total_qnty,
sum(t.totalvalue) as total_revanue
from products p
join transactions t on p.productid = t.productid
group by p.productid,p.productname

SELECT *
FROM PRODUCT_SALES;