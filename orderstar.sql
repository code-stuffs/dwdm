create database orderstar;
use orderstar;
-- 1. Star Schema Design
-- Fact Table: Order_Fact
-- Dimension Tables: Customer_Dim, Product_Dim, Promotion_Dim, SalesRep_Dim, Date_Dim, Currency_Dim

-- Dimension Tables
CREATE TABLE Customer_Dim (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Shipping_Address TEXT,
    Billing_Address TEXT
);

CREATE TABLE Product_Dim (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Product_Category VARCHAR(50)
);

CREATE TABLE Promotion_Dim (
    Promotion_ID INT PRIMARY KEY,
    Promotion_Description TEXT,
    Discount_Percentage DECIMAL(5, 2)
);

CREATE TABLE SalesRep_Dim (
    SalesRep_ID INT PRIMARY KEY,
    SalesRep_Name VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE Date_Dim (
    Date_ID INT PRIMARY KEY,
    Full_Date DATE,
    Year INT,
    Month INT,
    Day INT
);

CREATE TABLE Currency_Dim (
    Currency_Code VARCHAR(10) PRIMARY KEY,
    Exchange_Rate DECIMAL(10, 4) -- Rate to USD
);

-- Fact Table
CREATE TABLE Order_Fact (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_ID INT,
    Promotion_ID INT,
    SalesRep_ID INT,
    Order_Date_ID INT,
    Ship_Date_ID INT,
    Currency_Code VARCHAR(10),
    Quantity INT,
    Gross_Amount DECIMAL(15, 2),
    Net_Amount_USD DECIMAL(15, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Customer_Dim(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product_Dim(Product_ID),
    FOREIGN KEY (Promotion_ID) REFERENCES Promotion_Dim(Promotion_ID),
    FOREIGN KEY (SalesRep_ID) REFERENCES SalesRep_Dim(SalesRep_ID),
    FOREIGN KEY (Order_Date_ID) REFERENCES Date_Dim(Date_ID),
    FOREIGN KEY (Ship_Date_ID) REFERENCES Date_Dim(Date_ID),
    FOREIGN KEY (Currency_Code) REFERENCES Currency_Dim(Currency_Code)
);

-- 2. Insert Sample Data
-- Customer Dimension
INSERT INTO Customer_Dim VALUES
(1, 'Alice', '123 Maple Street', '456 Oak Avenue'),
(2, 'Bob', '789 Pine Road', '101 Elm Street');

-- Product Dimension
INSERT INTO Product_Dim VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Phone', 'Electronics');

-- Promotion Dimension
INSERT INTO Promotion_Dim VALUES
(1, 'Holiday Sale', 10.00),
(2, 'Clearance', 20.00);

-- Sales Representative Dimension
INSERT INTO SalesRep_Dim VALUES
(1, 'John', 'North Region'),
(2, 'Jane', 'South Region');

-- Date Dimension
INSERT INTO Date_Dim VALUES
(1, '2024-11-01', 2024, 11, 1),
(2, '2024-11-15', 2024, 11, 15);

-- Currency Dimension
INSERT INTO Currency_Dim VALUES
('USD', 1.0000),
('EUR', 0.9000),
('AED', 3.6725);

-- Fact Table
INSERT INTO Order_Fact VALUES
(1, 1, 1, 1, 1, 1, 2, 'USD', 2, 2000.00, 1800.00),
(2, 2, 2, 2, 2, 1, 2, 'EUR', 1, 800.00, 720.00);

-- 3. Query to Calculate Analytical Results
SELECT 
    c.Customer_Name,
    p.Product_Name,
    pr.Promotion_Description,
    s.SalesRep_Name,
    SUM(f.Net_Amount_USD) AS Total_Net_Amount_USD
FROM 
    Order_Fact f
JOIN 
    Customer_Dim c ON f.Customer_ID = c.Customer_ID
JOIN 
    Product_Dim p ON f.Product_ID = p.Product_ID
JOIN 
    Promotion_Dim pr ON f.Promotion_ID = pr.Promotion_ID
JOIN 
    SalesRep_Dim s ON f.SalesRep_ID = s.SalesRep_ID
GROUP BY 
    c.Customer_Name, p.Product_Name, pr.Promotion_Description, s.SalesRep_Name;

-- 4. Size Estimation
-- Assumption: 1000 orders/month * 12 months * 5 years = 60,000 rows.
-- Average row size: 100 bytes (estimate, including indices).
-- Estimated size: 60,000 * 100 / 1024 / 1024 = ~5.72 MB.
