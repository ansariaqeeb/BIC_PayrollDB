DROP TABLE [dbo].[StatusMaster]
GO
CREATE TABLE [dbo].[StatusMaster]
(
[STATUSID] [int] NOT NULL,
[STATUSCODE] [nvarchar] (30) NOT NULL,
[DISCRIPTION] [nvarchar] (120) NOT NULL,
[TYPEID] [int] NOT NULL,
[ISACTIVE] [bit] NULL CONSTRAINT [DF__StatusMas__ISACT__3B40CD36] DEFAULT ((1)),
[CREATEDON] [datetime] NULL,
[CREATEDBY] [int] NULL,
[UPDATEDON] [datetime] NULL,
[UPDATEDBY] [int] NULL
) ON [PRIMARY]
GO 
ALTER TABLE [dbo].[StatusMaster] ADD CONSTRAINT [FK_StatusMaster_C] FOREIGN KEY ([TYPEID]) REFERENCES [dbo].[StatusTypeMaster] ([TYPEID])
GO
