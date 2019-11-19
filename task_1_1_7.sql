-- Вариант 7

CREATE DATABASE [AnnyShym];
GO

USE [AnnyShym];
GO

CREATE SCHEMA [scales];
GO

CREATE SCHEMA [persons];
GO

CREATE TABLE [scales].[Orders] ([OrderNum] INT NULL);
GO

BACKUP DATABASE [AnnyShym] TO DISK = 'c:\tmp\AnnyShym.bak';
GO

USE [master];
GO

DROP DATABASE [AnnyShym];
GO

RESTORE DATABASE [AnnyShym] FROM DISK = 'c:\tmp\AnnyShym.bak';
GO