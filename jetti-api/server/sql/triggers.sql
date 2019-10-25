ALTER TRIGGER "Accumulation.Insert" ON dbo."Accumulation"
      FOR INSERT AS
      BEGIN

      INSERT INTO "Register.Accumulation.AccountablePersons"
      (DT, date, document, company, kind , "currency"
, "Employee"
, "CashFlow"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."Employee"') AS UNIQUEIDENTIFIER) "Employee"
, CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.AccountablePersons';

      INSERT INTO "Register.Accumulation.AP"
      (DT, date, document, company, kind , "currency"
, "Department"
, "AO"
, "Supplier"
, "PayDay"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER) "Department"
, CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER) "AO"
, CAST(JSON_VALUE(data, N'$."Supplier"') AS UNIQUEIDENTIFIER) "Supplier"
, JSON_VALUE(data, '$.PayDay') "PayDay"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.AP';

      INSERT INTO "Register.Accumulation.AR"
      (DT, date, document, company, kind , "currency"
, "Department"
, "AO"
, "Customer"
, "PayDay"
, "AR"
, "AR.In"
, "AR.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER) "Department"
, CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER) "AO"
, CAST(JSON_VALUE(data, N'$."Customer"') AS UNIQUEIDENTIFIER) "Customer"
, JSON_VALUE(data, '$.PayDay') "PayDay"

        , CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, -1) "AR"
        , CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, 1, NULL) "AR.In"
        , CAST(JSON_VALUE(data, N'$.AR') AS MONEY) * IIF(kind = 1, NULL, 1) "AR.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.AR';

      INSERT INTO "Register.Accumulation.Bank"
      (DT, date, document, company, kind , "currency"
, "BankAccount"
, "CashFlow"
, "Analytics"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."BankAccount"') AS UNIQUEIDENTIFIER) "BankAccount"
, CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER) "CashFlow"
, CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Bank';

      INSERT INTO "Register.Accumulation.Balance"
      (DT, date, document, company, kind , "Department"
, "Balance"
, "Analytics"
, "Amount"
, "Amount.In"
, "Amount.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER) "Department"
, CAST(JSON_VALUE(data, N'$."Balance"') AS UNIQUEIDENTIFIER) "Balance"
, CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Balance';

      INSERT INTO "Register.Accumulation.Cash"
      (DT, date, document, company, kind , "currency"
, "CashRegister"
, "CashFlow"
, "Analytics"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."CashRegister"') AS UNIQUEIDENTIFIER) "CashRegister"
, CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER) "CashFlow"
, CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Cash';

      INSERT INTO "Register.Accumulation.Cash.Transit"
      (DT, date, document, company, kind , "currency"
, "Sender"
, "Recipient"
, "CashFlow"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."Sender"') AS UNIQUEIDENTIFIER) "Sender"
, CAST(JSON_VALUE(data, N'$."Recipient"') AS UNIQUEIDENTIFIER) "Recipient"
, CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Cash.Transit';

      INSERT INTO "Register.Accumulation.Inventory"
      (DT, date, document, company, kind , "Expense"
, "Storehouse"
, "SKU"
, "batch"
, "Cost"
, "Cost.In"
, "Cost.Out"
, "Qty"
, "Qty.In"
, "Qty.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."Expense"') AS UNIQUEIDENTIFIER) "Expense"
, CAST(JSON_VALUE(data, N'$."Storehouse"') AS UNIQUEIDENTIFIER) "Storehouse"
, CAST(JSON_VALUE(data, N'$."SKU"') AS UNIQUEIDENTIFIER) "SKU"
, CAST(JSON_VALUE(data, N'$."batch"') AS UNIQUEIDENTIFIER) "batch"

        , CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, NULL) "Cost.In"
        , CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, NULL, 1) "Cost.Out"

        , CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, NULL) "Qty.In"
        , CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, NULL, 1) "Qty.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Inventory';

      INSERT INTO "Register.Accumulation.Loan"
      (DT, date, document, company, kind , "Loan"
, "Counterpartie"
, "CashFlow"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "AmountInBalance"
, "AmountInBalance.In"
, "AmountInBalance.Out"
, "AmountInAccounting"
, "AmountInAccounting.In"
, "AmountInAccounting.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."Loan"') AS UNIQUEIDENTIFIER) "Loan"
, CAST(JSON_VALUE(data, N'$."Counterpartie"') AS UNIQUEIDENTIFIER) "Counterpartie"
, CAST(JSON_VALUE(data, N'$."CashFlow"') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInBalance.In"
        , CAST(JSON_VALUE(data, N'$.AmountInBalance') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInBalance.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAccounting.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAccounting') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAccounting.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Loan';

      INSERT INTO "Register.Accumulation.PL"
      (DT, date, document, company, kind , "Department"
, "PL"
, "Analytics"
, "Amount"
, "Amount.In"
, "Amount.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER) "Department"
, CAST(JSON_VALUE(data, N'$."PL"') AS UNIQUEIDENTIFIER) "PL"
, CAST(JSON_VALUE(data, N'$."Analytics"') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.PL';

      INSERT INTO "Register.Accumulation.Sales"
      (DT, date, document, company, kind , "currency"
, "Department"
, "Customer"
, "Product"
, "Manager"
, "AO"
, "Storehouse"
, "Cost"
, "Cost.In"
, "Cost.Out"
, "Qty"
, "Qty.In"
, "Qty.Out"
, "Amount"
, "Amount.In"
, "Amount.Out"
, "Discount"
, "Discount.In"
, "Discount.Out"
, "Tax"
, "Tax.In"
, "Tax.Out"
, "AmountInDoc"
, "AmountInDoc.In"
, "AmountInDoc.Out"
, "AmountInAR"
, "AmountInAR.In"
, "AmountInAR.Out"
)
      SELECT
        CAST(DATEDIFF_BIG(MICROSECOND, '00010101', [date]) * 10 + (DATEPART(NANOSECOND, [date]) % 1000) / 100 +
        (SELECT ABS(CONVERT(SMALLINT, CONVERT(VARBINARY(16), (document), 1)))) AS BIGINT) + RIGHT(id,1) DT,
        CAST(SWITCHOFFSET(date, '+03:00') AS DATE) date,
        document, company, kind , CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) "currency"
, CAST(JSON_VALUE(data, N'$."Department"') AS UNIQUEIDENTIFIER) "Department"
, CAST(JSON_VALUE(data, N'$."Customer"') AS UNIQUEIDENTIFIER) "Customer"
, CAST(JSON_VALUE(data, N'$."Product"') AS UNIQUEIDENTIFIER) "Product"
, CAST(JSON_VALUE(data, N'$."Manager"') AS UNIQUEIDENTIFIER) "Manager"
, CAST(JSON_VALUE(data, N'$."AO"') AS UNIQUEIDENTIFIER) "AO"
, CAST(JSON_VALUE(data, N'$."Storehouse"') AS UNIQUEIDENTIFIER) "Storehouse"

        , CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, 1, NULL) "Cost.In"
        , CAST(JSON_VALUE(data, N'$.Cost') AS MONEY) * IIF(kind = 1, NULL, 1) "Cost.Out"

        , CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, 1, NULL) "Qty.In"
        , CAST(JSON_VALUE(data, N'$.Qty') AS MONEY) * IIF(kind = 1, NULL, 1) "Qty.Out"

        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, 1, NULL) "Amount.In"
        , CAST(JSON_VALUE(data, N'$.Amount') AS MONEY) * IIF(kind = 1, NULL, 1) "Amount.Out"

        , CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, -1) "Discount"
        , CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, 1, NULL) "Discount.In"
        , CAST(JSON_VALUE(data, N'$.Discount') AS MONEY) * IIF(kind = 1, NULL, 1) "Discount.Out"

        , CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, -1) "Tax"
        , CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, 1, NULL) "Tax.In"
        , CAST(JSON_VALUE(data, N'$.Tax') AS MONEY) * IIF(kind = 1, NULL, 1) "Tax.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInDoc"
        , CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInDoc.In"
        , CAST(JSON_VALUE(data, N'$.AmountInDoc') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInDoc.Out"

        , CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAR"
        , CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, 1, NULL) "AmountInAR.In"
        , CAST(JSON_VALUE(data, N'$.AmountInAR') AS MONEY) * IIF(kind = 1, NULL, 1) "AmountInAR.Out"

      FROM INSERTED WHERE type = N'Register.Accumulation.Sales';

      END;