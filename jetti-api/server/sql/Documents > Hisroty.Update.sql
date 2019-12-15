ALTER TRIGGER [dbo].[Documents > Hisroty.Update] 
   ON [dbo].[Documents]
   AFTER UPDATE
AS 
BEGIN
	IF (ROWCOUNT_BIG() = 0) RETURN;
	SET NOCOUNT ON;
	INSERT INTO [dbo].[Documents.Hisroty](
        [_id], [type], [date], [code], [description], [posted], [deleted],
        [parent], [isfolder], [company], [user], [info], [doc], [ExchangeCode], [ExchangeBase], [_user])

	SELECT 
		i.[id], i.[type], i.[date], i.[code], i.[description], i.[posted], i.[deleted],
        i.[parent], i.[isfolder], i.[company], i.[user], i.[info], i.[doc], i.[ExchangeCode], i.[ExchangeBase],
		(SELECT id from Documents WHERE type = 'Catalog.User' AND code = LOWER(CAST(SESSION_CONTEXT(N'user_id') AS nvarchar(150))))
	FROM inserted i INNER JOIN deleted d on i.id = d.id 
	AND NOT EXISTS (
		SELECT [id], [type], [date], [code], [description], [deleted],
        [parent], [isfolder], [company], [user], [info], [doc] FROM inserted
		INTERSECT 
		SELECT [id], [type], [date], [code], [description], [deleted],
        [parent], [isfolder], [company], [user], [info], [doc] FROM deleted);
END