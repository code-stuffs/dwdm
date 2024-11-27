create database ordergalaxy;
use ordergalaxy;
-- Step 1: Create Dimension Tables
CREATE TABLE DimCustomers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    BillingAddress VARCHAR(255),
    ShippingAddress VARCHAR(255)
);

CREATE TABLE DimProducts (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    BasePrice DECIMAL(10, 2)
);

CREATE TABLE DimDates (
    DateID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    Year INT,
    Month INT,
    Day INT,
    Week INT
);

CREATE TABLE DimSalesReps (
    SalesRepID INT AUTO_INCREMENT PRIMARY KEY,
    SalesRepName VARCHAR(100),
    Region VARCHAR(50)
);

CREATE TABLE DimCurrencies (
    CurrencyID INT AUTO_INCREMENT PRIMARY KEY,
    CurrencyName VARCHAR(50),
    ExchangeRateToDollar DECIMAL(10, 4)
);

-- Step 2: Create Fact Tables
CREATE TABLE FactOrders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    SalesRepID INT,
    DateID INT,
    Quantity INT,
    NetAmount DECIMAL(15, 2),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProducts(ProductID),
    FOREIGN KEY (SalesRepID) REFERENCES DimSalesReps(SalesRepID),
    FOREIGN KEY (DateID) REFERENCES DimDates(DateID)
);

CREATE TABLE FactPromotions (
    PromotionID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    PromotionName VARCHAR(100),
    DiscountPercentage DECIMAL(5, 2),
    DiscountAmount DECIMAL(15, 2),
    NetAmountAfterDiscount DECIMAL(15, 2),
    FOREIGN KEY (OrderID) REFERENCES FactOrders(OrderID)
);

-- Step 3: Insert Sample Data into Dimensions
INSERT INTO DimCustomers (CustomerName, BillingAddress, ShippingAddress) VALUES
('Alice', '123 Maple St', '456 Elm St'),
('Bob', '789 Pine St', '101 Oak St'),
('Charlie', '112 Birch St', '314 Walnut St');

INSERT INTO DimProducts (ProductName, Category, BasePrice) VALUES
('Laptop', 'Electronics', 1000.00),
('Phone', 'Electronics', 500.00),
('Tablet', 'Electronics', 300.00),
('Headphones', 'Accessories', 50.00),
('Monitor', 'Electronics', 200.00);

INSERT INTO DimDates (Date, Year, Month, Day, Week) VALUES
('2024-11-01', 2024, 11, 1, 44),
('2024-11-02', 2024, 11, 2, 44),
('2024-11-03', 2024, 11, 3, 44);

INSERT INTO DimSalesReps (SalesRepName, Region) VALUES
('David', 'North'),
('Emily', 'South'),
('Frank', 'West');

INSERT INTO DimCurrencies (CurrencyName, ExchangeRateToDollar) VALUES
('USD', 1.0000),
('EUR', 0.9000),
('AED', 3.6725);

-- Step 4: Insert Sample Data into Fact Tables
INSERT INTO FactOrders (CustomerID, ProductID, SalesRepID, DateID, Quantity, NetAmount) VALUES
(1, 1, 1, 1, 2, 2000.00),
(2, 2, 2, 2, 1, 500.00),
(3, 3, 3, 3, 3, 900.00);

INSERT INTO FactPromotions (OrderID, PromotionName, DiscountPercentage, DiscountAmount, NetAmountAfterDiscount) VALUES
(1, 'Black Friday', 10.00, 200.00, 1800.00),
(2, 'New Year', 5.00, 25.00, 475.00),
(3, 'Holiday Sale', 20.00, 180.00, 720.00);

-- Step 5: Analytical Query
SELECT 
    c.CustomerName,
    p.ProductName,
    pr.PromotionName,
    s.SalesRepName,
    o.Quantity,
    o.NetAmount,
    pr.DiscountAmount,
    pr.NetAmountAfterDiscount
FROM FactOrders o
JOIN DimCustomers c ON o.CustomerID = c.CustomerID
JOIN DimProducts p ON o.ProductID = p.ProductID
JOIN DimSalesReps s ON o.SalesRepID = s.SalesRepID
JOIN FactPromotions pr ON o.OrderID = pr.OrderID;

-- Step 6: Data Warehouse Size Estimation (Assumptions)
-- Number of records per year: 10,000 orders
-- Average record size for FactOrders: ~100 bytes
-- Average record size for FactPromotions: ~100 bytes
-- Total size per year = 10,000 * (100 + 100) = 2,000,000 bytes (~2 MB)
-- Over 5 years = 5 * 2 MB = ~10 MB
