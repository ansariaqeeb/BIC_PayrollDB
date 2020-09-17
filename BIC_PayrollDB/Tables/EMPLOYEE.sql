﻿DROP TABLE [dbo].[EMPLOYEE]
GO
CREATE TABLE [dbo].[EMPLOYEE]
(
[EMPID] [bigint] NOT NULL IDENTITY(1, 1),
[EMPCODE] [nvarchar] (20)  NOT NULL,
[TITLE] [varchar] (5) NULL,
[FIRSTNAEM] [nvarchar] (100) NULL,
[MIDDLENAME] [nvarchar] (100) NULL,
[LASTNAME] [nvarchar] (100) NULL,
[NICKNAME] [nvarchar] (100)  NULL,
[STARTDATE] [date] NULL,
[DOB] [date] NULL,
[NATIONALID] [nvarchar] (30)  NULL, 
[PASSPORTNO] [nvarchar] (30) NULL,
[COUNTRYOFISSUE] [nvarchar] (30) NULL,
[GENDER] [nvarchar] (10) NULL,
[MARITALSTATUS] [nvarchar] (10) NULL,
[DEPENDENT] [nvarchar] (5) NULL,
[YEARSOFSERVICE] [nvarchar] (5)  NULL,
[ADDR1COMPLEXNAME] [nvarchar] (500) NULL,
[ADDR1STREETNO] [nvarchar] (500) NULL,
[ADDR1STREETNAME] [nvarchar] (500) NULL,
[ADDR1POSTALCODE] [nvarchar] (255)  NULL,
[ADDR1COUNTRYID] [int] NOT NULL,
[ADDR1STATEID] [int] NOT NULL,
[ADDR1CITYID] [int] NOT NULL, 
[ADDR2SAMEASADDR1] [bit] NULL,
[ADDR2COMPLEXNAME] [nvarchar] (500) NULL,
[ADDR2STREETNO] [nvarchar] (500) NULL,
[ADDR2STREETNAME] [nvarchar] (500) NULL,
[ADDR2POSTALCODE] [nvarchar] (255)  NULL,
[ADDR2COUNTRYID] [int] NOT NULL,
[ADDR2STATEID] [int] NOT NULL,
[ADDR2CITYID] [int] NOT NULL, 
[WORKPHONE] [nvarchar] (15) NULL,
[HOMEPHONE] [nvarchar] (15) NULL,
[CELLNO] [nvarchar] (15) NULL,
[FAXNO] [nvarchar] (15) NULL,
[SPOUSENAME] [nvarchar] (100) NULL,
[SPOUSENO] [nvarchar] (15) NULL,
[EMAILID] [nvarchar] (30) NULL,
[DAILYRATE] [DECIMAL] (21, 6) NULL,
[WEEKLYRATE] [DECIMAL] (21, 6) NULL,
[MONTHLYRATE] [DECIMAL] (21, 6) NULL,
[HOURLYRATE] [DECIMAL] (21, 6) NULL,
[PREVIUSYEARLYPAY] [DECIMAL] (21, 6) NULL,
[LASTINCREAMENTDATE] [DATE] NULL,
[TERMINATIONDATE] [DATE] NULL,
[AVGHOURPERDAY] [DECIMAL] (21, 6) NULL,
[HOURPERWEEK] [DECIMAL] (21, 6) NULL,
[DAYSPERMONTH] [DECIMAL] (21, 6) NULL,
[WEEKDAYS] [nvarchar] (200) NULL,
[ANNUALSTANDARDLEAVE] [DECIMAL] (21, 6) NULL,
[ANNUALSICKLEAVE] [DECIMAL] (21, 6) NULL,
[ANNUALOPTIONALLEAVE] [DECIMAL] (21, 6) NULL,
[ISACTIVE] [bit] NULL DEFAULT ((1)),
[COMPID] [INT] NULL,
[CREATEDON] [datetime]  NULL ,
[CREATEDBY] [int]  NULL ,
[UPDATEDON] [datetime]  NULL , 
[UPDATEDBY] [int]  NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMPLOYEE] ADD CONSTRAINT [PK_EMPLOYEE] PRIMARY KEY CLUSTERED  ([EMPID]) ON [PRIMARY]
 

