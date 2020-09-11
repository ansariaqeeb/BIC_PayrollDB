CREATE TABLE [dbo].[LogTable]
(
[LogId] [BIGINT] NOT NULL IDENTITY(1, 1),
[ProcedureName] [varchar] (50) NULL,
[TableName] [varchar] (50) NULL,
[PRIMARYKEY] [varchar] (15) NULL,
[ActionTaken] [tinyint] NULL,
[Records] [xml] NULL,
[LogDate] [datetime] NULL DEFAULT (getutcdate()),
[UserId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogTable] ADD CONSTRAINT [PK_LogTable] PRIMARY KEY CLUSTERED  ([LogId]) ON [PRIMARY]
GO

