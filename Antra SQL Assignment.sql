
--Q1
USE WideWorldImporters
GO

select Fullname, People.PhoneNumber, People.FaxNumber, Customers.PhoneNumber AS 'CoPhoneNumber', Customers.FaxNumber AS 'CoFaxNumber'
from Application.People Left join Sales.Customers
On PersonID=PrimaryContactPersonID Or PersonID= AlternateContactPersonID
;

--Q2
Use WideWorldImporters
GO

select c.PrimaryContactPersonID, c.PhoneNumber
from Application.people as P, sales.Customers as C
where c.PrimaryContactPersonID = p.PersonID
AND P.PhoneNumber = C.PhoneNumber;

--Q3 
Use WideWorldImporters
GO

Select distinct customerID 
from Sales.CustomerTransactions
where TransactionDate < '2016-01-01 '
	and customerId not in 
	(Select distinct customerId 
	from Sales.CustomerTransactions
	where transactionDate >= '2016-01-01');

--Q4
Use WideWorldImporters
GO

 select StockItemName, QuantityPerOuter, year (TransactionOccurredWhen)
  from Warehouse.StockItems as a, Warehouse.StockItemTransactions as b
  where a.StockItemID = b.StockItemID
		and year(TransactionOccurredWhen) = 2013;

--Q5
Use WideWorldImporters
GO

 select StockItemID, StockItemName
  from Warehouse.StockItems
  where len(StockItemName) > 10;

  --Q6
Use WideWorldImporters
GO

selecy StockItemID         
from Warehouse.StockItems
where StockItemID NOT IN 
	(select StockItemID
	from Sales.OrderLines AS l
	join Sales.Orders AS o
	ON l.OrderLineID = o.OrderID
	join Sales.Customers AS c
	ON o.CustomerID = c.CustomerID
	join Application.Cities AS t
	ON c.PostalCityID = t.CityID
J	OIN Application.StateProvinces AS s
	ON t.StateProvinceID = s.StateProvinceID 
	AND s.StateProvinceName IN ('Alabama', 'Georgia')
	WHERE o.OrderDate > '20131231' and o.OrderDate < '20150101')

--q7
Use WideWorldImporters
GO

select s.StateProvinceName,
AVG(DATEDIFF(DAY, o.Orderdate, i.ConfirmedDeliveryTime)) AS Avg_Date
from Sales.Invoices AS i
join Sales.Orders AS o
ON i.OrderID = o.OrderID
join Sales.Customers AS c
ON o.CustomerID = c.CustomerID
join Application.Cities AS t
ON c.PostalCityID = t.CityID
join Application.StateProvinces AS s
ON t.StateProvinceID = s.StateProvinceID
GROUP BY s.StateProvinceName
;

--Q8
Use WideWorldImporters
GO

select 
		StateProvinceName, OrderDate , 
		DateDiff(Month, OrderDate, ExpectedDeliveryDate) As Daystosship
from Sales.Invoices as I
inner join Sales.Orders as O ON O.OrderID= I.OrderID
inner join Sales.Customers as C ON C.CustomerCategoryID = O.customerID
inner join Application.Cities CS ON C.PostalCityID = CS.CityID
inner join Application.StateProvinces as SP ON CS.StateProvinceID = SP.StateProvinceID
	Group by Year (so.OrderDate),Month (so.OrderDate), st.StateProvinceCode
	Order by st.StateProvinceCode,Year (so.OrderDate),Month (so.OrderDate)

;

--Q9
Use WideWorldImporters
GO

select I.StockItemID, Quantity, OrderedOuters, YEAR(I.LastEditedWhen) AS YearofOrder, P.ReceivedOuters
 from Sales.InvoiceLines AS I
 inner join Purchasing.PurchaseOrderLines AS P
 ON I.StockItemID = P.StockItemID
 WHERE YEAR(I.LastEditedWhen)= '2015'
 AND Quantity> ReceivedOuters; 

