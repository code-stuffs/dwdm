create database banksnowflake;
use banksnowflake;
-- 1. Dimension Tables

-- Dim_Customer: Stores Customer Information
CREATE TABLE Dim_Customer (
    Customer_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Date_of_Birth DATE,
    Customer_Type_ID INT
);

-- Dim_Branch: Stores Branch Information
CREATE TABLE Dim_Branch (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Branch_Location VARCHAR(100)
);

-- Dim_Account: Stores Account Information
CREATE TABLE Dim_Account (
    Account_ID INT PRIMARY KEY,
    Account_Type_ID INT,
    Balance DECIMAL(15, 2),
    Account_Status VARCHAR(50)
);

-- Dim_Time: Stores Time-related Information
CREATE TABLE Dim_Time (
    Time_ID INT PRIMARY KEY,
    Date DATE,
    Month INT,
    Quarter INT,
    Year INT
);

-- Sub-dimensions (additional normalization)
-- Dim_Customer_Type: Stores customer types (e.g., Individual, Corporate)
CREATE TABLE Dim_Customer_Type (
    Customer_Type_ID INT PRIMARY KEY,
    Customer_Type VARCHAR(50)
);

-- Dim_Account_Type: Stores account types (e.g., Checking, Savings, Loan)
CREATE TABLE Dim_Account_Type (
    Account_Type_ID INT PRIMARY KEY,
    Account_Type VARCHAR(50)
);

-- 2. Fact Table

-- Fact_Transaction: Stores Transaction Information
CREATE TABLE Fact_Transaction (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Branch_ID INT,
    Account_ID INT,
    Time_ID INT,
    Transaction_Amount DECIMAL(15, 2),
    Transaction_Type VARCHAR(50),  -- e.g., Deposit, Withdrawal, Transfer
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(Branch_ID),
    FOREIGN KEY (Account_ID) REFERENCES Dim_Account(Account_ID),
    FOREIGN KEY (Time_ID) REFERENCES Dim_Time(Time_ID)
);

-- 3. Sample Data Insertions

-- Insert Customer Types
INSERT INTO Dim_Customer_Type VALUES (1, 'Individual');
INSERT INTO Dim_Customer_Type VALUES (2, 'Corporate');

-- Insert Account Types
INSERT INTO Dim_Account_Type VALUES (1, 'Checking');
INSERT INTO Dim_Account_Type VALUES (2, 'Savings');
INSERT INTO Dim_Account_Type VALUES (3, 'Loan');

-- Insert Customers
INSERT INTO Dim_Customer VALUES (1, 'John', 'Doe', '1985-06-15', 1);
INSERT INTO Dim_Customer VALUES (2, 'Jane', 'Smith', '1990-11-23', 2);

-- Insert Branches
INSERT INTO Dim_Branch VALUES (1, 'Main Branch', 'Downtown');
INSERT INTO Dim_Branch VALUES (2, 'Sub Branch', 'Uptown');

-- Insert Account Information
INSERT INTO Dim_Account VALUES (1, 1, 1000.00, 'Active');
INSERT INTO Dim_Account VALUES (2, 2, 5000.00, 'Active');

-- Insert Time Data
INSERT INTO Dim_Time VALUES (1, '2024-01-01', 1, 1, 2024);
INSERT INTO Dim_Time VALUES (2, '2024-02-01', 2, 1, 2024);

-- Insert Transactions
INSERT INTO Fact_Transaction VALUES (1, 1, 1, 1, 1, 1000.00, 'Deposit');
INSERT INTO Fact_Transaction VALUES (2, 2, 2, 2, 2, 2000.00, 'Withdrawal');
SELECT
    c.First_Name, c.Last_Name, t.Transaction_Amount, t.Transaction_Type, b.Branch_Name, time.Date
FROM Fact_Transaction t
JOIN Dim_Customer c ON t.Customer_ID = c.Customer_ID
JOIN Dim_Branch b ON t.Branch_ID = b.Branch_ID
JOIN Dim_Account a ON t.Account_ID = a.Account_ID
JOIN Dim_Time time ON t.Time_ID = time.Time_ID
WHERE c.Customer_ID = 1;
SELECT
    b.Branch_Name,
    SUM(t.Transaction_Amount) AS Total_Deposits
FROM Fact_Transaction t
JOIN Dim_Branch b ON t.Branch_ID = b.Branch_ID
WHERE t.Transaction_Type = 'Deposit'
GROUP BY b.Branch_Name;
