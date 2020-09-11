DROP TABLE [dbo].[ProfileImg]
GO
CREATE TABLE [dbo].[ProfileImg]
(
[ImgID] [int] NOT NULL IDENTITY(1, 1),
[ImgDesc] [varchar] (120) NOT NULL,
[SizeKB] [int] NULL,
[ImgPath] [varchar] (500) NOT NULL,
[UserID] [bigint] NULL,
[SLID] [int] NULL,
[CommID] [int] NULL,
[FMembID] [int] NULL,
[IsActive] [bit] NULL DEFAULT ((0)),
[CreatedBy] [int] NULL,
[CreatedOn] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProfileImg] ADD CONSTRAINT [PK_ProfileImg] PRIMARY KEY CLUSTERED  ([ImgID]) ON [PRIMARY]
GO 
ALTER TABLE [dbo].[ProfileImg] ADD CONSTRAINT [FK_ProfileImg_UserID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[USERMAST] ([USERID])
GO
