create database bookstar;
use bookstar;


-- Create Dimension Tables
CREATE TABLE DimBookType (
    BookTypeID INT PRIMARY KEY,
    BookTypeName VARCHAR(50) NOT NULL
);

CREATE TABLE DimLocation (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(50) NOT NULL
);

CREATE TABLE DimAuthor (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL,
    AuthorAge INT NOT NULL,
    AuthorCountry VARCHAR(50) NOT NULL
);

CREATE TABLE DimPublication (
    PublicationID INT PRIMARY KEY,
    PublicationName VARCHAR(100) NOT NULL,
    PublicationCountry VARCHAR(50) NOT NULL,
    PublicationYear INT NOT NULL
);

-- Create Fact Table
CREATE TABLE FactBook (
    FactID INT PRIMARY KEY,
    BookTypeID INT,
    LocationID INT,
    AuthorID INT,
    PublicationID INT,
    Quantity INT NOT NULL,
    Profit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (BookTypeID) REFERENCES DimBookType(BookTypeID),
    FOREIGN KEY (LocationID) REFERENCES DimLocation(LocationID),
    FOREIGN KEY (AuthorID) REFERENCES DimAuthor(AuthorID),
    FOREIGN KEY (PublicationID) REFERENCES DimPublication(PublicationID)
);

-- Insert Data into Dimension Tables
INSERT INTO DimBookType VALUES (1, 'Fiction'), (2, 'Non-Fiction'), (3, 'Science'), (4, 'Biography');
INSERT INTO DimLocation VALUES (1, 'Pune'), (2, 'Mumbai'), (3, 'Delhi'), (4, 'Bangalore');
INSERT INTO DimAuthor VALUES 
    (1, 'J.K. Rowling', 57, 'UK'), 
    (2, 'George R.R. Martin', 75, 'USA'), 
    (3, 'Yuval Noah Harari', 47, 'Israel'), 
    (4, 'Walter Isaacson', 71, 'USA');
INSERT INTO DimPublication VALUES 
    (1, 'Bloomsbury', 'UK', 1986), 
    (2, 'Bantam Books', 'USA', 1945), 
    (3, 'HarperCollins', 'USA', 1989), 
    (4, 'Simon & Schuster', 'USA', 1924);

-- Insert Data into Fact Table
INSERT INTO FactBook VALUES 
    (1, 1, 1, 1, 1, 150, 2000.00), 
    (2, 2, 2, 2, 2, 200, 3000.50), 
    (3, 3, 3, 3, 3, 120, 1800.75), 
    (4, 4, 4, 4, 4, 90, 1250.00), 
    (5, 1, 2, 1, 1, 100, 2500.25), 
    (6, 3, 1, 3, 3, 80, 1600.00);

-- Query to Calculate Quantity and Profit by Book Type
SELECT 
    B.BookTypeName, 
    SUM(F.Quantity) AS TotalQuantity, 
    SUM(F.Profit) AS TotalProfit
FROM FactBook F
JOIN DimBookType B ON F.BookTypeID = B.BookTypeID
GROUP BY B.BookTypeName;

-- Query to Calculate Quantity and Profit by Location
SELECT 
    L.LocationName, 
    SUM(F.Quantity) AS TotalQuantity, 
    SUM(F.Profit) AS TotalProfit
FROM FactBook F
JOIN DimLocation L ON F.LocationID = L.LocationID
GROUP BY L.LocationName;

-- Query to Calculate Quantity and Profit by Author
SELECT 
    A.AuthorName, 
    SUM(F.Quantity) AS TotalQuantity, 
    SUM(F.Profit) AS TotalProfit
FROM FactBook F
JOIN DimAuthor A ON F.AuthorID = A.AuthorID
GROUP BY A.AuthorName;

-- Query to Calculate Quantity and Profit by Publication
SELECT 
    P.PublicationName, 
    SUM(F.Quantity) AS TotalQuantity, 
    SUM(F.Profit) AS TotalProfit
FROM FactBook F
JOIN DimPublication P ON F.PublicationID = P.PublicationID
GROUP BY P.PublicationName;
