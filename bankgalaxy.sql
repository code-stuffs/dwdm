create database bankgalaxy;
use bankgalaxy;
-- Dimension Tables
CREATE TABLE Dim_Customer (
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Date_of_Birth DATE,
    Gender VARCHAR(10),
    Contact_Info VARCHAR(200),
    Customer_Since DATE
);

CREATE TABLE Dim_Branch (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Branch_Location VARCHAR(100),
    Manager_Name VARCHAR(100)
);

CREATE TABLE Dim_Account (
    Account_ID INT PRIMARY KEY,
    Account_Type VARCHAR(50),
    Account_Balance DECIMAL(15, 2),
    Account_Creation_Date DATE,
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID)
);

CREATE TABLE Dim_Time (
    Time_ID INT PRIMARY KEY,
    Date DATE,
    Day_of_Week VARCHAR(20),
    Month VARCHAR(20),
    Quarter INT,
    Year INT
);

-- Fact Tables
CREATE TABLE Fact_Transactions (
    Transaction_ID INT PRIMARY KEY,
    Customer_ID INT,
    Branch_ID INT,
    Account_ID INT,
    Transaction_Type VARCHAR(50),
    Amount DECIMAL(15, 2),
    Time_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(Branch_ID),
    FOREIGN KEY (Account_ID) REFERENCES Dim_Account(Account_ID),
    FOREIGN KEY (Time_ID) REFERENCES Dim_Time(Time_ID)
);

CREATE TABLE Fact_Loans (
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT,
    Branch_ID INT,
    Loan_Type VARCHAR(50),
    Loan_Amount DECIMAL(15, 2),
    Interest_Rate DECIMAL(5, 2),
    Time_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Branch_ID) REFERENCES Dim_Branch(Branch_ID),
    FOREIGN KEY (Time_ID) REFERENCES Dim_Time(Time_ID)
);
-- Inserting Data into Dimension Tables
INSERT INTO Dim_Customer VALUES (1, 'John Doe', '1985-06-15', 'Male', '1234567890', '2010-02-25');
INSERT INTO Dim_Branch VALUES (1, 'Main Branch', 'New York', 'Alice Smith');
INSERT INTO Dim_Account VALUES (1, 'Checking', 10000.00, '2015-08-15', 1);
INSERT INTO Dim_Time VALUES (1, '2024-11-27', 'Tuesday', 'November', 4, 2024);

-- Inserting Data into Fact Tables
INSERT INTO Fact_Transactions VALUES (1, 1, 1, 1, 'Deposit', 5000.00, 1);
INSERT INTO Fact_Loans VALUES (1, 1, 1, 'Mortgage', 200000.00, 4.5, 1);
SELECT C.Name, SUM(T.Amount) AS Total_Amount
FROM Fact_Transactions T
JOIN Dim_Customer C ON T.Customer_ID = C.Customer_ID
GROUP BY C.Name;
SELECT B.Branch_Name, AVG(L.Loan_Amount) AS Average_Loan_Amount
FROM Fact_Loans L
JOIN Dim_Branch B ON L.Branch_ID = B.Branch_ID
GROUP BY B.Branch_Name;
SELECT B.Branch_Name, AVG(L.Loan_Amount) AS Average_Loan_Amount
FROM Fact_Loans L
JOIN Dim_Branch B ON L.Branch_ID = B.Branch_ID
GROUP BY B.Branch_Name;
