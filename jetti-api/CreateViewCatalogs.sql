

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
      GRANT SELECT ON dbo."Catalog.Account" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Balance" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Balance.Analytics" TO jetti;
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
,

        ISNULL("Bank".description, N'') "Bank.value", ISNULL("Bank".type, N'Catalog.Bank') "Bank.type",
          CAST(JSON_VALUE(d.doc, N'$."Bank"') AS UNIQUEIDENTIFIER) "Bank.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isDefault"') AS BIT), 0) "isDefault"

    

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

      LEFT JOIN dbo."Documents" "Bank" ON "Bank".id = CAST(JSON_VALUE(d.doc, N'$."Bank"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.BankAccount' 
      GO
      GRANT SELECT ON dbo."Catalog.BankAccount" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.CashFlow" TO jetti;
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
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isAccounting"') AS BIT), 0) "isAccounting"

    

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
      GRANT SELECT ON dbo."Catalog.CashRegister" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Currency" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Company" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Counterpartie" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Counterpartie", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."kind"'), '') "kind"
, ISNULL(JSON_VALUE(d.doc, N'$."FullName"'), '') "FullName"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Client"') AS BIT), 0) "Client"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Supplier"') AS BIT), 0) "Supplier"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isInternal"') AS BIT), 0) "isInternal"
, ISNULL(JSON_VALUE(d.doc, N'$."AddressShipping"'), '') "AddressShipping"
, ISNULL(JSON_VALUE(d.doc, N'$."AddressBilling"'), '') "AddressBilling"
, ISNULL(JSON_VALUE(d.doc, N'$."Phone"'), '') "Phone"
, ISNULL(JSON_VALUE(d.doc, N'$."Code1"'), '') "Code1"
, ISNULL(JSON_VALUE(d.doc, N'$."Code2"'), '') "Code2"
, ISNULL(JSON_VALUE(d.doc, N'$."Code3"'), '') "Code3"

    

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
      GRANT SELECT ON dbo."Catalog.Counterpartie" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Counterpartie.BankAccount" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CounterpartieBankAccount", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
,

        ISNULL("Bank".description, N'') "Bank.value", ISNULL("Bank".type, N'Catalog.Bank') "Bank.type",
          CAST(JSON_VALUE(d.doc, N'$."Bank"') AS UNIQUEIDENTIFIER) "Bank.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isDefault"') AS BIT), 0) "isDefault"
,

        ISNULL("owner".description, N'') "owner.value", ISNULL("owner".type, N'Catalog.Counterpartie') "owner.type",
          CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER) "owner.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "CounterpartieBankAccount.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "CounterpartieBankAccount.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "CounterpartieBankAccount.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "CounterpartieBankAccount.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Bank" ON "Bank".id = CAST(JSON_VALUE(d.doc, N'$."Bank"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "owner" ON "owner".id = CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Counterpartie.BankAccount' 
      GO
      GRANT SELECT ON dbo."Catalog.Counterpartie.BankAccount" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Contract" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Contract", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("owner".description, N'') "owner.value", ISNULL("owner".type, N'Catalog.Counterpartie') "owner.type",
          CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER) "owner.id"
, ISNULL(JSON_VALUE(d.doc, N'$."kind"'), '') "kind"
,

        ISNULL("BusinessDirection".description, N'') "BusinessDirection.value", ISNULL("BusinessDirection".type, N'Catalog.BusinessDirection') "BusinessDirection.type",
          CAST(JSON_VALUE(d.doc, N'$."BusinessDirection"') AS UNIQUEIDENTIFIER) "BusinessDirection.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Status"'), '') "Status"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,

        ISNULL("Manager".description, N'') "Manager.value", ISNULL("Manager".type, N'Catalog.Manager') "Manager.type",
          CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER) "Manager.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Contract.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Contract.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Contract.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Contract.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "owner" ON "owner".id = CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "BusinessDirection" ON "BusinessDirection".id = CAST(JSON_VALUE(d.doc, N'$."BusinessDirection"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Manager" ON "Manager".id = CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Contract' 
      GO
      GRANT SELECT ON dbo."Catalog.Contract" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.BusinessDirection" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BusinessDirection", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "BusinessDirection.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "BusinessDirection.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "BusinessDirection.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "BusinessDirection.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.BusinessDirection' 
      GO
      GRANT SELECT ON dbo."Catalog.BusinessDirection" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Department" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Expense" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Expense.Analytics" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Income" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Loan" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Manager" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Person" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.PriceType" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Product" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.ProductCategory" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.ProductKind" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Storehouse" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Operation" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Operation.Group" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Operation.Type" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Unit" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.User" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.UsersGroup" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "UsersGroup", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "UsersGroup.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "UsersGroup.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "UsersGroup.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "UsersGroup.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.UsersGroup' 
      GO
      GRANT SELECT ON dbo."Catalog.UsersGroup" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Role" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.SubSystem" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "SubSystem", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."icon"'), '') "icon"

    

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
      GRANT SELECT ON dbo."Catalog.SubSystem" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Documents" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Catalogs" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Forms" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Forms", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Forms.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Forms.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Forms.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Forms.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Forms' 
      GO
      GRANT SELECT ON dbo."Catalog.Forms" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Objects" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Subcount" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Brand" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.GroupObjectsExploitation" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.ObjectsExploitation" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Catalog" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.BudgetItem" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BudgetItem", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"

    

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
      GRANT SELECT ON dbo."Catalog.BudgetItem" TO jetti;
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
      GRANT SELECT ON dbo."Catalog.Scenario" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.AcquiringTerminal" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "AcquiringTerminal", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("BankAccount".description, N'') "BankAccount.value", ISNULL("BankAccount".type, N'Catalog.BankAccount') "BankAccount.type",
          CAST(JSON_VALUE(d.doc, N'$."BankAccount"') AS UNIQUEIDENTIFIER) "BankAccount.id"
