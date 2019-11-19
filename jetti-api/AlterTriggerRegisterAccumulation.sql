
      ALTER TRIGGER "Accumulation.Insert" ON dbo."Accumulation"
      AFTER INSERT AS
      BEGIN
        
      INSERT INTO "Register.Accumulation.AccountablePersons" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Employee"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Employee"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.AccountablePersons'; 


      INSERT INTO "Register.Accumulation.AP" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Supplier"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Supplier"

        , ISNULL(JSON_VALUE(data, N'$.PayDay'), '1970-01-01T00:00:00.000Z') "PayDay" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.AP'; 


      INSERT INTO "Register.Accumulation.AR" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Customer"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Customer"

        , ISNULL(JSON_VALUE(data, N'$.PayDay'), '1970-01-01T00:00:00.000Z') "PayDay" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AR"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AR.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AR'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AR.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.AR'; 


      INSERT INTO "Register.Accumulation.Bank" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BankAccount"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BankAccount"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Bank'; 


      INSERT INTO "Register.Accumulation.Balance" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "Balance"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Balance"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Balance"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Balance'; 


      INSERT INTO "Register.Accumulation.Cash" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashRegister"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashRegister"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Cash'; 


      INSERT INTO "Register.Accumulation.Cash.Transit" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Sender"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Sender"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Recipient"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Recipient"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Cash.Transit'; 


      INSERT INTO "Register.Accumulation.Inventory" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "OperationType"
        , "Expense"
        , "ExpenseAnalytics"
        , "Income"
        , "IncomeAnalytics"
        , "BalanceIn"
        , "BalanceInAnalytics"
        , "BalanceOut"
        , "BalanceOutAnalytics"
        , "Storehouse"
        , "SKU"
        , "batch"
        , "Cost"
        , "Cost.In"
        , "Cost.Out"
        , "Qty"
        , "Qty.In"
        , "Qty.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."OperationType"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "OperationType"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Expense"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Expense"

        , CAST(ISNULL(JSON_VALUE(data, N'$."ExpenseAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "ExpenseAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Income"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Income"

        , CAST(ISNULL(JSON_VALUE(data, N'$."IncomeAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "IncomeAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceIn"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceIn"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceInAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceInAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceOut"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceOut"

        , CAST(ISNULL(JSON_VALUE(data, N'$."BalanceOutAnalytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "BalanceOutAnalytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Storehouse"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Storehouse"

        , CAST(ISNULL(JSON_VALUE(data, N'$."SKU"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "SKU"

        , CAST(ISNULL(JSON_VALUE(data, N'$."batch"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "batch"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Cost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Cost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Qty.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Qty.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Inventory'; 


      INSERT INTO "Register.Accumulation.Loan" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Loan"
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
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Loan"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Loan"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Counterpartie"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Counterpartie"

        , CAST(ISNULL(JSON_VALUE(data, N'$."CashFlow"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "CashFlow"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Loan'; 


      INSERT INTO "Register.Accumulation.PL" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "Department"
        , "PL"
        , "Analytics"
        , "Amount"
        , "Amount.In"
        , "Amount.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."PL"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "PL"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Analytics"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Analytics"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.PL'; 


      INSERT INTO "Register.Accumulation.Sales" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "currency"
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
        , "AmountInAR.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Customer"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Customer"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Product"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Product"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Manager"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Manager"

        , CAST(ISNULL(JSON_VALUE(data, N'$."AO"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "AO"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Storehouse"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Storehouse"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Cost"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Cost.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Cost'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Cost.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Qty"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Qty.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Qty'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Qty.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Discount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Discount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Discount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Discount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Discount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Discount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.Tax'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Tax"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Tax'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Tax.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Tax'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Tax.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInDoc'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInDoc"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInDoc'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInDoc.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInDoc'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInDoc.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAR'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAR"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAR'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAR.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAR'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAR.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Sales'; 


      INSERT INTO "Register.Accumulation.Depreciation" (DT, id, parent, date, document, company, kind, calculated, exchangeRate
        , "BusinessOperation"
        , "currency"
        , "Department"
        , "OE"
        , "Amount"
        , "Amount.In"
        , "Amount.Out"
        , "AmountInBalance"
        , "AmountInBalance.In"
        , "AmountInBalance.Out"
        , "AmountInAccounting"
        , "AmountInAccounting.In"
        , "AmountInAccounting.Out")
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate
 
        , ISNULL(JSON_VALUE(data, '$.BusinessOperation'), '') "BusinessOperation" 

        , CAST(ISNULL(JSON_VALUE(data, N'$."currency"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "currency"

        , CAST(ISNULL(JSON_VALUE(data, N'$."Department"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "Department"

        , CAST(ISNULL(JSON_VALUE(data, N'$."OE"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "OE"

        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "Amount"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "Amount.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.Amount'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "Amount.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInBalance"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInBalance.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInBalance'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInBalance.Out" 

        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "AmountInAccounting"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "AmountInAccounting.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.AmountInAccounting'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "AmountInAccounting.Out" 

      FROM INSERTED WHERE type = N'Register.Accumulation.Depreciation'; 


      END;