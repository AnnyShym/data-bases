-- ������� 7

USE [AdventureWorks2012];
GO

/* a. C������� ������� dbo.PersonPhone � ����� �� ���������� 
	 ��� Person.PersonPhone, �� ������� �������, �����������
	 � ��������. */

CREATE TABLE [dbo].[PersonPhone]
(
	[BusinessEntityID] INT NOT NULL,
	[PhoneNumber] PHONE NOT NULL,
	[PhoneNumberTypeID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
);
GO

/* b. ��������� ���������� ALTER TABLE, �������� ��� ������� 
	 dbo.PersonPhone  ���������  ���������  ����  ��  ����� 
	 BusinessEntityID � PhoneNumber. */

ALTER TABLE [dbo].[PersonPhone]
ADD CONSTRAINT [PK_PersonPhone_BusinessEntityID_PhoneNumber] 
PRIMARY KEY ([BusinessEntityID], [PhoneNumber]);
GO

/* c. ��������� ���������� ALTER TABLE, �������� ��� �������
	 dbo.PersonPhone ����� ����  PostalCode  nvarchar(15) � 
	 �����������  ���  �����  ����, �����������  ���������� 
	 ����� ���� �������. */

ALTER TABLE [dbo].[PersonPhone]
ADD [PostalCode] NVARCHAR(15)
CONSTRAINT [CK_PersonPhone_PostalCode]
CHECK (LOWER([PostalCode]) LIKE REPLICATE('[^a-z]', LEN([PostalCode])));
GO

/* d. ���������  ���������� ALTER TABLE, �������� ���  ������� 
	 dbo.PersonPhone ����������� DEFAULT ��� ���� PostalCode, 
	 ������� �������� �� ��������� �0�. */

ALTER TABLE [dbo].[PersonPhone]
ADD CONSTRAINT [DF_PersonPhone_PostalCode]
DEFAULT '0' FOR [PostalCode];
GO

/* e. ��������� ����� ������� ������� �� Person.PersonPhone, ������ 
	 ���������� � ����� �Cell� �� ������� PhoneNumberType. */
	  
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

/* f. �������� ��� ���� PhoneNumberTypeID �� bigint � ����������� 
	 NULL ��������. */

ALTER TABLE [dbo].[PersonPhone]
ALTER COLUMN [PhoneNumberTypeID] BIGINT NULL;
GO
