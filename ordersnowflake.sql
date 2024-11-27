create database ordersnowflake;
use ordersnowflake;

-- Create Dimension Tables
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    BillingAddress VARCHAR(255),
    ShippingAddress VARCHAR(255)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(100)
);

CREATE TABLE DimPromotion (
    PromotionID INT PRIMARY KEY,
    PromotionName VARCHAR(100),
    DiscountPercent DECIMAL(5,2)
);

CREATE TABLE DimSalesRep (
    SalesRepID INT PRIMARY KEY,
    SalesRepName VARCHAR(100),
    Region VARCHAR(100)
);

CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    Year INT,
    Month INT,
    DayOfWeek VARCHAR(10)
);

-- Create Fact Table
CREATE TABLE FactOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    PromotionID INT,
    SalesRepID INT,
    OrderDate INT,
    ShipDate INT,
    OrderAmount DECIMAL(10,2),
    DiscountAmount DECIMAL(10,2),
    NetAmount DECIMAL(10,2),
    Currency VARCHAR(10),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (PromotionID) REFERENCES DimPromotion(PromotionID),
    FOREIGN KEY (SalesRepID) REFERENCES DimSalesRep(SalesRepID),
    FOREIGN KEY (OrderDate) REFERENCES DimDate(DateID),
    FOREIGN KEY (ShipDate) REFERENCES DimDate(DateID)
);

-- Step 2: Insert Sample Data
-- Insert Customers
INSERT INTO DimCustomer VALUES
(1, 'John Doe', '123 Main St', '456 Oak St'),
(2, 'Jane Smith', '789 Pine St', '101 Maple St');

-- Insert Products
INSERT INTO DimProduct VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Phone', 'Electronics');

-- Insert Promotions
INSERT INTO DimPromotion VALUES
(1, 'Holiday Sale', 10.00),
(2, 'Clearance', 20.00);

-- Insert Sales Representatives
INSERT INTO DimSalesRep VALUES
(1, 'Alice Brown', 'North'),
(2, 'Bob Green', 'South');

-- Insert Dates
INSERT INTO DimDate VALUES
(1, '2024-11-01', 2024, 11, 'Friday'),
(2, '2024-11-15', 2024, 11, 'Wednesday');

-- Insert Orders
INSERT INTO FactOrders VALUES
(1, 1, 1, 1, 1, 1, 2, 1000.00, 100.00, 900.00, 'USD'),
(2, 2, 2, 2, 2, 1, 2, 800.00, 160.00, 640.00, 'USD');

-- Step 3: Analytical Query
SELECT 
    c.CustomerName,
    p.ProductName,
    promo.PromotionName,
    rep.SalesRepName,
    SUM(o.NetAmount) AS NetOrderAmount
FROM FactOrders o
JOIN DimCustomer c ON o.CustomerID = c.CustomerID
JOIN DimProduct p ON o.ProductID = p.ProductID
JOIN DimPromotion promo ON o.PromotionID = promo.PromotionID
JOIN DimSalesRep rep ON o.SalesRepID = rep.SalesRepID
GROUP BY c.CustomerName, p.ProductName, promo.PromotionName, rep.SalesRepName;

-- Step 4: Estimate Data Warehouse Size
-- Assumption: 1000 orders/month, 12 months/year, 5 years
-- Average row size: FactOrders ~ 100 bytes; Dimensions ~ 50 bytes each
-- Total size = (1000 * 12 * 5 * 100) + (50 * 1000 rows * 5 dimensions) = Approx 6 MB.
