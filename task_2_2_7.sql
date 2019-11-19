-- ¬ариант 7

USE [AdventureWorks2012];
GO

/* a. Cоздайте таблицу dbo.PersonPhone с такой же структурой 
	 как Person.PersonPhone, не включа€ индексы, ограничени€
	 и триггеры. */

CREATE TABLE [dbo].[PersonPhone]
(
	[BusinessEntityID] INT NOT NULL,
	[PhoneNumber] PHONE NOT NULL,
	[PhoneNumberTypeID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
);
GO

/* b. »спользу€ инструкцию ALTER TABLE, создайте дл€ таблицы 
	 dbo.PersonPhone  составной  первичный  ключ  из  полей 
	 BusinessEntityID и PhoneNumber. */

ALTER TABLE [dbo].[PersonPhone]
ADD CONSTRAINT [PK_PersonPhone_BusinessEntityID_PhoneNumber] 
PRIMARY KEY ([BusinessEntityID], [PhoneNumber]);
GO

/* c. »спользу€ инструкцию ALTER TABLE, создайте дл€ таблицы
	 dbo.PersonPhone новое поле  PostalCode  nvarchar(15) и 
	 ограничение  дл€  этого  пол€, запрещающее  заполнение 
	 этого пол€ буквами. */

ALTER TABLE [dbo].[PersonPhone]
ADD [PostalCode] NVARCHAR(15)
CONSTRAINT [CK_PersonPhone_PostalCode]
CHECK (LOWER([PostalCode]) LIKE REPLICATE('[^a-z]', LEN([PostalCode])));
GO

/* d. »спользу€  инструкцию ALTER TABLE, создайте дл€  таблицы 
	 dbo.PersonPhone ограничение DEFAULT дл€ пол€ PostalCode, 
	 задайте значение по умолчанию С0Т. */

ALTER TABLE [dbo].[PersonPhone]
ADD CONSTRAINT [DF_PersonPhone_PostalCode]
DEFAULT '0' FOR [PostalCode];
GO

/* e. «аполните новую таблицу данными из Person.PersonPhone, только 
	 контактами с типом СCellТ из таблицы PhoneNumberType. */
	  
INSERT INTO [dbo].[PersonPhone]
(
	[BusinessEntityID],
	[PhoneNumber],
	[PhoneNumberTypeID],
	[ModifiedDate]
)
SELECT 
	[PersonPhone].[BusinessEntityID],
    [PhoneNumber],
    [PersonPhone].[PhoneNumberTypeID],
    [PersonPhone].[ModifiedDate]
FROM 
	[Person].[PersonPhone]
	INNER JOIN [Person].[PhoneNumberType]
        ON ([Person].[PersonPhone].[PhoneNumberTypeID] = [Person].[PhoneNumberType].[PhoneNumberTypeID])
WHERE
    [PhoneNumberType].[Name] = 'Cell';
GO

/* f. »змените тип пол€ PhoneNumberTypeID на bigint и допускающим 
	 NULL значени€. */

ALTER TABLE [dbo].[PersonPhone]
ALTER COLUMN [PhoneNumberTypeID] BIGINT NULL;
GO
