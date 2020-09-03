DROP TABLE [dbo].[StatusTypeMaster]
GO
CREATE TABLE [dbo].[StatusTypeMaster]
(
[TYPEID] [int] NOT NULL IDENTITY(1, 1),
[TYPECODE] [nvarchar] (20)  NOT NULL,
[DISCRIPTION] [nvarchar] (120) NOT NULL,
[ISACTIVE] [bit] NULL DEFAULT ((1)),
[CREATEDON] [datetime]  NULL ,
[CREATEDBY] [int]  NULL ,
[UPDATEDON] [datetime]  NULL , 
[UPDATEDBY] [int]  NULL 

) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatusTypeMaster] ADD CONSTRAINT [PK_StatusTypeMaster] PRIMARY KEY CLUSTERED  ([TYPEID]) ON [PRIMARY]
 
