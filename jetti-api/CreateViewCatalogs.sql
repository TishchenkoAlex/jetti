

      CREATE OR ALTER VIEW dbo."Catalog.Account" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Account", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isForex"') AS BIT), 0) "isForex"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isActive"') AS BIT), 0) "isActive"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isPassive"') AS BIT), 0) "isPassive"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Account.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Account.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Account.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Account.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Account' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Balance" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Balance", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isActive"') AS BIT), 0) "isActive"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isPassive"') AS BIT), 0) "isPassive"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Balance.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Balance.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Balance.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Balance.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Balance' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Balance.Analytics" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BalanceAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "BalanceAnalytics.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "BalanceAnalytics.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "BalanceAnalytics.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "BalanceAnalytics.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Balance.Analytics' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.BankAccount" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BankAccount", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "BankAccount.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "BankAccount.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "BankAccount.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "BankAccount.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.BankAccount' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.CashFlow" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CashFlow", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "CashFlow.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "CashFlow.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "CashFlow.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "CashFlow.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.CashFlow' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.CashRegister" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CashRegister", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "CashRegister.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "CashRegister.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "CashRegister.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "CashRegister.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.CashRegister' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Currency" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Currency", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Currency.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Currency.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Currency.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Currency.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Currency' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Company" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Company", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
, ISNULL(JSON_VALUE(d.doc, N'$."prefix"'), '') "prefix"
, ISNULL(JSON_VALUE(d.doc, N'$."timeZone"'), '') "timeZone"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Company.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Company.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Company.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Company.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Company' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Counterpartie" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Counterpartie", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."FullName"'), '') "FullName"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Client"') AS BIT), 0) "Client"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Supplier"') AS BIT), 0) "Supplier"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Phone"'), '') "Phone"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Counterpartie.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Counterpartie.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Counterpartie.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Counterpartie.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Counterpartie' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Department" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Department", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Department.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Department.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Department.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Department.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Department' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Expense" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Expense", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Account".description, N'') "Account.value", ISNULL("Account".type, N'Catalog.Account') "Account.type",
          CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER) "Account.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Expense.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Expense.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Expense.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Expense.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Account" ON "Account".id = CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Expense' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Expense.Analytics" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ExpenseAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "ExpenseAnalytics.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "ExpenseAnalytics.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "ExpenseAnalytics.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "ExpenseAnalytics.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Expense.Analytics' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Income" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Income", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Account".description, N'') "Account.value", ISNULL("Account".type, N'Catalog.Account') "Account.type",
          CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER) "Account.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Income.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Income.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Income.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Income.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Account" ON "Account".id = CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Income' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Loan" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Loan", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Loan.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Loan.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Loan.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Loan.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Loan' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Manager" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Manager", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."FullName"'), '') "FullName"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Gender"') AS BIT), 0) "Gender"
, ISNULL(JSON_VALUE(d.doc, N'$."Birthday"'), '') "Birthday"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Manager.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Manager.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Manager.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Manager.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Manager' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Person" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Person", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Person.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Person.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Person.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Person.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Person' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.PriceType" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "PriceType", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."TaxInclude"') AS BIT), 0) "TaxInclude"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "PriceType.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "PriceType.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "PriceType.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "PriceType.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.PriceType' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Product" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Product", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("ProductKind".description, N'') "ProductKind.value", ISNULL("ProductKind".type, N'Catalog.ProductKind') "ProductKind.type",
          CAST(JSON_VALUE(d.doc, N'$."ProductKind"') AS UNIQUEIDENTIFIER) "ProductKind.id"
,

        ISNULL("ProductCategory".description, N'') "ProductCategory.value", ISNULL("ProductCategory".type, N'Catalog.ProductCategory') "ProductCategory.type",
          CAST(JSON_VALUE(d.doc, N'$."ProductCategory"') AS UNIQUEIDENTIFIER) "ProductCategory.id"
,

        ISNULL("Brand".description, N'') "Brand.value", ISNULL("Brand".type, N'Catalog.Brand') "Brand.type",
          CAST(JSON_VALUE(d.doc, N'$."Brand"') AS UNIQUEIDENTIFIER) "Brand.id"
