create database healthgalaxy;
use healthgalaxy;

-- Dimension Tables

CREATE TABLE DIM_PATIENTS (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE DIM_PROVIDERS (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    specialty VARCHAR(50)
);

CREATE TABLE DIM_HOSPITALS (
    hospital_id INT PRIMARY KEY,
    hospital_name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE DIM_TIME (
    time_id INT PRIMARY KEY,
    date DATE,
    month INT,
    year INT,
    quarter INT
);

-- Fact Tables

CREATE TABLE FACT_VISITS (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    hospital_id INT,
    time_id INT,
    diagnosis VARCHAR(200),
    proc VARCHAR(100),
    FOREIGN KEY (patient_id) REFERENCES DIM_PATIENTS(patient_id),
    FOREIGN KEY (provider_id) REFERENCES DIM_PROVIDERS(provider_id),
    FOREIGN KEY (hospital_id) REFERENCES DIM_HOSPITALS(hospital_id),
    FOREIGN KEY (time_id) REFERENCES DIM_TIME(time_id)
);

CREATE TABLE FACT_BILLING (
    billing_id INT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    hospital_id INT,
    time_id INT,
    charge DECIMAL(10, 2),
    payment DECIMAL(10, 2),
    insurance_claim DECIMAL(10, 2),
    FOREIGN KEY (patient_id) REFERENCES DIM_PATIENTS(patient_id),
    FOREIGN KEY (provider_id) REFERENCES DIM_PROVIDERS(provider_id),
    FOREIGN KEY (hospital_id) REFERENCES DIM_HOSPITALS(hospital_id),
    FOREIGN KEY (time_id) REFERENCES DIM_TIME(time_id)
);
-- Inserting data into Dimension Tables

INSERT INTO DIM_PATIENTS VALUES (1, 'John', 'Doe', 45, 'Male');
INSERT INTO DIM_PATIENTS VALUES (2, 'Jane', 'Smith', 34, 'Female');

INSERT INTO DIM_PROVIDERS VALUES (1, 'Dr. Adam', 'Cardiologist');
INSERT INTO DIM_PROVIDERS VALUES (2, 'Dr. Lucy', 'Pediatrician');

INSERT INTO DIM_HOSPITALS VALUES (1, 'City General Hospital', 'New York');
INSERT INTO DIM_HOSPITALS VALUES (2, 'Green Valley Hospital', 'California');

INSERT INTO DIM_TIME VALUES (1, '2024-05-01', 5, 2024, 2);
INSERT INTO DIM_TIME VALUES (2, '2024-05-02', 5, 2024, 2);

-- Inserting data into Fact Tables

INSERT INTO FACT_VISITS VALUES (1, 1, 1, 1, 1, 'Heart Attack', 'Angioplasty');
INSERT INTO FACT_VISITS VALUES (2, 2, 2, 2, 2, 'Fever', 'Vaccination');

INSERT INTO FACT_BILLING VALUES (1, 1, 1, 1, 1, 1500.00, 1000.00, 500.00);
INSERT INTO FACT_BILLING VALUES (2, 2, 2, 2, 2, 250.00, 200.00, 50.00);
SELECT p.first_name, p.last_name, SUM(b.charge) AS total_billing
FROM FACT_BILLING b
JOIN DIM_PATIENTS p ON b.patient_id = p.patient_id
GROUP BY p.patient_id;
SELECT pr.provider_name, COUNT(v.visit_id) AS total_visits
FROM FACT_VISITS v
JOIN DIM_PROVIDERS pr ON v.provider_id = pr.provider_id
GROUP BY pr.provider_name;
