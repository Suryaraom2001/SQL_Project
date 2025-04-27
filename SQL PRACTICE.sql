
-- Create Database

CREATE DATABASE EventTicketingSystem;
USE EventTicketingSystem;

-- Creating Tables
-- Events Table
CREATE TABLE Events (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    EventName VARCHAR(100),
    EventDate DATE,
    Location VARCHAR(100),
    TotalTickets INT
);
desc events;
-- Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100)
);
desc customers;
-- Tickets Table
CREATE TABLE Tickets (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT,
    TicketType VARCHAR(50),
    Price DECIMAL(8,2),
    Status VARCHAR(20) DEFAULT 'Available',  -- Available, Sold, Reserved
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
); 
desc tickets;

-- Reservations Table
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TicketID INT,
    ReservationDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID)
); 
desc Reservations;

-- Sales Table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    TicketID INT,
    SaleDate DATE,
    Amount DECIMAL(8,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID)
);
desc sales;

-- =========================================================
-- Insert Sample Data
-- =========================================================

-- Insert into Events
INSERT INTO Events (EventName, EventDate, Location, TotalTickets) VALUES
('Music Concert', '2025-05-10', 'vellachery', 100),
('Cricket Match', '2025-06-15', 'Guindy', 50),
('Food Festival', '2025-05-22', 'Adyar', 200);
select * from events;

-- Insert into Customers
INSERT INTO Customers (CustomerName, Email) VALUES
('Korkai', 'korkaimaran@gmail.com'),
('Surya Rao', 'suryaraom@gmail.com'),
('Hari', 'harikrishnan@gmail.com');
select * from customers;

-- Insert into Tickets
INSERT INTO Tickets (EventID, TicketType, Price) VALUES
(1, 'VIP', 150.00),
(1, 'Regular', 80.00),
(2, 'Regular', 50.00),
(3, 'VIP', 200.00),
(3, 'Regular', 100.00);
select * from tickets;

-- Insert into Reservations
INSERT INTO Reservations (CustomerID, TicketID, ReservationDate) VALUES
(1, 1, '2025-04-01'),
(2, 3, '2025-04-03');
select * from reservations;

-- Insert into Sales
INSERT INTO Sales (CustomerID, TicketID, SaleDate, Amount) VALUES
(1, 2, '2025-04-05', 80.00),
(2, 4, '2025-04-10', 200.00),
(3, 5, '2025-04-12', 100.00);
select * from sales;

-- Update sold tickets' status
UPDATE Tickets
SET Status = 'Sold'
WHERE TicketID IN (2, 4, 5);
select * from tickets;

-- Update reserved tickets' status
UPDATE Tickets
SET Status = 'Reserved'
WHERE TicketID IN (1, 3);
select * from tickets;

-- =========================================================
-- Queries
-- =========================================================

-- 1. JOIN: List customer names and the events they reserved or bought tickets for
SELECT Customers.CustomerName, Events.EventName, Tickets.TicketType, Tickets.Price
FROM Customers
JOIN Reservations ON Customers.CustomerID = Reservations.CustomerID
JOIN Tickets ON Reservations.TicketID = Tickets.TicketID
JOIN Events ON Tickets.EventID = Events.EventID

UNION ALL

SELECT Customers.CustomerName, Events.EventName, Tickets.TicketType, Tickets.Price
FROM Customers
JOIN Sales ON Customers.CustomerID = Sales.CustomerID
JOIN Tickets ON Sales.TicketID = Tickets.TicketID
JOIN Events ON Tickets.EventID = Events.EventID;

-- 2. SUBQUERY: Find customers who bought VIP tickets
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales
    WHERE TicketID IN (
        SELECT TicketID
        FROM Tickets
        WHERE TicketType = 'VIP'
    )
);

-- 3. VIEW: Create a view to see all ticket sales with event names
CREATE VIEW TicketSalesView AS
SELECT Sales.SaleID, Customers.CustomerName, Events.EventName, Tickets.TicketType, Sales.Amount, Sales.SaleDate
FROM Sales
JOIN Customers ON Sales.CustomerID = Customers.CustomerID
JOIN Tickets ON Sales.TicketID = Tickets.TicketID
JOIN Events ON Tickets.EventID = Events.EventID;

-- 4. Using the VIEW: Display all ticket sales
SELECT * FROM TicketSalesView;

-- 5. STORED PROCEDURE: Count number of tickets sold for an event
DELIMITER //
CREATE PROCEDURE GetSoldTicketCount(IN inputEventID INT)
BEGIN
    SELECT COUNT(*) AS SoldTickets
    FROM Tickets
    WHERE EventID = inputEventID AND Status = 'Sold';
END //
DELIMITER ;

-- Execute Stored Procedure Example
CALL GetSoldTicketCount(1);
