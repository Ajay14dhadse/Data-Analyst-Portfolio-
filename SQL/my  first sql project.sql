                    -- *ONLINE BOOK STORE  PROJECT *--
-- CREATE DATABASE 
CREATE DATABASE ONLINEBOOKSTORE;

-- SWITCH TO THE DATABASE \ONLINEBOOKSTORE;

-- CREATE TABLES ...
DROP TABLE IF EXISTS Books ;
CREATE TABLE Books(
Book_id SERIAL PRIMARY KEY ,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
Customer_id SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR (100),
Country VARCHAR (100)

);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
Order_id SERIAL PRIMARY KEY ,
Customer_id INT REFERENCES Customers(Customer_id),
Book_id INT REFERENCES Books(Book_id),
Order_date DATE,
Quantity INT,
Total_Amount NUMERIC (10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--1)RETRIVE ALL BOOKS IN THE FICTION GENRE ;
SELECT * FROM Books
WHERE genre = 'Fiction';

-- 2)FIND BOOKS PUBLISHED AFTER THE YEAR 1950 ;
SELECT * FROM Books 
WHERE Published_Year > 1950;

--3) LIST ALL CUSTOMERS FROM THE CANADA 
SELECT * FROM Customers
WHERE Country = 'Canada';

--4)Show orders placed in november 2023;
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01'AND '2023-11-30';

--5) RETRIVE THE TOTAL STOCK OF BOOKS AVAILABLE
SELECT SUM(Stock) AS TOTAL_STOCK
FROM Books;

--6) FIND THE DETAILS OF THE MOST EXPENSIVE BOOK;
SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;

--7) SHOW ALL CUSTOMERS WHO ORDERED MORE THAN 5 QUANTITY OF A BOOK;
SELECT * FROM Orders
WHERE Quantity > 5;

--8) RETRIVE ALL ORDERS WHERE THE TOTAL AMOUNT  EXCEEDS   more than $300 : 
SELECT * FROM Orders 
WHERE total_amount > 300;

--9) LIST ALL GENRE AVAILABLE IN THE BOOKS TABLE (unique column)
SELECT DISTINCT genre 
FROM Books;

--10 ) FIND THE BOOK WITH THE LOWEST STOCK ;
SELECT * FROM Books
ORDER BY Stock 
LIMIT 1;

-- 11) CALCULATE THE TOTAL REVENUE GENERATED FROM ALL ORDRES ;
SELECT SUM(TOTAL_AMOUNT) AS REVENUE 
FROM Orders ;

-- ADVANCED QUESTION 
-- 1) RETRIEVE THE TOTAL NUMBER OF BOOKS SOLD FOR EACH GENRERE :
SELECT * FROM Orders ;

SELECT b.Genre , SUM(o.Quantity ) AS TOTAL_BOOKS_SOLD
FROM Orders o 
JOIN Books b ON o.Book_id = b.book_id 
GROUP BY b.genre ;

--2) FIND THE AVERAGE PRICE OF BOOKS IN THE 'FANSTASY' GENRE :
SELECT AVG(Price) AS AVERAGE_PRICE
FROM Books 
WHERE Genre = 'Fantasy';

--3) LIST CUSTOMERS WHO HAVE PLACED AT LEAT 2 ORDERS :
SELECT o.Customer_id , c.name, COUNT(o.Order_id) AS order_count 
FROM Orders o
JOIN Customers c ON O.Customer_id = c.Customer_id
GROUP BY o.Customer_id, c.name  
HAVING COUNT(Order_id) >=2;

--4) FIND THE MOST FREQUENTLY ORDERED BOOK:

SELECT O.Book_id,b.title, COUNT(O.order_id) AS ORDER_COUNT 
FROM orders o
JOIN Books b ON O.Book_id = b.Book_id 
GROUP BY O.Book_id, b.title 
ORDER BY ORDER_COUNT  DESC 
LIMIT 1;

--5) RETRIEVE THE TOP 3 MOST EXPENSIVE BOOKS OF 'FANTASY' GENRE:
SELECT * FROM Books 
WHERE GENRE = 'Fantasy'
ORDER BY Price DESC 
LIMIT 3;

--6) RETRIEVE THE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR :
SELECT b.author , SUM(o.Quantity) AS TOTAL_QUANTITY
FROM Orders o
JOIN books b ON O.Book_id = b.book_id 
GROUP BY b.Author;

--7) LIST THE CITIES WHERE CUSTOMERS WHO SPENT OVER $30 ARE LOCATED:
SELECT DISTINCT c.city, total_amount 
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id 
WHERE o.total_amount > 30;

--8) FIND THE CUSTOMERS WHO SPENT THE MOST ON ORDERS:
SELECT c.Customer_id , c.name ,SUM( O.total_amount) AS TOTAL_SPENT 
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY  c.customer_id, c.name
ORDER BY TOTAL_SPENT DESC
LIMIT 3;

--9) CALCULATE THE STOCK REMAINING AFTER FULFILLING ALL ORDERS:
SELECT b.Book_id, b.title , b.stock, COALESCE(SUM(o.quantity),0) AS Order_quality,
b.stock- COALESCE(SUM(O.quantity),0) AS Remaining_Quatity
FROM Books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id ;


