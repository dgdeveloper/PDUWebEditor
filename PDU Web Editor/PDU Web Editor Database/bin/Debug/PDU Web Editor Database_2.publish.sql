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
The type for column Ast_AssetUniqueId in table [dbo].[tbl_Assets] is currently  UNIQUEIDENTIFIER NOT NULL but is being changed to  INT IDENTITY (1, 1) NOT NULL. There is no implicit or explicit conversion.
*/

IF EXISTS (select top 1 1 from [dbo].[tbl_Assets])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The type for column Pdr_AssetUniqueId in table [dbo].[tbl_PDURecords] is currently  UNIQUEIDENTIFIER NULL but is being changed to  INT NULL. There is no implicit or explicit conversion.

The type for column Pdr_PDURecordId in table [dbo].[tbl_PDURecords] is currently  UNIQUEIDENTIFIER NOT NULL but is being changed to  INT IDENTITY (1, 1) NOT NULL. There is no implicit or explicit conversion.
*/

IF EXISTS (select top 1 1 from [dbo].[tbl_PDURecords])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The type for column Pdr_PDURecordId in table [dbo].[tbl_PDUs] is currently  UNIQUEIDENTIFIER NOT NULL but is being changed to  INT NULL. There is no implicit or explicit conversion.

The type for column Pdu_PDUUniqueId in table [dbo].[tbl_PDUs] is currently  UNIQUEIDENTIFIER NOT NULL but is being changed to  INT IDENTITY (1, 1) NOT NULL. There is no implicit or explicit conversion.
*/

IF EXISTS (select top 1 1 from [dbo].[tbl_PDUs])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Rename refactoring operation with key 92f4f2a5-a197-487e-a302-70a076bf9431 is skipped, element [dbo].[Table1].[Ast_AssetUniqu] (SqlSimpleColumn) will not be renamed to Ast_AssetUniqueId';


GO
PRINT N'Rename refactoring operation with key f001a014-be79-4bbf-91c3-4feeb1120fc6 is skipped, element [dbo].[PK_AssetId] (SqlPrimaryKeyConstraint) will not be renamed to [pk_AssetId]';


GO
PRINT N'Rename refactoring operation with key 9d6eba22-f10e-4b5b-8859-88e1adec6024 is skipped, element [dbo].[tbl_PDURecords].[Id] (SqlSimpleColumn) will not be renamed to Pdr_PDURecordId';


GO
PRINT N'Rename refactoring operation with key 99f98ee4-e729-43ca-be11-3ebf64b75640 is skipped, element [dbo].[pk_tbl_PDURecords] (SqlPrimaryKeyConstraint) will not be renamed to [pk_PDURecordId]';


GO
PRINT N'Rename refactoring operation with key c859ef6e-2c24-4502-a60f-f8bf10f90a13 is skipped, element [dbo].[tbl_PDURecords].[Pdt_AssetUniqueId] (SqlSimpleColumn) will not be renamed to Pdr_AssetUniqueId';


GO
PRINT N'Rename refactoring operation with key b16dcd0b-28d7-4dd6-ba4d-d0f6fba84aa7 is skipped, element [dbo].[tbl_PDUs].[Id] (SqlSimpleColumn) will not be renamed to Pdu_PDUUniqueId';


GO
PRINT N'Rename refactoring operation with key abf76b01-c8e8-4514-b504-582172b4f2a8 is skipped, element [dbo].[pk_] (SqlPrimaryKeyConstraint) will not be renamed to [pk_Pdu_PDUUniqueId]';


GO
PRINT N'Rename refactoring operation with key 70687978-872c-4c7b-b526-e3db8b2d9783 is skipped, element [dbo].[fk_] (SqlForeignKeyConstraint) will not be renamed to [fk_Pdr_PDURecordId]';


GO
PRINT N'Rename refactoring operation with key 51f6a990-d84d-435a-98b5-d9a4d2bb21fe is skipped, element [dbo].[tbl_Assets].[Ast_UpdateByWho] (SqlSimpleColumn) will not be renamed to Ast_UpdatedByWho';


