

      DROP VIEW IF EXISTS dbo.[Catalog.Account];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Account] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Account", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isForex"') AS BIT), 0) "isForex"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isActive"') AS BIT), 0) "isActive"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isPassive"') AS BIT), 0) "isPassive"

    
      , ISNULL(l5.description, d.description) [Account.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Account.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Account.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Account.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Account.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Account' 
      GO
      GRANT SELECT ON dbo.[Catalog.Account] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Balance];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Balance] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Balance", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isActive"') AS BIT), 0) "isActive"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isPassive"') AS BIT), 0) "isPassive"

    
      , ISNULL(l5.description, d.description) [Balance.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Balance.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Balance.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Balance.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Balance.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Balance' 
      GO
      GRANT SELECT ON dbo.[Catalog.Balance] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Balance.Analytics];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Balance.Analytics] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BalanceAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [BalanceAnalytics.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BalanceAnalytics.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BalanceAnalytics.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BalanceAnalytics.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BalanceAnalytics.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Balance.Analytics' 
      GO
      GRANT SELECT ON dbo.[Catalog.Balance.Analytics] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.BankAccount];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.BankAccount] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BankAccount", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [BankAccount.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BankAccount.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BankAccount.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BankAccount.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BankAccount.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Bank" ON "Bank".id = CAST(JSON_VALUE(d.doc, N'$."Bank"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.BankAccount' 
      GO
      GRANT SELECT ON dbo.[Catalog.BankAccount] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.CashFlow];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.CashFlow] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CashFlow", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [CashFlow.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashFlow.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashFlow.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashFlow.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashFlow.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.CashFlow' 
      GO
      GRANT SELECT ON dbo.[Catalog.CashFlow] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.CashRegister];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.CashRegister] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CashRegister", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isAccounting"') AS BIT), 0) "isAccounting"

    
      , ISNULL(l5.description, d.description) [CashRegister.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashRegister.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashRegister.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashRegister.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashRegister.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.CashRegister' 
      GO
      GRANT SELECT ON dbo.[Catalog.CashRegister] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Currency];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Currency] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Currency", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Currency.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Currency.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Currency.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Currency.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Currency.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Currency' 
      GO
      GRANT SELECT ON dbo.[Catalog.Currency] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Company];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Company] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Company", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."FullName"'), '') "FullName"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
, ISNULL(JSON_VALUE(d.doc, N'$."prefix"'), '') "prefix"
,

        ISNULL("Intercompany".description, N'') "Intercompany.value", ISNULL("Intercompany".type, N'Catalog.Company') "Intercompany.type",
          CAST(JSON_VALUE(d.doc, N'$."Intercompany"') AS UNIQUEIDENTIFIER) "Intercompany.id"
, ISNULL(JSON_VALUE(d.doc, N'$."AddressShipping"'), '') "AddressShipping"
, ISNULL(JSON_VALUE(d.doc, N'$."AddressBilling"'), '') "AddressBilling"
, ISNULL(JSON_VALUE(d.doc, N'$."Phone"'), '') "Phone"
, ISNULL(JSON_VALUE(d.doc, N'$."Code1"'), '') "Code1"
, ISNULL(JSON_VALUE(d.doc, N'$."Code2"'), '') "Code2"
, ISNULL(JSON_VALUE(d.doc, N'$."Code3"'), '') "Code3"
, ISNULL(JSON_VALUE(d.doc, N'$."timeZone"'), '') "timeZone"

    
      , ISNULL(l5.description, d.description) [Company.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Company.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Company.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Company.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Company.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Intercompany" ON "Intercompany".id = CAST(JSON_VALUE(d.doc, N'$."Intercompany"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Company' 
      GO
      GRANT SELECT ON dbo.[Catalog.Company] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Counterpartie];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Counterpartie", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [Counterpartie.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Counterpartie.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Counterpartie.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Counterpartie.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Counterpartie.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Counterpartie' 
      GO
      GRANT SELECT ON dbo.[Catalog.Counterpartie] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Counterpartie.BankAccount];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie.BankAccount] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CounterpartieBankAccount", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [CounterpartieBankAccount.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CounterpartieBankAccount.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CounterpartieBankAccount.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CounterpartieBankAccount.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CounterpartieBankAccount.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Bank" ON "Bank".id = CAST(JSON_VALUE(d.doc, N'$."Bank"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "owner" ON "owner".id = CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Counterpartie.BankAccount' 
      GO
      GRANT SELECT ON dbo.[Catalog.Counterpartie.BankAccount] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Contract];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Contract] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Contract", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("owner".description, N'') "owner.value", ISNULL("owner".type, N'Catalog.Counterpartie') "owner.type",
          CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER) "owner.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Status"'), '') "Status"
