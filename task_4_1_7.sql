-- ¬ариант 7

USE [AdventureWorks2012];
GO

/* a. —оздайте таблицу Sales.CurrencyHst, котора€ будет хранить информацию об 
	изменени€х в таблице Sales.Currency.
	ќб€зательные пол€, которые должны присутствовать в таблице: ID Ч первичный 
	ключ IDENTITY(1,1);  Action  Ч  совершенное  действие  (insert, update или 
	delete);  ModifiedDate  Ч  дата  и  врем€,  когда была совершена операци€; 
	SourceID Ч  первичный  ключ исходной таблицы; UserName Ч им€ пользовател€, 
	совершившего операцию. —оздайте другие пол€, если считаете их нужными. */

CREATE TABLE [Sales].[CurrencyHst]
(
    [ID] INT IDENTITY(1, 1) PRIMARY KEY,
    [Action] NVARCHAR(6) NOT NULL CHECK ([Action] IN('insert', 'update', 'delete')),
    [ModifiedDate] DATETIME NOT NULL,
    [SourceID] NCHAR(3) NOT NULL,
    [UserName] Name NOT NULL
);
GO

/* b. —оздайте три AFTER триггера дл€ трех операций INSERT, UPDATE, DELETE дл€ 
	таблицы  Sales.Currency.    аждый   триггер   должен   заполн€ть   таблицу 
	Sales.CurrencyHst с указанием типа операции в поле Action. */

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

/* c. —оздайте представление VIEW, отображающее все пол€ таблицы Sales.Currency. 
	—делайте невозможным просмотр исходного кода представлени€. */
	 
CREATE VIEW [Sales].[CurrencyView]
WITH ENCRYPTION AS
SELECT
    [CurrencyCode],
    [Name],
    [ModifiedDate]
FROM [Sales].[Currency];
GO

/* d. ¬ставьте новую  строку в Sales.Currency через представление. ќбновите вставленную строку. 
	”далите вставленную строку. ”бедитесь, что все три операции отображены в Sales.CurrencyHst. */

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