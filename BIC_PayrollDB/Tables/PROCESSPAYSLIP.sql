﻿DROP TABLE [dbo].[PROCESSPAYSLIP]
GO
CREATE TABLE [dbo].[PROCESSPAYSLIP]
(
[PROCESSID] [bigint] NOT NULL IDENTITY(1, 1),
[EMPID] [bigint]  NOT NULL,
[HEADID] [bigint] NOT NULL,
[QTY] [decimal] (21,6) NULL,
[RATE] [decimal] (21,6) NULL,
[AMOUNT] [decimal] (21,6) NULL,
[ISOVERRIDE] [bit] NULL DEFAULT ((0)), 
[REFERENCE] [varchar] (500) NULL ,
[COMPID] [INT] NULL,
[ISACTIVE] [bit] NULL DEFAULT ((1)), 
[CREATEDON] [datetime]  NULL ,
[CREATEDBY] [int]  NULL ,
[UPDATEDON] [datetime]  NULL , 
[UPDATEDBY] [int]  NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PROCESSPAYSLIP] ADD CONSTRAINT [PK_PROCESSPAYSLIP] PRIMARY KEY CLUSTERED  ([PROCESSID]) ON [PRIMARY]
 