,

        ISNULL("Unit".description, N'') "Unit.value", ISNULL("Unit".type, N'Catalog.Unit') "Unit.type",
          CAST(JSON_VALUE(d.doc, N'$."Unit"') AS UNIQUEIDENTIFIER) "Unit.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Volume"') AS NUMERIC(15,2)), 0) "Volume"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Product.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Product.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Product.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Product.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "ProductKind" ON "ProductKind".id = CAST(JSON_VALUE(d.doc, N'$."ProductKind"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "ProductCategory" ON "ProductCategory".id = CAST(JSON_VALUE(d.doc, N'$."ProductCategory"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Brand" ON "Brand".id = CAST(JSON_VALUE(d.doc, N'$."Brand"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Unit" ON "Unit".id = CAST(JSON_VALUE(d.doc, N'$."Unit"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Product' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.ProductCategory" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ProductCategory", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "ProductCategory.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "ProductCategory.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "ProductCategory.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "ProductCategory.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.ProductCategory' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.ProductKind" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ProductKind", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."ProductType"'), '') "ProductType"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "ProductKind.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "ProductKind.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "ProductKind.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "ProductKind.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.ProductKind' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Storehouse" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Storehouse", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Storehouse.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Storehouse.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Storehouse.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Storehouse.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Storehouse' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Operation" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Group".description, N'') "Group.value", ISNULL("Group".type, N'Catalog.Operation.Group') "Group.type",
          CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER) "Group.id"
, ISNULL(JSON_VALUE(d.doc, N'$."script"'), '') "script"
, ISNULL(JSON_VALUE(d.doc, N'$."module"'), '') "module"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Operation.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Operation.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Operation.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Operation.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Operation' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Operation.Group" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "OperationGroup", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."Prefix"'), '') "Prefix"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "OperationGroup.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "OperationGroup.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "OperationGroup.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "OperationGroup.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Operation.Group' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Operation.Type" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "OperationType", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "OperationType.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "OperationType.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "OperationType.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "OperationType.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Operation.Type' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Unit" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Unit", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Unit.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Unit.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Unit.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Unit.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Unit' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.User" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "User", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isAdmin"') AS BIT), 0) "isAdmin"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "User.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "User.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "User.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "User.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.User' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Role" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Role", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Role.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Role.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Role.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Role.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Role' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.SubSystem" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "SubSystem", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "SubSystem.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "SubSystem.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "SubSystem.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "SubSystem.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.SubSystem' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Documents" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Documents", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Documents.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Documents.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Documents.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Documents.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Documents' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Catalogs" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Catalogs", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Catalogs.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Catalogs.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Catalogs.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Catalogs.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Catalogs' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Objects" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Objects", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Objects.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Objects.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Objects.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Objects.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Objects' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Subcount" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Subcount", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Subcount.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Subcount.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Subcount.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Subcount.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Subcount' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Brand" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Brand", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Brand.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Brand.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Brand.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Brand.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Brand' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.GroupObjectsExploitation" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "GroupObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."Method"'), '') "Method"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "GroupObjectsExploitation.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "GroupObjectsExploitation.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "GroupObjectsExploitation.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "GroupObjectsExploitation.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.GroupObjectsExploitation' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.ObjectsExploitation" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Group".description, N'') "Group.value", ISNULL("Group".type, N'Catalog.ObjectsExploitation') "Group.type",
          CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER) "Group.id"
, ISNULL(JSON_VALUE(d.doc, N'$."InventoryNumber"'), '') "InventoryNumber"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "ObjectsExploitation.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "ObjectsExploitation.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "ObjectsExploitation.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "ObjectsExploitation.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.ObjectsExploitation' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Catalog" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Catalog", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."prefix"'), '') "prefix"
, ISNULL(JSON_VALUE(d.doc, N'$."icon"'), '') "icon"
, ISNULL(JSON_VALUE(d.doc, N'$."menu"'), '') "menu"
, ISNULL(JSON_VALUE(d.doc, N'$."presentation"'), '') "presentation"
, ISNULL(JSON_VALUE(d.doc, N'$."hierarchy"'), '') "hierarchy"
, ISNULL(JSON_VALUE(d.doc, N'$."module"'), '') "module"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Catalog.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Catalog.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Catalog.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Catalog.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Catalog' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.BudgetItem" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BudgetItem", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."FactRule"'), '') "FactRule"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "BudgetItem.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "BudgetItem.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "BudgetItem.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "BudgetItem.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.BudgetItem' 
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Scenario" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Scenario", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Scenario.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Scenario.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Scenario.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Scenario.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Scenario' 
      GO

      CREATE OR ALTER VIEW dbo."Document.ExchangeRates" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ExchangeRates", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "ExchangeRates.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "ExchangeRates.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "ExchangeRates.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "ExchangeRates.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Document.ExchangeRates' 
      GO

      CREATE OR ALTER VIEW dbo."Document.Invoice" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Invoice", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
,

        ISNULL("Storehouse".description, N'') "Storehouse.value", ISNULL("Storehouse".type, N'Catalog.Storehouse') "Storehouse.type",
          CAST(JSON_VALUE(d.doc, N'$."Storehouse"') AS UNIQUEIDENTIFIER) "Storehouse.id"
