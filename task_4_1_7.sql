-- ������� 7

USE [AdventureWorks2012];
GO

/* a. �������� ������� Sales.CurrencyHst, ������� ����� ������� ���������� �� 
	���������� � ������� Sales.Currency.
	������������ ����, ������� ������ �������������� � �������: ID � ��������� 
	���� IDENTITY(1,1);  Action  �  �����������  ��������  (insert, update ��� 
	delete);  ModifiedDate  �  ����  �  �����,  ����� ���� ��������� ��������; 
	SourceID �  ���������  ���� �������� �������; UserName � ��� ������������, 
	������������ ��������. �������� ������ ����, ���� �������� �� �������. */

CREATE TABLE [Sales].[CurrencyHst]
(
    [ID] INT IDENTITY(1, 1) PRIMARY KEY,
    [Action] NVARCHAR(6) NOT NULL CHECK ([Action] IN('insert', 'update', 'delete')),
    [ModifiedDate] DATETIME NOT NULL,
    [SourceID] NCHAR(3) NOT NULL,
    [UserName] Name NOT NULL
);
GO

/* b. �������� ��� AFTER �������� ��� ���� �������� INSERT, UPDATE, DELETE ��� 
	�������  Sales.Currency.   ������   �������   ������   ���������   ������� 
	Sales.CurrencyHst � ��������� ���� �������� � ���� Action. */

CREATE TRIGGER [Sales].[CurrencyAfterInsert]
ON [Sales].[Currency]
AFTER INSERT AS
INSERT INTO [Sales].[CurrencyHst]
(
    [Action],
    [SourceID],
    [UserName],
    [ModifiedDate]
)
SELECT
    'insert',
    [inserted].[CurrencyCode],
    CURRENT_USER,
    [inserted].[ModifiedDate]
FROM [inserted];
GO

CREATE TRIGGER [Sales].[CurrencyAfterUpdate]
ON [Sales].[Currency]
AFTER UPDATE AS
INSERT INTO [Sales].[CurrencyHst]
(
    [Action],
    [SourceID],
    [UserName],
    [ModifiedDate]
)
SELECT
    'update',
    [inserted].[CurrencyCode],
    CURRENT_USER,
    [inserted].[ModifiedDate]
FROM [inserted];
GO

CREATE TRIGGER [Sales].[CurrencyAfterDelete]
ON [Sales].[Currency]
AFTER DELETE AS
INSERT INTO [Sales].[CurrencyHst]
(
    [Action],
    [SourceID],
    [UserName],
    [ModifiedDate]
)
SELECT
    'delete',
    [deleted].[CurrencyCode],
    CURRENT_USER,
    [deleted].[ModifiedDate]
FROM [deleted];
GO

/* c. �������� ������������� VIEW, ������������ ��� ���� ������� Sales.Currency. 
	�������� ����������� �������� ��������� ���� �������������. */
	 
CREATE VIEW [Sales].[CurrencyView]
WITH ENCRYPTION AS
SELECT
    [CurrencyCode],
    [Name],
    [ModifiedDate]
FROM [Sales].[Currency];
GO

/* d. �������� �����  ������ � Sales.Currency ����� �������������. �������� ����������� ������. 
	������� ����������� ������. ���������, ��� ��� ��� �������� ���������� � Sales.CurrencyHst. */

INSERT INTO [Sales].[CurrencyView]
(
	[CurrencyCode],
	[Name],
	[ModifiedDate]
)
VALUES
(
	'N7',
    'D6',
	GetDate()
);
GO

UPDATE [Sales].[CurrencyView]
SET
    [CurrencyCode] = 'N8',
    [Name] = 'L9',
	[ModifiedDate] = GetDate()
WHERE [CurrencyCode] = 'N7';
GO

DELETE FROM [Sales].[CurrencyView]
WHERE [CurrencyCode] = 'N8';
GO

SELECT * FROM [Sales].[CurrencyHst];
GO