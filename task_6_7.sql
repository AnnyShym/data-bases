-- Вариант 7

USE [AdventureWorks2012];
GO

/* a. Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
	отображающую  данные  о  количестве  сотрудников  (HumanResources.Employee)  работающих в 
	определенную  смену  (HumanResources.Shift).  Вывести  информацию  необходимо для каждого 
	отдела  (HumanResources.Department).  Список  названий  смен  передайте в процедуру через 
	входной параметр.*/

CREATE PROCEDURE [HumanResources].[EmpCountByShift]
    @Shifts NVARCHAR(500)
AS DECLARE @Query AS NVARCHAR(MAX);
	SET @Query = '
	SELECT
		[DepName],
		' + @Shifts + '
	FROM
	(
		SELECT
			[D].[Name] AS [DepName],
			[S].[Name] AS [ShiftName]
		FROM [HumanResources].[Department] [D] JOIN [HumanResources].[EmployeeDepartmentHistory] [EDH]
			ON [D].[DepartmentID] = [EDH].[DepartmentID]
		JOIN [HumanResources].[Shift] [S]
			ON [EDH].[ShiftID] = [S].[ShiftID]
		WHERE [EndDate] IS NULL
	) AS [SourceTable]
	PIVOT (COUNT([ShiftName]) FOR [ShiftName] IN (' + @Shifts + ')) AS [PivotTable];';
	EXEC (@Query);
GO

EXECUTE [HumanResources].[EmpCountByShift] '[Day],[Evening],[Night]';
GO