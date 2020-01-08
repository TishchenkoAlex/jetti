
    CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
    SELECT
      'https://x100-jetti.web.app/' + d.type + '/' + TRY_CONVERT(varchar(36), d.id) as link,
      d.id, d.date [date],
      d.description Presentation
      FROM dbo.[Documents] d
    GO
    GRANT SELECT ON [dbo].[Catalog.Documents] TO jetti;
    GO

    

      CREATE OR ALTER VIEW dbo.[Catalog.Account] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Account", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[isForex] [isForex]
        , d.[isActive] [isActive]
        , d.[isPassive] [isPassive]
      
        , ISNULL(l5.description, d.description) [Account.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Account.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Account.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Account.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Account.Level1]
      FROM [Catalog.Account.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Account.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Account.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Account.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Account.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Account.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Account.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Account] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Balance] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Balance", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[isActive] [isActive]
        , d.[isPassive] [isPassive]
      
        , ISNULL(l5.description, d.description) [Balance.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Balance.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Balance.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Balance.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Balance.Level1]
      FROM [Catalog.Balance.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Balance.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Balance.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Balance.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Balance.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Balance.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Balance.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Balance] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Balance.Analytics] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BalanceAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [BalanceAnalytics.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BalanceAnalytics.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BalanceAnalytics.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BalanceAnalytics.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BalanceAnalytics.Level1]
      FROM [Catalog.Balance.Analytics.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Balance.Analytics.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Balance.Analytics.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Balance.Analytics.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Balance.Analytics.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Balance.Analytics.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Balance.Analytics.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Balance.Analytics] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.BankAccount] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BankAccount", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([Bank.v].description, '') [Bank.value], d.[Bank] [Bank.id], [Bank.v].type [Bank.type]
        , d.[isDefault] [isDefault]
      
        , ISNULL(l5.description, d.description) [BankAccount.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BankAccount.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BankAccount.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BankAccount.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BankAccount.Level1]
      FROM [Catalog.BankAccount.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.BankAccount.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.BankAccount.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.BankAccount.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.BankAccount.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.BankAccount.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.BankAccount.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Bank.v] [Bank.v] WITH (NOEXPAND) ON [Bank.v].id = d.[Bank]
    
      GO
      GRANT SELECT ON dbo.[Catalog.BankAccount] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.CashFlow] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashFlow", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [CashFlow.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashFlow.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashFlow.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashFlow.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashFlow.Level1]
      FROM [Catalog.CashFlow.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.CashFlow.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.CashFlow.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.CashFlow.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.CashFlow.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.CashFlow.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.CashFlow.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.CashFlow] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.CashRegister] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashRegister", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[isAccounting] [isAccounting]
      
        , ISNULL(l5.description, d.description) [CashRegister.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashRegister.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashRegister.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashRegister.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashRegister.Level1]
      FROM [Catalog.CashRegister.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.CashRegister.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.CashRegister.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.CashRegister.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.CashRegister.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.CashRegister.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.CashRegister.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    
      GO
      GRANT SELECT ON dbo.[Catalog.CashRegister] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Currency] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Currency", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [Currency.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Currency.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Currency.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Currency.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Currency.Level1]
      FROM [Catalog.Currency.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Currency.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Currency.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Currency.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Currency.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Currency.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Currency.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Currency] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Company] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Company", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[kind] [kind]
        , d.[FullName] [FullName]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[prefix] [prefix]
        , ISNULL([Intercompany.v].description, '') [Intercompany.value], d.[Intercompany] [Intercompany.id], [Intercompany.v].type [Intercompany.type]
        , d.[AddressShipping] [AddressShipping]
        , d.[AddressBilling] [AddressBilling]
        , d.[Phone] [Phone]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Code3] [Code3]
        , d.[timeZone] [timeZone]
      
        , ISNULL(l5.description, d.description) [Company.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Company.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Company.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Company.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Company.Level1]
      FROM [Catalog.Company.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Company.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Company.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Company.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Company.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Company.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Company.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Company.v] [Intercompany.v] WITH (NOEXPAND) ON [Intercompany.v].id = d.[Intercompany]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Company] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Counterpartie", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[kind] [kind]
        , d.[FullName] [FullName]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[Client] [Client]
        , d.[Supplier] [Supplier]
        , d.[isInternal] [isInternal]
        , d.[AddressShipping] [AddressShipping]
        , d.[AddressBilling] [AddressBilling]
        , d.[Phone] [Phone]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Code3] [Code3]
      
        , ISNULL(l5.description, d.description) [Counterpartie.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Counterpartie.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Counterpartie.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Counterpartie.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Counterpartie.Level1]
      FROM [Catalog.Counterpartie.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Counterpartie.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Counterpartie.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Counterpartie.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Counterpartie.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Counterpartie.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Counterpartie.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Counterpartie] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie.BankAccount] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CounterpartieBankAccount", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([Bank.v].description, '') [Bank.value], d.[Bank] [Bank.id], [Bank.v].type [Bank.type]
        , d.[isDefault] [isDefault]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
      
        , ISNULL(l5.description, d.description) [CounterpartieBankAccount.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CounterpartieBankAccount.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CounterpartieBankAccount.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CounterpartieBankAccount.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CounterpartieBankAccount.Level1]
      FROM [Catalog.Counterpartie.BankAccount.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Counterpartie.BankAccount.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Counterpartie.BankAccount.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Counterpartie.BankAccount.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Counterpartie.BankAccount.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Counterpartie.BankAccount.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Counterpartie.BankAccount.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Bank.v] [Bank.v] WITH (NOEXPAND) ON [Bank.v].id = d.[Bank]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [owner.v] WITH (NOEXPAND) ON [owner.v].id = d.[owner]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Counterpartie.BankAccount] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Contract] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Contract", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , d.[Status] [Status]
        , d.[kind] [kind]
        , d.[StartDate] [StartDate]
        , d.[EndDate] [EndDate]
        , ISNULL([BusinessDirection.v].description, '') [BusinessDirection.value], d.[BusinessDirection] [BusinessDirection.id], [BusinessDirection.v].type [BusinessDirection.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
        , ISNULL([Manager.v].description, '') [Manager.value], d.[Manager] [Manager.id], [Manager.v].type [Manager.type]
        , d.[isDefault] [isDefault]
      
        , ISNULL(l5.description, d.description) [Contract.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Contract.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Contract.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Contract.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Contract.Level1]
      FROM [Catalog.Contract.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Contract.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Contract.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Contract.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Contract.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Contract.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Contract.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [owner.v] WITH (NOEXPAND) ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.BusinessDirection.v] [BusinessDirection.v] WITH (NOEXPAND) ON [BusinessDirection.v].id = d.[BusinessDirection]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Counterpartie.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
        LEFT JOIN dbo.[Catalog.Manager.v] [Manager.v] WITH (NOEXPAND) ON [Manager.v].id = d.[Manager]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Contract] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.BusinessDirection] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BusinessDirection", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [BusinessDirection.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BusinessDirection.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BusinessDirection.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BusinessDirection.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BusinessDirection.Level1]
      FROM [Catalog.BusinessDirection.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.BusinessDirection.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.BusinessDirection.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.BusinessDirection.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.BusinessDirection.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.BusinessDirection.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.BusinessDirection.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.BusinessDirection] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Department] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Department", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([BusinessRegion.v].description, '') [BusinessRegion.value], d.[BusinessRegion] [BusinessRegion.id], [BusinessRegion.v].type [BusinessRegion.type]
      
        , ISNULL(l5.description, d.description) [Department.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Department.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Department.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Department.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Department.Level1]
      FROM [Catalog.Department.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Department.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Department.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Department.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Department.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Department.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Department.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.BusinessRegion.v] [BusinessRegion.v] WITH (NOEXPAND) ON [BusinessRegion.v].id = d.[BusinessRegion]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Department] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Expense] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Expense", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Account.v].description, '') [Account.value], d.[Account] [Account.id], [Account.v].type [Account.type]
      
        , ISNULL(l5.description, d.description) [Expense.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Expense.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Expense.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Expense.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Expense.Level1]
      FROM [Catalog.Expense.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Expense.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Expense.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Expense.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Expense.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Expense.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Expense.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Account.v] [Account.v] WITH (NOEXPAND) ON [Account.v].id = d.[Account]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Expense] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Expense.Analytics] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ExpenseAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [ExpenseAnalytics.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ExpenseAnalytics.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ExpenseAnalytics.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ExpenseAnalytics.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ExpenseAnalytics.Level1]
      FROM [Catalog.Expense.Analytics.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Expense.Analytics.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Expense.Analytics.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Expense.Analytics.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Expense.Analytics.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Expense.Analytics.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Expense.Analytics.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Expense.Analytics] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Income] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Income", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Account.v].description, '') [Account.value], d.[Account] [Account.id], [Account.v].type [Account.type]
      
        , ISNULL(l5.description, d.description) [Income.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Income.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Income.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Income.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Income.Level1]
      FROM [Catalog.Income.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Income.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Income.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Income.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Income.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Income.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Income.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Account.v] [Account.v] WITH (NOEXPAND) ON [Account.v].id = d.[Account]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Income] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Loan] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Loan", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , d.[kind] [kind]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([loanType.v].description, '') [loanType.value], d.[loanType] [loanType.id], [loanType.v].type [loanType.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[PayDay] [PayDay]
        , d.[CloseDay] [CloseDay]
      
        , ISNULL(l5.description, d.description) [Loan.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Loan.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Loan.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Loan.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Loan.Level1]
      FROM [Catalog.Loan.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Loan.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Loan.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Loan.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Loan.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Loan.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Loan.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [owner.v] WITH (NOEXPAND) ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.LoanTypes.v] [loanType.v] WITH (NOEXPAND) ON [loanType.v].id = d.[loanType]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Loan] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.LoanTypes] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "LoanTypes", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [LoanTypes.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [LoanTypes.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [LoanTypes.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [LoanTypes.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [LoanTypes.Level1]
      FROM [Catalog.LoanTypes.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.LoanTypes.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.LoanTypes.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.LoanTypes.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.LoanTypes.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.LoanTypes.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.LoanTypes.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.LoanTypes] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Manager] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Manager", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[FullName] [FullName]
        , d.[Gender] [Gender]
        , d.[Birthday] [Birthday]
      
        , ISNULL(l5.description, d.description) [Manager.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Manager.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Manager.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Manager.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Manager.Level1]
      FROM [Catalog.Manager.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Manager.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Manager.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Manager.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Manager.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Manager.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Manager.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Manager] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Person] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Person", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Address] [Address]
        , d.[Phone] [Phone]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([JobTitle.v].description, '') [JobTitle.value], d.[JobTitle] [JobTitle.id], [JobTitle.v].type [JobTitle.type]
        , d.[Profile] [Profile]
      
        , ISNULL(l5.description, d.description) [Person.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Person.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Person.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Person.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Person.Level1]
      FROM [Catalog.Person.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Person.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Person.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Person.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Person.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Person.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Person.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.JobTitle.v] [JobTitle.v] WITH (NOEXPAND) ON [JobTitle.v].id = d.[JobTitle]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Person] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.PriceType] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PriceType", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[TaxInclude] [TaxInclude]
      
        , ISNULL(l5.description, d.description) [PriceType.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PriceType.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PriceType.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PriceType.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PriceType.Level1]
      FROM [Catalog.PriceType.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.PriceType.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.PriceType.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.PriceType.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.PriceType.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.PriceType.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.PriceType.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    
      GO
      GRANT SELECT ON dbo.[Catalog.PriceType] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Product] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Product", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([ProductKind.v].description, '') [ProductKind.value], d.[ProductKind] [ProductKind.id], [ProductKind.v].type [ProductKind.type]
        , ISNULL([ProductCategory.v].description, '') [ProductCategory.value], d.[ProductCategory] [ProductCategory.id], [ProductCategory.v].type [ProductCategory.type]
        , ISNULL([Brand.v].description, '') [Brand.value], d.[Brand] [Brand.id], [Brand.v].type [Brand.type]
        , ISNULL([Unit.v].description, '') [Unit.value], d.[Unit] [Unit.id], [Unit.v].type [Unit.type]
        , d.[Volume] [Volume]
      
        , ISNULL(l5.description, d.description) [Product.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Product.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Product.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Product.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Product.Level1]
      FROM [Catalog.Product.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Product.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Product.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Product.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Product.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Product.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Product.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.ProductKind.v] [ProductKind.v] WITH (NOEXPAND) ON [ProductKind.v].id = d.[ProductKind]
        LEFT JOIN dbo.[Catalog.ProductCategory.v] [ProductCategory.v] WITH (NOEXPAND) ON [ProductCategory.v].id = d.[ProductCategory]
        LEFT JOIN dbo.[Catalog.Brand.v] [Brand.v] WITH (NOEXPAND) ON [Brand.v].id = d.[Brand]
        LEFT JOIN dbo.[Catalog.Unit.v] [Unit.v] WITH (NOEXPAND) ON [Unit.v].id = d.[Unit]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Product] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.ProductCategory] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductCategory", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [ProductCategory.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductCategory.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductCategory.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductCategory.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductCategory.Level1]
      FROM [Catalog.ProductCategory.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.ProductCategory.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.ProductCategory.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.ProductCategory.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.ProductCategory.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.ProductCategory.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.ProductCategory.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.ProductCategory] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.ProductKind] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductKind", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[ProductType] [ProductType]
      
        , ISNULL(l5.description, d.description) [ProductKind.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductKind.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductKind.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductKind.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductKind.Level1]
      FROM [Catalog.ProductKind.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.ProductKind.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.ProductKind.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.ProductKind.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.ProductKind.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.ProductKind.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.ProductKind.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.ProductKind] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Storehouse] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Storehouse", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
      
        , ISNULL(l5.description, d.description) [Storehouse.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Storehouse.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Storehouse.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Storehouse.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Storehouse.Level1]
      FROM [Catalog.Storehouse.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Storehouse.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Storehouse.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Storehouse.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Storehouse.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Storehouse.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Storehouse.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Storehouse] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Operation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Group.v].description, '') [Group.value], d.[Group] [Group.id], [Group.v].type [Group.type]
        , d.[script] [script]
        , d.[module] [module]
      
        , ISNULL(l5.description, d.description) [Operation.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Operation.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Operation.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Operation.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Operation.Level1]
      FROM [Catalog.Operation.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Operation.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Operation.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Operation.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Operation.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Operation.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Operation.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Operation] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Group] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "OperationGroup", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Prefix] [Prefix]
      
        , ISNULL(l5.description, d.description) [OperationGroup.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [OperationGroup.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [OperationGroup.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [OperationGroup.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [OperationGroup.Level1]
      FROM [Catalog.Operation.Group.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Operation.Group.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Operation.Group.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Operation.Group.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Operation.Group.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Operation.Group.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Operation.Group.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Operation.Group] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Type] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "OperationType", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [OperationType.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [OperationType.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [OperationType.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [OperationType.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [OperationType.Level1]
      FROM [Catalog.Operation.Type.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Operation.Type.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Operation.Type.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Operation.Type.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Operation.Type.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Operation.Type.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Operation.Type.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Operation.Type] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Unit] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Unit", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [Unit.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Unit.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Unit.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Unit.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Unit.Level1]
      FROM [Catalog.Unit.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Unit.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Unit.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Unit.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Unit.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Unit.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Unit.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Unit] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.User] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "User", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[isAdmin] [isAdmin]
        , ISNULL([Person.v].description, '') [Person.value], d.[Person] [Person.id], [Person.v].type [Person.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
      
        , ISNULL(l5.description, d.description) [User.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [User.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [User.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [User.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [User.Level1]
      FROM [Catalog.User.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.User.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.User.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.User.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.User.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.User.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.User.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Person.v] [Person.v] WITH (NOEXPAND) ON [Person.v].id = d.[Person]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    
      GO
      GRANT SELECT ON dbo.[Catalog.User] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.UsersGroup] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "UsersGroup", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [UsersGroup.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [UsersGroup.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [UsersGroup.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [UsersGroup.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [UsersGroup.Level1]
      FROM [Catalog.UsersGroup.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.UsersGroup.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.UsersGroup.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.UsersGroup.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.UsersGroup.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.UsersGroup.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.UsersGroup.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.UsersGroup] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Role] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Role", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [Role.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Role.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Role.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Role.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Role.Level1]
      FROM [Catalog.Role.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Role.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Role.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Role.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Role.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Role.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Role.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Role] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.SubSystem] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "SubSystem", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[icon] [icon]
      
        , ISNULL(l5.description, d.description) [SubSystem.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [SubSystem.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [SubSystem.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [SubSystem.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [SubSystem.Level1]
      FROM [Catalog.SubSystem.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.SubSystem.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.SubSystem.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.SubSystem.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.SubSystem.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.SubSystem.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.SubSystem.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.SubSystem] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.JobTitle] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "JobTitle", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [JobTitle.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [JobTitle.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [JobTitle.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [JobTitle.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [JobTitle.Level1]
      FROM [Catalog.JobTitle.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.JobTitle.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.JobTitle.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.JobTitle.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.JobTitle.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.JobTitle.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.JobTitle.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.JobTitle] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Brand] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Brand", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [Brand.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Brand.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Brand.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Brand.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Brand.Level1]
      FROM [Catalog.Brand.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Brand.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Brand.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Brand.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Brand.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Brand.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Brand.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Brand] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.GroupObjectsExploitation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "GroupObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Method] [Method]
      
        , ISNULL(l5.description, d.description) [GroupObjectsExploitation.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [GroupObjectsExploitation.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [GroupObjectsExploitation.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [GroupObjectsExploitation.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [GroupObjectsExploitation.Level1]
      FROM [Catalog.GroupObjectsExploitation.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.GroupObjectsExploitation.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.GroupObjectsExploitation.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.GroupObjectsExploitation.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.GroupObjectsExploitation.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.GroupObjectsExploitation.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.GroupObjectsExploitation.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.GroupObjectsExploitation] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.ObjectsExploitation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Group.v].description, '') [Group.value], d.[Group] [Group.id], [Group.v].type [Group.type]
        , d.[InventoryNumber] [InventoryNumber]
      
        , ISNULL(l5.description, d.description) [ObjectsExploitation.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ObjectsExploitation.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ObjectsExploitation.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ObjectsExploitation.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ObjectsExploitation.Level1]
      FROM [Catalog.ObjectsExploitation.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.ObjectsExploitation.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.ObjectsExploitation.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.ObjectsExploitation.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.ObjectsExploitation.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.ObjectsExploitation.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.ObjectsExploitation.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.ObjectsExploitation.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
    
      GO
      GRANT SELECT ON dbo.[Catalog.ObjectsExploitation] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Catalog] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Catalog", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[prefix] [prefix]
        , d.[icon] [icon]
        , d.[menu] [menu]
        , d.[presentation] [presentation]
        , d.[hierarchy] [hierarchy]
        , d.[module] [module]
      
        , ISNULL(l5.description, d.description) [Catalog.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Catalog.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Catalog.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Catalog.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Catalog.Level1]
      FROM [Catalog.Catalog.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Catalog.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Catalog.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Catalog.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Catalog.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Catalog.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Catalog.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Catalog] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.BudgetItem] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BudgetItem", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [BudgetItem.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BudgetItem.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BudgetItem.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BudgetItem.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BudgetItem.Level1]
      FROM [Catalog.BudgetItem.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.BudgetItem.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.BudgetItem.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.BudgetItem.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.BudgetItem.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.BudgetItem.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.BudgetItem.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.BudgetItem] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Scenario] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Scenario", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
      
        , ISNULL(l5.description, d.description) [Scenario.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Scenario.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Scenario.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Scenario.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Scenario.Level1]
      FROM [Catalog.Scenario.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Scenario.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Scenario.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Scenario.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Scenario.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Scenario.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Scenario.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Scenario] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.AcquiringTerminal] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "AcquiringTerminal", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
        , ISNULL([Counterpartie.v].description, '') [Counterpartie.value], d.[Counterpartie] [Counterpartie.id], [Counterpartie.v].type [Counterpartie.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[isDefault] [isDefault]
      
        , ISNULL(l5.description, d.description) [AcquiringTerminal.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [AcquiringTerminal.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [AcquiringTerminal.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [AcquiringTerminal.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [AcquiringTerminal.Level1]
      FROM [Catalog.AcquiringTerminal.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.AcquiringTerminal.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.AcquiringTerminal.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.AcquiringTerminal.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.AcquiringTerminal.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.AcquiringTerminal.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.AcquiringTerminal.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Counterpartie.v] WITH (NOEXPAND) ON [Counterpartie.v].id = d.[Counterpartie]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    
      GO
      GRANT SELECT ON dbo.[Catalog.AcquiringTerminal] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.Bank] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Bank", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Address] [Address]
        , d.[KorrAccount] [KorrAccount]
        , d.[isActive] [isActive]
      
        , ISNULL(l5.description, d.description) [Bank.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Bank.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Bank.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Bank.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Bank.Level1]
      FROM [Catalog.Bank.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Bank.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Bank.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Bank.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Bank.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Bank.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.Bank.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.Bank] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.BusinessRegion] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BusinessRegion", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [BusinessRegion.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [BusinessRegion.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [BusinessRegion.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [BusinessRegion.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [BusinessRegion.Level1]
      FROM [Catalog.BusinessRegion.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.BusinessRegion.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.BusinessRegion.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.BusinessRegion.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.BusinessRegion.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.BusinessRegion.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.BusinessRegion.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.BusinessRegion] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Catalog.TaxRate] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxRate", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Rate] [Rate]
      
        , ISNULL(l5.description, d.description) [TaxRate.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxRate.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxRate.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxRate.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxRate.Level1]
      FROM [Catalog.TaxRate.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxRate.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxRate.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxRate.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxRate.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxRate.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Catalog.TaxRate.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Catalog.TaxRate] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.ExchangeRates] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ExchangeRates", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [ExchangeRates.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ExchangeRates.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ExchangeRates.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ExchangeRates.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ExchangeRates.Level1]
      FROM [Document.ExchangeRates.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.ExchangeRates.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.ExchangeRates.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.ExchangeRates.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.ExchangeRates.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.ExchangeRates.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.ExchangeRates.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    
      GO
      GRANT SELECT ON dbo.[Document.ExchangeRates] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.Invoice] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Invoice", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([Storehouse.v].description, '') [Storehouse.value], d.[Storehouse] [Storehouse.id], [Storehouse.v].type [Storehouse.type]
        , ISNULL([Customer.v].description, '') [Customer.value], d.[Customer] [Customer.id], [Customer.v].type [Customer.type]
        , ISNULL([Manager.v].description, '') [Manager.value], d.[Manager] [Manager.id], [Manager.v].type [Manager.type]
        , d.[Status] [Status]
        , d.[PayDay] [PayDay]
        , d.[Amount] [Amount]
        , d.[Tax] [Tax]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
      
        , ISNULL(l5.description, d.description) [Invoice.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Invoice.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Invoice.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Invoice.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Invoice.Level1]
      FROM [Document.Invoice.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.Invoice.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.Invoice.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.Invoice.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.Invoice.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.Invoice.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.Invoice.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Storehouse.v] [Storehouse.v] WITH (NOEXPAND) ON [Storehouse.v].id = d.[Storehouse]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Customer.v] WITH (NOEXPAND) ON [Customer.v].id = d.[Customer]
        LEFT JOIN dbo.[Catalog.Manager.v] [Manager.v] WITH (NOEXPAND) ON [Manager.v].id = d.[Manager]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    
      GO
      GRANT SELECT ON dbo.[Document.Invoice] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.Operation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Group.v].description, '') [Group.value], d.[Group] [Group.id], [Group.v].type [Group.type]
        , ISNULL([Operation.v].description, '') [Operation.value], d.[Operation] [Operation.id], [Operation.v].type [Operation.type]
        , d.[Amount] [Amount]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([f1.v].description, '') [f1.value], d.[f1] [f1.id], [f1.v].type [f1.type]
        , ISNULL([f2.v].description, '') [f2.value], d.[f2] [f2.id], [f2.v].type [f2.type]
        , ISNULL([f3.v].description, '') [f3.value], d.[f3] [f3.id], [f3.v].type [f3.type]
      
        , ISNULL(l5.description, d.description) [Operation.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Operation.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Operation.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Operation.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Operation.Level1]
      FROM [Document.Operation.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.Operation.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.Operation.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.Operation.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.Operation.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.Operation.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.Operation.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
    
      GO
      GRANT SELECT ON dbo.[Document.Operation] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.PriceList] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PriceList", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([PriceType.v].description, '') [PriceType.value], d.[PriceType] [PriceType.id], [PriceType.v].type [PriceType.type]
        , d.[TaxInclude] [TaxInclude]
      
        , ISNULL(l5.description, d.description) [PriceList.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PriceList.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PriceList.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PriceList.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PriceList.Level1]
      FROM [Document.PriceList.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.PriceList.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.PriceList.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.PriceList.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.PriceList.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.PriceList.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.PriceList.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.PriceType.v] [PriceType.v] WITH (NOEXPAND) ON [PriceType.v].id = d.[PriceType]
    
      GO
      GRANT SELECT ON dbo.[Document.PriceList] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.Settings] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Settings", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([balanceCurrency.v].description, '') [balanceCurrency.value], d.[balanceCurrency] [balanceCurrency.id], [balanceCurrency.v].type [balanceCurrency.type]
        , ISNULL([accountingCurrency.v].description, '') [accountingCurrency.value], d.[accountingCurrency] [accountingCurrency.id], [accountingCurrency.v].type [accountingCurrency.type]
      
        , ISNULL(l5.description, d.description) [Settings.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Settings.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Settings.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Settings.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Settings.Level1]
      FROM [Document.Settings.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.Settings.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.Settings.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.Settings.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.Settings.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.Settings.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.Settings.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [balanceCurrency.v] WITH (NOEXPAND) ON [balanceCurrency.v].id = d.[balanceCurrency]
        LEFT JOIN dbo.[Catalog.Currency.v] [accountingCurrency.v] WITH (NOEXPAND) ON [accountingCurrency.v].id = d.[accountingCurrency]
    
      GO
      GRANT SELECT ON dbo.[Document.Settings] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.UserSettings] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "UserSettings", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([UserOrGroup.v].description, '') [UserOrGroup.value], d.[UserOrGroup] [UserOrGroup.id], [UserOrGroup.v].type [UserOrGroup.type]
        , d.[COMP] [COMP]
        , d.[DEPT] [DEPT]
        , d.[STOR] [STOR]
        , d.[CASH] [CASH]
        , d.[BANK] [BANK]
        , d.[GROUP] [GROUP]
      
        , ISNULL(l5.description, d.description) [UserSettings.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [UserSettings.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [UserSettings.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [UserSettings.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [UserSettings.Level1]
      FROM [Document.UserSettings.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.UserSettings.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.UserSettings.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.UserSettings.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.UserSettings.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.UserSettings.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.UserSettings.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Documents] [UserOrGroup.v] ON [UserOrGroup.v].id = d.[UserOrGroup]
    
      GO
      GRANT SELECT ON dbo.[Document.UserSettings] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.WorkFlow] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "WorkFlow", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Document.v].description, '') [Document.value], d.[Document] [Document.id], [Document.v].type [Document.type]
        , d.[Status] [Status]
      
        , ISNULL(l5.description, d.description) [WorkFlow.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [WorkFlow.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [WorkFlow.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [WorkFlow.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [WorkFlow.Level1]
      FROM [Document.WorkFlow.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.WorkFlow.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.WorkFlow.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.WorkFlow.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.WorkFlow.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.WorkFlow.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.WorkFlow.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Documents] [Document.v] ON [Document.v].id = d.[Document]
    
      GO
      GRANT SELECT ON dbo.[Document.WorkFlow] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.CashRequest] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashRequest", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Status] [Status]
        , d.[Operation] [Operation]
        , d.[PaymentKind] [PaymentKind]
        , d.[CashKind] [CashKind]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([CashRecipient.v].description, '') [CashRecipient.value], d.[CashRecipient] [CashRecipient.id], [CashRecipient.v].type [CashRecipient.type]
        , ISNULL([Contract.v].description, '') [Contract.value], d.[Contract] [Contract.id], [Contract.v].type [Contract.type]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([Loan.v].description, '') [Loan.value], d.[Loan] [Loan.id], [Loan.v].type [Loan.type]
        , ISNULL([CashOrBank.v].description, '') [CashOrBank.value], d.[CashOrBank] [CashOrBank.id], [CashOrBank.v].type [CashOrBank.type]
        , ISNULL([CashRecipientBankAccount.v].description, '') [CashRecipientBankAccount.value], d.[CashRecipientBankAccount] [CashRecipientBankAccount.id], [CashRecipientBankAccount.v].type [CashRecipientBankAccount.type]
        , ISNULL([CashOrBankIn.v].description, '') [CashOrBankIn.value], d.[CashOrBankIn] [CashOrBankIn.id], [CashOrBankIn.v].type [CashOrBankIn.type]
        , d.[PayDay] [PayDay]
        , d.[Amount] [Amount]
        , ISNULL([сurrency.v].description, '') [сurrency.value], d.[сurrency] [сurrency.id], [сurrency.v].type [сurrency.type]
        , ISNULL([ExpenseOrBalance.v].description, '') [ExpenseOrBalance.value], d.[ExpenseOrBalance] [ExpenseOrBalance.id], [ExpenseOrBalance.v].type [ExpenseOrBalance.type]
        , ISNULL([ExpenseAnalytics.v].description, '') [ExpenseAnalytics.value], d.[ExpenseAnalytics] [ExpenseAnalytics.id], [ExpenseAnalytics.v].type [ExpenseAnalytics.type]
        , ISNULL([BalanceAnalytics.v].description, '') [BalanceAnalytics.value], d.[BalanceAnalytics] [BalanceAnalytics.id], [BalanceAnalytics.v].type [BalanceAnalytics.type]
        , d.[workflowID] [workflowID]
      
        , ISNULL(l5.description, d.description) [CashRequest.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashRequest.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashRequest.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashRequest.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashRequest.Level1]
      FROM [Document.CashRequest.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.CashRequest.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.CashRequest.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.CashRequest.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.CashRequest.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.CashRequest.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.CashRequest.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Documents] [CashRecipient.v] ON [CashRecipient.v].id = d.[CashRecipient]
        LEFT JOIN dbo.[Catalog.Contract.v] [Contract.v] WITH (NOEXPAND) ON [Contract.v].id = d.[Contract]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.Loan.v] [Loan.v] WITH (NOEXPAND) ON [Loan.v].id = d.[Loan]
        LEFT JOIN dbo.[Documents] [CashOrBank.v] ON [CashOrBank.v].id = d.[CashOrBank]
        LEFT JOIN dbo.[Catalog.Counterpartie.BankAccount.v] [CashRecipientBankAccount.v] WITH (NOEXPAND) ON [CashRecipientBankAccount.v].id = d.[CashRecipientBankAccount]
        LEFT JOIN dbo.[Documents] [CashOrBankIn.v] ON [CashOrBankIn.v].id = d.[CashOrBankIn]
        LEFT JOIN dbo.[Catalog.Currency.v] [сurrency.v] WITH (NOEXPAND) ON [сurrency.v].id = d.[сurrency]
        LEFT JOIN dbo.[Documents] [ExpenseOrBalance.v] ON [ExpenseOrBalance.v].id = d.[ExpenseOrBalance]
        LEFT JOIN dbo.[Catalog.Expense.Analytics.v] [ExpenseAnalytics.v] WITH (NOEXPAND) ON [ExpenseAnalytics.v].id = d.[ExpenseAnalytics]
        LEFT JOIN dbo.[Catalog.Balance.Analytics.v] [BalanceAnalytics.v] WITH (NOEXPAND) ON [BalanceAnalytics.v].id = d.[BalanceAnalytics]
    
      GO
      GRANT SELECT ON dbo.[Document.CashRequest] TO jetti;
      GO
      

      CREATE OR ALTER VIEW dbo.[Document.CashRequestRegistry] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashRequestRegistry", d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Status] [Status]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([BusinessDirection.v].description, '') [BusinessDirection.value], d.[BusinessDirection] [BusinessDirection.id], [BusinessDirection.v].type [BusinessDirection.type]
        , d.[Amount] [Amount]
        , ISNULL([сurrency.v].description, '') [сurrency.value], d.[сurrency] [сurrency.id], [сurrency.v].type [сurrency.type]
      
        , ISNULL(l5.description, d.description) [CashRequestRegistry.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CashRequestRegistry.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CashRequestRegistry.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CashRequestRegistry.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CashRequestRegistry.Level1]
      FROM [Document.CashRequestRegistry.v] d WITH (NOEXPAND)
        LEFT JOIN [Document.CashRequestRegistry.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Document.CashRequestRegistry.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Document.CashRequestRegistry.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Document.CashRequestRegistry.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Document.CashRequestRegistry.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN [Document.CashRequestRegistry.v] [parent] WITH (NOEXPAND) ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.BusinessDirection.v] [BusinessDirection.v] WITH (NOEXPAND) ON [BusinessDirection.v].id = d.[BusinessDirection]
        LEFT JOIN dbo.[Catalog.Currency.v] [сurrency.v] WITH (NOEXPAND) ON [сurrency.v].id = d.[сurrency]
    
      GO
      GRANT SELECT ON dbo.[Document.CashRequestRegistry] TO jetti;
      GO
      
    