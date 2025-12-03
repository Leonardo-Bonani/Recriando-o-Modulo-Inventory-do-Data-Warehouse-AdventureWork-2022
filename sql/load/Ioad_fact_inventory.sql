TRUNCATE TABLE dbo.FactProductInventory;

INSERT INTO dbo.FactProductInventory
(
    ProductKey,
    DateKey,
    MovementDate
)
SELECT 
    dp.ProductKey,
    dd.DateKey,
    dd.FullDateAlternateKey as MovementDate
FROM dbo.DimProduct dp
CROSS JOIN dbo.DimDate dd
WHERE dd.FullDateAlternateKey BETWEEN '2010-01-01' AND '2014-12-31'
ORDER BY dp.ProductKey, dd.DateKey;

