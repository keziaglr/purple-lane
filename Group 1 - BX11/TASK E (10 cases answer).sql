USE PurpleLane_Database
--1
SELECT 
	ProductName, 
	[Total Product Sold] = CAST(SUM(Quantity) AS varchar) + ' product(s)'
FROM 
	MsProduct mp JOIN MsProductCategory mpc ON mp.ProductCategoryID = mpc.ProductCategoryID 
	JOIN SalesTransactionDetail std ON std.ProductID = mp.ProductID
WHERE 
	SalesPrice > 150000 AND 
	ProductCategoryName IN ('chair', 'stool')
GROUP BY 
	ProductName

--2
SELECT 
	StaffName,  
	[Total Product Sold Before November] = SUM(Quantity)
FROM MsStaff mst JOIN HeaderSalesTransaction hst ON mst.StaffID = hst.StaffID 
	JOIN SalesTransactionDetail std ON	 std.SalesID = hst.SalesID
WHERE  
	MONTH(TransactionDate) < 11
GROUP BY 
	StaffName
HAVING 
	SUM(Quantity) > 10

--3
SELECT 
	CustomerName, 
	[Total Sales Transactions] = COUNT(DISTINCT hst.SalesID), 
	[Total Price of Product Sold] = SUM(Quantity * SalesPrice)
FROM 
	MsCustomer mc JOIN HeaderSalesTransaction hst ON mc.CustomerID = hst.CustomerID 
	JOIN SalesTransactionDetail std ON std.SalesID = hst.SalesID 
	JOIN MsProduct mp ON mp.ProductID = std.ProductID
WHERE 
	(LEN(CustomerName) - LEN(REPLACE(CustomerName,' ','')) < 3)
GROUP BY 
	CustomerName
HAVING 
	COUNT(DISTINCT hst.SalesID) > 1

--4
SELECT 
	SupplierName, 
	[Total Purchase Transactions] = COUNT(DISTINCT hpt.PurchaseID), 
	[Total Price of Product Purchased] = SUM(Quantity * PurchasePrice)
FROM 
	MsSupplier msp JOIN HeaderPurchaseTransaction hpt ON hpt.SupplierID = msp.SupplierID 
	JOIN PurchaseTransactionDetail ptd ON hpt.PurchaseID = ptd.PurchaseID 
	JOIN MsProduct mp ON mp.ProductID = ptd.ProductID
WHERE 
	LEN(SupplierName) > 10
GROUP BY 
	SupplierName
HAVING 
	SUM(Quantity * PurchasePrice) > 5000000


--5
SELECT 
	ProductCategoryName, 
	[Total Products Sold] = CAST(A.[Total Products Sold] AS varchar) + ' product(s)'
FROM MsProductCategory mfc,
(
	SELECT 
		ProductCategoryID, 
		[Total Products Sold] = SUM(Quantity)
	FROM 
		SalesTransactionDetail std JOIN MsProduct mp ON std.ProductID = mp.ProductID
	WHERE
		ProductName NOT LIKE '%g%'
	GROUP BY 
		ProductCategoryID
) AS A,
(
	SELECT 
		[Maximum Quantity] = MAX(Quantity)
	FROM 
		SalesTransactionDetail
) as B
WHERE 
	A.ProductCategoryID = mfc.ProductCategoryID AND 
	A.[Total Products Sold] > B.[Maximum Quantity]

--6
SELECT 
	DISTINCT CustomerName
FROM 
	MsCustomer mc, 
	HeaderSalesTransaction hst, 
	MsStaff mst ,
(
	SELECT 
		[Average Staff's Salary] = AVG(StaffSalary)
	FROM 
		HeaderSalesTransaction hst JOIN MsStaff mst ON mst.StaffID = hst.StaffID
) as A
WHERE 
	mc.CustomerID = hst.CustomerID AND 
	mst.StaffID = hst.StaffID AND 
	StaffSalary > A.[Average Staff's Salary] AND
	DATEDIFF(MONTH, GETDATE(), TransactionDate) < 15

--7
SELECT 
	StaffName, 
	[Gender] = LEFT(StaffGender,1),
	[Total Product Purchased] = A.[Total Product Purchased]
FROM MsStaff mst,
(
	SELECT 
		StaffID, 
		[Total Product Purchased] = SUM(Quantity)
	FROM 
		HeaderPurchaseTransaction hpt JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseID = hpt.PurchaseID
	GROUP BY 
		StaffID
) AS A,
(
	SELECT 
		[Average of Total Quantity] = AVG(Quantity)
	FROM 
		HeaderPurchaseTransaction hpt JOIN PurchaseTransactionDetail ptd ON ptd.PurchaseID = hpt.PurchaseID
	WHERE 
		YEAR(TransactionDate) = 2020
) AS B
WHERE 
	mst.StaffID = a.StaffID AND 
	A.[Total Product Purchased] > B.[Average of Total Quantity]

--8.
SELECT 
	CustomerName, 
	CustomerEmail, 
	[Phone Number] = STUFF(CustomerPhoneNumber,CHARINDEX('0',CustomerPhoneNumber),1, '+62'), 
	[Total Product Sold] = CAST(A.[Total Product Sold] AS varchar) + ' product(s)'
FROM MsCustomer mc, 
(
	SELECT 
		CustomerID, 
		[Total Product Sold] = SUM(std.Quantity)
	FROM HeaderSalesTransaction hst JOIN SalesTransactionDetail std ON hst.SalesID = std.SalesID
	GROUP BY 
		CustomerID
) AS A,
(
	SELECT 
		[average of quantity] = AVG(Quantity)
	FROM 
		SalesTransactionDetail
) AS B
WHERE 
	mc.CustomerID = A.CustomerID AND 
	CustomerName LIKE '%j%' AND 
	A.[Total Product Sold] > B.[average of quantity]

--9.
CREATE VIEW Q4LargeSupplierTransactionsData AS
SELECT 
	SupplierName, 
	SupplierAddress, 
	[Total Price of Product Purchased] = SUM(ptd.Quantity * mp.PurchasePrice), 
	[Maximum Product Purchased] = MAX(ptd.Quantity)
FROM 
	MsSupplier ms, HeaderPurchaseTransaction hpt, PurchaseTransactionDetail ptd, MsProduct mp
WHERE 
	ms.SupplierID = hpt.SupplierID AND 
	hpt.PurchaseID = ptd.PurchaseID AND 
	mp.ProductID = ptd.ProductID AND 
	MONTH(hpt.TransactionDate) > 9
GROUP BY 
	SupplierName, 
	SupplierAddress
HAVING 
	MAX(ptd.Quantity) > 15

--10.
CREATE VIEW CustomerTransactionData AS
SELECT 
	CustomerName, 
	[Total Product Sold] = SUM(std.Quantity), 
	[Max Product Sold In a Transaction] = MAX(std.Quantity)
FROM 
	MsCustomer mc, 
	HeaderSalesTransaction hst, 
	SalesTransactionDetail std
WHERE 
	mc.CustomerID = hst.CustomerID AND 
	hst.SalesID = std.SalesID AND 
	mc.CustomerName LIKE '% %' 
GROUP BY 
	CustomerName
HAVING 
	MAX(std.Quantity) > 1
