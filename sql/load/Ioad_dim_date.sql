DECLARE @StartDate DATE = '2005-01-01';
DECLARE @EndDate   DATE = '2014-12-31';

-- CTE 
;WITH GerarData AS (
    SELECT @StartDate AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM GerarData
    WHERE DateValue < @EndDate
)

INSERT INTO dbo.DimDate (
     DateKey,
     FullDateAlternateKey,
     DayNumberOfWeek,
     EnglishDayNameOfWeek,
     SpanishDayNameOfWeek,
     FrenchDayNameOfWeek,
     DayNumberOfMonth,
     DayNumberOfYear,
     WeekNumberOfYear,
     EnglishMonthName,
     SpanishMonthName,
     FrenchMonthName,
     MonthNumberOfYear,
     CalendarQuarter,
     CalendarYear,
     CalendarSemester,
     FiscalQuarter,
     FiscalYear,
     FiscalSemester
)

SELECT
    -- 1 a 4
    CONVERT(INT, FORMAT(DateValue, 'yyyyMMdd')) AS DateKey,
    DateValue AS FullDateAlternateKey,
    DATEPART(WEEKDAY, DateValue) AS DayNumberOfWeek,
    DATENAME(WEEKDAY, DateValue) AS EnglishDayNameOfWeek,

    -- 5 e 6 substituídas por NULL
    NULL AS SpanishDayNameOfWeek,
    NULL AS FrenchDayNameOfWeek,

    -- 7 a 10
    DAY(DateValue) AS DayNumberOfMonth,
    DATEPART(DAYOFYEAR, DateValue) AS DayNumberOfYear,
    DATEPART(WEEK, DateValue) AS WeekNumberOfYear,
    DATENAME(MONTH, DateValue) AS EnglishMonthName,

    -- 11 e 12 substituídas por NULL
    NULL AS SpanishMonthName,
    NULL AS FrenchMonthName,

    -- 13 a 15
    MONTH(DateValue) AS MonthNumberOfYear,
    DATEPART(QUARTER, DateValue) AS CalendarQuarter,
    YEAR(DateValue) AS CalendarYear,

    -- 16
    CASE 
        WHEN MONTH(DateValue) BETWEEN 1 AND 6 THEN 1
        ELSE 2
    END AS CalendarSemester,

    -- 17
    CASE 
        WHEN MONTH(DateValue) BETWEEN 7 AND 9  THEN 1
        WHEN MONTH(DateValue) BETWEEN 10 AND 12 THEN 2
        WHEN MONTH(DateValue) BETWEEN 1 AND 3  THEN 3
        WHEN MONTH(DateValue) BETWEEN 4 AND 6  THEN 4
    END AS FiscalQuarter,

    -- 18
    CASE 
        WHEN MONTH(DateValue) >= 7 THEN YEAR(DateValue) + 1
        ELSE YEAR(DateValue)
    END AS FiscalYear,

    -- 19
    CASE 
        WHEN MONTH(DateValue) BETWEEN 7 AND 12 THEN 1
        ELSE 2
    END AS FiscalSemester

FROM GerarData
OPTION (MAXRECURSION 0);
