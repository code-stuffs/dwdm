create database bookgalaxy;
use bookgalaxy;

CREATE TABLE Fact_Book_Sales (
    fact_id INT PRIMARY KEY,
    book_type_id INT,
    location_id INT,
    author_id INT,
    publication_id INT,
    quantity INT,
    profit DECIMAL(10, 2),
    FOREIGN KEY (book_type_id) REFERENCES Dim_Book_Type(book_type_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id),
    FOREIGN KEY (author_id) REFERENCES Dim_Author(author_id),
    FOREIGN KEY (publication_id) REFERENCES Dim_Publication(publication_id)
);

CREATE TABLE Fact_Author_Performance (
    fact_id INT PRIMARY KEY,
    author_id INT,
    book_type_id INT,
    location_id INT,
    profit DECIMAL(10, 2),
    quantity INT,
    FOREIGN KEY (author_id) REFERENCES Dim_Author(author_id),
    FOREIGN KEY (book_type_id) REFERENCES Dim_Book_Type(book_type_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);
CREATE TABLE Dim_Book_Type (
    book_type_id INT PRIMARY KEY,
    book_type_name VARCHAR(100)
);

CREATE TABLE Dim_Location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE Dim_Author (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100),
    age INT,
    country VARCHAR(100)
);

CREATE TABLE Dim_Publication (
    publication_id INT PRIMARY KEY,
    publication_name VARCHAR(100),
    publication_country VARCHAR(100),
    publication_year INT
);
-- Insert data into Dim_Book_Type
INSERT INTO Dim_Book_Type (book_type_id, book_type_name) VALUES 
(1, 'Fiction'),
(2, 'Non-Fiction'),
(3, 'Science'),
(4, 'Biography');

-- Insert data into Dim_Location
INSERT INTO Dim_Location (location_id, location_name, country) VALUES 
(1, 'New York', 'USA'),
(2, 'London', 'UK'),
(3, 'Berlin', 'Germany');

-- Insert data into Dim_Author
INSERT INTO Dim_Author (author_id, author_name, age, country) VALUES 
(1, 'J.K. Rowling', 55, 'UK'),
(2, 'Stephen Hawking', 76, 'UK'),
(3, 'Isaac Newton', 84, 'UK');

-- Insert data into Dim_Publication
INSERT INTO Dim_Publication (publication_id, publication_name, publication_country, publication_year) VALUES 
(1, 'Bloomsbury', 'UK', 1997),
(2, 'Cambridge University Press', 'UK', 1988),
(3, 'Macmillan', 'UK', 1687);

-- Insert data into Fact_Book_Sales
INSERT INTO Fact_Book_Sales (fact_id, book_type_id, location_id, author_id, publication_id, quantity, profit) VALUES 
(1, 1, 1, 1, 1, 100, 1500.00),
(2, 2, 2, 2, 2, 50, 5000.00),
(3, 3, 3, 3, 3, 200, 8000.00);

-- Insert data into Fact_Author_Performance
INSERT INTO Fact_Author_Performance (fact_id, author_id, book_type_id, location_id, profit, quantity) VALUES 
(1, 1, 1, 1, 1500.00, 100),
(2, 2, 2, 2, 5000.00, 50),
(3, 3, 3, 3, 8000.00, 200);
SELECT 
    bt.book_type_name,
    SUM(bs.quantity) AS total_quantity,
    SUM(bs.profit) AS total_profit
FROM 
    Fact_Book_Sales bs
JOIN 
    Dim_Book_Type bt ON bs.book_type_id = bt.book_type_id
GROUP BY 
    bt.book_type_name;
SELECT 
    loc.location_name,
    SUM(bs.quantity) AS total_quantity,
    SUM(bs.profit) AS total_profit
FROM 
    Fact_Book_Sales bs
JOIN 
    Dim_Location loc ON bs.location_id = loc.location_id
GROUP BY 
    loc.location_name;
SELECT 
    auth.author_name,
    SUM(fap.quantity) AS total_quantity,
    SUM(fap.profit) AS total_profit
FROM 
    Fact_Author_Performance fap
JOIN 
    Dim_Author auth ON fap.author_id = auth.author_id
GROUP BY 
    auth.author_name;
SELECT 
    pub.publication_name,
    SUM(bs.quantity) AS total_quantity,
    SUM(bs.profit) AS total_profit
FROM 
    Fact_Book_Sales bs
JOIN 
    Dim_Publication pub ON bs.publication_id = pub.publication_id
GROUP BY 
    pub.publication_name;
