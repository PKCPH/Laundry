USE MASTER
GO
IF DB_ID('LaundryOnline') IS NOT NULL
	BEGIN
		ALTER DATABASE LaundryOnline SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE LaundryOnline
	END
GO
CREATE DATABASE LaundryOnline
GO
USE LaundryOnline
GO

--Vaskerier skal have navn og ?bningstider (?ben / luk) (brug Time som datatype)
CREATE TABLE LaundryHalls(
LaundryHallsID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
HallName NVARCHAR(500),
OpeningTime TIME,
ClosingTime TIME
);

-- Brugere skal have navn, e-mail (skal v?re unik), password (skal v?re l?ngere end 5 karakterer), konto (decimal), et vaskeri samt dato for oprettelse.
CREATE TABLE LaundryUsers(
UserId INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
FullName NVARCHAR(500),
Email NVARCHAR(500) NOT NULL,
UserPassword NVARCHAR(500),
Balance DECIMAL,
LaundryHall INT,
DateCreated DATETIME

CONSTRAINT EmailUnique UNIQUE(Email)

CONSTRAINT FK_LaundryHallForUser FOREIGN KEY (LaundryHall) REFERENCES LaundryHalls(LaundryHallsID)
);

--Maskiner skal have navn, pris pr. vask (decimal), hvor mange minutter en vask tager og id p? vaskeri den st?r
CREATE TABLE LaundryMachines(
LaundryMachinesID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
MachineName NVARCHAR(500),
Price DECIMAL,
LaundryTimeInMinutes INT,
LaundryHall INT,

CONSTRAINT FK_LaundryHall FOREIGN KEY (LaundryHall) REFERENCES LaundryHalls(LaundryHallsID)
);

--Bookinger skal have en dato og tidspunkt (Datetime) for bestilling, id p? bruger der har booket og id p? maskinen der er booket tid p?
CREATE TABLE Bookings(
BookingsId INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
BookingDateTime DATETIME,
BookingUser INT,
BookingLaundryMachine INT,

CONSTRAINT FK_BookingUser FOREIGN KEY(BookingUser) REFERENCES LaundryUsers(UserId),

CONSTRAINT FK_BookingMachine FOREIGN KEY(BookingLaundryMachine) REFERENCES LaundryMachines(LaundryMachinesID)
);

INSERT INTO LaundryHalls(HallName,OpeningTime,ClosingTime) VALUES('Whitewash Inc.', '07:00:00.0000000', '20:00:00.0000000')
INSERT INTO LaundryHalls(HallName,OpeningTime,ClosingTime) VALUES('Double Bubble', '09:00:00.0000000', '20:00:00.0000000')
INSERT INTO LaundryHalls(HallName,OpeningTime,ClosingTime) VALUES('Wash & Coffee', '08:00:00.0000000', '21:00:00.0000000')

--SELECT * FROM LaundryHalls

INSERT INTO LaundryUsers(FullName, Email, UserPassword, Balance, LaundryHall, DateCreated) VALUES('John', 'john_doe66@gmail.com', 'password', 100.00, 2, 2021-02-15)
INSERT INTO LaundryUsers(FullName, Email, UserPassword, Balance, LaundryHall, DateCreated) VALUES('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69', 1000.00, 1, 2021-02-10)
INSERT INTO LaundryUsers(FullName, Email, UserPassword, Balance, LaundryHall, DateCreated) VALUES('Batman', 'noreply@thecave.com', 'Rob1n', 500.00, 3, 2020-03-10)
INSERT INTO LaundryUsers(FullName, Email, UserPassword, Balance, LaundryHall, DateCreated) VALUES('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecognized', 100000.00, 1, 2021-01-01)
INSERT INTO LaundryUsers(FullName, Email, UserPassword, Balance, LaundryHall, DateCreated) VALUES('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 0.50, 3, 2020-07-06)

--SELECT * FROM LaundryUsers


INSERT INTO LaundryMachines(MachineName,Price,LaundryTimeInMinutes,LaundryHall) VALUES('Mielle 911 Turbo', 5.00, 60, 2)
INSERT INTO LaundryMachines(MachineName,Price,LaundryTimeInMinutes,LaundryHall) VALUES('Siemons IClean', 10000.00, 30, 1)
INSERT INTO LaundryMachines(MachineName,Price,LaundryTimeInMinutes,LaundryHall) VALUES('Electrolax FX-2', 15.00, 45, 2)
INSERT INTO LaundryMachines(MachineName,Price,LaundryTimeInMinutes,LaundryHall) VALUES('NASA Spacewasher 8000', 500.00, 5, 1)
INSERT INTO LaundryMachines(MachineName,Price,LaundryTimeInMinutes,LaundryHall) VALUES('The Lost Sock', 3.50, 90, 3)
INSERT INTO LaundryMachines(MachineName,Price,LaundryTimeInMinutes,LaundryHall) VALUES('Yo Mama', 0.50, 120, 3)

--SELECT * FROM LaundryMachines

INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 12:00:00', 1, 1)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 16:00:00', 1, 3)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 08:00:00', 2, 4)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 15:00:00', 3, 5)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 20:00:00', 4, 2)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 19:00:00', 4, 2)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 10:00:00', 4, 2)
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2021-02-26 16:00:00', 5, 6)

--SELECT * FROM Bookings


--Opret en transaktion med en booking for brugeren ?Goldman Sachs? i dag kl. 12.00 p? ?Siemons IClean? maskinen. Gennemf?r transaktionen.
BEGIN TRANSACTION GoldmanSachsBooking;
INSERT INTO Bookings(BookingDateTime,BookingUser,BookingLaundryMachine) VALUES('2022-09-15', 4, 2)
COMMIT

--Opret et VIEW over bookinger
GO 
CREATE VIEW BookingsView AS
	SELECT Bookings.BookingDateTime, LaundryUsers.FullName 
	AS Username, LaundryMachines.MachineName, LaundryMachines.Price
	FROM Bookings
	JOIN LaundryUsers ON Bookings.BookingsId = LaundryUsers.UserId
	JOIN LaundryMachines ON Bookings.BookingsId = LaundryMachines.LaundryMachinesID
GO

SELECT * FROM BookingsView

--En SELECT der udv?lger brugere med ?@gmail.com? e-mails.
SELECT Email FROM LaundryUsers WHERE Email like '%@gmail.com'

--En SELECT der viser alle maskinerne og vaskeriets detaljer de st?r i.
SELECT * FROM LaundryMachines JOIN LaundryHalls ON LaundryMachines.LaundryHall = LaundryHalls.LaundryHallsID

--En SELECT der udv?lger hvor mange bookinger der er pr. maskine. Hint: Count + Group B
SELECT LaundryMachines.MachineName, 
COUNT(Bookings.BookingLaundryMachine) AS Bookings FROM LaundryMachines
JOIN Bookings ON Bookings.BookingLaundryMachine = LaundryMachines.LaundryMachinesID
GROUP BY LaundryMachines.MachineName

--En DELETE der sletter alle bookinger mellem kl. 12.00 - 13.00 Hint: Cast as Time + Between
DELETE FROM Bookings WHERE CAST(BookingDateTime AS TIME) BETWEEN '12:00:00' AND '14:00:00'

--En UPDATE der ?ndrer Batmans password til ?SelinaKyle?.
UPDATE LaundryUsers SET UserPassword = 'Selinakyle' WHERE UserId = 3;

SELECT * FROM LaundryUsers