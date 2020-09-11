DROP TABLE [dbo].[USERMAST]
GO
CREATE TABLE [dbo].[USERMAST]
(
[USERID] [BIGINT] NOT NULL IDENTITY(1, 1),
[LOGINID] [varchar] (120) NOT NULL,  
[Email] [nvarchar] (300) NULL,
[MobileNo] [varchar] (18) NULL,
[MobileVerify] [bit] NULL DEFAULT ((0)),
[EmailVerify] [bit] NULL DEFAULT ((0)), 
[FNAME] [varchar] (50) NULL,
[MNAME] [varchar] (50) NULL,
[LNAME] [varchar] (50) NULL,
[DOB] [date] NULL,
[ADDRESS] [varchar] (1000) NULL,
[PASSWORD] [nvarchar] (max) NULL, 
[SVRKEY] [nvarchar] (max) NULL,
[SVRDATE] [date] NULL,
[SecondaryEmailID] [nvarchar] (300) NULL,   
[ISACTIVE] [bit] NULL DEFAULT ((1)), 
[ISADMIN] [bit] NULL DEFAULT ((0)),
[CREATEDON] [datetime]  NULL ,
[CREATEDBY] [int]  NULL ,
[UPDATEDON] [datetime]  NULL , 
[UPDATEDBY] [int]  NULL,
[COUNTRYID] [int] NUll
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[USERMAST] ADD CONSTRAINT [PK_USERMAST] PRIMARY KEY CLUSTERED  ([USERID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[USERMAST] ADD CONSTRAINT [UNI_USERMAST_Email] UNIQUE NONCLUSTERED  ([Email]) ON [PRIMARY]
GO 