, ISNULL(JSON_VALUE(d.doc, N'$."kind"'), '') "kind"
, ISNULL(JSON_VALUE(d.doc, N'$."StartDate"'), '') "StartDate"
, ISNULL(JSON_VALUE(d.doc, N'$."EndDate"'), '') "EndDate"
,

        ISNULL("BusinessDirection".description, N'') "BusinessDirection.value", ISNULL("BusinessDirection".type, N'Catalog.BusinessDirection') "BusinessDirection.type",
          CAST(JSON_VALUE(d.doc, N'$."BusinessDirection"') AS UNIQUEIDENTIFIER) "BusinessDirection.id"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
,

        ISNULL("Manager".description, N'') "Manager.value", ISNULL("Manager".type, N'Catalog.Manager') "Manager.type",
          CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER) "Manager.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isDefault"') AS BIT), 0) "isDefault"

    
      , ISNULL(l5.description, d.description) [Contract.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Contract.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Contract.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Contract.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Contract.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "owner" ON "owner".id = CAST(JSON_VALUE(d.doc, N'$."owner"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "BusinessDirection" ON "BusinessDirection".id = CAST(JSON_VALUE(d.doc, N'$."BusinessDirection"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Manager" ON "Manager".id = CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Contract' 
      GO
      GRANT SELECT ON dbo.[Catalog.Contract] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.BusinessDirection];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.BusinessDirection] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BusinessDirection", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [BusinessDirection.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BusinessDirection.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BusinessDirection.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BusinessDirection.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BusinessDirection.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.BusinessDirection' 
      GO
      GRANT SELECT ON dbo.[Catalog.BusinessDirection] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Department];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Department] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Department", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Department.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Department.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Department.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Department.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Department.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Department' 
      GO
      GRANT SELECT ON dbo.[Catalog.Department] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Expense];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Expense] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Expense", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("Account".description, N'') "Account.value", ISNULL("Account".type, N'Catalog.Account') "Account.type",
          CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER) "Account.id"

    
      , ISNULL(l5.description, d.description) [Expense.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Expense.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Expense.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Expense.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Expense.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Account" ON "Account".id = CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Expense' 
      GO
      GRANT SELECT ON dbo.[Catalog.Expense] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Expense.Analytics];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Expense.Analytics] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ExpenseAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [ExpenseAnalytics.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ExpenseAnalytics.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ExpenseAnalytics.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ExpenseAnalytics.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ExpenseAnalytics.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Expense.Analytics' 
      GO
      GRANT SELECT ON dbo.[Catalog.Expense.Analytics] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Income];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Income] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Income", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("Account".description, N'') "Account.value", ISNULL("Account".type, N'Catalog.Account') "Account.type",
          CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER) "Account.id"

    
      , ISNULL(l5.description, d.description) [Income.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Income.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Income.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Income.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Income.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Account" ON "Account".id = CAST(JSON_VALUE(d.doc, N'$."Account"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Income' 
      GO
      GRANT SELECT ON dbo.[Catalog.Income] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Loan];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Loan] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Loan", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"

    
      , ISNULL(l5.description, d.description) [Loan.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Loan.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Loan.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Loan.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Loan.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Loan' 
      GO
      GRANT SELECT ON dbo.[Catalog.Loan] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Manager];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Manager] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Manager", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."FullName"'), '') "FullName"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Gender"') AS BIT), 0) "Gender"
