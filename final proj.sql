CREATE DATABASE restaurant_reservations;
USE restaurant_reservations;
CREATE TABLE Customers (
    customerId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerName VARCHAR(45) NOT NULL,
    contactInfo VARCHAR(200),
    PRIMARY KEY (customerId)
);
CREATE TABLE Reservations (
    reservationId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    reservationTime DATETIME NOT NULL,
    numberOfGuests INT NOT NULL,
    specialRequests VARCHAR(200),
    PRIMARY KEY (reservationId),
    FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);
CREATE TABLE DiningPreferences (
    preferenceId INT NOT NULL UNIQUE AUTO_INCREMENT,
    customerId INT NOT NULL,
    favoriteTable VARCHAR(45),
    dietaryRestrictions VARCHAR(200),
    PRIMARY KEY (preferenceId),
    FOREIGN KEY (customerId) REFERENCES Customers(customerId)
);
DELIMITER $$
CREATE PROCEDURE findReservations(IN customerId INT)
BEGIN
    SELECT * FROM Reservations WHERE customerId = customerId;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE addSpecialRequest(IN reservationId INT, IN requests VARCHAR(200))
BEGIN
    UPDATE Reservations SET specialRequests = requests WHERE reservationId = reservationId;
END$$
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE addReservation(
    IN customerName VARCHAR(45), 
    IN contactInfo VARCHAR(200), 
    IN reservationTime DATETIME, 
    IN numberOfGuests INT, 
    IN specialRequests VARCHAR(200))
BEGIN
    DECLARE cid INT;
    SELECT customerId INTO cid FROM Customers WHERE customerName = customerName;

    IF cid IS NULL THEN
        INSERT INTO Customers (customerName, contactInfo) VALUES (customerName, contactInfo);
        SET cid = LAST_INSERT_ID();
    END IF;

    INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests)
    VALUES (cid, reservationTime, numberOfGuests, specialRequests);
END$$
DELIMITER ;
INSERT INTO Customers (customerName, contactInfo) VALUES 
('John Doe', 'john@example.com'), 
('Jane Smith', 'jane@example.com'), 
('Alice Brown', 'alice@example.com');
INSERT INTO Reservations (customerId, reservationTime, numberOfGuests, specialRequests) VALUES 
(1, '2024-12-10 19:00:00', 4, 'Window seat'),
(2, '2024-12-11 20:00:00', 2, 'No peanuts'),
(3, '2024-12-12 18:30:00', 3, 'Quiet corner');



