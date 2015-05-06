CREATE TABLE [dbo].[tbl_PDUs]
(
	[Pdu_PDUUniqueId] INT IDENTITY(1,1) NOT NULL, 
    [Pdu_FileName] NVARCHAR(255) NOT NULL, 
    [Pdu_UpdateByWho] NVARCHAR(255) NOT NULL, 
    [Pdu_UpdateOnDate] DATETIME2 NOT NULL, 
    [Pdu_Type] NVARCHAR(25) NOT NULL, 
    [Pdu_ScreenSize] NVARCHAR(50) NOT NULL, 
    CONSTRAINT [pk_Pdu_PDUUniqueId] PRIMARY KEY ([Pdu_PDUUniqueId])
)
