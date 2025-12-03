TRUNCATE TABLE dbo.stg_DimProductSubcategory;

INSERT INTO dbo.stg_DimProductSubcategory
(
    ProductSubcategoryAlternateKey,
    EnglishProductSubcategoryName,
    SpanishProductSubcategoryName,
    FrenchProductSubcategoryName,
    ProductCategoryAlternateKey
)
SELECT
    ProductSubcategoryID,
    Name,
    NULL,
    NULL,
    ProductCategoryID
FROM AdventureWorks2022.Production.ProductSubcategory;

-- LOAD 

TRUNCATE TABLE dbo.stg_DimProductSubcategory;

INSERT INTO dbo.stg_DimProductSubcategory
(
    ProductSubcategoryAlternateKey,
    EnglishProductSubcategoryName,
    SpanishProductSubcategoryName,
    FrenchProductSubcategoryName,
    ProductCategoryAlternateKey
)
SELECT
    sc.ProductSubcategoryID AS ProductSubcategoryAlternateKey,
    TRIM(sc.Name) AS EnglishProductSubcategoryName,
    NULL AS SpanishProductSubcategoryName,
    NULL AS FrenchProductSubcategoryName,
    pc.ProductCategoryKey  -- lookup no DW
FROM AdventureWorks2022.Production.ProductSubcategory sc
LEFT JOIN dbo.DimProductCategory pc
    ON pc.ProductCategoryAlternateKey = sc.ProductCategoryID;
