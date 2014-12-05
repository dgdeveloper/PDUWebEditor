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
USE [PDUWebEditorDB]
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
USE [PDUWebEditorDB]
GO
DELETE FROM [dbo].[tbl_PDUs]
/****** Object:  Table [dbo].[tbl_PDUs]    Script Date: 08/25/2014 10:55:50 ******/
SET IDENTITY_INSERT [dbo].[tbl_PDUs] ON
INSERT [dbo].[tbl_PDUs] ([Pdu_PDUUniqueId], [Pdu_FileName], [Pdu_UpdateByWho], [Pdu_UpdateOnDate], [Pdu_Type], [Pdu_ScreenSize]) VALUES (16, N'PDUDemo1', N'CONNEX\xiguo', CAST(0x07CFC21D3C54ED380B AS DateTime2), N'Hospitality', N'FullScreen')
INSERT [dbo].[tbl_PDUs] ([Pdu_PDUUniqueId], [Pdu_FileName], [Pdu_UpdateByWho], [Pdu_UpdateOnDate], [Pdu_Type], [Pdu_ScreenSize]) VALUES (17, N'PDUDemo2', N'CONNEX\xiguo', CAST(0x074264333F59ED380B AS DateTime2), N'Hospitality', N'VSplit')
SET IDENTITY_INSERT [dbo].[tbl_PDUs] OFF
-------------------------------------------------------------------LINE BREAK---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate tbl_Records table
USE [PDUWebEditorDB]
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



