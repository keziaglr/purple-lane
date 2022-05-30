use PurpleLane_Database

--Ada tambahan transaksi purchase baru
INSERT INTO HeaderPurchaseTransaction VALUES
('PA022','ST001','SU003','2021-06-12'),
('PA023','ST002','SU004','2021-04-24');

INSERT INTO PurchaseTransactionDetail VALUES
('PA022', 'PR021',18),
('PA022', 'PR022',21),
('PA023', 'PR022',21);

--Menghapus transaksi purchase yang ada (batal beli ke supplier)
DELETE FROM HeaderPurchaseTransaction
WHERE PurchaseID = 'PA023'

--Mengupdate Detail transaksi (misal salah input jumlah)
UPDATE PurchaseTransactionDetail
SET Quantity = 20
WHERE ProductID = 'PR021' AND PurchaseID = 'PA022'

--Mengupdate total barang yang dipurchase ke masterstock
UPDATE MsProduct
SET ProductStock+=21
WHERE ProductID='PR022';
UPDATE MsProduct
SET ProductStock+=20
WHERE ProductID='PR021';


--Ada tambahan transaksi penjualan
INSERT INTO HeaderSalesTransaction VALUES ('SA026','ST001','CU364','2021-06-12'),
('SA027','ST002','CU029','2021-04-29');

INSERT INTO SalesTransactionDetail VALUES
('SA027', 'PR011',3),
('SA026', 'PR012',3),
('SA026', 'PR002',2);

--Menghapus transaksi sales yang ada (cust batal beli)
DELETE FROM HeaderSalesTransaction
WHERE SalesID = 'SA027'

--Mengupdate Detail transaksi (misal salah input jumlah)
UPDATE SalesTransactionDetail
SET Quantity = 5
WHERE ProductID = 'PR012' AND SalesID = 'SA026'

--Mengupdate total barang yang terjual
UPDATE MsProduct
SET ProductStock-=2
WHERE ProductID='PR002'
UPDATE MsProduct
SET ProductStock-=5
WHERE ProductID='PR012'




