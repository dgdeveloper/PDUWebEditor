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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Creating $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Creating [dbo].[tbl_Assets]...';


GO
CREATE TABLE [dbo].[tbl_Assets] (
    [Ast_FileName]      NVARCHAR (255) NOT NULL,
    [Ast_UpdatedByWho]  NVARCHAR (50)  NOT NULL,
    [Ast_UpdatedOnDate] NVARCHAR (50)  NOT NULL,
    [Ast_FileLocation]  NVARCHAR (255) NOT NULL,
    [Ast_ScreenSize]    NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_Ast_FileName] PRIMARY KEY CLUSTERED ([Ast_FileName] ASC)
);


GO
PRINT N'Creating [dbo].[tbl_PDUs]...';


GO
CREATE TABLE [dbo].[tbl_PDUs] (
    [Pdu_PDUUniqueId]  INT            IDENTITY (1, 1) NOT NULL,
    [Pdu_FileName]     NVARCHAR (255) NOT NULL,
    [Pdu_UpdateByWho]  NVARCHAR (255) NOT NULL,
    [Pdu_UpdateOnDate] DATETIME2 (7)  NOT NULL,
    [Pdu_Type]         NVARCHAR (25)  NOT NULL,
    [Pdu_ScreenSize]   NVARCHAR (50)  NOT NULL,
    CONSTRAINT [pk_Pdu_PDUUniqueId] PRIMARY KEY CLUSTERED ([Pdu_PDUUniqueId] ASC)
);


GO
PRINT N'Creating [dbo].[tbl_Records]...';


GO
CREATE TABLE [dbo].[tbl_Records] (
    [Rec_RecordId]        INT            IDENTITY (1, 1) NOT NULL,
    [Rec_RecordName]      NVARCHAR (255) NOT NULL,
    [Rec_RecordStartDate] DATE           NOT NULL,
    [Rec_RecordEndDate]   DATE           NOT NULL,
    [Rec_RecordWeight]    INT            NOT NULL,
    [Rec_AssetFileName]   NVARCHAR (255) NOT NULL,
    [Rec_PDUUniqueId]     INT            NOT NULL,
    CONSTRAINT [pk_Rec_PDURecordId] PRIMARY KEY CLUSTERED ([Rec_RecordId] ASC)
);


GO
PRINT N'Creating [dbo].[fk_Rec_AssetUniqueId]...';


