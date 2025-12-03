DROP TABLE IF EXISTS #Extract_ProductCategory;

SELECT 
    ProductCategoryID AS ProductCategoryAlternateKey,
    Name              AS EnglishProductCategoryName
INTO #Extract_ProductCategory
FROM AdventureWorks2022.Production.ProductCategory;

-- LOAD 

TRUNCATE TABLE dbo.stg_DimProductCategory;

INSERT INTO dbo.stg_DimProductCategory
(
    ProductCategoryKey,
    ProductCategoryAlternateKey,
    EnglishProductCategoryName,
    SpanishProductCategoryName,
    FrenchProductCategoryName
)
SELECT
    NULL AS ProductCategoryKey,          -- identity será gerado no DW
    ProductCategoryAlternateKey,
    EnglishProductCategoryName,
    NULL AS SpanishProductCategoryName,  -- ainda não existem no OLTP
    NULL AS FrenchProductCategoryName
FROM #Extract_ProductCategory
ORDER BY ProductCategoryAlternateKey;