GO
PRINT N'Rename refactoring operation with key c32cf349-a116-42e9-bec3-2c2e39dcf6be is skipped, element [dbo].[tbl_Assets].[Ast_UpdateOnDate] (SqlSimpleColumn) will not be renamed to Ast_UpdatedOnDate';


GO
PRINT N'Dropping fk_AssetUinqueId...';


GO
ALTER TABLE [dbo].[tbl_PDURecords] DROP CONSTRAINT [fk_AssetUinqueId];


GO
PRINT N'Starting rebuilding table [dbo].[tbl_Assets]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tbl_Assets] (
    [Ast_AssetUniqueId] INT            IDENTITY (1, 1) NOT NULL,
    [Ast_AssetFileName] NVARCHAR (255) NOT NULL,
    [Ast_UpdatedByWho]  NVARCHAR (50)  NOT NULL,
    [Ast_UpdatedOnDate] DATE           NOT NULL,
    [Ast_FileLocation]  NVARCHAR (255) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_pk_AssetId] PRIMARY KEY CLUSTERED ([Ast_AssetUniqueId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tbl_Assets])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tbl_Assets] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tbl_Assets] ([Ast_AssetUniqueId], [Ast_AssetFileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation])
        SELECT   [Ast_AssetUniqueId],
                 [Ast_AssetFileName],
                 [Ast_UpdatedByWho],
                 [Ast_UpdatedOnDate],
                 [Ast_FileLocation]
        FROM     [dbo].[tbl_Assets]
        ORDER BY [Ast_AssetUniqueId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tbl_Assets] OFF;
    END

DROP TABLE [dbo].[tbl_Assets];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tbl_Assets]', N'tbl_Assets';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_pk_AssetId]', N'pk_AssetId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[tbl_PDURecords]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tbl_PDURecords] (
    [Pdr_PDURecordId]        INT            IDENTITY (1, 1) NOT NULL,
    [Pdr_PDURecordName]      NVARCHAR (255) NOT NULL,
    [Pdr_PDURecordStartDate] DATE           NOT NULL,
    [Pdr_PDURecordEndDate]   DATE           NOT NULL,
    [Pdr_PDURecordWeight]    INT            NOT NULL,
    [Pdr_AssetUniqueId]      INT            NULL,
    CONSTRAINT [tmp_ms_xx_constraint_pk_PDURecordId] PRIMARY KEY CLUSTERED ([Pdr_PDURecordId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tbl_PDURecords])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tbl_PDURecords] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tbl_PDURecords] ([Pdr_PDURecordId], [Pdr_PDURecordName], [Pdr_PDURecordStartDate], [Pdr_PDURecordEndDate], [Pdr_PDURecordWeight], [Pdr_AssetUniqueId])
        SELECT   [Pdr_PDURecordId],
                 [Pdr_PDURecordName],
                 [Pdr_PDURecordStartDate],
                 [Pdr_PDURecordEndDate],
                 [Pdr_PDURecordWeight],
                 [Pdr_AssetUniqueId]
        FROM     [dbo].[tbl_PDURecords]
        ORDER BY [Pdr_PDURecordId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tbl_PDURecords] OFF;
    END

DROP TABLE [dbo].[tbl_PDURecords];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tbl_PDURecords]', N'tbl_PDURecords';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_pk_PDURecordId]', N'pk_PDURecordId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[tbl_PDUs]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_tbl_PDUs] (
    [Pdu_PDUUniqueId]     INT            IDENTITY (1, 1) NOT NULL,
    [Pdu_PDUFileName]     NVARCHAR (255) NOT NULL,
    [Pdu_PDUUpdateByWho]  NVARCHAR (255) NOT NULL,
    [Pdu_PDUUpdateOnDate] DATE           NOT NULL,
    [Pdu_PDUType]         NVARCHAR (25)  NOT NULL,
    [Pdr_PDURecordId]     INT            NULL,
    CONSTRAINT [tmp_ms_xx_constraint_pk_Pdu_PDUUniqueId] PRIMARY KEY CLUSTERED ([Pdu_PDUUniqueId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[tbl_PDUs])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tbl_PDUs] ON;
        INSERT INTO [dbo].[tmp_ms_xx_tbl_PDUs] ([Pdu_PDUUniqueId], [Pdu_PDUFileName], [Pdu_PDUUpdateByWho], [Pdu_PDUUpdateOnDate], [Pdu_PDUType], [Pdr_PDURecordId])
        SELECT   [Pdu_PDUUniqueId],
                 [Pdu_PDUFileName],
                 [Pdu_PDUUpdateByWho],
                 [Pdu_PDUUpdateOnDate],
                 [Pdu_PDUType],
                 [Pdr_PDURecordId]
        FROM     [dbo].[tbl_PDUs]
        ORDER BY [Pdu_PDUUniqueId] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_tbl_PDUs] OFF;
    END

