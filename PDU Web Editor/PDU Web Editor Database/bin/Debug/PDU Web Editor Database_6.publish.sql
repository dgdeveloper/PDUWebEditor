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
PRINT N'Dropping ck_PDURecordWeight...';


GO
ALTER TABLE [dbo].[tbl_PDURecords] DROP CONSTRAINT [ck_PDURecordWeight];


GO
PRINT N'Creating ck_PDURecordWeight...';


GO
ALTER TABLE [dbo].[tbl_PDURecords] WITH NOCHECK
    ADD CONSTRAINT [ck_PDURecordWeight] CHECK (Pdr_PDURecordWeight BETWEEN 1 AND 5);


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[tbl_PDURecords] WITH CHECK CHECK CONSTRAINT [ck_PDURecordWeight];


GO
PRINT N'Update complete.';


GO