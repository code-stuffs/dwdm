create database healthcarestar;
use healthcarestar
-- Create Dimension Table: Dim_Patient
CREATE TABLE Dim_Patient (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender CHAR(1),
    InsuranceType VARCHAR(50),
    MedicalHistory VARCHAR(255)
);

-- Create Dimension Table: Dim_Doctor
CREATE TABLE Dim_Doctor (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100),
    Specialization VARCHAR(100),
    YearsOfExperience INT,
    Qualification VARCHAR(50)
);

-- Create Dimension Table: Dim_Treatment
CREATE TABLE Dim_Treatment (
    TreatmentID INT PRIMARY KEY,
    TreatmentName VARCHAR(100),
    TreatmentType VARCHAR(50),
    Cost DECIMAL(10, 2)
);

-- Create Dimension Table: Dim_Time
CREATE TABLE Dim_Time (
    DateKey INT PRIMARY KEY,
    Date DATE,
    Month INT,
    Year INT,
    Quarter INT
);

-- Create Fact Table: Fact_PatientVisit
CREATE TABLE Fact_PatientVisit (
    VisitID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    TreatmentID INT,
    DateKey INT,
    Cost DECIMAL(10, 2),
    Revenue DECIMAL(10, 2),
    LOS INT,
    SatisfactionScore DECIMAL(3, 2),
    FOREIGN KEY (PatientID) REFERENCES Dim_Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Dim_Doctor(DoctorID),
    FOREIGN KEY (TreatmentID) REFERENCES Dim_Treatment(TreatmentID),
    FOREIGN KEY (DateKey) REFERENCES Dim_Time(DateKey)
);

-- Insert Data into Dim_Patient
INSERT INTO Dim_Patient (PatientID, Name, Age, Gender, InsuranceType, MedicalHistory) VALUES
(1, 'John Doe', 45, 'M', 'Private', 'Hypertension'),
(2, 'Jane Smith', 30, 'F', 'Public', 'None');

-- Insert Data into Dim_Doctor
INSERT INTO Dim_Doctor (DoctorID, DoctorName, Specialization, YearsOfExperience, Qualification) VALUES
(1, 'Dr. Adam Brown', 'Cardiologist', 10, 'MD'),
(2, 'Dr. Sarah Green', 'General Medicine', 5, 'MBBS');

-- Insert Data into Dim_Treatment
INSERT INTO Dim_Treatment (TreatmentID, TreatmentName, TreatmentType, Cost) VALUES
(1, 'Coronary Bypass', 'Surgical', 5000),
(2, 'Consultation', 'Non-Surgical', 150);

-- Insert Data into Dim_Time
INSERT INTO Dim_Time (DateKey, Date, Month, Year, Quarter) VALUES
(20240101, '2024-01-01', 1, 2024, 1),
(20240201, '2024-02-01', 2, 2024, 1);

-- Insert Data into Fact_PatientVisit
INSERT INTO Fact_PatientVisit (VisitID, PatientID, DoctorID, TreatmentID, DateKey, Cost, Revenue, LOS, SatisfactionScore) VALUES
(1, 1, 1, 1, 20240101, 5000, 7000, 7, 4.5),
(2, 2, 2, 2, 20240201, 150, 200, 1, 3.8);

-- Query 1: Total Revenue by Doctor
SELECT D.DoctorName, SUM(F.Revenue) AS TotalRevenue
FROM Fact_PatientVisit F
JOIN Dim_Doctor D ON F.DoctorID = D.DoctorID
GROUP BY D.DoctorName;

-- Query 2: Average Length of Stay (LOS) by Patient
SELECT P.Name, AVG(F.LOS) AS AvgLOS
FROM Fact_PatientVisit F
JOIN Dim_Patient P ON F.PatientID = P.PatientID
GROUP BY P.Name;

-- Query 3: Patient Satisfaction Score by Treatment Type
SELECT T.TreatmentType, AVG(F.SatisfactionScore) AS AvgSatisfaction
FROM Fact_PatientVisit F
JOIN Dim_Treatment T ON F.TreatmentID = T.TreatmentID
GROUP BY T.TreatmentType;

-- Query 4: Monthly Revenue in 2024
SELECT T.Month, SUM(F.Revenue) AS MonthlyRevenue
FROM Fact_PatientVisit F
JOIN Dim_Time T ON F.DateKey = T.DateKey
WHERE T.Year = 2024
GROUP BY T.Month;
