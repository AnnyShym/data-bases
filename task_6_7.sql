-- ������� 7

USE [AdventureWorks2012];
GO

/* a. �������� �������� ���������, ������� ����� ���������� ������� ������� (�������� PIVOT), 
	������������  ������  �  ����������  �����������  (HumanResources.Employee)  ���������� � 
	������������  �����  (HumanResources.Shift).  �������  ����������  ���������� ��� ������� 
	������  (HumanResources.Department).  ������  ��������  ����  ��������� � ��������� ����� 
	������� ��������.*/

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