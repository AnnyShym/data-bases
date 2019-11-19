-- ������� 7

USE [AdventureWorks2012];
GO

/* 1. ������� �� ����� ��������� ���� ��������� ��������� 
	 ������ ��� ������� ����������. */

SELECT [Employee].[BusinessEntityID], 
	   [JobTitle],
	   MAX([EmployeePayHistory].[ModifiedDate]) AS [LastRateDate]
FROM [HumanResources].[Employee]
	JOIN [HumanResources].[EmployeePayHistory]
	ON [HumanResources].[Employee].[BusinessEntityID] = [HumanResources].[EmployeePayHistory].[BusinessEntityID]
GROUP BY [Employee].[BusinessEntityID], 
		 [JobTitle];

/* 2. �������  ��  �����  ����������  ���,  ������� ������ 
	 ��������� ���������� � ������ ������. ���� ��������� 
	 �������� � ������ �� ��������� �����, ���������� ��� 
	 �������� �� ������������ ���. */

SELECT [Employee].[BusinessEntityID], 
	   [JobTitle],
	   [Name] AS [DepName],
	   [StartDate],
	   [EndDate],
	   IIF([EndDate] IS NULL, YEAR(GETDATE()) - YEAR([StartDate]), YEAR([EndDate]) - YEAR([StartDate])) AS [Years]
FROM [HumanResources].[EmployeeDepartmentHistory]
	JOIN [HumanResources].[Employee]
	ON [HumanResources].[EmployeeDepartmentHistory].[BusinessEntityID] = [HumanResources].[Employee].[BusinessEntityID]
	JOIN [HumanResources].[Department]
	ON [HumanResources].[EmployeeDepartmentHistory].[DepartmentID] = [HumanResources].[Department].[DepartmentID];

/* 3. �������    ��    �����    ����������   ���   ����   �����������, 
	 �  ���������  ������,  �  �������  ���  ��������   �   ��������� 
	 ������. ������� ����� ������ ����� �� �������� ������ �������. */

SELECT [Employee].[BusinessEntityID],
	   [JobTitle],
	   [Name] AS [DepName],
	   [GroupName],
	   IIF(CHARINDEX(' ', [GroupName]) = 0, [GroupName], SUBSTRING([GroupName], 0, CHARINDEX(' ', [GroupName]))) AS [DepGroup]
FROM [HumanResources].[Employee] 
	JOIN [HumanResources].[EmployeeDepartmentHistory]
	ON [HumanResources].[EmployeeDepartmentHistory].[BusinessEntityID] = [HumanResources].[Employee].[BusinessEntityID]
	JOIN [HumanResources].[Department]
	ON [HumanResources].[EmployeeDepartmentHistory].[DepartmentID] = [HumanResources].[Department].[DepartmentID]
WHERE [EndDate] IS NULL;