, ISNULL(JSON_VALUE(d.doc, N'$."Birthday"'), '') "Birthday"

    
      , ISNULL(l5.description, d.description) [Manager.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Manager.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Manager.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Manager.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Manager.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Manager' 
      GO
      GRANT SELECT ON dbo.[Catalog.Manager] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Person];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Person] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Person", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Person.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Person.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Person.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Person.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Person.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Person' 
      GO
      GRANT SELECT ON dbo.[Catalog.Person] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.PriceType];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.PriceType] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "PriceType", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."TaxInclude"') AS BIT), 0) "TaxInclude"

    
      , ISNULL(l5.description, d.description) [PriceType.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PriceType.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PriceType.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PriceType.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PriceType.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.PriceType' 
      GO
      GRANT SELECT ON dbo.[Catalog.PriceType] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Product];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Product] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Product", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [Product.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Product.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Product.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Product.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Product.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "ProductKind" ON "ProductKind".id = CAST(JSON_VALUE(d.doc, N'$."ProductKind"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "ProductCategory" ON "ProductCategory".id = CAST(JSON_VALUE(d.doc, N'$."ProductCategory"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Brand" ON "Brand".id = CAST(JSON_VALUE(d.doc, N'$."Brand"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Unit" ON "Unit".id = CAST(JSON_VALUE(d.doc, N'$."Unit"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Product' 
      GO
      GRANT SELECT ON dbo.[Catalog.Product] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.ProductCategory];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.ProductCategory] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ProductCategory", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [ProductCategory.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductCategory.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductCategory.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductCategory.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductCategory.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.ProductCategory' 
      GO
      GRANT SELECT ON dbo.[Catalog.ProductCategory] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.ProductKind];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.ProductKind] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ProductKind", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."ProductType"'), '') "ProductType"

    
      , ISNULL(l5.description, d.description) [ProductKind.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductKind.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductKind.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductKind.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductKind.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.ProductKind' 
      GO
      GRANT SELECT ON dbo.[Catalog.ProductKind] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Storehouse];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Storehouse] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Storehouse", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"

    
      , ISNULL(l5.description, d.description) [Storehouse.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Storehouse.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Storehouse.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Storehouse.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Storehouse.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Storehouse' 
      GO
      GRANT SELECT ON dbo.[Catalog.Storehouse] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Operation];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Operation] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("Group".description, N'') "Group.value", ISNULL("Group".type, N'Catalog.Operation.Group') "Group.type",
          CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER) "Group.id"
