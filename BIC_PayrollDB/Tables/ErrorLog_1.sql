
CREATE TABLE [dbo].[ErrorLog]
(
[userName] [varchar] (20) NULL,
[ErrorNumber] [int] NULL,
[ErrorSeverity] [int] NULL,
[ErrorState] [int] NULL,
[ErrorProcedure] [varchar] (50) NULL,
[ErrorLine] [int] NULL,
[ErrorMessage] [varchar] (max) NULL,
[ErrorDate] [datetime] NULL DEFAULT (getdate()),
[InputParameter] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
