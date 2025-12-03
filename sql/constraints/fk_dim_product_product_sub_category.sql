ALTER TABLE dbo.DimProduct
ADD CONSTRAINT FK_DimProduct_ProductSubcategory
    FOREIGN KEY (ProductSubcategoryKey)
    REFERENCES dbo.DimProductSubcategory(ProductSubcategoryKey);
