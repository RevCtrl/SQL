CREATE TABLE mod
AS
SELECT t1.[Country Name] AS CountryName,t1.[Country Code] AS CountryCode,t1.'2020' AS y2020, t2.IncomeGroup
FROM t1
INNER JOIN t2
ON t1.[Country Code] = t2.[Country Code];

CREATE TABLE ex
AS
SELECT  CountryName, CountryCode, IncomeGroup, AVG(y2020) OVER (PARTITION BY IncomeGroup)
FROM mod WHERE y2020!="" AND IncomeGroup!="" ORDER BY CountryCode;
