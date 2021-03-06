﻿

CREATE TABLE [dbo].[FREQUENCYPERIODTRANS]
(
[TID] [int] NOT NULL IDENTITY(1, 1),
[RMID] [int] NOT NULL, 
[MONTHID] [int] NOT NULL,
[MONTHENDDATE] [date] NOT NULL ,
[STATUS] [VARCHAR] (25) NOT NULL, 
[ISACTIVE] [bit] NULL DEFAULT ((1)),
[ISCLOSED] [bit] NULL DEFAULT((0)),
[CREATEDON] [datetime] NULL,
[CREATEDBY] [int] NULL,
[UPDATEDON] [datetime] NULL,
[UPDATEDBY] [int] NULL,
[ISCURRENT] [bit] null
) ON [PRIMARY] 
GO
ALTER TABLE [dbo].[FREQUENCYPERIODTRANS] ADD CONSTRAINT [PK_FREQUENCYPERIODTRANS] PRIMARY KEY CLUSTERED  ([TID]) ON [PRIMARY]
GO