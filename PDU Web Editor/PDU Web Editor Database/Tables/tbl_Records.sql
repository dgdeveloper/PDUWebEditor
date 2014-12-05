CREATE TABLE [dbo].[tbl_Records]
(
	[Rec_RecordId] INT IDENTITY(1,1) NOT NULL, 
    [Rec_RecordName] NVARCHAR(255) NOT NULL, 
    [Rec_RecordStartDate] DATE NOT NULL, 
    [Rec_RecordEndDate] DATE NOT NULL, 
    [Rec_RecordWeight] INT NOT NULL, 
    [Rec_AssetFileName] NVARCHAR(255) NOT NULL, 
	[Rec_PDUUniqueId] INT NOT NULL,
    CONSTRAINT [pk_Rec_PDURecordId] PRIMARY KEY ([Rec_RecordId]), 
    CONSTRAINT [fk_Rec_AssetUniqueId] FOREIGN KEY ([Rec_AssetFileName]) REFERENCES [tbl_Assets]([Ast_FileName]) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [fk_Rec_PDUUniqueId] FOREIGN KEY ([Rec_PDUUniqueId]) REFERENCES [tbl_PDUs]([Pdu_PDUUniqueId]) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [ck_Rec_PDURecordWeight] CHECK ([Rec_RecordWeight] BETWEEN 1 AND 5) 
)
