CREATE VIEW [dbo].[Catalogs.Hierarchy] 
WITH SCHEMABINDING
AS SELECT 
	l6.id, l6.type, l6.description,
	ISNULL(l5.description, l6.description) Level5,
	ISNULL(l4.description, ISNULL(l5.description, l6.description)) Level4,
	ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, l6.description))) Level3,
	ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, l6.description)))) Level2,
	ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, l6.description))))) Level1
FROM  dbo.Documents l6
LEFT JOIN  dbo.Documents l5 ON (l5.id = l6.parent)
LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
WHERE l6.type LIKE 'Catalog.%'
GO