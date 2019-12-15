ALTER TRIGGER [dbo].[Documents.Operation.Delete] 
   ON [dbo].[Documents] 
   AFTER DELETE
AS 
BEGIN	
	IF (ROWCOUNT_BIG() = 0) RETURN;

	SET NOCOUNT ON;

	DELETE FROM  [Documents.Operation] WHERE id IN (SELECT id FROM deleted);

END
GO

ALTER TRIGGER [dbo].[Documents.Operation.Insert] 
   ON [dbo].[Documents] 
   AFTER INSERT
AS 
BEGIN	
	IF (ROWCOUNT_BIG() = 0) RETURN;
	SET NOCOUNT ON;

	INSERT INTO [Documents.Operation]
	SELECT 
		d.id, 
		d.date, 
		d.code, 
		d.description, 
		d.posted, 
		d.deleted, 
		d.type,

		"parent".id "parent.id",
		ISNULL("parent".description, N'') "parent.value",
		"parent".type "parent.type",

		"company".id "company.id",
		ISNULL("company".description, N'') "company.value",
		"company".type "company.type",

		"user".id "user.id",
		ISNULL("user".description, N'') "user.value",
		"user".type "user.type",

		"Group".id "Group.id",
		ISNULL("Group".description, N'') "Group.value",
		"Group".type "Group.type",

		"Operation".id "Operation.id",
		ISNULL("Operation".description, N'') "Operation.value",
		"Operation".type "Operation.type",

		"currency".id "currency.id",
		ISNULL("currency".description, N'') "currency.value",
		"currency".type "currency.type",

		ISNULL(CAST(JSON_VALUE(d.doc, N'$."Amount"') AS NUMERIC(15,2)), 0) "Amount",

		"f1".id "f1.id",
		"f1".type "f1.type",
		"f1".description "f1.value",

		"f2".id "f2.id",
		"f2".type "f2.type",
		"f2".description "f2.value",

		"f3".id "f3.id",
		"f3".type "f3.type",
		"f3".description "f3.value"

	FROM inserted d
		LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
		LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
		LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
		LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "Operation" ON "Operation".id = CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "f1" ON "f1".id = CAST(JSON_VALUE(d.doc, N'$."f1"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "f2" ON "f2".id = CAST(JSON_VALUE(d.doc, N'$."f2"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "f3" ON "f3".id = CAST(JSON_VALUE(d.doc, N'$."f3"') AS UNIQUEIDENTIFIER)
	WHERE d.type = 'Document.Operation' and d.isfolder = 0;

END
GO

ALTER TRIGGER [dbo].[Documents.Operation.Update] 
   ON [dbo].[Documents] 
   AFTER UPDATE
AS 
BEGIN
	IF (ROWCOUNT_BIG() = 0) RETURN;
	SET NOCOUNT ON;

	UPDATE [Documents.Operation] SET 
		date = i.date,
		code = i.code,
		description = i.description,
		posted = i.posted,
		deleted = i.deleted,
		type = i.type,
		"parent.id" = i."parent.id",
		"parent.value" = i."parent.value",
		"parent.type" = i."parent.type",
		"company.id" = i."company.id",
		"company.value" = i."company.value",
		"company.type" = i."company.type",
		"user.id" = i."user.id",
		"user.value" = i."user.value",
		"user.type" = i."user.type",
		"Group.id"  = i."Group.id",
		"Group.value" = i."Group.value",
		"Group.type" = i."Group.type",
		"Operation.id"  = i."Operation.id",
		"Operation.value"  = i."Operation.value",
		"Operation.type" = i."Operation.type",
		Amount = i.Amount,
		"currency.id" = i."currency.id",
		"f1.id" = i."f1.id",
		"f1.value" = i."f1.value",
		"f1.type" = i."f1.type",
		"f2.id" = i."f2.id",
		"f2.value" = i."f2.value",
		"f2.type" = i."f2.type",
		"f3.id" = i."f3.id",
		"f3.value" = i."f3.value",
		"f3.type" = i."f3.type"
	FROM  (
		SELECT 
		d.id, 
		d.date, 
		d.code, 
		d.description, 
		d.posted, 
		d.deleted, 
		d.type,

		"parent".id "parent.id",
		ISNULL("parent".description, N'') "parent.value",
		"parent".type "parent.type",

		"company".id "company.id",
		ISNULL("company".description, N'') "company.value",
		"company".type "company.type",

		"user".id "user.id",
		ISNULL("user".description, N'') "user.value",
		"user".type "user.type",

		"Group".id "Group.id",
		ISNULL("Group".description, N'') "Group.value",
		"Group".type "Group.type",

		"Operation".id "Operation.id",
		ISNULL("Operation".description, N'') "Operation.value",
		"Operation".type "Operation.type",

		"currency".id "currency.id",
		ISNULL("currency".description, N'') "currency.value",
		"currency".type "currency.type",

		ISNULL(CAST(JSON_VALUE(d.doc, N'$."Amount"') AS NUMERIC(15,2)), 0) "Amount",

		"f1".id "f1.id",
		"f1".type "f1.type",
		"f1".description "f1.value",

		"f2".id "f2.id",
		"f2".type "f2.type",
		"f2".description "f2.value",

		"f3".id "f3.id",
		"f3".type "f3.type",
		"f3".description "f3.value"

	FROM inserted d
		LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
		LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
		LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
		LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "Operation" ON "Operation".id = CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "f1" ON "f1".id = CAST(JSON_VALUE(d.doc, N'$."f1"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "f2" ON "f2".id = CAST(JSON_VALUE(d.doc, N'$."f2"') AS UNIQUEIDENTIFIER)
		LEFT JOIN dbo."Documents" "f3" ON "f3".id = CAST(JSON_VALUE(d.doc, N'$."f3"') AS UNIQUEIDENTIFIER)
	WHERE d.type = 'Document.Operation' and d.isfolder = 0) i 
		INNER JOIN [Documents.Operation] ON i.id = [Documents.Operation].id;

END