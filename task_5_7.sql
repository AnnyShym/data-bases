-- Вариант 7

USE [AdventureWorks2012];
GO

/* a. Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра 
	код валюты (Sales.Currency.CurrencyCode)  и  возвращать последний установленный курс по 
	отношению к USD (Sales.CurrencyRate.ToCurrencyCode).*/

CREATE FUNCTION [Sales].[GetLastRateFromUSD] (@CurrencyCode NCHAR(3))
RETURNS MONEY
AS
BEGIN
    RETURN
    (
        SELECT TOP (1)
            [AverageRate]
        FROM [Sales].[CurrencyRate]
        WHERE [ToCurrencyCode] = @CurrencyCode AND [FromCurrencyCode] = 'USD'
        ORDER BY [CurrencyRateDate] DESC
    )
END;
GO

/* b. Создайте inline table-valued функцию, которая будет принимать в качестве входного 
	параметра id продукта (Production.Product.ProductID), а возвращать детали заказа на 
	покупку   данного   продукта  из  Purchasing.PurchaseOrderDetail,  где   количество 
	заказанных позиций более 1000 (OrderQty).*/

CREATE FUNCTION [Production].[GetOrdersMore1000] (@ProductID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM [Purchasing].[PurchaseOrderDetail]
    WHERE [ProductID] = @ProductID AND [OrderQty] > 1000
);
GO

/* c. Вызовите функцию для каждого продукта, применив оператор CROSS APPLY. Вызовите 
	функцию для каждого продукта, применив оператор OUTER APPLY.*/

SELECT * FROM [Production].[Product] CROSS APPLY [Production].[GetOrdersMore1000] ([Product].[ProductID]);
SELECT * FROM [Production].[Product] OUTER APPLY [Production].[GetOrdersMore1000] ([Product].[ProductID]);
GO

/* d. Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
	(предварительно сохранив для проверки код создания inline table-valued функции).*/

DROP FUNCTION [Production].[GetOrdersMore1000];
GO

CREATE FUNCTION [Production].[GetOrdersMore1000] (@ProductID INT)
RETURNS
    @Orders TABLE
    (
        [PurchaseOrderID] INT,
        [PurchaseOrderDetailID] INT,
        [DueDate] DATETIME,
        [OrderQty] SMALLINT,
        [ProductID] INT,
        [UnitPrice] MONEY,
        [LineTotal] MONEY,
        [ReceivedQty] DECIMAL(8,2),
        [RejectedQty] DECIMAL(8,2),
        [StockedQty] DECIMAL(9,2),
        [ModifiedDate] DATETIME
    )
AS
BEGIN
    INSERT INTO @Orders
    (
        [PurchaseOrderID],
        [PurchaseOrderDetailID],
        [DueDate],
        [OrderQty],
        [ProductID],
        [UnitPrice],
        [LineTotal],
        [ReceivedQty],
        [RejectedQty],
        [StockedQty],
        [ModifiedDate]
    )
    SELECT
        [PurchaseOrderID],
        [PurchaseOrderDetailID],
        [DueDate],
        [OrderQty],
        [ProductID],
        [UnitPrice],
        [LineTotal],
        [ReceivedQty],
        [RejectedQty],
        [StockedQty],
        [ModifiedDate]
    FROM [Purchasing].[PurchaseOrderDetail]
    WHERE [ProductID] = @ProductID AND [OrderQty] > 1000;
    RETURN
END;
GO