ALTER TABLE dbo.DimProductSubcategory
ADD CONSTRAINT FK_DimProductSubcategory_Category
    FOREIGN KEY (ProductCategoryKey)
    REFERENCES dbo.DimProductCategory(ProductCategoryKey);
