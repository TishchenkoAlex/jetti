CREATE OR ALTER VIEW [dbo].[Register.Accumulation.Inventory.TO]
WITH
    SCHEMABINDING
AS
    SELECT COUNT_BIG(*) [COUNT]
	, [BOMONTH] [date]
	, [company], [Storehouse], [SKU]
	, SUM(ISNULL([Cost], 0)) [Cost]
	, SUM(ISNULL([Qty], 0)) [Qty]
    FROM [dbo].[Register.Accumulation.Inventory]
    GROUP BY
	[BOMONTH], [company], [Storehouse], [SKU]
GO

CREATE UNIQUE CLUSTERED INDEX [Register.Accumulation.Inventory.TO.CI] ON [dbo].[Register.Accumulation.Inventory.TO]
(
	[date] ASC,
	[company] ASC,
	[Storehouse] ASC,
	[SKU] ASC
);
GO