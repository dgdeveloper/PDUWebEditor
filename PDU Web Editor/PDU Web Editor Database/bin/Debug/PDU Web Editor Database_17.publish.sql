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
PRINT N'Dropping ck_Rec_PDURecordWeight...';


GO
ALTER TABLE [dbo].[tbl_Records] DROP CONSTRAINT [ck_Rec_PDURecordWeight];


GO
PRINT N'Altering [dbo].[tbl_Records]...';


GO
ALTER TABLE [dbo].[tbl_Records]
    ADD [Rec_PDUUniqueId] INT NULL;


GO
PRINT N'Creating fk_Rec_PDUUniqueId...';


GO
ALTER TABLE [dbo].[tbl_Records] WITH NOCHECK
    ADD CONSTRAINT [fk_Rec_PDUUniqueId] FOREIGN KEY ([Rec_PDUUniqueId]) REFERENCES [dbo].[tbl_PDUs] ([Pdu_PDUUniqueId]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating ck_Rec_PDURecordWeight...';


GO
ALTER TABLE [dbo].[tbl_Records] WITH NOCHECK
    ADD CONSTRAINT [ck_Rec_PDURecordWeight] CHECK ([Rec_RecordWeight] BETWEEN 1 AND 5);


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[tbl_Records] WITH CHECK CHECK CONSTRAINT [fk_Rec_PDUUniqueId];

ALTER TABLE [dbo].[tbl_Records] WITH CHECK CHECK CONSTRAINT [ck_Rec_PDURecordWeight];


GO
PRINT N'Update complete.';


GO
