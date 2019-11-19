-- ������� 7

USE [AdventureWorks2012];
GO

/* 1. ������� �� ����� ���������� �������, ������� ������ � 
	 ������ �Executive General and Administration�. */

SELECT COUNT(*) AS [DepartmentCount] 
FROM [HumanResources].[Department] 
WHERE [GroupName] = 'Executive General and Administration';

/* 2. ������� �� ����� 5(����) ����� ������� �����������. */

SELECT TOP 5 [BusinessEntityID], 
			 [JobTitle], 
			 [Gender], 
			 [BirthDate] 
FROM [HumanResources].[Employee] 
ORDER BY [BirthDate] DESC;
	
/* 3. ������� �� ����� ������ ����������� �������� ����, 
	 �������� ��  ������  ��  ������� (Tuesday). � ���� 
	 [LoginID]   ��������  �����  �adventure-works�  �� 
	 �adventure-works2012�. */

SELECT [BusinessEntityID], 
	   [JobTitle], 
	   [Gender], 
	   [HireDate],
	   REPLACE([LoginID], 'adventure-works', 'adventure-works2012') As [LoginID]
FROM [HumanResources].[Employee] 
WHERE [Gender] = 'F' 
	  AND DATENAME(weekday, [HireDate]) = 'Tuesday';
