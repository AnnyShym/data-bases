-- Вариант 7

USE [AdventureWorks2012];
GO

/* a. Выполните код, созданный во втором задании второй лабораторной работы. 
	Добавьте  в  таблицу  dbo.PersonPhone  поля  OrdersCount  INT и CardType 
	NVARCHAR(50).  Также  создайте  в  таблице  вычисляемое поле IsSuperior, 
	которое  будет  хранить  1,  если  тип  карты ‘ SuperiorCard’  и  0  для 
	остальных карт.*/

ALTER TABLE [dbo].[PersonPhone]
ADD
    [OrdersCount] INT,
    [CardType] NVARCHAR(50),
    [IsSuperior] AS IIF ([CardType] = 'SuperiorCard', 1, 0);
GO

/* b. Создайте временную таблицу #PersonPhone, с первичным ключом по полю 
	BusinessEntityID. Временная  таблица должна включать все поля таблицы 
	dbo.PersonPhone за исключением поля IsSuperior.*/

CREATE TABLE #PersonPhone
(
    [BusinessEntityID] INT NOT NULL PRIMARY KEY,
    [PhoneNumber] NVARCHAR(25) NOT NULL,
    [PhoneNumberTypeID] BIGINT NULL,
    [ModifiedDate] DATETIME,
    [PostalCode] NVARCHAR(15) DEFAULT ('0'),
    [OrdersCount] INT,
    [CardType] NVARCHAR(50)
);
GO

/* c. Заполните временную таблицу данными из dbo.PersonPhone. Поле CardType 
	заполните данными из таблицы  Sales.CreditCard.  Посчитайте  количество
	заказов,   оплаченных    каждой   картой   (CreditCardID)   в   таблице 
	Sales.SalesOrderHeader  и  заполните этими значениями поле OrdersCount. 
	Подсчет количества заказов осуществите в Common Table Expression (CTE).*/

WITH [OrdersCount_CTE] 
(
	[CreditCardID], 
	[OrdersCount]
)
AS
(
    SELECT
        [CreditCardID],
        COUNT(*) AS [OrdersCount]
    FROM [Sales].[SalesOrderHeader]
    GROUP BY [CreditCardID]
)
INSERT INTO #PersonPhone
(
        [BusinessEntityID],
        [PhoneNumber],
        [PhoneNumberTypeID],
        [ModifiedDate],
        [PostalCode],
        [OrdersCount],
        [CardType]
)
SELECT
    [PP].[BusinessEntityID],
    [PP].[PhoneNumber],
    [PP].[PhoneNumberTypeID],
    [PP].[ModifiedDate],
    [PP].[PostalCode],
    [OCCTE].[OrdersCount],
    [CC].[CardType]
FROM [dbo].[PersonPhone] AS [PP] JOIN [Sales].[PersonCreditCard] [PCD]
    ON ([PP].[BusinessEntityID] = [PCD].[BusinessEntityID]) JOIN [Sales].[CreditCard] [CC]
    ON ([PCD].[CreditCardID] = [CC].[CreditCardID]) JOIN [OrdersCount_CTE] [OCCTE]
    ON ([CC].[CreditCardID] = [OCCTE].[CreditCardID]);
GO

/* d. Удалите из таблицы dbo.PersonPhone одну строку (где BusinessEntityID = 297).*/

DELETE FROM #PersonPhone
WHERE [BusinessEntityID] = 297;

/* e. Напишите Merge выражение, использующее  dbo.PersonPhone как target, а временную 
	таблицу  как  source.  Для  связи  target  и source используйте BusinessEntityID. 
	Обновите поля OrdersCount и CardType, если запись присутствует в source и target. 
	Если  строка  присутствует  во  временной  таблице,  но  не  существует в target, 
	добавьте  строку  в  dbo.PersonPhone.  Если  в dbo.PersonPhone присутствует такая 
	строка,  которой  не  существует  во  временной  таблице,   удалите   строку   из 
	dbo.PersonPhone.*/

MERGE [dbo].[PersonPhone] AS [target]
USING #PersonPhone AS [source]
ON ([target].[BusinessEntityID] = [source].[BusinessEntityID])
WHEN MATCHED THEN
    UPDATE SET
        [OrdersCount] = [source].[OrdersCount],
        [CardType] = [source].[CardType]
WHEN NOT MATCHED BY TARGET THEN
INSERT
(
    [BusinessEntityID],
    [PhoneNumber],
    [PhoneNumberTypeID],
    [ModifiedDate],
    [OrdersCount],
    [CardType]
)
VALUES
(
    [source].[BusinessEntityID],
    [source].[PhoneNumber],
    [source].[PhoneNumberTypeID],
    [source].[ModifiedDate],
    [source].[OrdersCount],
    [source].[CardType]
)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
GO