-- Вариант 7

USE [AdventureWorks2012];
GO

/* a. Добавьте в таблицу dbo.PersonPhone поле City типа nvarchar(30).*/

ALTER TABLE [dbo].[PersonPhone]
ADD [City] NVARCHAR(30);
GO

/* b. Объявите табличную переменную с такой же структурой как dbo.PersonPhone 
	и заполните ее данными из dbo.PersonPhone. Поле City заполните значениями 
	из  таблицы  Person.Address  поля  City,  а поле PostalCode значениями из 
	Person.Address  поля  PostalCode.  Если  поле PostalCode содержит буквы — 
	заполните поле значением по умолчанию.*/

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

/* c. Обновите данные в полях PostalCode и City в dbo.PersonPhone данными 
	из табличной  переменной. Также  обновите  данные в поле PhoneNumber. 
	Добавьте  код  ‘1 (11)’  для  тех  телефонов, для которых этот код не 
	указан.*/

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

/* d. Удалите данные из dbo.PersonPhone для сотрудников компании, 
	то есть где PersonType в Person.Person равен ‘EM’*/

DELETE [PP]
FROM [dbo].[PersonPhone] [PP] JOIN [Person].[Person] [P]
    ON ([PP].[BusinessEntityID] = [P].[BusinessEntityID])
WHERE [PersonType] = 'EM';
GO

/* e. Удалите полe City из таблицы, удалите все созданные ограничения 
	и значения по умолчанию.*/

ALTER TABLE [dbo].[PersonPhone] DROP COLUMN [City];

ALTER TABLE [dbo].[PersonPhone]
DROP CONSTRAINT
    [PK_PersonPhone_BusinessEntityID_PhoneNumber],
    [CK_PersonPhone_PostalCode],
    [DF_PersonPhone_PostalCode];
GO

/* f. Удалите таблицу dbo.PersonPhone.*/

DROP TABLE [dbo].[PersonPhone];
GO