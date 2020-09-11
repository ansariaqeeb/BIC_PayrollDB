CREATE TABLE [dbo].[DbLog]
(
[dbLogId] [int] NOT NULL IDENTITY(1, 1),
[userId] [int] NULL,
[xmlFile] [xml] NULL,
[logDateTime] [datetime] NULL DEFAULT (getdate()),
[compName] [varchar] (100)  NULL,
[compUser] [varchar] (100)  NULL,
[compIpAddress] [varchar] (100)  NULL,
[browserName] [varchar] (100)  NULL,
[browserServer] [varchar] (100) NULL,
[spName] [varchar] (50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
