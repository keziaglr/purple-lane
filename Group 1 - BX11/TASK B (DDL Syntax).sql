CREATE DATABASE PurpleLane_Database
USE PurpleLane_Database

CREATE TABLE MsStaff (
	StaffID CHAR(5) PRIMARY KEY CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'), 
	StaffName VARCHAR(75) NOT NULL CHECK(LEN(StaffName) >= 5), 
	StaffGender VARCHAR(6) NOT NULL CHECK(StaffGender = 'Male' OR StaffGender = 'Female'), 
	StaffEmail VARCHAR(75) NOT NULL CHECK(StaffEmail LIKE '%@purplelane.com'), 
	StaffPhoneNumber VARCHAR(15) NOT NULL, 
	StaffAddress VARCHAR(100) NOT NULL, 
	StaffSalary INT NOT NULL CHECK(StaffSalary BETWEEN 1000000 AND 25000000)
)

CREATE TABLE MsProductCategory(
	ProductCategoryID CHAR(5) PRIMARY KEY CHECK(ProductCategoryID LIKE 'PC[0-9][0-9][0-9]'),
	ProductCategoryName VARCHAR(15) NOT NULL
)

CREATE TABLE MsProduct(
	ProductID CHAR(5) PRIMARY KEY CHECK(ProductID LIKE 'PR[0-9][0-9][0-9]'),
	ProductCategoryID CHAR(5) NOT  NULL REFERENCES MsProductCategory(ProductCategoryID)  ON UPDATE CASCADE ON DELETE CASCADE,
	ProductName VARCHAR(75) NOT NULL,  
	ProductStock INT NOT NULL, 
	PurchasePrice INT NOT NULL, 
	SalesPrice INT NOT NULL
)

CREATE TABLE MsCustomer(
	CustomerID CHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(75) NOT NULL CHECK(LEN(CustomerName) >= 5),
	CustomerPhoneNumber VARCHAR(15) NOT NULL,
	CustomerAddress VARCHAR(100) NOT NULL,
	CustomerGender VARCHAR(6) NOT NULL CHECK(CustomerGender = 'Male' OR CustomerGender = 'Female'),
	CustomerEmail VARCHAR(75) NOT NULL CHECK(CustomerEmail LIKE '%@%')
)

CREATE TABLE MsSupplier(
	SupplierID CHAR(5) PRIMARY KEY CHECK(SupplierID LIKE 'SU[0-9][0-9][0-9]'),
	SupplierName VARCHAR(75) NOT NULL,
	SupplierAddress VARCHAR(100) NOT NULL,
)

CREATE TABLE HeaderPurchaseTransaction(
	PurchaseID CHAR(5) PRIMARY KEY CHECK(PurchaseID LIKE 'PA[0-9][0-9][0-9]'), 		
	StaffID CHAR(5) NOT NULL REFERENCES MsStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE, 
	SupplierID CHAR(5) NOT NULL REFERENCES MsSupplier(SupplierID) ON UPDATE CASCADE ON DELETE CASCADE, 
	TransactionDate DATE NOT NULL, 
)

CREATE TABLE PurchaseTransactionDetail(
	PurchaseID CHAR(5) NOT NULL REFERENCES HeaderPurchaseTransaction(PurchaseID) ON UPDATE CASCADE ON DELETE CASCADE,
	ProductID CHAR(5) NOT NULL REFERENCES MsProduct(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
	Quantity INT NOT NULL,
	PRIMARY KEY (PurchaseID, ProductID),
)

CREATE TABLE HeaderSalesTransaction(
	SalesID CHAR(5) PRIMARY KEY CHECK(SalesID LIKE 'SA[0-9][0-9][0-9]'),
	StaffID CHAR(5) NOT NULL REFERENCES MsStaff(StaffID)  ON UPDATE CASCADE ON DELETE CASCADE,
	CustomerID CHAR(5) NOT NULL REFERENCES MsCustomer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE, 
	TransactionDate DATE NOT NULL, 
)

CREATE TABLE SalesTransactionDetail(
	SalesID CHAR(5) NOT NULL REFERENCES HeaderSalesTransaction(SalesID) ON UPDATE CASCADE ON DELETE CASCADE,
	ProductID CHAR(5) NOT NULL REFERENCES MsProduct(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
	Quantity INT NOT NULL,
	PRIMARY KEY (SalesID, ProductID),
)