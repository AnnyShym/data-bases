-- ������� 7

USE [AdventureWorks2012];
GO

/* a. �������� � ������� dbo.PersonPhone ���� City ���� nvarchar(30).*/

ALTER TABLE [dbo].[PersonPhone]
ADD [City] NVARCHAR(30);
GO

/* b. �������� ��������� ���������� � ����� �� ���������� ��� dbo.PersonPhone 
	� ��������� �� ������� �� dbo.PersonPhone. ���� City ��������� ���������� 
	��  �������  Person.Address  ����  City,  � ���� PostalCode ���������� �� 
	Person.Address  ����  PostalCode.  ����  ���� PostalCode �������� ����� � 
	��������� ���� ��������� �� ���������.*/

DECLARE @PersonPhoneVar TABLE
(
    [BusinessEntityID] INT NOT NULL,
    [PhoneNumber] Phone NOT NULL,
    [PhoneNumberTypeID] BIGINT NULL,
    [ModifiedDate] DATETIME,
    [PostalCode] NVARCHAR(15) DEFAULT ('0'),
    [City] NVARCHAR(30)
);

INSERT INTO @PersonPhoneVar
(
    [BusinessEntityID],
    [PhoneNumber],
    [PhoneNumberTypeID],
    [ModifiedDate],
    [PostalCode],
    [City]
)
SELECT
    [PP].[BusinessEntityID],
    [PP].[PhoneNumber],
    [PP].[PhoneNumberTypeID],
    [PP].[ModifiedDate],
    IIF ([A].[PostalCode] NOT LIKE '%[^0-9]%', [A].[PostalCode], '0'),
    [A].[City]
FROM [dbo].[PersonPhone] AS [PP]LEFT JOIN [Person].[BusinessEntityAddress] AS [BEA]
    ON ([PP].[BusinessEntityID] = [BEA].[BusinessEntityID]) LEFT JOIN [Person].[Address] AS [A]
    ON ([BEA].[AddressID] = [A].[AddressID]);

/* c. �������� ������ � ����� PostalCode � City � dbo.PersonPhone ������� 
	�� ���������  ����������. �����  ��������  ������ � ���� PhoneNumber. 
	��������  ���  �1 (11)�  ���  ���  ���������, ��� ������� ���� ��� �� 
	������.*/

UPDATE [dbo].[PersonPhone]
SET
    [PersonPhone].[PostalCode] = [PPV].[PostalCode],
    [PersonPhone].[City] = [PPV].[City],
	[PersonPhone].[PhoneNumberTypeID] = [PPV].[PhoneNumberTypeID],
    [PersonPhone].[PhoneNumber]
        = IIF (CHARINDEX('1 (11)', [PPV].PhoneNumber) = 0,
            '1 (11) ' + [PPV].PhoneNumber,
            [PPV].PhoneNumber)
FROM [dbo].[PersonPhone] AS [PP]
JOIN @PersonPhoneVar AS [PPV]
        ON ([PP].[BusinessEntityID] = [PPV].[BusinessEntityID]);
GO

/* d. ������� ������ �� dbo.PersonPhone ��� ����������� ��������, 
	�� ���� ��� PersonType � Person.Person ����� �EM�*/

DELETE [PP]
FROM [dbo].[PersonPhone] [PP] JOIN [Person].[Person] [P]
    ON ([PP].[BusinessEntityID] = [P].[BusinessEntityID])
WHERE [PersonType] = 'EM';
GO

/* e. ������� ���e City �� �������, ������� ��� ��������� ����������� 
	� �������� �� ���������.*/

ALTER TABLE [dbo].[PersonPhone] DROP COLUMN [City];

ALTER TABLE [dbo].[PersonPhone]
DROP CONSTRAINT
    [PK_PersonPhone_BusinessEntityID_PhoneNumber],
    [CK_PersonPhone_PostalCode],
    [DF_PersonPhone_PostalCode];
GO

/* f. ������� ������� dbo.PersonPhone.*/

DROP TABLE [dbo].[PersonPhone];
GO