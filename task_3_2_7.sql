-- ������� 7

USE [AdventureWorks2012];
GO

/* a. ��������� ���, ��������� �� ������ ������� ������ ������������ ������. 
	��������  �  �������  dbo.PersonPhone  ����  OrdersCount  INT � CardType 
	NVARCHAR(50).  �����  ��������  �  �������  ����������� ���� IsSuperior, 
	�������  �����  �������  1,  ����  ���  ����� � SuperiorCard�  �  0  ��� 
	��������� ����.*/

ALTER TABLE [dbo].[PersonPhone]
ADD
    [OrdersCount] INT,
    [CardType] NVARCHAR(50),
    [IsSuperior] AS IIF ([CardType] = 'SuperiorCard', 1, 0);
GO

/* b. �������� ��������� ������� #PersonPhone, � ��������� ������ �� ���� 
	BusinessEntityID. ���������  ������� ������ �������� ��� ���� ������� 
	dbo.PersonPhone �� ����������� ���� IsSuperior.*/

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

/* c. ��������� ��������� ������� ������� �� dbo.PersonPhone. ���� CardType 
	��������� ������� �� �������  Sales.CreditCard.  ����������  ����������
	�������,   ����������    ������   ������   (CreditCardID)   �   ������� 
	Sales.SalesOrderHeader  �  ��������� ����� ���������� ���� OrdersCount. 
	������� ���������� ������� ����������� � Common Table Expression (CTE).*/

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

/* d. ������� �� ������� dbo.PersonPhone ���� ������ (��� BusinessEntityID = 297).*/

DELETE FROM #PersonPhone
WHERE [BusinessEntityID] = 297;

/* e. �������� Merge ���������, ������������  dbo.PersonPhone ��� target, � ��������� 
	�������  ���  source.  ���  �����  target  � source ����������� BusinessEntityID. 
	�������� ���� OrdersCount � CardType, ���� ������ ������������ � source � target. 
	����  ������  ������������  ��  ���������  �������,  ��  ��  ���������� � target, 
	��������  ������  �  dbo.PersonPhone.  ����  � dbo.PersonPhone ������������ ����� 
	������,  �������  ��  ����������  ��  ���������  �������,   �������   ������   �� 
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