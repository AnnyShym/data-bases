-- ������� 7

USE [AdventureWorks2012];
GO

/* a. �������� ������������� VIEW, ������������ ������ �� ������ Sales.Currency 
	� Sales.CurrencyRate.  ������� Sales.Currency  ������  ����������  �������� 
	������  ���  ����  ToCurrencyCode.  �������� ���������� ���������� ������ � 
	������������� �� ���� CurrencyRateID.*/

CREATE VIEW [Sales].[CurrencyRateView]
WITH SCHEMABINDING AS
SELECT
    [CurrencyCode],
    [Name],
    [CurrencyRateID],
    [CurrencyRateDate],
    [FromCurrencyCode],
    [AverageRate],
    [EndOfDayRate]
FROM [Sales].[Currency] JOIN [Sales].[CurrencyRate]
    ON ([CurrencyCode] = [ToCurrencyCode]);
GO

CREATE UNIQUE CLUSTERED INDEX [IX_CurrencyCurrencyRateView_CurrencyRateID]
ON [Sales].[CurrencyRateView] 
(
	[CurrencyRateID]
);
GO

/* b. �������� ���� INSTEAD OF ������� ��� ������������� �� ��� �������� 
	INSERT,  UPDATE,  DELETE. �������  ������  ��������� ��������������� 
	�������� � �������� Sales.Currency � Sales.CurrencyRate.*/

CREATE TRIGGER [Sales].[CurrencyCurrencyRateViewAction]
ON [Sales].[CurrencyRateView]
INSTEAD OF INSERT, UPDATE, DELETE AS
BEGIN
    IF EXISTS (SELECT * FROM [inserted]) AND NOT EXISTS(SELECT * FROM [deleted])
    BEGIN
        IF EXISTS (SELECT * FROM [Currency], [inserted] WHERE [Currency].[CurrencyCode] = [inserted].[CurrencyCode])
            UPDATE [Sales].[Currency] SET
                [Name] = [inserted].[Name],
                [ModifiedDate] = GetDate()
            FROM [inserted]
            WHERE [Currency].[CurrencyCode] = [inserted].[CurrencyCode]
        ELSE
            INSERT INTO [Sales].[Currency]
            (
                [CurrencyCode],
                [Name]
            )
            SELECT
                [CurrencyCode],
                [Name]
            FROM [inserted];

        INSERT INTO [Sales].[CurrencyRate]
        (
            [CurrencyRateDate],
            [FromCurrencyCode],
            [ToCurrencyCode],
            [AverageRate],
            [EndOfDayRate],
			[ModifiedDate]
        )
        SELECT
            [CurrencyRateDate],
            [FromCurrencyCode],
            [CurrencyCode],
            [AverageRate],
            [EndOfDayRate],
			GetDate()
        FROM [inserted];
    END;

    IF EXISTS (SELECT * FROM [inserted]) AND EXISTS (SELECT * FROM [deleted])
    BEGIN
        UPDATE [CurrencyRate] SET
            [CurrencyRateDate] = [inserted].[CurrencyRateDate],
            [FromCurrencyCode] = [inserted].[FromCurrencyCode],
            [AverageRate] = [inserted].[AverageRate],
            [EndOfDayRate] = [inserted].[EndOfDayRate],
            [ModifiedDate] = GetDate()
        FROM [inserted], 
			 [deleted]
        WHERE [CurrencyRate].[CurrencyRateID] = [deleted].[CurrencyRateID];

        UPDATE [Currency] SET
            [Name] = [inserted].[Name],
            [ModifiedDate] = GetDate()
        FROM [inserted], 
			 [deleted]
        WHERE [Currency].[CurrencyCode] = [deleted].[CurrencyCode];
    END;

    IF EXISTS (SELECT * FROM [deleted]) AND NOT EXISTS(SELECT * FROM [inserted])
    BEGIN
        DELETE [CurrencyRate]
        FROM [Sales].[CurrencyRate] [CurrencyRate],
			 [deleted]
        WHERE [CurrencyRate].[ToCurrencyCode] = [deleted].[CurrencyCode];

        DELETE [Currency]
        FROM [Sales].[Currency] [Currency],
			 [deleted]
        WHERE [Currency].[CurrencyCode] = [deleted].[CurrencyCode];
    END;
END;
GO

/* c. �������� ����� ������ � �������������, ������  ����� ������ ��� Currency 
	� CurrencyRate (������� FromCurrencyCode = �USD�). ������� ������ ��������
	�����  ������  �  �������  Sales.Currency  �  Sales.CurrencyRate. �������� 
	����������� ������ ����� �������������. ������� ������.*/

INSERT INTO [Sales].[CurrencyRateView]
(
    [CurrencyCode],
    [Name],
    [CurrencyRateDate],
    [FromCurrencyCode],
    [AverageRate],
    [EndOfDayRate]
)
VALUES
(
    'Ruu',
    'rub',
    GETDATE(),
    'R',
    2.8,
    3.8
);
GO

UPDATE [Sales].[CurrencyRateView] SET
    [CurrencyRateDate] = GETDATE(),
    [AverageRate] = 9.1,
    [EndOfDayRate] = 6.5
WHERE [CurrencyCode] = 'Ruu';
GO

DELETE FROM [Sales].[CurrencyRateView]
WHERE [CurrencyCode] = 'Ruu';
GO