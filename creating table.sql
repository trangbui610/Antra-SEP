DROP TABLE IF EXISTS ods.StockItem;
CREATE TABLE ods.StockItem (
StockItem INT,
StockItemName nvarchar(100),
SupplierID INT,
ColorID INT,
UnitPackageID INT,
OuterPackageID INT,
Brand nvarchar(50),
Size nvarchar(20),
LeadTimeDays INT,
QuantityPerOuter INT,
IsChillerStock BIT,
Barcode nvarchar(50),
TaxRate DEC(18,2),
UnitPrice DEC(18,2),
RecommendedRetailPrice DEC(18,2),
TypicalWeightPerUnit DEC(18,3),
MarketingComments nvarchar(MAX),
InternalComments nvarchar(MAX),
CountryOfManufacture nvarchar(MAX),
Range nvarchar(MAX),
Shelflife nvarchar(MAX)
);

INSERT INTO ods.StockItem
SELECT StockItemID, StockItemName , SupplierID, ColorID, UnitPackageID,OuterPackageID,Brand, Size, LeadTimeDays,
QuantityPerOuter,IsChillerStock,Barcode,TaxRate, UnitPrice, RecommendedRetailPrice,TypicalWeightPerUnit,MarketingComments,
InternalComments,JSON_VALUE(WSI.CustomFields,'$.CountryOfManufacture') AS CountryOfManufacture,
JSON_VALUE(WSI.CustomFields, '$.Range') AS Range, JSON_VALUE(WSI.CustomFields,'$.ShelfLife')
AS ShelfLife FROM Warehouse.StockItems WSI;

SELECT * FROM ods.StockItem;