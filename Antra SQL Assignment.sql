
-Q1
Use WideWorldImporters
GO

select Fullname, PhoneNumber, FaxNumber
from [WideWorldImporters].[Application].[People];

-Q2
Use WideWorldImporters
GO

select c.PrimaryContactPersonID, c.PhoneNumber
from Application.people as P, sales.Customers as C
where c.PrimaryContactPersonID = p.PersonID
AND P.PhoneNumber = C.PhoneNumber;

-Q3 
Use WideWorldImporters
GO
Select distinct customerID 
from Sales.CustomerTransactions
where TransactionDate < '2016-01-01 '
	and customerId not in 
	(Select distinct customerId 
	from Sales.CustomerTransactions
	where transactionDate >= '2016-01-01');
