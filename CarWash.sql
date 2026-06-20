CREATE DATABASE CarWashDB;
GO

USE CarWashDB;
GO

--------------------------------------------------
-- 1. TIER
--------------------------------------------------
CREATE TABLE Tier (
    tierId INT NOT NULL PRIMARY KEY,

    tierName VARCHAR(50) NOT NULL UNIQUE,

    minPoints INT NOT NULL,

    bookingPriorityDays INT NOT NULL,

    bonusRate INT NOT NULL,

    status BIT NOT NULL DEFAULT 1
);
GO

--------------------------------------------------
-- 2. CUSTOMERS
--------------------------------------------------
CREATE TABLE Customers (
    cusId INT IDENTITY(1,1) PRIMARY KEY,

    fullname NVARCHAR(100) NOT NULL,

    gender NVARCHAR(25) NOT NULL,

    dateOfBirth DATE NOT NULL,

    phone VARCHAR(15) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    password VARCHAR(255) NOT NULL,

    tierId INT NOT NULL,

    points INT NOT NULL DEFAULT 0,

    totalPoints INT NOT NULL DEFAULT 0,

    lastpointearned  DATETIME,

    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    status BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Customers_Tier
        FOREIGN KEY (tierId)
        REFERENCES Tier(tierId)
);
GO

--------------------------------------------------
-- 3. CARS
--------------------------------------------------
CREATE TABLE Cars (
    id INT IDENTITY(1,1) PRIMARY KEY,

    cusid INT NOT NULL,

    licensePlate VARCHAR(20) NOT NULL UNIQUE,

    type NVARCHAR(100) NOT NULL,

    brand NVARCHAR(100) NOT NULL,

    model NVARCHAR(100) NOT NULL,

    color NVARCHAR(50) NOT NULL,

    createdDate DATETIME NOT NULL DEFAULT GETDATE(),

    status BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_Cars_Customers
        FOREIGN KEY (cusid)
        REFERENCES Customers(cusId)
);
GO

--------------------------------------------------
-- 4. SERVICES
--------------------------------------------------
CREATE TABLE Services (
    serviceId INT IDENTITY(1,1) PRIMARY KEY,

    serviceName NVARCHAR(100) NOT NULL,

    description NVARCHAR(255) NOT NULL,

    price DECIMAL(12,2) NOT NULL,

    durationMinutes INT NOT NULL,

    status BIT NOT NULL DEFAULT 1
);
GO

--------------------------------------------------
-- 5. BOOKINGS
--------------------------------------------------
CREATE TABLE Bookings (
    bookingId INT IDENTITY(1,1) PRIMARY KEY,

    cusId INT NOT NULL,

    carId INT NOT NULL,

    serviceId INT NOT NULL,

    bookingDate DATETIME NOT NULL,

    totalAmount DECIMAL(12,2) NOT NULL,

    bookingStatus VARCHAR(50) NOT NULL DEFAULT 'Pending',

    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Bookings_Customers
        FOREIGN KEY (cusId)
        REFERENCES Customers(cusId),

    CONSTRAINT FK_Bookings_Cars
        FOREIGN KEY (carId)
        REFERENCES Cars(id),

    CONSTRAINT FK_Bookings_Services
        FOREIGN KEY (serviceId)
        REFERENCES Services(serviceId)
);
GO

--------------------------------------------------
-- 6. REWARD TRANSACTIONS
--------------------------------------------------
CREATE TABLE RewardTransactions (
    transactionId INT IDENTITY(1,1) PRIMARY KEY,

    cusId INT NOT NULL,

    points INT NOT NULL,

    transactionType VARCHAR(30) NOT NULL,

    description NVARCHAR(255) NOT NULL,

    createdAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_RewardTransactions_Customers
        FOREIGN KEY (cusId)
        REFERENCES Customers(cusId)
);
GO



--------------------------------------------------
-- 7. PAYMENTS
--------------------------------------------------
CREATE TABLE Payments (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,

    bookingId INT NOT NULL,

    amount DECIMAL(12,2) NOT NULL,

    paymentMethod VARCHAR(50) NOT NULL,

    paymentDate DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Payments_Bookings
        FOREIGN KEY (bookingId)
        REFERENCES Bookings(bookingId)
);
GO

--------------------------------------------------
-- INSERT TIER
--------------------------------------------------
INSERT INTO Tier
(
    tierName,
    tierId,
    minPoints,
    bookingPriorityDays,
    bonusRate,
    status
)
VALUES
('Member',1,0,7,0,1),
('Silver',2,2000,10,10,1),
('Gold',3,6000,12,20,1),
('Platinum',4,15000,14,30,1);
GO

--------------------------------------------------
-- INSERT CUSTOMERS
--------------------------------------------------
INSERT INTO Customers
(
    fullname,
    gender,
    dateOfBirth,
    phone,
    email,
    password,
    tierId,
    points,
    totalPoints,
    lastpointearned,
    status
)
VALUES
(
    N'Nguyen Van A',
    'Male',
    '2000-05-10',
    '0901111111',
    'vana@gmail.com',
    '123456',
    2,
    120,
    2100,
    '2000-05-11',
    1
),
(
    N'Tran Thi B',
    'Female',
    '1999-08-20',
    '0902222222',
    'tranb@gmail.com',
    '123456',
    3,
    450,
    6450,
    '2000-05-11',
    1
),
(
    N'Le Van C',
    'Male',
    '2001-11-15',
    '0903333333',
    'levanc@gmail.com',
    '123456',
    1,
    20,
    2020,
    '2001-11-16',
    1
),
(
    N'ADMIN',
    'Male',
    '2001-11-15',
    '0999999999',
    'admin@admin.com',
    '123456',
    1,
    0,
    0,
    '2001-11-16',
    1
);
GO

--------------------------------------------------
-- INSERT CARS
--------------------------------------------------
INSERT INTO Cars
(
    cusid,
    licensePlate,
    [type],
    brand,
    model,
    color
)
VALUES
(
    1,
    '51A-12345',
    N'Sedan',
    N'Toyota',
    N'Vios',
    N'Trang'
),
(
    1,
    '51H-67890',
    N'Sedan',
    N'Hyundai',
    N'Accent',
    N'Den'
),
(
    2,
    '50F-99999',
    N'Sedan',
    N'Kia',
    N'Seltos',
    N'Do'
);
GO

--------------------------------------------------
-- INSERT SERVICES
--------------------------------------------------
INSERT INTO Services
(
    serviceName,
    description,
    price,
    durationMinutes
)
VALUES
(
    N'Basic Wash',
    N'Exterior Wash',
    100000,
    20
),
(
    N'Premium Wash',
    N'Exterior + Interior',
    250000,
    45
),
(
    N'Wax Coating',
    N'Wax Protection',
    300000,
    30
);
GO