, ISNULL(JSON_VALUE(d.doc, N'$."script"'), '') "script"
, ISNULL(JSON_VALUE(d.doc, N'$."module"'), '') "module"

    
      , ISNULL(l5.description, d.description) [Operation.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Operation.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Operation.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Operation.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Operation.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Operation' 
      GO
      GRANT SELECT ON dbo.[Catalog.Operation] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Operation.Group];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Group] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "OperationGroup", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Prefix"'), '') "Prefix"

    
      , ISNULL(l5.description, d.description) [OperationGroup.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [OperationGroup.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [OperationGroup.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [OperationGroup.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [OperationGroup.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Operation.Group' 
      GO
      GRANT SELECT ON dbo.[Catalog.Operation.Group] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Operation.Type];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Type] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "OperationType", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [OperationType.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [OperationType.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [OperationType.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [OperationType.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [OperationType.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Operation.Type' 
      GO
      GRANT SELECT ON dbo.[Catalog.Operation.Type] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Unit];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Unit] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Unit", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Unit.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Unit.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Unit.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Unit.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Unit.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Unit' 
      GO
      GRANT SELECT ON dbo.[Catalog.Unit] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.User];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.User] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "User", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isAdmin"') AS BIT), 0) "isAdmin"

    
      , ISNULL(l5.description, d.description) [User.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [User.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [User.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [User.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [User.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.User' 
      GO
      GRANT SELECT ON dbo.[Catalog.User] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.UsersGroup];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.UsersGroup] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "UsersGroup", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [UsersGroup.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [UsersGroup.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [UsersGroup.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [UsersGroup.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [UsersGroup.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.UsersGroup' 
      GO
      GRANT SELECT ON dbo.[Catalog.UsersGroup] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Role];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Role] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Role", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Role.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Role.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Role.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Role.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Role.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Role' 
      GO
      GRANT SELECT ON dbo.[Catalog.Role] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.SubSystem];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.SubSystem] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "SubSystem", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."icon"'), '') "icon"

    
      , ISNULL(l5.description, d.description) [SubSystem.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [SubSystem.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [SubSystem.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [SubSystem.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [SubSystem.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.SubSystem' 
      GO
      GRANT SELECT ON dbo.[Catalog.SubSystem] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Documents];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Documents] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Documents", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Documents.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Documents.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Documents.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Documents.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Documents.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Documents' 
      GO
      GRANT SELECT ON dbo.[Catalog.Documents] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Catalogs];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Catalogs] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Catalogs", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Catalogs.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Catalogs.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Catalogs.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Catalogs.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Catalogs.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Catalogs' 
      GO
      GRANT SELECT ON dbo.[Catalog.Catalogs] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Forms];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Forms] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Forms", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Forms.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Forms.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Forms.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Forms.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Forms.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Forms' 
      GO
      GRANT SELECT ON dbo.[Catalog.Forms] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Objects];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Objects] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Objects", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Objects.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Objects.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Objects.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Objects.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Objects.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Objects' 
      GO
      GRANT SELECT ON dbo.[Catalog.Objects] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Subcount];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Subcount] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Subcount", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Subcount.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Subcount.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Subcount.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Subcount.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Subcount.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Subcount' 
      GO
      GRANT SELECT ON dbo.[Catalog.Subcount] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Brand];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Brand] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Brand", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [Brand.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Brand.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Brand.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Brand.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Brand.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Brand' 
      GO
      GRANT SELECT ON dbo.[Catalog.Brand] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.GroupObjectsExploitation];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.GroupObjectsExploitation] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "GroupObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Method"'), '') "Method"

    
      , ISNULL(l5.description, d.description) [GroupObjectsExploitation.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [GroupObjectsExploitation.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [GroupObjectsExploitation.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [GroupObjectsExploitation.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [GroupObjectsExploitation.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.GroupObjectsExploitation' 
      GO
      GRANT SELECT ON dbo.[Catalog.GroupObjectsExploitation] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.ObjectsExploitation];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.ObjectsExploitation] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("Group".description, N'') "Group.value", ISNULL("Group".type, N'Catalog.ObjectsExploitation') "Group.type",
          CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER) "Group.id"
, ISNULL(JSON_VALUE(d.doc, N'$."InventoryNumber"'), '') "InventoryNumber"

    
      , ISNULL(l5.description, d.description) [ObjectsExploitation.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ObjectsExploitation.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ObjectsExploitation.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ObjectsExploitation.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ObjectsExploitation.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.ObjectsExploitation' 
      GO
      GRANT SELECT ON dbo.[Catalog.ObjectsExploitation] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Catalog];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Catalog] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Catalog", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."prefix"'), '') "prefix"
, ISNULL(JSON_VALUE(d.doc, N'$."icon"'), '') "icon"
, ISNULL(JSON_VALUE(d.doc, N'$."menu"'), '') "menu"
, ISNULL(JSON_VALUE(d.doc, N'$."presentation"'), '') "presentation"
, ISNULL(JSON_VALUE(d.doc, N'$."hierarchy"'), '') "hierarchy"
, ISNULL(JSON_VALUE(d.doc, N'$."module"'), '') "module"

    
      , ISNULL(l5.description, d.description) [Catalog.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Catalog.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Catalog.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Catalog.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Catalog.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Catalog' 
      GO
      GRANT SELECT ON dbo.[Catalog.Catalog] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.BudgetItem];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.BudgetItem] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "BudgetItem", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [BudgetItem.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BudgetItem.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BudgetItem.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BudgetItem.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BudgetItem.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.BudgetItem' 
      GO
      GRANT SELECT ON dbo.[Catalog.BudgetItem] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Scenario];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Scenario] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Scenario", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("currency".description, N'') "currency.value", ISNULL("currency".type, N'Catalog.Currency') "currency.type",
          CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER) "currency.id"

    
      , ISNULL(l5.description, d.description) [Scenario.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Scenario.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Scenario.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Scenario.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Scenario.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Scenario' 
      GO
      GRANT SELECT ON dbo.[Catalog.Scenario] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.AcquiringTerminal];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.AcquiringTerminal] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "AcquiringTerminal", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("BankAccount".description, N'') "BankAccount.value", ISNULL("BankAccount".type, N'Catalog.BankAccount') "BankAccount.type",
          CAST(JSON_VALUE(d.doc, N'$."BankAccount"') AS UNIQUEIDENTIFIER) "BankAccount.id"