--Q10
Use WideWorldImporters
GO

select CustomerName, C.PhoneNumber, PrimaryContactPersonID, P.FullName, year(C.Validfrom) as YearOrder, O.OrderID
  from Sales.Customers as C
  inner join Application.People as P on C.PrimaryContactPersonID = P.PersonID
  inner join sales.OrderLines as O on C.LastEditedBy = O.LastEditedBy
  where year(C.Validfrom)= '2016'
  and OrderID in 
	 (select StockItemName, WS.StockItemID,O. Quantity, O.OrderID
  	from Warehouse.StockItems as WS
  	inner join Sales.OrderLines as O 
  	on WS.StockItemID = O.StockItemID
  	where StockItemName like '%mug%'
 	AND Quantity < 10)
;  

--Q11
Use WideWorldImporters
GO

select distinct co.CityName, co.Validfrom, co.ValidTo        
from Application.Cities AS co
join Application.Cities_Archive AS ca 
ON co.CityID = co.CityID AND co.Validfrom = ca.ValidTo
WHERE co.Validfrom > '20141231'

--q12
Use WideWorldImporters
GO

 select l.Description AS StockItemName, c.DeliveryAddressLine1 + c.DeliveryAddressLine1 AS DeliveryAddress, ac.CityName, st.StateProvinceName AS StateName, 
co.CountryName, c.CustomerName, p.FullName AS CustomerContactPersonName, c.PhoneNumber AS CustomerPhoneNumber, l.Quantity
from Sales.OrderLines AS l
	join Sales.Orders AS o
	ON o.OrderID = l.OrderID
	join Sales.Customers AS c
	ON o.CustomerID = C.CustomerID
	join Application.People AS p
	ON c.PrimaryContactPersonID = p.PersonID
	join Application.Cities AS ac
	ON c.PostalCityID = ac.CityID
	join Application.StateProvinces AS st
	ON ac.StateProvinceID = st.StateProvinceID
	join Application.Countries AS co
	ON co.CountryID = st.CountryID
WHERE o.OrderDate = '20140701'

  --q13

Use WideWorldImporters
GO

select WSG.StockGroupName,SIP.StockItemID,SIP.QuantityPurchased,SIS.QuantitySold,SIP.QuantityPurchased-SIS.QuantitySold as Remaining
	 from(
		 select pol.StockItemID,SUM(pol.ReceivedOuters) as QuantityPurchased
		 from Purchasing.PurchaseOrderLines pol 
		 group by pol.StockItemID) AS SIP
	  join(
		 select SOL.StockItemID, SUM(SOL.Quantity) as QuantitySold
		 from Sales.OrderLines SOL
		 Group by SOL.StockItemID) AS SIS
	ON SIP.StockItemID=SIS.StockItemID
	 join Warehouse.StockItemStockGroups SISG on SIP.StockItemID= SISG.StockItemID
	 join Warehouse.StockGroups WSG on WSG.StockGroupID=SISG.StockGroupID;

-- q14
Use WideWorldImporters
GO

select distinct C.CityID, Ci.Cityorder,
 case when isnull(ci.Cityorder,'') <> '' then 'Have Sales' else 'No sales' end
 from Application.Cities C 
   inner join Application.StateProvinces S ON C.StateProvinceID = S.StateProvinceID
   inner join Application.Countries Co on S.CountryID = Co.CountryID
left join (
			select distinct c.CityID as Cityorder
		  from Application.Cities C 
		  inner join Application.StateProvinces S ON C.StateProvinceID = S.StateProvinceID
		  inner join Application.Countries Co on S.CountryID = Co.CountryID
		  inner join Sales.Customers CU ON c.CityID = CU.DeliveryCityID
		  inner join Sales.Invoices I on CU.CustomerID = I.CustomerID
		  where Co.CountryID = '230'
		  AND YEAR (I.ConfirmedDeliveryTime) = '2016'
		 GROUP BY C.CityID 

) Ci on C.CityID = Ci.Cityorder
where Co.CountryID = '230';

