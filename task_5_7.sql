-- ������� 7

USE [AdventureWorks2012];
GO

/* a. �������� scalar-valued �������, ������� ����� ��������� � �������� �������� ��������� 
	��� ������ (Sales.Currency.CurrencyCode)  �  ���������� ��������� ������������� ���� �� 
	��������� � USD (Sales.CurrencyRate.ToCurrencyCode).*/

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

/* b. �������� inline table-valued �������, ������� ����� ��������� � �������� �������� 
	��������� id �������� (Production.Product.ProductID), � ���������� ������ ������ �� 
	�������   �������   ��������  ��  Purchasing.PurchaseOrderDetail,  ���   ���������� 
	���������� ������� ����� 1000 (OrderQty).*/

CREATE FUNCTION [Production].[GetOrdersMore1000] (@ProductID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM [Purchasing].[PurchaseOrderDetail]
    WHERE [ProductID] = @ProductID AND [OrderQty] > 1000
);
GO

/* c. �������� ������� ��� ������� ��������, �������� �������� CROSS APPLY. �������� 
	������� ��� ������� ��������, �������� �������� OUTER APPLY.*/

SELECT * FROM [Production].[Product] CROSS APPLY [Production].[GetOrdersMore1000] ([Product].[ProductID]);
SELECT * FROM [Production].[Product] OUTER APPLY [Production].[GetOrdersMore1000] ([Product].[ProductID]);
GO

/* d. �������� ��������� inline table-valued �������, ������ �� multistatement table-valued 
	(�������������� �������� ��� �������� ��� �������� inline table-valued �������).*/

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