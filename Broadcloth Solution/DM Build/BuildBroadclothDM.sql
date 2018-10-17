--BroadclothDM is....

--BroadclothDM written and developed by Alexandra Ricker, Brooke Quinn, Marion Bania
-- Originally Written: October 2018
-----------------------------------------------------------



--Drop existing tables

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'BroadclothDM')
	CREATE DATABASE BroadclothDM
GO  

USE BroadclothDM
GO
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'FactProduction'
	)
	DROP TABLE FactProduction;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimProduct'
	)
	DROP TABLE DimProduct;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimCustomer'
	)
	DROP TABLE DimCustomer;

--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimFactory'
	)
	DROP TABLE DimFactory;
-- 
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDate'
	)
	DROP TABLE DimDate;
-- 
CREATE TABLE DimDate
	(
	Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);


--Create tables

CREATE TABLE DimFactory
	(
	Factory_SK			INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Factory_AK			INT NOT NULL,
	Nation				NVARCHAR(50) NOT NULL,
	City				NVARCHAR(50) NOT NULL,
	OverallRating		NVARCHAR(4) NOT NULL,
	MaxWorkers			INT NOT NULL,

	);

--
CREATE TABLE DimCustomer
	(
	Customer_SK			INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Customer_AK			INT NOT NULL,
	CompanyName			NVARCHAR(50) NOT NULL,
	DeliveryNation		NVARCHAR(50) NOT NULL,
	DeliveryState		NVARCHAR(20) NOT NULL,
	DeliveryCity		NVARCHAR(20) NOT NULL,
	);
--
CREATE TABLE DimProduct
	(
	Product_SK			INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Product_AK			INT NOT NULL,
	ModelDescription	NVARCHAR(50) NOT NULL,
	Color				NVARCHAR(50) NOT NULL,
	Size				NUMERIC(18,0) NOT NULL,

	);

--
CREATE TABLE FactProduction
	(
Product_SK			INT NOT NULL,
Customer_SK			INT NOT NULL,
Factory_SK			INT NOT NULL,
StartDateTime		INT NOT NULL,
ActualEndTime		INT NOT NULL,
QuantityShipped		INT,
QualityRating		NUMERIC(18,0),
ProductionCost		NUMERIC(12,4),

	CONSTRAINT pk_fact_production PRIMARY KEY (Product_SK,Customer_SK, Factory_SK,StartDateTime),
	CONSTRAINT fk_start_dim_date FOREIGN KEY (StartDateTime) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_end_dim_date FOREIGN KEY (ActualEndTime) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_dim_customer FOREIGN KEY (Customer_SK) REFERENCES DimCustomer(Customer_SK),
	CONSTRAINT fk_dim_product FOREIGN KEY (Product_SK) REFERENCES DimProduct(Product_SK),
	CONSTRAINT fk_dim_factory FOREIGN KEY (Factory_SK) REFERENCES DimFactory(Factory_SK),
	);
