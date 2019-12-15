ALTER TRIGGER [dbo].[Documents.CheckAccessToCommonDocs] 
   ON [dbo].[Documents]
   AFTER UPDATE, DELETE
AS 
BEGIN
	IF (ROWCOUNT_BIG() = 0) RETURN;
	DECLARE @isAdmin BIT = ISNULL((CAST(SESSION_CONTEXT(N'isAdmin') AS BIT)), 0);
	IF (@isAdmin) = 1 RETURN;

	DECLARE @COUNT INT = 0;
	SELECT @COUNT = COUNT(*) FROM deleted WHERE company IS NULL;
	DECLARE @ERROOR NVARCHAR(200) = (SELECT 'Acces denied for common documents');

	IF (@COUNT > 0) THROW 50001, @ERROOR, 1

END