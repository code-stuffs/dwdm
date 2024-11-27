create database booksnowflake;
use booksnowflake;

-- Create Dimension Tables

-- Dim_Book
CREATE TABLE Dim_Book (
    Book_ID INT PRIMARY KEY,
    Book_Type VARCHAR(50),
    Book_Cost DECIMAL(10, 2)
);

-- Dim_Author
CREATE TABLE Dim_Author (
    Author_ID INT PRIMARY KEY,
    Author_Name VARCHAR(100),
    Author_Age INT,
    Author_Country VARCHAR(50)
);

-- Dim_Publication
CREATE TABLE Dim_Publication (
    Publication_ID INT PRIMARY KEY,
    Publication_Name VARCHAR(100),
    Publication_Country VARCHAR(50),
    Publication_Year INT
);

-- Dim_Location
CREATE TABLE Dim_Location (
    Location_ID INT PRIMARY KEY,
    Location_Name VARCHAR(100),
    Location_Country VARCHAR(50),
    Location_Region VARCHAR(50)
);

-- Create Fact Table

-- Fact_Book_Sales
CREATE TABLE Fact_Book_Sales (
    Sale_ID INT PRIMARY KEY,
    Book_ID INT,
    Author_ID INT,
    Publication_ID INT,
    Location_ID INT,
    Quantity INT,
    Profit DECIMAL(10, 2),
    FOREIGN KEY (Book_ID) REFERENCES Dim_Book(Book_ID),
    FOREIGN KEY (Author_ID) REFERENCES Dim_Author(Author_ID),
    FOREIGN KEY (Publication_ID) REFERENCES Dim_Publication(Publication_ID),
    FOREIGN KEY (Location_ID) REFERENCES Dim_Location(Location_ID)
);

-- Insert Sample Data into Dimension Tables

-- Dim_Book
INSERT INTO Dim_Book (Book_ID, Book_Type, Book_Cost)
VALUES (1, 'Fiction', 300.00),
       (2, 'Non-Fiction', 250.00),
       (3, 'Science', 400.00);

-- Dim_Author
INSERT INTO Dim_Author (Author_ID, Author_Name, Author_Age, Author_Country)
VALUES (1, 'John Doe', 45, 'USA'),
       (2, 'Jane Smith', 34, 'UK'),
       (3, 'Albert Einstein', 76, 'Germany');

-- Dim_Publication
INSERT INTO Dim_Publication (Publication_ID, Publication_Name, Publication_Country, Publication_Year)
VALUES (1, 'Harper Collins', 'USA', 2020),
       (2, 'Penguin', 'UK', 2019),
       (3, 'Springer', 'Germany', 2018);

-- Dim_Location
INSERT INTO Dim_Location (Location_ID, Location_Name, Location_Country, Location_Region)
VALUES (1, 'New York', 'USA', 'East'),
       (2, 'London', 'UK', 'South'),
       (3, 'Berlin', 'Germany', 'West');

-- Insert Sample Data into Fact Table

-- Fact_Book_Sales
INSERT INTO Fact_Book_Sales (Sale_ID, Book_ID, Author_ID, Publication_ID, Location_ID, Quantity, Profit)
VALUES (1, 1, 1, 1, 1, 100, 5000.00),
       (2, 2, 2, 2, 2, 150, 3750.00),
       (3, 3, 3, 3, 3, 200, 8000.00);

-- Query to Get Quantity and Profit per Book Type, Location, Author, and Publication
SELECT 
    b.Book_Type,
    l.Location_Name,
    a.Author_Name,
    p.Publication_Name,
    SUM(fs.Quantity) AS Total_Quantity,
    SUM(fs.Profit) AS Total_Profit
FROM 
    Fact_Book_Sales fs
JOIN Dim_Book b ON fs.Book_ID = b.Book_ID
JOIN Dim_Author a ON fs.Author_ID = a.Author_ID
JOIN Dim_Publication p ON fs.Publication_ID = p.Publication_ID
JOIN Dim_Location l ON fs.Location_ID = l.Location_ID
GROUP BY 
    b.Book_Type, l.Location_Name, a.Author_Name, p.Publication_Name;