,

        ISNULL("Customer".description, N'') "Customer.value", ISNULL("Customer".type, N'Catalog.Counterpartie') "Customer.type",
          CAST(JSON_VALUE(d.doc, N'$."Customer"') AS UNIQUEIDENTIFIER) "Customer.id"
,

        ISNULL("Manager".description, N'') "Manager.value", ISNULL("Manager".type, N'Catalog.Manager') "Manager.type",
          CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER) "Manager.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Status"'), '') "Status"
, ISNULL(JSON_VALUE(d.doc, N'$."PayDay"'), '') "PayDay"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Amount"') AS NUMERIC(15,2)), 0) "Amount"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Tax"') AS NUMERIC(15,2)), 0) "Tax"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Invoice.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Invoice.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Invoice.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Invoice.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Storehouse" ON "Storehouse".id = CAST(JSON_VALUE(d.doc, N'$."Storehouse"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Customer" ON "Customer".id = CAST(JSON_VALUE(d.doc, N'$."Customer"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Manager" ON "Manager".id = CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.Invoice' 
      GO

      CREATE OR ALTER VIEW dbo."Document.Operation" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("Group".description, N'') "Group.value", ISNULL("Group".type, N'Catalog.Operation.Group') "Group.type",
          CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER) "Group.id"
,

        ISNULL("Operation".description, N'') "Operation.value", ISNULL("Operation".type, N'Catalog.Operation') "Operation.type",
          CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER) "Operation.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Amount"') AS NUMERIC(15,2)), 0) "Amount"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,
        IIF("f1".id IS NULL, JSON_VALUE(d.doc, N'$."f1".id'), "f1".id) "f1.id",
        IIF("f1".id IS NULL, JSON_VALUE(d.doc, N'$."f1".value'), "f1".description) "f1.value",
        IIF("f1".id IS NULL, JSON_VALUE(d.doc, N'$."f1".type'), "f1".type) "f1.type"
,
        IIF("f2".id IS NULL, JSON_VALUE(d.doc, N'$."f2".id'), "f2".id) "f2.id",
        IIF("f2".id IS NULL, JSON_VALUE(d.doc, N'$."f2".value'), "f2".description) "f2.value",
        IIF("f2".id IS NULL, JSON_VALUE(d.doc, N'$."f2".type'), "f2".type) "f2.type"
,
        IIF("f3".id IS NULL, JSON_VALUE(d.doc, N'$."f3".id'), "f3".id) "f3.id",
        IIF("f3".id IS NULL, JSON_VALUE(d.doc, N'$."f3".value'), "f3".description) "f3.value",
        IIF("f3".id IS NULL, JSON_VALUE(d.doc, N'$."f3".type'), "f3".type) "f3.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Operation.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Operation.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Operation.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Operation.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Operation" ON "Operation".id = CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "f1" ON "f1".id = CAST(JSON_VALUE(d.doc, N'$."f1"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "f2" ON "f2".id = CAST(JSON_VALUE(d.doc, N'$."f2"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "f3" ON "f3".id = CAST(JSON_VALUE(d.doc, N'$."f3"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.Operation' 
      GO

      CREATE OR ALTER VIEW dbo."Document.PriceList" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "PriceList", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("PriceType".description, N'') "PriceType.value", ISNULL("PriceType".type, N'Catalog.PriceType') "PriceType.type",
          CAST(JSON_VALUE(d.doc, N'$."PriceType"') AS UNIQUEIDENTIFIER) "PriceType.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."TaxInclude"') AS BIT), 0) "TaxInclude"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "PriceList.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "PriceList.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "PriceList.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "PriceList.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "PriceType" ON "PriceType".id = CAST(JSON_VALUE(d.doc, N'$."PriceType"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.PriceList' 
      GO

      CREATE OR ALTER VIEW dbo."Document.Settings" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Settings", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("balanceCurrency".description, N'') "balanceCurrency.value", ISNULL("balanceCurrency".type, N'Catalog.Currency') "balanceCurrency.type",
          CAST(JSON_VALUE(d.doc, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER) "balanceCurrency.id"
,

        ISNULL("accountingCurrency".description, N'') "accountingCurrency.value", ISNULL("accountingCurrency".type, N'Catalog.Currency') "accountingCurrency.type",
          CAST(JSON_VALUE(d.doc, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER) "accountingCurrency.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Settings.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Settings.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Settings.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Settings.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "balanceCurrency" ON "balanceCurrency".id = CAST(JSON_VALUE(d.doc, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "accountingCurrency" ON "accountingCurrency".id = CAST(JSON_VALUE(d.doc, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.Settings' 
      GO

      CREATE OR ALTER VIEW dbo."Document.UserSettings" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "UserSettings", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "UserSettings.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "UserSettings.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "UserSettings.Level2"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
              (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
             (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "UserSettings.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Document.UserSettings' 
      GO