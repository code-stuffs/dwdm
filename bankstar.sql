create database bankstar;
use bankstar;

-- Create Dimension Tables

-- Dimension Table for Customer
CREATE TABLE Dim_Customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Contact VARCHAR(15),
    Address VARCHAR(255)
);

-- Dimension Table for Account
CREATE TABLE Dim_Account (
    Account_ID VARCHAR(10) PRIMARY KEY,
    Account_Type VARCHAR(50),
    Balance DECIMAL(15, 2),
    Opening_Date DATE
);

-- Dimension Table for Branch
CREATE TABLE Dim_Branch (
    Branch_ID VARCHAR(10) PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Location VARCHAR(100),
    Branch_Manager VARCHAR(100)
);

-- Dimension Table for Time
CREATE TABLE Dim_Time (
    Time_ID INT PRIMARY KEY,
    Date DATE,
    Day_of_Week VARCHAR(20),
    Month INT,
    Quarter INT,
    Year INT
);

-- Dimension Table for Employee
CREATE TABLE Dim_Employee (
    Employee_ID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Role VARCHAR(50),
    Branch_ID VARCHAR(10),
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(Branch_ID)
);

-- Create Fact Table for Transactions
CREATE TABLE Fact_Transactions (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Account_ID VARCHAR(10),
    Branch_ID VARCHAR(10),
    Time_ID INT,
    Employee_ID VARCHAR(10),
    Transaction_Type VARCHAR(50),
    Amount DECIMAL(15, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Account_ID) REFERENCES Dim_Account(Account_ID),
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(Branch_ID),
    FOREIGN KEY (Time_ID) REFERENCES Dim_Time(Time_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Dim_Employee(Employee_ID)
);

-- Insert Sample Data into Dim_Customer
INSERT INTO Dim_Customer (Customer_ID, Name, Contact, Address)
VALUES
(101, 'John Doe', '1234567890', '123 Main St, City A'),
(102, 'Jane Smith', '9876543210', '456 Oak Rd, City B'),
(103, 'Sam White', '5551234567', '789 Pine St, City C'),
(104, 'Lisa Brown', '3339876543', '321 Maple Ave, City D');

-- Insert Sample Data into Dim_Account
INSERT INTO Dim_Account (Account_ID, Account_Type, Balance, Opening_Date)
VALUES
('A1001', 'Savings', 5000.00, '2020-01-01'),
('A1002', 'Checking', 3000.00, '2021-03-15'),
('A1003', 'Business', 15000.00, '2019-05-22'),
('A1004', 'Savings', 2500.00, '2022-08-01');

-- Insert Sample Data into Dim_Branch
INSERT INTO Dim_Branch (Branch_ID, Branch_Name, Location, Branch_Manager)
VALUES
('B001', 'Main Branch', 'City A', 'David Wilson'),
('B002', 'City B Branch', 'City B', 'Sarah Taylor'),
('B003', 'Suburb Branch', 'City C', 'Michael Johnson');

-- Insert Sample Data into Dim_Time
INSERT INTO Dim_Time (Time_ID, Date, Day_of_Week, Month, Quarter, Year)
VALUES
(20230101, '2023-01-01', 'Sunday', 1, 1, 2023),
(20230102, '2023-01-02', 'Monday', 1, 1, 2023),
(20230103, '2023-01-03', 'Tuesday', 1, 1, 2023),
(20230104, '2023-01-04', 'Wednesday', 1, 1, 2023);

-- Insert Sample Data into Dim_Employee
INSERT INTO Dim_Employee (Employee_ID, Name, Role, Branch_ID)
VALUES
('E001', 'Alice Green', 'Teller', 'B001'),
('E002', 'Bob Adams', 'Manager', 'B002'),
('E003', 'Charlie Brown', 'Loan Officer', 'B003'),
('E004', 'Diana Black', 'Branch Head', 'B001');

-- Insert Sample Data into Fact_Transactions
INSERT INTO Fact_Transactions (Transaction_ID, Customer_ID, Account_ID, Branch_ID, Time_ID, Employee_ID, Transaction_Type, Amount)
VALUES
(1, 101, 'A1001', 'B001', 20230101, 'E001', 'Deposit', 5000.00),
(2, 102, 'A1002', 'B002', 20230102, 'E002', 'Withdrawal', 3000.00),
(3, 103, 'A1003', 'B003', 20230103, 'E003', 'Transfer', 2000.00),
(4, 104, 'A1004', 'B001', 20230104, 'E004', 'Loan Repayment', 1500.00);

-- Example Queries

-- Query 1: Get total transaction amount by customer
SELECT c.Name, SUM(f.Amount) AS Total_Amount
FROM Fact_Transactions f
JOIN Dim_Customer c ON f.Customer_ID = c.Customer_ID
GROUP BY c.Name;

-- Query 2: Get transaction details by branch and account type
SELECT b.Branch_Name, a.Account_Type, SUM(f.Amount) AS Total_Amount
FROM Fact_Transactions f
JOIN Dim_Branch b ON f.Branch_ID = b.Branch_ID
JOIN Dim_Account a ON f.Account_ID = a.Account_ID
GROUP BY b.Branch_Name, a.Account_Type;

-- Query 3: Get total transactions by employee for a specific month (January 2023)
SELECT e.Name AS Employee_Name, SUM(f.Amount) AS Total_Amount
FROM Fact_Transactions f
JOIN Dim_Employee e ON f.Employee_ID = e.Employee_ID
JOIN Dim_Time t ON f.Time_ID = t.Time_ID
WHERE t.Month = 1 AND t.Year = 2023
GROUP BY e.Name;

-- Query 4: Get transactions by type (Deposit, Withdrawal, etc.)
SELECT f.Transaction_Type, COUNT(*) AS Transaction_Count, SUM(f.Amount) AS Total_Amount
FROM Fact_Transactions f
GROUP BY f.Transaction_Type;
