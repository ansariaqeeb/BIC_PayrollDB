﻿CREATE TABLE [dbo].[LOGINLOG]
(
[LOGID] [int] NOT NULL IDENTITY(1, 1),
[LOGINID] [varchar] (120) NULL,
[TRYPASSWORD] [varchar] (20) NULL,
[COMPNAME] [varchar] (100) NULL,
[COMPUSER] [varchar] (100) NULL,
[COMPIPADDRESS] [varchar] (100) NULL,
[BROWSERNM] [varchar] (100) NULL,
[BROWSERVER] [varchar] (100) NULL,
[LOGDATETIME] [datetime] NULL DEFAULT (getdate()),
[ATTEMPTNO] [int] NULL,
[ISSUCESS] [bit] NULL,
[ISLOCKED] [bit] NULL,
[UID] [uniqueidentifier] NULL DEFAULT (newsequentialid()),
[LOGOUTDATETIME] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LOGINLOG] ADD CONSTRAINT [PK_LOGINLOG] PRIMARY KEY CLUSTERED  ([LOGID]) ON [PRIMARY]
GO