--q15

Use WideWorldImporters
GO

select *, (Len(ReturnedDeliveryData) - Len(Replace(ReturnedDeliveryData, 'DeliveryAttempt', ''))/Len('DeliveryAttempt')) As CountDelivery
from Sales.Invoices
where CountDelivery >= 1;

select orderID, COUNT(orderID) As CountDelivery
from(
	select orderID, JSON_VALUE(ReturnedDeliveryData, '$.Events[1].Event') AS DeliveryAttempt
	from Sales.Invoices

	UNION ALL
	select orderID, JSON_VALUE(ReturnedDeliveryData, '$.Events[2].Event') AS DeliveryAttempt
	from Sales.Invoices
	where JSON_VALUE(ReturnedDeliveryData, '$.Events[2].Event') <> null 
)a
group by a.orderID;

--q16
Use WideWorldImporters
GO

select SI.StockItemName
from
Warehouse.StockItems as SI
where
ISJSON(CustomFields)>0
and JSON_VALUE(CustomFields,'$.CountryOfManufacture')='China';

--q17
Use WideWorldImporters
GO

select JSON_VALUE(SI.CustomFields,'$.CountryOfManufacture') AS CountryManu, 
SUM(TB.TotalOrder) AS TotalQuan
from Warehouse.StockItems SI join TB ON 
SI.StockItemID = TB.StockItemID 
group by JSON_VALUE(SI.CustomFields,'$.CountryOfManufacture');

--q18
Use WideWorldImporters
GO

IF OBJECT_ID(N'vw_StockGroup_Sold_By_Year', N'V') IS NOT NULL
DROP VIEW vw_StockGroup_Sold_By_Year
GO
CREATE VIEW vw_StockGroup_Sold_By_Year
AS 
WITH SouceTable as 
(select SUM(l.Quantity) AS total, sg.StockGroupName, 
Year(o.OrderDate) AS FiscalYear
from Sales.OrderLines as l
join Sales.Orders AS o
ON o.OrderID = l.OrderID
join Warehouse.StockItemStockGroups AS si
ON l.StockItemID = si.StockItemID
join Warehouse.StockGroups AS sg
ON si.StockGroupID = Sg.StockGroupID
GROUP BY sg.StockGroupName, Year(o.OrderDate)
)

select StockGroupName, [2013], [2014], [2015], [2016], [2017]
from SouceTable
PIVOT (MAX(total)
      FOR FiscalYear in ([2013], [2014], [2015], [2016], [2017])
	  ) AS p
GO
select * from vw_StockGroup_Sold_By_Year;

--q20
USE WideWorldImporters
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Fn_OrderID](
	@orderID  int
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @returnValue FLOAT 
	SET @returnValue = (
			select count(OrderID) 
			  from Sales.OrderLines
			  where OrderID = @orderID 
			  group by OrderID)
	RETURN  @returnValue
END

select * , [dbo].[Fn_OrderID
from Sales.Invoices;

--q22
Use WideWorldImporters
GO

DROP ods.StockItem
select  
[StockItemID], [StockItemName] ,[SupplierID] ,[ColorID] ,
[UnitPackageID] ,[OuterPackageID] ,[Brand] ,[Size] ,
[LeadTimeDays] ,[QuantityPerOuter] ,[IsChillerStock] ,
[Barcode] ,[TaxRate]  ,[UnitPrice],[RecommendedRetailPrice] ,
[TypicalWeightPerUnit] ,[MarketingComments]  ,
[InternalComments], 
JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOFManufacutre, 
JSON_VALUE(CustomFields,'$.Range') AS Range, 
JSON_VALUE(CustomFields,'$.ShelfLife') AS ShelfLife
INTO ods.StockItem
from Warehouse.StockItems


select * from ods.StockItem;
