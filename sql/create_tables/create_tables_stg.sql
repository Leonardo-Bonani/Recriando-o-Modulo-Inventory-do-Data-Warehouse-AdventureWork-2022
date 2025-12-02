DROP TABLE IF EXISTS dbo.stg_DimProduct;

CREATE TABLE dbo.stg_DimProduct
(
    ProductAlternateKey            NVARCHAR(25) NOT NULL, 
    ProductSubcategoryKey          INT NULL,
    WeightUnitMeasureCode          NCHAR(3) NULL,
    SizeUnitMeasureCode            NCHAR(3) NULL,
    EnglishProductName             NVARCHAR(50) NULL,
    SpanishProductName             NVARCHAR(50) NULL, 
    FrenchProductName              NVARCHAR(50) NULL, 
    StandardCost                   MONEY NULL,
    FinishedGoodsFlag              BIT NULL,
    Color                          NVARCHAR(15) NULL,
    SafetyStockLevel               SMALLINT NULL,
    ReorderPoint                   SMALLINT NULL,
    ListPrice                      MONEY NULL,
    Size                           NVARCHAR(50) NULL,
    SizeRange                      NVARCHAR(50) NULL, 
    Weight                         FLOAT NULL,
    DaysToManufacture              INT NULL,
    ProductLine                    NCHAR(2) NULL,
    DealerPrice                    MONEY NULL, 
    Class                          NCHAR(2) NULL,
    Style                          NCHAR(2) NULL,
    ModelName                      NVARCHAR(50) NULL,
    LargePhoto                     VARBINARY(MAX) NULL,
    EnglishDescription             NVARCHAR(400) NULL, 
    FrenchDescription              NVARCHAR(400) NULL, 
    ChineseDescription             NVARCHAR(400) NULL,
    ArabicDescription              NVARCHAR(400) NULL,
    HebrewDescription              NVARCHAR(400) NULL, 
    ThaiDescription                NVARCHAR(400) NULL, 
    GermanDescription              NVARCHAR(400) NULL, 
    JapaneseDescription            NVARCHAR(400) NULL, 
    TurkishDescription             NVARCHAR(400) NULL, 
    SellStartDate                  DATETIME NULL,  
    SellEndDate                    DATETIME NULL,  
    Status                         NVARCHAR(20) NULL 
);


DROP TABLE IF EXISTS dbo.stg_DimProductSubcategory;

CREATE TABLE dbo.stg_DimProductSubcategory
(
    ProductSubcategoryAlternateKey INT,
    EnglishProductSubcategoryName NVARCHAR(50),
    SpanishProductSubcategoryName NVARCHAR(50),
    FrenchProductSubcategoryName NVARCHAR(50),
    ProductCategoryAlternateKey INT   
);


DROP TABLE IF EXISTS dbo.stg_DimProductCategory;

CREATE TABLE dbo.stg_DimProductCategory
(
    ProductCategoryKey             INT,        
    ProductCategoryAlternateKey    INT,
    EnglishProductCategoryName     NVARCHAR(50),
    SpanishProductCategoryName     NVARCHAR(50),
    FrenchProductCategoryName      NVARCHAR(50)
);
