﻿DROP TABLE [dbo].[COUNTRYMAST]
GO
CREATE TABLE [dbo].[COUNTRYMAST]
(
[COUNTRYID] [int] NOT NULL IDENTITY(1, 1),
[COUNTRYCODE] [nvarchar] (10)   NOT NULL,
[SHORTNAME] [nvarchar] (60) NULL,
[COUNTRYNAME] [nvarchar] (120)  NOT NULL,
[ISACTIVE] [bit] NULL DEFAULT ((1)), 
[CREATEDON] [datetime]  NULL ,
[CREATEDBY] [int]  NULL ,
[UPDATEDON] [datetime]  NULL , 
[UPDATEDBY] [int]  NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COUNTRYMAST] ADD CONSTRAINT [PK_COUNTRYMAST] PRIMARY KEY CLUSTERED  ([COUNTRYID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[COUNTRYMAST] ADD CONSTRAINT [UK_COUNTRYMAST] UNIQUE NONCLUSTERED  ([COUNTRYCODE]) ON [PRIMARY]
GO
