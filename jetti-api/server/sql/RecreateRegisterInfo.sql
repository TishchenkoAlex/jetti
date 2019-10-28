/****** Script for SelectTopNRows command from SSMS  ******/
BEGIN TRANSACTION
DROP TABLE #tempRI;
SELECT * 
INTO #tempRI
FROM [dbo].[Register.Info];

DELETE FROM [dbo].[Register.Info];
INSERT INTO [dbo].[Register.Info]([date], [type], [data], [document], [company], [kind])
SELECT [date], [type], [data], [document], [company], [kind] FROM #tempRI;

COMMIT;
