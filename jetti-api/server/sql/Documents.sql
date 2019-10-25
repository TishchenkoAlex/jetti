/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.3023)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

/****** Object:  Table [dbo].[Documents]    Script Date: 4/3/2018 9:14:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Documents](
	[id] [uniqueidentifier] NOT NULL,
	[type] [nvarchar](100) NOT NULL,
	[date] [datetimeoffset(7)] NOT NULL,
	[code] [nvarchar](36) NOT NULL,
	[description] [nvarchar](150) NOT NULL,
	[posted] [bit] NOT NULL,
	[deleted] [bit] NOT NULL,
	[doc] [nvarchar](max) NULL,
	[parent] [uniqueidentifier] NULL,
	[isfolder] [bit] NOT NULL,
	[company] [uniqueidentifier] NULL,
	[user] [uniqueidentifier] NULL,
	[info] [nvarchar](4000) NULL,
	[timestamp] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Documents_code_idx]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Documents_code_idx] ON [dbo].[Documents]
(
	[type] ASC,
	[code] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [Documents_company_idx]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE NONCLUSTERED INDEX [Documents_company_idx] ON [dbo].[Documents]
(
	[company] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Documents_date_idx]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Documents_date_idx] ON [dbo].[Documents]
(
	[type] ASC,
	[date] ASC,
	[id] ASC,
	[posted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Documents_description_idx]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Documents_description_idx] ON [dbo].[Documents]
(
	[type] ASC,
	[description] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [Documents_id_idx]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Documents_id_idx] ON [dbo].[Documents]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Documents_isfolder_type_index]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE NONCLUSTERED INDEX [Documents_isfolder_type_index] ON [dbo].[Documents]
(
	[isfolder] ASC,
	[type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [Documents_parent_index]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE NONCLUSTERED INDEX [Documents_parent_index] ON [dbo].[Documents]
(
	[parent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Documents_posted_type_date_id_uindex]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Documents_posted_type_date_id_uindex] ON [dbo].[Documents]
(
	[posted] ASC,
	[type] ASC,
	[date] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Documents_type_idx]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [Documents_type_idx] ON [dbo].[Documents]
(
	[type] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [cci_Documents]    Script Date: 4/3/2018 9:14:13 AM ******/
CREATE CLUSTERED COLUMNSTORE INDEX [cci_Documents] ON [dbo].[Documents] WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
GO

/****** Object:  FullTextIndex     Script Date: 4/3/2018 9:14:13 AM ******/
CREATE FULLTEXT INDEX ON [dbo].[Documents](
[doc] LANGUAGE 'English')
KEY INDEX [Documents_id_idx]ON ([jsonDocuments], FILEGROUP [PRIMARY])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)

GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF__Documents__id__5AEE82B9]  DEFAULT (newsequentialid()) FOR [id]
GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [Documents_date_default]  DEFAULT (getdate()) FOR [date]
GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF__Documents__poste__60A75C0F]  DEFAULT ((0)) FOR [posted]
GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF__Documents__delet__619B8048]  DEFAULT ((0)) FOR [deleted]
GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF__Documents__doc__5FB337D6]  DEFAULT ('{}') FOR [doc]
GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF__Documents__isfol__628FA481]  DEFAULT ((0)) FOR [isfolder]
GO

ALTER TABLE [dbo].[Documents] ADD  CONSTRAINT [DF__Documents__times__5EBF139D]  DEFAULT (getdate()) FOR [timestamp]
GO

ALTER TABLE [dbo].[Documents]  WITH CHECK ADD  CONSTRAINT [Content should be formatted as JSON] CHECK  ((isjson([doc])>(0)))
GO

ALTER TABLE [dbo].[Documents] CHECK CONSTRAINT [Content should be formatted as JSON]
GO


