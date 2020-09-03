DROP TABLE [dbo].[StatusMaster]
GO
CREATE TABLE [dbo].[StatusMaster]
(
[STATUSID] [int] NOT NULL IDENTITY(1, 1),
[STATUSCODE] [nvarchar] (20)  NOT NULL,
[DISCRIPTION] [nvarchar] (120) NOT NULL,
[TYPEID] [int]  NOT NULL,
[ISACTIVE] [bit] NULL DEFAULT ((1)),
[CREATEDON] [datetime]  NULL ,
[CREATEDBY] [int]  NULL ,
[UPDATEDON] [datetime]  NULL , 
[UPDATEDBY] [int]  NULL 

) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatusMaster] ADD CONSTRAINT [PK_StatusMaster] PRIMARY KEY CLUSTERED  ([TYPEID]) ON [PRIMARY]
 GO
 ALTER TABLE [dbo].[StatusMaster] ADD CONSTRAINT [FK_StatusMaster_C] FOREIGN KEY ([TYPEID]) REFERENCES [dbo].[StatusTypeMaster] ([TYPEID])
