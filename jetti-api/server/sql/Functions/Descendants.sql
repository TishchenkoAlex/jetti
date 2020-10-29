USE [sm]
GO
/****** Object:  UserDefinedFunction [dbo].[Descendants]    Script Date: 27.10.2020 20:29:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Descendants]
(	
	@id UNIQUEIDENTIFIER,
	@type NVARCHAR(100) = ''
)
RETURNS TABLE 
WITH SCHEMABINDING  
AS
RETURN 
(
	WITH cte AS 
	(
		SELECT a.id, a.parent FROM [dbo].[Documents] a WHERE [id] = @id
		UNION ALL
		SELECT a.id, a.parent FROM [dbo].[Documents] a
			JOIN cte c ON a.parent = c.id
	)
	SELECT c.id, c.parent FROM cte c
)
