CREATE TABLE [Register.Accumulation.Sales]
(
  date       DATE                   NOT NULL,
  document   UNIQUEIDENTIFIER       NOT NULL,
  company    UNIQUEIDENTIFIER       NOT NULL,

  Department UNIQUEIDENTIFIER,
  Customer   UNIQUEIDENTIFIER       NOT NULL,
  Product    UNIQUEIDENTIFIER       NOT NULL,
  Manager    UNIQUEIDENTIFIER,

  Amount     MONEY DEFAULT 0        NOT NULL,
  Qty        MONEY DEFAULT 0        NOT NULL,
  Cost       MONEY DEFAULT 0        NOT NULL,
  Discount   MONEY DEFAULT 0        NOT NULL,
  Tax        MONEY DEFAULT 0        NOT NULL
)
GO

CREATE CLUSTERED COLUMNSTORE INDEX "Register.Accumulation.Sales.CCI" ON [Register.Accumulation.Sales]
GO

select count(*) from Documents

