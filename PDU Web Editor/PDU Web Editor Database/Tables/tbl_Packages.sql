CREATE TABLE [dbo].[tbl_Packages]
(
	[Pkg_Name] NVARCHAR(255) NOT NULL, 
    [Pkg_UpdateByWho] NVARCHAR(255) NOT NULL, 
    [Pkg_UpdateOnDate] DATETIME2 NOT NULL, 
    [PKg_HospitalityFullAd] NVARCHAR(255) NOT NULL, 
    [Pkg_HospitalityVSplitAd] NVARCHAR(255) NOT NULL, 
    [Pkg_RetailFullAd] NVARCHAR(255) NOT NULL, 
    [Pkg_RetailVSplitAd] NVARCHAR(255) NOT NULL, 
    [Pkg_PkgUniqueId] INT IDENTITY(1,1) NOT NULL, 
    [Pkg_Uri] NVARCHAR(255) NULL, 
    CONSTRAINT [PK_tbl_Packages] PRIMARY KEY ([Pkg_PkgUniqueId]) 
)
