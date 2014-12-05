CREATE TABLE [dbo].[tbl_Assets]
(
    [Ast_FileName] NVARCHAR(255) NOT NULL, 
    [Ast_UpdatedByWho] NVARCHAR(50) NOT NULL, 
    [Ast_UpdatedOnDate] NVARCHAR(50) NOT NULL, 
    [Ast_FileLocation] NVARCHAR(255) NOT NULL, 
    [Ast_ScreenSize] NVARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_Ast_FileName] PRIMARY KEY ([Ast_FileName]) 
)
