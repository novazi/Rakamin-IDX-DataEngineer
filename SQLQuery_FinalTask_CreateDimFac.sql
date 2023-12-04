CREATE DATABASE DWH_Project;

USE DWH_Project;

CREATE TABLE DimCustomer (
	CustomerID INT NOT NULL,
	CustomerName VARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	NoHp VARCHAR(50) NOT NULL,
	CONSTRAINT PKCustomerID PRIMARY KEY (CustomerID)
);

CREATE TABLE DimProduct (
	ProductID INT NOT NULL,
	ProductName VARCHAR(255) NOT NULL,
	ProductCategory VARCHAR(255) NOT NULL,
	ProductUnitPrice INT NOT NULL,
	CONSTRAINT PKProductID PRIMARY KEY (ProductID)
);

CREATE TABLE DimStatusOrder (
	StatusID INT NOT NULL,
	StatusOrder VARCHAR(50) NOT NULL,
	StatusOrderDesc VARCHAR(50) NOT NULL,
	CONSTRAINT PKStatusID PRIMARY KEY (StatusID)
);

CREATE TABLE FactSalesOrder (
	OrderID INT NOT NULL,
	CustomerID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL,
	Amount INT NOT NULL,
	StatusID INT NOT NULL,
	OrderDate DATE NOT NULL,
	CONSTRAINT PKOrderID PRIMARY KEY (OrderID),
	CONSTRAINT FKCustomerID FOREIGN KEY (CustomerID) REFERENCES DimCustomer (CustomerID),
	CONSTRAINT FKProductID FOREIGN KEY (ProductID) REFERENCES DimProduct (ProductID),
	CONSTRAINT FKStatusID FOREIGN KEY (StatusID) REFERENCES DimStatusOrder (StatusID)
);


SELECT * FROM DimCustomer;
SELECT * FROM DimProduct;
SELECT * FROM DimStatusOrder;
SELECT * FROM FactSalesOrder;

CREATE PROCEDURE summary_order_status @StatusID INT AS
BEGIN
	SELECT 
		fo.OrderID,
		dc.CustomerName,
		dp.ProductName,
		fo.Quantity,
		ds.StatusOrder
	FROM
		FactSalesOrder AS fo
	JOIN 
		DimCustomer AS dc
			ON fo.CustomerID = dc.CustomerID
	JOIN 
		DimProduct AS dp
			ON fo.ProductID = dp.ProductID
	JOIN 
		DimStatusOrder AS ds
			ON fo.StatusID = ds.StatusID
	WHERE fo.StatusID = @StatusID
END;

EXEC summary_order_status @StatusID = 4;

DROP PROCEDURE summary_order_status;