GO
ALTER TABLE [dbo].[tbl_Records]
    ADD CONSTRAINT [fk_Rec_AssetUniqueId] FOREIGN KEY ([Rec_AssetFileName]) REFERENCES [dbo].[tbl_Assets] ([Ast_FileName]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating [dbo].[fk_Rec_PDUUniqueId]...';


GO
ALTER TABLE [dbo].[tbl_Records]
    ADD CONSTRAINT [fk_Rec_PDUUniqueId] FOREIGN KEY ([Rec_PDUUniqueId]) REFERENCES [dbo].[tbl_PDUs] ([Pdu_PDUUniqueId]) ON DELETE CASCADE ON UPDATE CASCADE;


GO
PRINT N'Creating [dbo].[ck_Rec_PDURecordWeight]...';


GO
ALTER TABLE [dbo].[tbl_Records]
    ADD CONSTRAINT [ck_Rec_PDURecordWeight] CHECK ([Rec_RecordWeight] BETWEEN 1 AND 5);


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
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '527152cb-7341-40ab-b217-3a558480b732')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('527152cb-7341-40ab-b217-3a558480b732')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fd03957c-3bb1-47e3-8174-8e7ba81b35c7')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fd03957c-3bb1-47e3-8174-8e7ba81b35c7')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4e683407-405b-4ef0-9121-a682f7f1ac16')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4e683407-405b-4ef0-9121-a682f7f1ac16')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2c72fd85-fc06-4dbe-9f3c-0c4b0f267bfa')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2c72fd85-fc06-4dbe-9f3c-0c4b0f267bfa')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dfd64c44-0a74-4ed6-8d86-233e2c58835f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dfd64c44-0a74-4ed6-8d86-233e2c58835f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd5a8ee14-6de3-4541-9f36-4b4487355bad')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d5a8ee14-6de3-4541-9f36-4b4487355bad')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b3aa203d-d1a6-4e5a-a1be-c5f1d2191ea3')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b3aa203d-d1a6-4e5a-a1be-c5f1d2191ea3')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7d02cc58-6ab2-4818-86f8-8abe738a40a8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7d02cc58-6ab2-4818-86f8-8abe738a40a8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '88c3c5ed-959a-4d11-8be6-1a8c8daf816c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('88c3c5ed-959a-4d11-8be6-1a8c8daf816c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5d224fe9-e5cd-46c5-99b3-5a581230807d')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5d224fe9-e5cd-46c5-99b3-5a581230807d')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e9d75f37-077e-42a0-9c56-61f25ccf01db')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e9d75f37-077e-42a0-9c56-61f25ccf01db')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2760c7cc-7ccb-4938-91e6-90085397e4e9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2760c7cc-7ccb-4938-91e6-90085397e4e9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c6704492-7cc2-4fb3-a1d9-b1ece012f344')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c6704492-7cc2-4fb3-a1d9-b1ece012f344')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4eadc249-52e3-43ca-b2c1-44168be8c065')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4eadc249-52e3-43ca-b2c1-44168be8c065')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7cc18a33-d2ea-469f-9656-ea4d1a8691e0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7cc18a33-d2ea-469f-9656-ea4d1a8691e0')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '95c45857-5e03-4c59-9fff-4f5b2a447575')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('95c45857-5e03-4c59-9fff-4f5b2a447575')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'ceb7672c-1475-4fd5-a305-1809c52bd4e8')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('ceb7672c-1475-4fd5-a305-1809c52bd4e8')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '0770f994-eb44-40b6-84fc-2a15c2e8dd49')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('0770f994-eb44-40b6-84fc-2a15c2e8dd49')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '5f8fda53-c3ad-4a98-bb6d-9199093e782b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('5f8fda53-c3ad-4a98-bb6d-9199093e782b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'b28a28a9-fe7b-4d55-a271-0ea4a676e74f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('b28a28a9-fe7b-4d55-a271-0ea4a676e74f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a4bfb31a-82e1-4894-8cfc-d7dab7643b73')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a4bfb31a-82e1-4894-8cfc-d7dab7643b73')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'a53efcfc-a31a-49eb-9564-c74975d49bd4')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('a53efcfc-a31a-49eb-9564-c74975d49bd4')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '658172ab-770e-4b3a-9fdc-62ae66145c14')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('658172ab-770e-4b3a-9fdc-62ae66145c14')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '26f186d2-b824-47a3-ac52-1b194a9a2966')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('26f186d2-b824-47a3-ac52-1b194a9a2966')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'af621c2f-3868-461c-8e00-0121ec84acfa')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('af621c2f-3868-461c-8e00-0121ec84acfa')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '6312725b-7bc9-40a9-8d97-4258e7777cef')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('6312725b-7bc9-40a9-8d97-4258e7777cef')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c11dd960-0933-499b-9f9d-8fdd2676278b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c11dd960-0933-499b-9f9d-8fdd2676278b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '779ded8f-d77d-42e2-9a64-248fce2d08e9')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('779ded8f-d77d-42e2-9a64-248fce2d08e9')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '7e84a9ea-2858-401d-afdb-22dbe1cd5172')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('7e84a9ea-2858-401d-afdb-22dbe1cd5172')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '072dfdf4-45d4-48f8-aecf-90591c02f950')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('072dfdf4-45d4-48f8-aecf-90591c02f950')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '1d75fae7-6614-4156-a618-69bbc42cccdc')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('1d75fae7-6614-4156-a618-69bbc42cccdc')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'c056e162-5454-4eab-be52-884b620884bb')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('c056e162-5454-4eab-be52-884b620884bb')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '22dfb69f-4509-4c3b-bf23-8693c69199e5')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('22dfb69f-4509-4c3b-bf23-8693c69199e5')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '376d0839-17e4-408a-8a08-b4cf5cede0e4')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('376d0839-17e4-408a-8a08-b4cf5cede0e4')

GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
/**
* Populate PDU web editor db with default data which include 2 pdu demo releases
*/

--Populate tbl_Assets table
USE [PDU Web Editor Database]
GO
DELETE FROM [dbo].[tbl_Assets]
/****** Object:  Table [dbo].[tbl_Assets]    Script Date: 08/25/2014 10:50:22 ******/
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'BC5050_DailyDraws_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:30:43 PM', N'Animations/Ads/BC5050_DailyDraws_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'BC5050_DailyDraws_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:19:36 AM', N'Images/VSplitAds/BC5050_DailyDraws_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'BigLottoPromo_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:17:32 AM', N'Images/VSplitAds/BigLottoPromo_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'GS_Budget_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:22 PM', N'Animations/Ads/GS_Budget_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'GS_Budget_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:18:15 AM', N'Images/VSplitAds/GS_Budget_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'GS_Lucky_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:16 PM', N'Animations/Ads/GS_Lucky_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'GS_Lucky_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:18:05 AM', N'Images/VSplitAds/GS_Lucky_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'GS_Odds_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:10 PM', N'Animations/Ads/GS_Odds_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'GS_Odds_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:17:58 AM', N'Images/VSplitAds/GS_Odds_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'KenoBonus_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:30:36 PM', N'Animations/Ads/KenoBonus_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'KenoBonus_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:19:13 AM', N'Images/VSplitAds/KenoBonus_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'LM_12Pkg_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:53 PM', N'Animations/Ads/LM_12Pkg_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'LM_12Pkg_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:18:47 AM', N'Images/VSplitAds/LM_12Pkg_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'LM_20Pkg_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:33 PM', N'Animations/Ads/LM_20Pkg_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'LM_20Pkg_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:18:29 AM', N'Images/VSplitAds/LM_20Pkg_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'LM_40Pkg_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:38 PM', N'Animations/Ads/LM_40Pkg_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'LM_40Pkg_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:18:37 AM', N'Images/VSplitAds/LM_40Pkg_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'Mobile_PDU_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:30:28 PM', N'Animations/Ads/Mobile_PDU_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'Mobile_PDU_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:19:19 AM', N'Images/VSplitAds/Mobile_PDU_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'PHEP_BadBeat_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:30:54 PM', N'Animations/Ads/PHEP_BadBeat_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'PHEP_BadBeat_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:19:43 AM', N'Images/VSplitAds/PHEP_BadBeat_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'ProbGam_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:30:12 PM', N'Animations/Ads/ProbGam_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'ProbGam_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:18:58 AM', N'Images/VSplitAds/ProbGam_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'SA_mobile_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:30:22 PM', N'Animations/Ads/SA_mobile_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'SA_mobile_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:19:04 AM', N'Images/VSplitAds/SA_mobile_Half.swf', N'VSplit')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'SuperDraw_Full.swf', N'CONNEX\xiguo', N'8/22/2014 4:29:01 PM', N'Animations/Ads/SuperDraw_Full.swf', N'FullScreen')
INSERT [dbo].[tbl_Assets] ([Ast_FileName], [Ast_UpdatedByWho], [Ast_UpdatedOnDate], [Ast_FileLocation], [Ast_ScreenSize]) VALUES (N'SuperDraw_Half.swf', N'CONNEX\xiguo', N'8/25/2014 10:17:45 AM', N'Images/VSplitAds/SuperDraw_Half.swf', N'VSplit')

