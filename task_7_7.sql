-- ¬ариант 7

USE [AdventureWorks2012];
GO

/* a. ¬ывести значени€ полей [ProductID], [Name] из таблицы [Production].[Product] и полей [ProductModelID] 
	и [Name] из таблицы [Production].[ProductModel] в виде xml, сохраненного в переменную.*/

DECLARE @xml XML;

SET @xml =
(
    SELECT
        [P].[ProductID] AS '@ID',
        [P].[Name] AS 'Name',
        [PM].[ProductModelID] AS 'Model/@ID',
        [PM].[Name] AS 'Model/Name'
    FROM [Production].[Product] [P] JOIN [Production].[ProductModel] [PM]
        ON [P].[ProductModelID] = [PM].[ProductModelID]
    FOR XML
        PATH ('Product'),
        ROOT ('Products')
);

SELECT @xml;

/* b. —оздать временную таблицу и заполнить еЄ данными из переменной, содержащей xml.*/

CREATE TABLE #Product
(
    [ProductID] INT,
    [ProductName] NVARCHAR(50),
    [ProductModelID] INT,
    [ProductModelName] NVARCHAR(50)
);

INSERT INTO #Product
(
    [ProductID],
    [ProductName],
    [ProductModelID],
    [ProductModelName]
)
SELECT
    [ProductID] = [node].[value]('@ID', 'INT'),
    [ProductName] = [node].[value]('Name[1]', 'NVARCHAR(50)'),
    [ProductModelID] = [node].[value]('Model[1]/@ID', 'INT'),
    [ProductModelName] = [node].[value]('Model[1]/Name[1]', 'NVARCHAR(50)')
FROM @xml.[nodes]('/Products/Product') AS xml([node]);
GO

