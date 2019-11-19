-- Вариант 7

USE [AdventureWorks2012];
GO

/* 1. Вывести на экран последнюю дату изменения почасовой 
	 ставки для каждого сотрудника. */

SELECT [Employee].[BusinessEntityID], 
	   [JobTitle],
	   MAX([EmployeePayHistory].[ModifiedDate]) AS [LastRateDate]
FROM [HumanResources].[Employee]
	JOIN [HumanResources].[EmployeePayHistory]
	ON [HumanResources].[Employee].[BusinessEntityID] = [HumanResources].[EmployeePayHistory].[BusinessEntityID]
GROUP BY [Employee].[BusinessEntityID], 
		 [JobTitle];

/* 2. Вывести  на  экран  количество  лет,  которые каждый 
	 сотрудник проработал в каждом отделе. Если сотрудник 
	 работает в отделе по настоящее время, количество лет 
	 считайте до сегодняшнего дня. */

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

/* 3. Вывести    на    экран    информацию   обо   всех   сотрудниках, 
	 с  указанием  отдела,  в  котором  они  работают   в   настоящий 
	 момент. Вывести также первое слово из названия группы отделов. */

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