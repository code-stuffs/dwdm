create database healthcaresnowflake;
use healthcaresnowflake;
-- Create Dim Patient Table
CREATE TABLE Dim_Patient (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    Address VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

-- Create Dim Department Table (for healthcare provider's department)
CREATE TABLE Dim_Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50)
);

-- Create Dim Healthcare Provider Table (now references department)
CREATE TABLE Dim_Healthcare_Provider (
    ProviderID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Dim_Department(DepartmentID)
);

-- Create Dim Treatment Table (now normalized)
CREATE TABLE Dim_Treatment (
    TreatmentID INT PRIMARY KEY,
    TreatmentTypeID INT,   -- links to Treatment Type table
    TreatmentName VARCHAR(100),
    TreatmentDescription TEXT
);

-- Create Dim Treatment Type Table
CREATE TABLE Dim_Treatment_Type (
    TreatmentTypeID INT PRIMARY KEY,
    TreatmentTypeName VARCHAR(50)
);

-- Create Dim Insurance Company Table
CREATE TABLE Dim_Insurance (
    InsuranceID INT PRIMARY KEY,
    InsuranceCompany VARCHAR(50)
);

-- Create Dim Payment Table (normalized)
CREATE TABLE Dim_Payment (
    PaymentID INT PRIMARY KEY,
    AmountCharged DECIMAL(10, 2),
    AmountPaid DECIMAL(10, 2)
);

-- Create Fact Visits Table (keeps references to all normalized dimension tables)
CREATE TABLE Fact_Visits (
    VisitID INT PRIMARY KEY,
    PatientID INT,
    ProviderID INT,
    TreatmentID INT,
    InsuranceID INT,
    PaymentID INT,
    VisitDate DATE,
    Diagnosis VARCHAR(100),
    TotalCharges DECIMAL(10, 2),
    FOREIGN KEY (PatientID) REFERENCES Dim_Patient(PatientID),
    FOREIGN KEY (ProviderID) REFERENCES Dim_Healthcare_Provider(ProviderID),
    FOREIGN KEY (TreatmentID) REFERENCES Dim_Treatment(TreatmentID),
    FOREIGN KEY (InsuranceID) REFERENCES Dim_Insurance(InsuranceID),
    FOREIGN KEY (PaymentID) REFERENCES Dim_Payment(PaymentID)
);

-- Insert Data into Dim Patient
INSERT INTO Dim_Patient (PatientID, FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber)
VALUES
(1, 'John', 'Doe', '1985-08-15', 'Male', '1234 Elm St, Springfield', '123-456-7890'),
(2, 'Jane', 'Smith', '1990-11-21', 'Female', '5678 Oak St, Springfield', '987-654-3210');

-- Insert Data into Dim Department
INSERT INTO Dim_Department (DepartmentID, DepartmentName, Location)
VALUES
(1, 'Cardiology', '2nd Floor'),
(2, 'Neurology', '3rd Floor');

-- Insert Data into Dim Healthcare Provider
INSERT INTO Dim_Healthcare_Provider (ProviderID, FirstName, LastName, Specialty, DepartmentID)
VALUES
(1, 'Dr. Alice', 'Johnson', 'Cardiology', 1),
(2, 'Dr. Bob', 'Williams', 'Neurology', 2);

-- Insert Data into Dim Treatment Type
INSERT INTO Dim_Treatment_Type (TreatmentTypeID, TreatmentTypeName)
VALUES
(1, 'Surgery'),
(2, 'Consultation');

-- Insert Data into Dim Treatment
INSERT INTO Dim_Treatment (TreatmentID, TreatmentTypeID, TreatmentName, TreatmentDescription)
VALUES
(1, 1, 'Cardiac Surgery', 'Surgical treatment for heart disease'),
(2, 2, 'Neuro Consultation', 'Consultation for neurological disorders');

-- Insert Data into Dim Insurance
INSERT INTO Dim_Insurance (InsuranceID, InsuranceCompany)
VALUES
(1, 'ABC Health'),
(2, 'XYZ Insure');

-- Insert Data into Dim Payment
INSERT INTO Dim_Payment (PaymentID, AmountCharged, AmountPaid)
VALUES
(1, 2000.00, 1800.00),
(2, 1500.00, 1500.00);

-- Insert Data into Fact Visits
INSERT INTO Fact_Visits (VisitID, PatientID, ProviderID, TreatmentID, InsuranceID, PaymentID, VisitDate, Diagnosis, TotalCharges)
VALUES
(1, 1, 1, 1, 1, 1, '2024-11-01', 'Heart Disease', 2000.00),
(2, 2, 2, 2, 2, 2, '2024-11-05', 'Neurological Disorder', 1500.00);

-- Sample Query 1: Total Charges for Each Patient
SELECT p.FirstName, p.LastName, SUM(f.TotalCharges) AS TotalCharges
FROM Fact_Visits f
JOIN Dim_Patient p ON f.PatientID = p.PatientID
GROUP BY p.PatientID;

-- Sample Query 2: Treatments Provided by Healthcare Providers
SELECT hp.FirstName, hp.LastName, t.TreatmentName, COUNT(f.VisitID) AS NumberOfTreatments
FROM Fact_Visits f
JOIN Dim_Healthcare_Provider hp ON f.ProviderID = hp.ProviderID
JOIN Dim_Treatment t ON f.TreatmentID = t.TreatmentID
GROUP BY hp.ProviderID, t.TreatmentID;

-- Sample Query 3: Total Charges by Department
SELECT d.DepartmentName, SUM(f.TotalCharges) AS TotalCharges
FROM Fact_Visits f
JOIN Dim_Healthcare_Provider hp ON f.ProviderID = hp.ProviderID
JOIN Dim_Department d ON hp.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID;

-- Sample Query 4: Billing Details for Each Visit
SELECT p.FirstName, p.LastName, i.InsuranceCompany, pmt.AmountCharged, pmt.AmountPaid
FROM Fact_Visits f
JOIN Dim_Patient p ON f.PatientID = p.PatientID
JOIN Dim_Insurance i ON f.InsuranceID = i.InsuranceID
JOIN Dim_Payment pmt ON f.PaymentID = pmt.PaymentID;
