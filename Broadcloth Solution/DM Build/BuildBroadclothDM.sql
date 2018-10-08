IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'Broadcloth')
	CREATE DATABASE Broadcloth
GO  

USE Broadcloth
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
	WHERE NAME = N'DimDate'
	)
	DROP TABLE DimDate;

	IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimFactory'
	)
	DROP TABLE DimFactory;
-- 
-- 
CREATE TABLE DimDate
	(
	Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	Year				INT,-- Year value of Date stored in Row
	Month				INT, -- Number of the Month 1 to 12{}
	Quarter				NCHAR(2),
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);
--

CREATE TABLE DimFactory
	(
	Factory_SK			INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Factory_AK			INT NOT NULL,
	Nation				NVARCHAR(50) NOT NULL,
	City				NVARCHAR(50) NOT NULL,
	OverallRating		NUMERIC(18,0),
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
	ModelDescription		NVARCHAR(50) NOT NULL,
	Color				NVARCHAR(50) NOT NULL,
	Size				NUMERIC(18,0) NOT NULL,

	);

--
CREATE TABLE FactProduction
	(
Product_SK		INT NOT NULL,
Customer_SK		INT NOT NULL,
Factory_SK		INT NOT NULL,
StartDateTime	INT NOT NULL,
ActualEndTime	INT NOT NULL,
QuantityShipped INT,
QualityRating	NUMERIC(18,0),
ProductionCost	NUMERIC(12,4),

	CONSTRAINT pk_fact_production PRIMARY KEY (Product_SK,Customer_SK, Factory_SK,StartDateTime),
	CONSTRAINT fk_start_dim_date FOREIGN KEY (StartDateTime) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_end_dim_date FOREIGN KEY (ActualEndTime) REFERENCES DimDate(Date_SK),
	CONSTRAINT fk_dim_customer FOREIGN KEY (Customer_SK) REFERENCES DimCustomer(Customer_SK),
	CONSTRAINT fk_dim_product FOREIGN KEY (Product_SK) REFERENCES DimProduct(Product_SK),
	CONSTRAINT fk_dim_factory FOREIGN KEY (Factory_SK) REFERENCES DimFactory(Factory_SK)
	);
