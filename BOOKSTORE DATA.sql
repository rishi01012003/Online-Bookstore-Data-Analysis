/*
ONLINE BOOKSTORE DATABASE ANALYSIS
PostgreSQL / pgAdmin 4

IMPORTANT:
1. Run the database creation command below by itself in pgAdmin while connected
   to an existing database (usually postgres).
2. After it succeeds, connect to OnlineBookstore in pgAdmin.
3. Open a NEW Query Tool for OnlineBookstore and run the MAIN SCRIPT below.
4. Import the CSV files using pgAdmin's Import/Export Data option (instructions
   are at the end). The old Windows COPY paths have been removed because the
   PostgreSQL server may not be able to access files on your computer.
*/


/* ============================================================
   STEP 1 - CREATE DATABASE
   Run this statement separately. Do not run it together with the
   main script, and do not use \c in pgAdmin Query Tool.
   ============================================================ */

-- CREATE DATABASE OnlineBookstore;


/* ============================================================
   STEP 2 - MAIN SCRIPT
   First connect pgAdmin Query Tool to the OnlineBookstore database.
   ============================================================ */


/* ---------- A. DROP EXISTING TABLES IN FOREIGN-KEY ORDER ---------- */

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;


/* ---------- B. CREATE TABLES ---------- */

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


/* ---------- C. CHECK TABLES ---------- */

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


/* ============================================================
   D. CSV DATA IMPORT
   Import data AFTER creating the tables and BEFORE running the
   analysis queries below.

   In pgAdmin:
   1. Expand OnlineBookstore > Schemas > public > Tables.
   2. Right-click Books > Import/Export Data.
   3. Choose Import, select Books.csv, set Format = csv,
      enable Header, and confirm the delimiter is a comma.
   4. Repeat for Customers.csv and Orders.csv.
   5. Import Books and Customers BEFORE Orders because Orders has
      foreign keys referencing both tables.

   Ensure the CSV column order matches the table column order.
   If your CSV files do not contain ID columns, import only the
   non-ID columns and let SERIAL generate the IDs. The Orders CSV
   must then use the generated Customer_ID and Book_ID values.

   After importing explicit ID values, reset the SERIAL sequences
   by running the sequence-reset statements below.
   ============================================================ */


/* Run these only after importing rows with explicit ID values.
   They are safe when the corresponding tables contain data. */

SELECT setval(
    pg_get_serial_sequence('books', 'book_id'),
    COALESCE((SELECT MAX(book_id) FROM Books), 1),
    (SELECT COUNT(*) > 0 FROM Books)
);

SELECT setval(
    pg_get_serial_sequence('customers', 'customer_id'),
    COALESCE((SELECT MAX(customer_id) FROM Customers), 1),
    (SELECT COUNT(*) > 0 FROM Customers)
);

SELECT setval(
    pg_get_serial_sequence('orders', 'order_id'),
    COALESCE((SELECT MAX(order_id) FROM Orders), 1),
    (SELECT COUNT(*) > 0 FROM Orders)
);


/* ============================================================
   E. BASIC SQL QUERIES
   ============================================================ */

-- 1. Retrieve all books in the Fiction genre.
SELECT *
FROM Books
WHERE Genre = 'Fiction';


-- 2. Find books published after the year 1950.
SELECT *
FROM Books
WHERE Published_Year > 1950;


-- 3. List all customers from Canada.
SELECT *
FROM Customers
WHERE Country = 'Canada';


-- 4. Show orders placed in November 2023.
SELECT *
FROM Orders
WHERE Order_Date >= DATE '2023-11-01'
  AND Order_Date < DATE '2023-12-01';


-- 5. Retrieve the total stock of books available.
SELECT SUM(Stock) AS Total_Stock
FROM Books;


-- 6. Find the most expensive book.
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;


-- 7. Show orders where more than one copy of a book was ordered.
SELECT *
FROM Orders
WHERE Quantity > 1;


-- 8. Retrieve orders where the total amount exceeds $20.
SELECT *
FROM Orders
WHERE Total_Amount > 20;


-- 9. List all genres available in the Books table.
SELECT DISTINCT Genre
FROM Books
ORDER BY Genre;


-- 10. Find the book with the lowest stock.
SELECT *
FROM Books
ORDER BY Stock ASC NULLS LAST
LIMIT 1;


-- 11. Calculate total revenue generated from all orders.
SELECT SUM(Total_Amount) AS Revenue
FROM Orders;


/* ============================================================
   F. ADVANCED SQL QUERIES
   ============================================================ */

-- 1. Retrieve the total number of books sold for each genre.
SELECT
    b.Genre,
    SUM(o.Quantity) AS Total_Books_Sold
FROM Orders AS o
JOIN Books AS b
    ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY b.Genre;


-- 2. Find the average price of books in the Fantasy genre.
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';


-- 3. List customers who have placed at least two orders.
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Order_Count
FROM Customers AS c
JOIN Orders AS o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2
ORDER BY Order_Count DESC;


-- 4. Find the most frequently ordered book (by number of order records).
SELECT
    b.Book_ID,
    b.Title,
    COUNT(o.Order_ID) AS Order_Count
FROM Orders AS o
JOIN Books AS b
    ON o.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY Order_Count DESC
LIMIT 1;


-- 5. Show the top three most expensive books in the Fantasy genre.
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;


-- 6. Retrieve the total quantity of books sold by each author.
SELECT
    b.Author,
    SUM(o.Quantity) AS Total_Books_Sold
FROM Orders AS o
JOIN Books AS b
    ON o.Book_ID = b.Book_ID
GROUP BY b.Author
ORDER BY Total_Books_Sold DESC;


-- 7. List cities where customers' combined order spending exceeds $30.
SELECT
    c.City,
    SUM(o.Total_Amount) AS Total_Spent
FROM Orders AS o
JOIN Customers AS c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
HAVING SUM(o.Total_Amount) > 30
ORDER BY Total_Spent DESC;


-- 8. Find the customer who spent the most on orders.
SELECT
    c.Customer_ID,
    c.Name,
    SUM(o.Total_Amount) AS Total_Spent
FROM Orders AS o
JOIN Customers AS c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;


-- 9. Calculate stock remaining after fulfilling all recorded orders.
-- This assumes Books.Stock represents the stock before these orders.
SELECT
    b.Book_ID,
    b.Title,
    b.Stock AS Initial_Stock,
    COALESCE(SUM(o.Quantity), 0) AS Order_Quantity,
    b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_Quantity
FROM Books AS b
LEFT JOIN Orders AS o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock
ORDER BY b.Book_ID;


/* ============================================================
   END OF SCRIPT
   ============================================================ */
