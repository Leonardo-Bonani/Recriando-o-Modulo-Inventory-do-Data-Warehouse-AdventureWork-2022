MERGE dbo.DimProduct AS T
USING dbo.stg_DimProduct AS S
    ON T.ProductAlternateKey = S.ProductAlternateKey
WHEN MATCHED THEN
    UPDATE SET
       -- Subcategoria
        T.ProductSubcategoryKey = S.ProductSubcategoryKey,
       -- Medidas
        T.WeightUnitMeasureCode = S.WeightUnitMeasureCode,
        T.SizeUnitMeasureCode = S.SizeUnitMeasureCode,
       -- Atributos 
        T.EnglishProductName = S.EnglishProductName,
        T.StandardCost = S.StandardCost,
        T.FinishedGoodsFlag = S.FinishedGoodsFlag,
        T.Color = S.Color,
        T.SafetyStockLevel = S.SafetyStockLevel,
        T.ReorderPoint = S.ReorderPoint,
        T.ListPrice = S.ListPrice,
        T.Size = S.Size,
        T.Weight = S.Weight,
        T.DaysToManufacture = S.DaysToManufacture,
        T.ProductLine = S.ProductLine,
        T.Class = S.Class,
        T.Style = S.Style,
        T.ModelName = S.ModelName,
       -- Foto
        T.LargePhoto = S.LargePhoto,

        T.Status = S.Status,           -- 'Current' ou 'Obsolete'
        T.StartDate = ISNULL(T.StartDate, GETDATE()),
        T.EndDate = '2014-12-31'

WHEN NOT MATCHED THEN
    INSERT (
        ProductAlternateKey,
        ProductSubcategoryKey,
        WeightUnitMeasureCode,
        SizeUnitMeasureCode,
        EnglishProductName,
        StandardCost,
        FinishedGoodsFlag,
        Color,
        SafetyStockLevel,
        ReorderPoint,
        ListPrice,
        Size,
        SizeRange,
        Weight,
        DaysToManufacture,
        ProductLine,
        DealerPrice,
        Class,
        Style,
        ModelName,
        LargePhoto,
        EnglishDescription,
        FrenchDescription,
        ChineseDescription,
        ArabicDescription,
        HebrewDescription,
        ThaiDescription,
        GermanDescription,
        JapaneseDescription,
        TurkishDescription,
        StartDate,
        EndDate,
        Status
    )
    VALUES (
        S.ProductAlternateKey,
        S.ProductSubcategoryKey,
        S.WeightUnitMeasureCode,
        S.SizeUnitMeasureCode,
        S.EnglishProductName,
        S.StandardCost,
        S.FinishedGoodsFlag,
        S.Color,
        S.SafetyStockLevel,
        S.ReorderPoint,
        S.ListPrice,
        S.Size,
        S.SizeRange,
        S.Weight,
        S.DaysToManufacture,
        S.ProductLine,
        S.DealerPrice,
        S.Class,
        S.Style,
        S.ModelName,
        S.LargePhoto,
        S.EnglishDescription,
        S.FrenchDescription,
        S.ChineseDescription,
        S.ArabicDescription,
        S.HebrewDescription,
        S.ThaiDescription,
        S.GermanDescription,
        S.JapaneseDescription,
        S.TurkishDescription,
        GETDATE(),          -- StartDate
        '2014-12-31',       -- EndDate
        'Current'           -- Status
    );