,

        ISNULL("Counterpartie".description, N'') "Counterpartie.value", ISNULL("Counterpartie".type, N'Catalog.Counterpartie') "Counterpartie.type",
          CAST(JSON_VALUE(d.doc, N'$."Counterpartie"') AS UNIQUEIDENTIFIER) "Counterpartie.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "AcquiringTerminal.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "AcquiringTerminal.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "AcquiringTerminal.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "AcquiringTerminal.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "BankAccount" ON "BankAccount".id = CAST(JSON_VALUE(d.doc, N'$."BankAccount"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Counterpartie" ON "Counterpartie".id = CAST(JSON_VALUE(d.doc, N'$."Counterpartie"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.AcquiringTerminal' 
      GO
      GRANT SELECT ON dbo."Catalog.AcquiringTerminal" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Catalog.Bank" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Bank", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
, ISNULL(JSON_VALUE(d.doc, N'$."Code1"'), '') "Code1"
, ISNULL(JSON_VALUE(d.doc, N'$."Code2"'), '') "Code2"
, ISNULL(JSON_VALUE(d.doc, N'$."Address"'), '') "Address"
, ISNULL(JSON_VALUE(d.doc, N'$."KorrAccount"'), '') "KorrAccount"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isActive"') AS BIT), 0) "isActive"

    

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "Bank.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "Bank.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "Bank.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "Bank.Level1"
      FROM dbo."Documents" d

      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
    WHERE d.[type] = 'Catalog.Bank' 
      GO
      GRANT SELECT ON dbo."Catalog.Bank" TO jetti;
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
      GRANT SELECT ON dbo."Document.ExchangeRates" TO jetti;
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
      GRANT SELECT ON dbo."Document.Invoice" TO jetti;
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
      GRANT SELECT ON dbo."Document.Operation" TO jetti;
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
      GRANT SELECT ON dbo."Document.PriceList" TO jetti;
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
      GRANT SELECT ON dbo."Document.Settings" TO jetti;
      GO

      CREATE OR ALTER VIEW dbo."Document.UserSettings" WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "UserSettings", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,
        IIF("UserOrGroup".id IS NULL, JSON_VALUE(d.doc, N'$."UserOrGroup".id'), "UserOrGroup".id) "UserOrGroup.id",
        IIF("UserOrGroup".id IS NULL, JSON_VALUE(d.doc, N'$."UserOrGroup".value'), "UserOrGroup".description) "UserOrGroup.value",
        IIF("UserOrGroup".id IS NULL, JSON_VALUE(d.doc, N'$."UserOrGroup".type'), "UserOrGroup".type) "UserOrGroup.type"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."COMP"') AS BIT), 0) "COMP"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."DEPT"') AS BIT), 0) "DEPT"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."STOR"') AS BIT), 0) "STOR"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."CASH"') AS BIT), 0) "CASH"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."BANK"') AS BIT), 0) "BANK"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."GROUP"') AS BIT), 0) "GROUP"

    

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
      
      LEFT JOIN dbo."Documents" "UserOrGroup" ON "UserOrGroup".id = CAST(JSON_VALUE(d.doc, N'$."UserOrGroup"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.UserSettings' 
      GO
      GRANT SELECT ON dbo."Document.UserSettings" TO jetti;
      GO