,

        ISNULL("Counterpartie".description, N'') "Counterpartie.value", ISNULL("Counterpartie".type, N'Catalog.Counterpartie') "Counterpartie.type",
          CAST(JSON_VALUE(d.doc, N'$."Counterpartie"') AS UNIQUEIDENTIFIER) "Counterpartie.id"
,

        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isDefault"') AS BIT), 0) "isDefault"

    
      , ISNULL(l5.description, d.description) [AcquiringTerminal.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [AcquiringTerminal.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [AcquiringTerminal.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [AcquiringTerminal.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [AcquiringTerminal.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "BankAccount" ON "BankAccount".id = CAST(JSON_VALUE(d.doc, N'$."BankAccount"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Counterpartie" ON "Counterpartie".id = CAST(JSON_VALUE(d.doc, N'$."Counterpartie"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.AcquiringTerminal' 
      GO
      GRANT SELECT ON dbo.[Catalog.AcquiringTerminal] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Catalog.Bank];
      GO
      CREATE OR ALTER VIEW dbo.[Catalog.Bank] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Bank", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
, ISNULL(JSON_VALUE(d.doc, N'$."Code1"'), '') "Code1"
, ISNULL(JSON_VALUE(d.doc, N'$."Code2"'), '') "Code2"
, ISNULL(JSON_VALUE(d.doc, N'$."Address"'), '') "Address"
, ISNULL(JSON_VALUE(d.doc, N'$."KorrAccount"'), '') "KorrAccount"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."isActive"') AS BIT), 0) "isActive"

    
      , ISNULL(l5.description, d.description) [Bank.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Bank.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Bank.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Bank.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Bank.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Catalog.Bank' 
      GO
      GRANT SELECT ON dbo.[Catalog.Bank] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Document.ExchangeRates];
      GO
      CREATE OR ALTER VIEW dbo.[Document.ExchangeRates] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "ExchangeRates", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"

    
      , ISNULL(l5.description, d.description) [ExchangeRates.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ExchangeRates.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ExchangeRates.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ExchangeRates.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ExchangeRates.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.ExchangeRates' 
      GO
      GRANT SELECT ON dbo.[Document.ExchangeRates] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Document.Invoice];
      GO
      CREATE OR ALTER VIEW dbo.[Document.Invoice] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Invoice", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [Invoice.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Invoice.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Invoice.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Invoice.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Invoice.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Storehouse" ON "Storehouse".id = CAST(JSON_VALUE(d.doc, N'$."Storehouse"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Customer" ON "Customer".id = CAST(JSON_VALUE(d.doc, N'$."Customer"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Manager" ON "Manager".id = CAST(JSON_VALUE(d.doc, N'$."Manager"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.Invoice' 
      GO
      GRANT SELECT ON dbo.[Document.Invoice] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Document.Operation];
      GO
      CREATE OR ALTER VIEW dbo.[Document.Operation] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [Operation.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Operation.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Operation.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Operation.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Operation.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Group" ON "Group".id = CAST(JSON_VALUE(d.doc, N'$."Group"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Operation" ON "Operation".id = CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "currency" ON "currency".id = CAST(JSON_VALUE(d.doc, N'$."currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "f1" ON "f1".id = CAST(JSON_VALUE(d.doc, N'$."f1"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "f2" ON "f2".id = CAST(JSON_VALUE(d.doc, N'$."f2"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "f3" ON "f3".id = CAST(JSON_VALUE(d.doc, N'$."f3"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.Operation' 
      GO
      GRANT SELECT ON dbo.[Document.Operation] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Document.PriceList];
      GO
      CREATE OR ALTER VIEW dbo.[Document.PriceList] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "PriceList", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("PriceType".description, N'') "PriceType.value", ISNULL("PriceType".type, N'Catalog.PriceType') "PriceType.type",
          CAST(JSON_VALUE(d.doc, N'$."PriceType"') AS UNIQUEIDENTIFIER) "PriceType.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."TaxInclude"') AS BIT), 0) "TaxInclude"

    
      , ISNULL(l5.description, d.description) [PriceList.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PriceList.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PriceList.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PriceList.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PriceList.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "PriceType" ON "PriceType".id = CAST(JSON_VALUE(d.doc, N'$."PriceType"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.PriceList' 
      GO
      GRANT SELECT ON dbo.[Document.PriceList] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Document.Settings];
      GO
      CREATE OR ALTER VIEW dbo.[Document.Settings] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "Settings", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,

        ISNULL("balanceCurrency".description, N'') "balanceCurrency.value", ISNULL("balanceCurrency".type, N'Catalog.Currency') "balanceCurrency.type",
          CAST(JSON_VALUE(d.doc, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER) "balanceCurrency.id"
,

        ISNULL("accountingCurrency".description, N'') "accountingCurrency.value", ISNULL("accountingCurrency".type, N'Catalog.Currency') "accountingCurrency.type",
          CAST(JSON_VALUE(d.doc, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER) "accountingCurrency.id"

    
      , ISNULL(l5.description, d.description) [Settings.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Settings.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Settings.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Settings.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Settings.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "balanceCurrency" ON "balanceCurrency".id = CAST(JSON_VALUE(d.doc, N'$."balanceCurrency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "accountingCurrency" ON "accountingCurrency".id = CAST(JSON_VALUE(d.doc, N'$."accountingCurrency"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.Settings' 
      GO
      GRANT SELECT ON dbo.[Document.Settings] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

      DROP VIEW IF EXISTS dbo.[Document.UserSettings];
      GO
      CREATE OR ALTER VIEW dbo.[Document.UserSettings] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "UserSettings", d.posted, d.deleted, d.isfolder, d.timestamp
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
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

    
      , ISNULL(l5.description, d.description) [UserSettings.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [UserSettings.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [UserSettings.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [UserSettings.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [UserSettings.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "UserOrGroup" ON "UserOrGroup".id = CAST(JSON_VALUE(d.doc, N'$."UserOrGroup"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.UserSettings' 
      GO
      GRANT SELECT ON dbo.[Document.UserSettings] TO jetti;
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      

<<<<<<< HEAD
      DROP VIEW IF EXISTS dbo.[Document.CashRequest];
      GO
      CREATE OR ALTER VIEW dbo.[Document.CashRequest] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "CashRequest", d.posted, d.deleted, d.isfolder, d.timestamp
=======
      DROP VIEW IF EXISTS dbo.[Document.WorkFlow];
      GO
      CREATE OR ALTER VIEW dbo.[Document.WorkFlow] WITH SCHEMABINDING AS
        
      SELECT d.id, d.type, d.date, d.code, d.description "WorkFlow", d.posted, d.deleted, d.isfolder, d.timestamp
>>>>>>> 16f383d5a48274bfee6f3200ca5d733f771d2020
      , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
      , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
      , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
,

<<<<<<< HEAD
        ISNULL("Department".description, N'') "Department.value", ISNULL("Department".type, N'Catalog.Department') "Department.type",
          CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER) "Department.id"
,

        ISNULL("CashFlow".description, N'') "CashFlow.value", ISNULL("CashFlow".type, N'Catalog.CashFlow') "CashFlow.type",
          CAST(JSON_VALUE(d.doc, N'$."CashFlow"') AS UNIQUEIDENTIFIER) "CashFlow.id"
,

        ISNULL("Recipient".description, N'') "Recipient.value", ISNULL("Recipient".type, N'Catalog.Counterpartie') "Recipient.type",
          CAST(JSON_VALUE(d.doc, N'$."Recipient"') AS UNIQUEIDENTIFIER) "Recipient.id"
, ISNULL(CAST(JSON_VALUE(d.doc, N'$."Amount"') AS NUMERIC(15,2)), 0) "Amount"
,

        ISNULL("Currency".description, N'') "Currency.value", ISNULL("Currency".type, N'Catalog.Currency') "Currency.type",
          CAST(JSON_VALUE(d.doc, N'$."Currency"') AS UNIQUEIDENTIFIER) "Currency.id"
,

        ISNULL("OperationGroup".description, N'') "OperationGroup.value", ISNULL("OperationGroup".type, N'Catalog.Operation.Group') "OperationGroup.type",
          CAST(JSON_VALUE(d.doc, N'$."OperationGroup"') AS UNIQUEIDENTIFIER) "OperationGroup.id"
,

        ISNULL("Operation".description, N'') "Operation.value", ISNULL("Operation".type, N'Catalog.Operation') "Operation.type",
          CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER) "Operation.id"

    
      , ISNULL(l5.description, d.description) [CashRequest.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashRequest.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashRequest.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashRequest.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashRequest.Level1]
=======
        ISNULL("workflow".description, N'') "workflow.value", ISNULL("workflow".type, N'Document.WorkFlow') "workflow.type",
          CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER) "workflow.id"
,
        IIF("Document".id IS NULL, JSON_VALUE(d.doc, N'$."Document".id'), "Document".id) "Document.id",
        IIF("Document".id IS NULL, JSON_VALUE(d.doc, N'$."Document".value'), "Document".description) "Document.value",
        IIF("Document".id IS NULL, JSON_VALUE(d.doc, N'$."Document".type'), "Document".type) "Document.type"
, ISNULL(JSON_VALUE(d.doc, N'$."Status"'), '') "Status"

    
      , ISNULL(l5.description, d.description) [WorkFlow.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [WorkFlow.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [WorkFlow.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [WorkFlow.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [WorkFlow.Level1]
>>>>>>> 16f383d5a48274bfee6f3200ca5d733f771d2020
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      
      LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
      LEFT JOIN dbo."Documents" "company" ON "company".id = d.company
      
<<<<<<< HEAD
      LEFT JOIN dbo."Documents" "Department" ON "Department".id = CAST(JSON_VALUE(d.doc, N'$."Department"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "CashFlow" ON "CashFlow".id = CAST(JSON_VALUE(d.doc, N'$."CashFlow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Recipient" ON "Recipient".id = CAST(JSON_VALUE(d.doc, N'$."Recipient"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Currency" ON "Currency".id = CAST(JSON_VALUE(d.doc, N'$."Currency"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "OperationGroup" ON "OperationGroup".id = CAST(JSON_VALUE(d.doc, N'$."OperationGroup"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Operation" ON "Operation".id = CAST(JSON_VALUE(d.doc, N'$."Operation"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.CashRequest' 
      GO
      GRANT SELECT ON dbo.[Document.CashRequest] TO jetti;
=======
      LEFT JOIN dbo."Documents" "workflow" ON "workflow".id = CAST(JSON_VALUE(d.doc, N'$."workflow"') AS UNIQUEIDENTIFIER)

      LEFT JOIN dbo."Documents" "Document" ON "Document".id = CAST(JSON_VALUE(d.doc, N'$."Document"') AS UNIQUEIDENTIFIER)

    WHERE d.[type] = 'Document.WorkFlow' 
      GO
      GRANT SELECT ON dbo.[Document.WorkFlow] TO jetti;
>>>>>>> 16f383d5a48274bfee6f3200ca5d733f771d2020
      GO
      CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
      SELECT
	      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
	      d.id, d.date [date],
	      d.description Presentation
        FROM dbo.[Documents] d
      GO
      