-------------------------------------------------------------------LINE BREAK---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate tbl_PDUs table
USE [PDU Web Editor Database]
GO
DELETE FROM [dbo].[tbl_PDUs]
/****** Object:  Table [dbo].[tbl_PDUs]    Script Date: 08/25/2014 10:55:50 ******/
SET IDENTITY_INSERT [dbo].[tbl_PDUs] ON
INSERT [dbo].[tbl_PDUs] ([Pdu_PDUUniqueId], [Pdu_FileName], [Pdu_UpdateByWho], [Pdu_UpdateOnDate], [Pdu_Type], [Pdu_ScreenSize]) VALUES (16, N'PDUDemo1', N'CONNEX\xiguo', CAST(0x07CFC21D3C54ED380B AS DateTime2), N'Hospitality', N'FullScreen')
INSERT [dbo].[tbl_PDUs] ([Pdu_PDUUniqueId], [Pdu_FileName], [Pdu_UpdateByWho], [Pdu_UpdateOnDate], [Pdu_Type], [Pdu_ScreenSize]) VALUES (17, N'PDUDemo2', N'CONNEX\xiguo', CAST(0x074264333F59ED380B AS DateTime2), N'Hospitality', N'VSplit')
SET IDENTITY_INSERT [dbo].[tbl_PDUs] OFF
-------------------------------------------------------------------LINE BREAK---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate tbl_Records table
USE [PDU Web Editor Database]
GO
DELETE FROM [dbo].[tbl_Records]
/****** Object:  Table [dbo].[tbl_Records]    Script Date: 08/25/2014 10:57:26 ******/
SET IDENTITY_INSERT [dbo].[tbl_Records] ON
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (52, N'649 SuperDraw-June1-27.2014', CAST(0x98380B00 AS Date), CAST(0xB2380B00 AS Date), 5, N'SuperDraw_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (53, N'GameSense-Odds-June2-July7.2014', CAST(0x99380B00 AS Date), CAST(0xBC380B00 AS Date), 1, N'GS_Odds_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (54, N'GameSense-Lucky-July7-Aug11.2014', CAST(0xBC380B00 AS Date), CAST(0xDF380B00 AS Date), 1, N'GS_Lucky_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (55, N'GameSense-Budget-Aug11-Sept8.2014', CAST(0xDF380B00 AS Date), CAST(0xFB380B00 AS Date), 1, N'GS_Budget_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (56, N'LM Pkg$20-June2-July7.2014', CAST(0x99380B00 AS Date), CAST(0xBC380B00 AS Date), 3, N'LM_20Pkg_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (57, N'LM Pkg$40-July7-Aug11.2014', CAST(0xBC380B00 AS Date), CAST(0xDF380B00 AS Date), 2, N'LM_40Pkg_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (58, N'LM Pkg$12-Aug11-Sept8.2014', CAST(0xDF380B00 AS Date), CAST(0xFB380B00 AS Date), 2, N'LM_12Pkg_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (59, N'ProblemGambling June2-July6.2014', CAST(0x99380B00 AS Date), CAST(0xBB380B00 AS Date), 1, N'ProbGam_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (60, N'Sports Action-Mobile PDU', CAST(0xEA380B00 AS Date), CAST(0xEB380B00 AS Date), 3, N'SA_mobile_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (61, N'Mobile PDU - Subscription', CAST(0xEA380B00 AS Date), CAST(0xEB380B00 AS Date), 3, N'Mobile_PDU_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (62, N'KenoBonus-May6-July29', CAST(0x7E380B00 AS Date), CAST(0xD2380B00 AS Date), 5, N'KenoBonus_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (63, N'BC5050-Daily Draws', CAST(0xEA380B00 AS Date), CAST(0xEB380B00 AS Date), 2, N'BC5050_DailyDraws_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (64, N'PHEP - BadBeat', CAST(0xEA380B00 AS Date), CAST(0xEB380B00 AS Date), 2, N'PHEP_BadBeat_Full.swf', 16)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (65, N'BigLottoPromo-May5-June2.2014', CAST(0x7D380B00 AS Date), CAST(0x99380B00 AS Date), 2, N'BigLottoPromo_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (66, N'649 SuperDraw-June1-27.2014', CAST(0x98380B00 AS Date), CAST(0xB2380B00 AS Date), 5, N'SuperDraw_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (67, N'GameSense-Odds-June2-July7.2014', CAST(0x99380B00 AS Date), CAST(0xBC380B00 AS Date), 1, N'GS_Odds_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (68, N'ameSense-Lucky-July7-Aug11.2014', CAST(0xBC380B00 AS Date), CAST(0xDF380B00 AS Date), 1, N'GS_Lucky_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (69, N'GameSense-Budget-Aug11-Sept8.2014', CAST(0xDF380B00 AS Date), CAST(0xFB380B00 AS Date), 1, N'GS_Budget_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (70, N'Lotto Max-20Pkg-June2-July7.2014', CAST(0x99380B00 AS Date), CAST(0xBC380B00 AS Date), 2, N'LM_20Pkg_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (71, N'Lotto Max-40Pkg-July7-Aug11.2014', CAST(0xBC380B00 AS Date), CAST(0xDF380B00 AS Date), 2, N'LM_40Pkg_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (72, N'Lotto Max-12Pkg-Aug11-Sept8.2014', CAST(0xDF380B00 AS Date), CAST(0xFB380B00 AS Date), 2, N'LM_12Pkg_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (73, N'Problem Gambling-Jun2-July6', CAST(0x99380B00 AS Date), CAST(0xBB380B00 AS Date), 1, N'ProbGam_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (74, N'Sports Action - Mobile PDU', CAST(0xED380B00 AS Date), CAST(0xED380B00 AS Date), 3, N'SA_mobile_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (75, N'Keno Bonus-May6-July29', CAST(0x7E380B00 AS Date), CAST(0xD2380B00 AS Date), 5, N'KenoBonus_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (76, N'Mobile PDU - Subscriptions', CAST(0xED380B00 AS Date), CAST(0xED380B00 AS Date), 3, N'Mobile_PDU_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (77, N'BC5050-Daily Draws', CAST(0xED380B00 AS Date), CAST(0xED380B00 AS Date), 2, N'BC5050_DailyDraws_Half.swf', 17)
INSERT [dbo].[tbl_Records] ([Rec_RecordId], [Rec_RecordName], [Rec_RecordStartDate], [Rec_RecordEndDate], [Rec_RecordWeight], [Rec_AssetFileName], [Rec_PDUUniqueId]) VALUES (78, N'PHEP-BadBeat', CAST(0xED380B00 AS Date), CAST(0xED380B00 AS Date), 2, N'PHEP_BadBeat_Half.swf', 17)
SET IDENTITY_INSERT [dbo].[tbl_Records] OFF

-------------------------------------------------------------------LINE BREAK---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Update complete.';


GO
