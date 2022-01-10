USE [EnterpriseDBA]
GO

/****** Object:  Table [dbo].[AUDIT_Tgr_MonitorChange]    Script Date: 3/12/2015 10:06:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MonitorChange](
	[EventType] [varchar](100) NULL,
	[ClientHost] [varchar](100) NULL,
	[IPAddress] [varchar](32) NULL,
	[ProgramName] [nvarchar](255) NULL,
	[DatabaseName] [nvarchar](255) NULL,
	[TSQL] [nvarchar](3999) NULL,
	[SchemaName] [varchar](100) NULL,
	[ObjectName] [varchar](100) NULL,
	[ObjectType] [varchar](100) NULL,
	[EventDate] [datetime] NULL,
	[SystemUser] [varchar](100) NULL,
	[CurrentUser] [varchar](100) NULL,
	[OriginalUser] [varchar](100) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


