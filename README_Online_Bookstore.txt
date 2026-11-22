# Online Bookstore Data Analysis | PostgreSQL

The Online Bookstore Data Analysis project uses PostgreSQL to organize and analyze bookstore data. It creates a relational database with Books, Customers, and Orders tables, then applies SQL queries to explore book inventory, customer locations, order activity, sales revenue, and purchasing patterns.

## Project Goals & Features

**Database Design:** Create an `OnlineBookstore` database with three related tables: `Books`, `Customers`, and `Orders`. Primary keys and foreign-key relationships connect customers and books to their orders.

**Book Inventory Analysis:** Retrieve books by genre and publication year, calculate total stock, identify the most expensive book, find the lowest-stock book, and list available genres.

**Customer Analysis:** Filter customers by country and identify customers who have placed at least two orders.

**Order & Revenue Analysis:** Examine orders within a selected date range, filter orders by quantity and total amount, and calculate total revenue.

**Advanced SQL Analysis:** Use `JOIN`, `GROUP BY`, aggregate functions, `HAVING`, `ORDER BY`, and `LIMIT` to analyze books sold by genre and author, frequently ordered books, customer spending, and city-wise spending.

**Inventory Tracking:** Compare recorded order quantities with book stock to calculate an estimated remaining quantity.

## Tools & Technologies

- **PostgreSQL** – relational database and SQL query execution.
- **pgAdmin 4** – database management and query editor.
- **SQL** – database creation, table design, data retrieval, joins, aggregations, and analysis.
- **CSV files** – data import source for the Books, Customers, and Orders tables.

## Database Structure

The project contains three tables:

- **Books:** `Book_ID`, `Title`, `Author`, `Genre`, `Published_Year`, `Price`, `Stock`
- **Customers:** `Customer_ID`, `Name`, `Email`, `Phone`, `City`, `Country`
- **Orders:** `Order_ID`, `Customer_ID`, `Book_ID`, `Order_Date`, `Quantity`, `Total_Amount`

`Orders.Customer_ID` references `Customers.Customer_ID`, and `Orders.Book_ID` references `Books.Book_ID`.

## SQL Concepts Demonstrated

- `CREATE DATABASE` and `CREATE TABLE`
- Primary keys and foreign keys
- `SELECT`, `WHERE`, `DISTINCT`, and date filtering
- `ORDER BY` and `LIMIT`
- Aggregate functions: `SUM`, `AVG`, and `COUNT`
- `JOIN` and `LEFT JOIN`
- `GROUP BY` and `HAVING`
- `COALESCE` and `NULLS LAST`
- PostgreSQL `SERIAL` sequences

## Project Files

- `BOOKSTORE_Data_Analysis_FIXED.sql` – SQL script for creating the tables and running basic and advanced analysis queries.
- `README.md` – project documentation.

## How to Run

1. Install PostgreSQL and open pgAdmin 4.
2. Connect to an existing database (such as `postgres`) and create the project database by running `CREATE DATABASE OnlineBookstore;` separately.
3. Connect to the new `OnlineBookstore` database and open a new Query Tool.
4. Open and run the main script from `BOOKSTORE_Data_Analysis_FIXED.sql`.
5. Import the Books, Customers, and Orders CSV files through pgAdmin's **Import/Export Data** option. Import Books and Customers before Orders because Orders contains foreign keys.
6. Run the analysis queries after importing the data.

**Data import note:** The SQL script provides table definitions and import guidance. The CSV data files are not included in this repository unless added separately. Ensure the imported CSV columns match the table structure and that the customer and book IDs in Orders correspond to IDs in the parent tables.

**Inventory note:** The remaining-stock query assumes `Books.Stock` represents stock before the recorded orders. If the stock values already reflect fulfilled orders, subtracting order quantities again would not represent current stock.

## Author

**Nageshwar Kashyap**

- GitHub: https://github.com/rishi01012003
- LinkedIn: https://www.linkedin.com/in/nageshwar-kashyap-366939312/
