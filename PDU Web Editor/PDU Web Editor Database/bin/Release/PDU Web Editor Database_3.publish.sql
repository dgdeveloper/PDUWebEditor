﻿/*
Deployment script for PDU Web Editor Database

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "PDU Web Editor Database"
:setvar DefaultFilePrefix "PDU Web Editor Database"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.DEV\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.DEV\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[tbl_PDUs].[Pdu_ScreenSize] on table [dbo].[tbl_PDUs] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[tbl_PDUs])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'The following operation was generated from a refactoring log file 376d0839-17e4-408a-8a08-b4cf5cede0e4';

PRINT N'Rename [dbo].[tbl_Assets].[Ast_FileType] to Ast_ScreenSize';


GO
EXECUTE sp_rename @objname = N'[dbo].[tbl_Assets].[Ast_FileType]', @newname = N'Ast_ScreenSize', @objtype = N'COLUMN';


GO
PRINT N'Dropping [dbo].[ck_Rec_PDURecordWeight]...';


GO
ALTER TABLE [dbo].[tbl_Records] DROP CONSTRAINT [ck_Rec_PDURecordWeight];


GO
PRINT N'Altering [dbo].[tbl_PDUs]...';


GO
ALTER TABLE [dbo].[tbl_PDUs]
    ADD [Pdu_ScreenSize] NVARCHAR (50) NOT NULL;


GO
PRINT N'Creating [dbo].[ck_Rec_PDURecordWeight]...';


GO
ALTER TABLE [dbo].[tbl_Records] WITH NOCHECK
    ADD CONSTRAINT [ck_Rec_PDURecordWeight] CHECK ([Rec_RecordWeight] BETWEEN 1 AND 5);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '376d0839-17e4-408a-8a08-b4cf5cede0e4')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('376d0839-17e4-408a-8a08-b4cf5cede0e4')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[tbl_Records] WITH CHECK CHECK CONSTRAINT [ck_Rec_PDURecordWeight];


GO
PRINT N'Update complete.';


GO
