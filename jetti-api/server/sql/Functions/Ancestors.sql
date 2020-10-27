USE [sm]
GO
/****** Object:  UserDefinedFunction [dbo].[Ancestors]    Script Date: 27.10.2020 20:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Ancestors]
(	
	@id UNIQUEIDENTIFIER
)
RETURNS TABLE 
AS
RETURN 
(
		WITH Parents ([id], [parent.id], [Level], [description])
		AS
		(
		  SELECT id 'id', 
				 parent 'parent.id', 
				 1 as level, 
				 [description] 'description'
		  FROM [dbo].[Documents]
		  WHERE 
			ID = @id
		  UNION ALL
		  SELECT  j.id 'id', 
				  j.parent 'parent.id', 
				  Level + 1, 
				  j.[description] 'description'
		  FROM [dbo].[Documents]  as j
		  INNER JOIN Parents AS jpt ON j.ID = jpt.[parent.id]
		)
	SELECT [id],[parent.id],ROW_NUMBER() OVER(ORDER BY [Level] DESC)[LevelUp],[Level] LevelDown,[description]
	FROM Parents 
	Ancestors 
)