DROP TABLE [dbo].[tbl_PDUs];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_tbl_PDUs]', N'tbl_PDUs';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_pk_Pdu_PDUUniqueId]', N'pk_Pdu_PDUUniqueId', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating fk_AssetUinqueId...';


GO
ALTER TABLE [dbo].[tbl_PDURecords] WITH NOCHECK
    ADD CONSTRAINT [fk_AssetUinqueId] FOREIGN KEY ([Pdr_AssetUniqueId]) REFERENCES [dbo].[tbl_Assets] ([Ast_AssetUniqueId]) ON DELETE SET NULL ON UPDATE CASCADE;


GO
PRINT N'Creating fk_Pdr_PDURecordId...';


GO
ALTER TABLE [dbo].[tbl_PDUs] WITH NOCHECK
    ADD CONSTRAINT [fk_Pdr_PDURecordId] FOREIGN KEY ([Pdr_PDURecordId]) REFERENCES [dbo].[tbl_PDURecords] ([Pdr_PDURecordId]) ON DELETE SET NULL ON UPDATE CASCADE;


GO
PRINT N'Creating ck_PDURecordWeight...';


GO
ALTER TABLE [dbo].[tbl_PDURecords] WITH NOCHECK
    ADD CONSTRAINT [ck_PDURecordWeight] CHECK (Pdr_PDURecordWeight BETWEEN 1 AND 5);


GO
-- Refactoring step to update target server with deployed transaction logs

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '92f4f2a5-a197-487e-a302-70a076bf9431')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('92f4f2a5-a197-487e-a302-70a076bf9431')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'f001a014-be79-4bbf-91c3-4feeb1120fc6')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('f001a014-be79-4bbf-91c3-4feeb1120fc6')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '9d6eba22-f10e-4b5b-8859-88e1adec6024')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('9d6eba22-f10e-4b5b-8859-88e1adec6024')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '99f98ee4-e729-43ca-be11-3ebf64b75640')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('99f98ee4-e729-43ca-be11-3ebf64b75640')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c859ef6e-2c24-4502-a60f-f8bf10f90a13')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c859ef6e-2c24-4502-a60f-f8bf10f90a13')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b16dcd0b-28d7-4dd6-ba4d-d0f6fba84aa7')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b16dcd0b-28d7-4dd6-ba4d-d0f6fba84aa7')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'abf76b01-c8e8-4514-b504-582172b4f2a8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('abf76b01-c8e8-4514-b504-582172b4f2a8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '70687978-872c-4c7b-b526-e3db8b2d9783')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('70687978-872c-4c7b-b526-e3db8b2d9783')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '51f6a990-d84d-435a-98b5-d9a4d2bb21fe')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('51f6a990-d84d-435a-98b5-d9a4d2bb21fe')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c32cf349-a116-42e9-bec3-2c2e39dcf6be')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c32cf349-a116-42e9-bec3-2c2e39dcf6be')

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[tbl_PDURecords] WITH CHECK CHECK CONSTRAINT [fk_AssetUinqueId];

ALTER TABLE [dbo].[tbl_PDUs] WITH CHECK CHECK CONSTRAINT [fk_Pdr_PDURecordId];

ALTER TABLE [dbo].[tbl_PDURecords] WITH CHECK CHECK CONSTRAINT [ck_PDURecordWeight];


GO
PRINT N'Update complete.';


GO
