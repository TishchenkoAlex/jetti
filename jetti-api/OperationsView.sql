
------------------------------ BEGIN Operation.LOAD_SALARY ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.LOAD_SALARY] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "LOAD_SALARY",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[AmountIncome] [AmountIncome]
        , d.[AmountIncomeBalance] [AmountIncomeBalance]
        , d.[AmountExpense] [AmountExpense]
        , d.[AmountTax] [AmountTax]
        , d.[Status] [Status]
        , d.[DocVerified] [DocVerified]
        , d.[IsPortal] [IsPortal]
      FROM [Operation.LOAD_SALARY.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ; 
GO
GRANT SELECT ON dbo.[Operation.LOAD_SALARY] TO jetti;
------------------------------ END Operation.LOAD_SALARY ------------------------------

GO

------------------------------ BEGIN Operation.SPECIFICATION ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.SPECIFICATION] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "SPECIFICATION",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      FROM [Operation.SPECIFICATION.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
    ; 
GO
GRANT SELECT ON dbo.[Operation.SPECIFICATION] TO jetti;
------------------------------ END Operation.SPECIFICATION ------------------------------

GO

------------------------------ BEGIN Operation.OPER_PREPAY_RETAIL_CLIENT ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.OPER_PREPAY_RETAIL_CLIENT] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "OPER_PREPAY_RETAIL_CLIENT",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([RetailClient.v].description, '') [RetailClient.value], d.[RetailClient] [RetailClient.id], [RetailClient.v].type [RetailClient.type]
        , ISNULL([ProductPackage.v].description, '') [ProductPackage.value], d.[ProductPackage] [ProductPackage.id], [ProductPackage.v].type [ProductPackage.type]
        , ISNULL([Product.v].description, '') [Product.value], d.[Product] [Product.id], [Product.v].type [Product.type]
        , d.[Qty] [Qty]
        , d.[DateExpire] [DateExpire]
        , d.[Remote_transaction_id] [Remote_transaction_id]
      FROM [Operation.OPER_PREPAY_RETAIL_CLIENT.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.RetailClient.v] [RetailClient.v] WITH (NOEXPAND) ON [RetailClient.v].id = d.[RetailClient]
        LEFT JOIN dbo.[Catalog.Product.Package.v] [ProductPackage.v] WITH (NOEXPAND) ON [ProductPackage.v].id = d.[ProductPackage]
        LEFT JOIN dbo.[Catalog.Product.v] [Product.v] WITH (NOEXPAND) ON [Product.v].id = d.[Product]
    ; 
GO
GRANT SELECT ON dbo.[Operation.OPER_PREPAY_RETAIL_CLIENT] TO jetti;
------------------------------ END Operation.OPER_PREPAY_RETAIL_CLIENT ------------------------------

GO

------------------------------ BEGIN Operation.GYM_SALES ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.GYM_SALES] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "GYM_SALES",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([Training_type.v].description, '') [Training_type.value], d.[Training_type] [Training_type.id], [Training_type.v].type [Training_type.type]
        , ISNULL([Trainer.v].description, '') [Trainer.value], d.[Trainer] [Trainer.id], [Trainer.v].type [Trainer.type]
        , ISNULL([Department_Finance.v].description, '') [Department_Finance.value], d.[Department_Finance] [Department_Finance.id], [Department_Finance.v].type [Department_Finance.type]
        , d.[Max_members] [Max_members]
        , d.[Members_count] [Members_count]
        , d.[Visited_count] [Visited_count]
        , d.[Is_online] [Is_online]
        , d.[Online_url] [Online_url]
        , d.[Training_Id] [Training_Id]
      FROM [Operation.GYM_SALES.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Product.Analytic.v] [Training_type.v] WITH (NOEXPAND) ON [Training_type.v].id = d.[Training_type]
        LEFT JOIN dbo.[Catalog.Person.v] [Trainer.v] WITH (NOEXPAND) ON [Trainer.v].id = d.[Trainer]
        LEFT JOIN dbo.[Catalog.Department.v] [Department_Finance.v] WITH (NOEXPAND) ON [Department_Finance.v].id = d.[Department_Finance]
    ; 
GO
GRANT SELECT ON dbo.[Operation.GYM_SALES] TO jetti;
------------------------------ END Operation.GYM_SALES ------------------------------

GO

------------------------------ BEGIN Operation.LOAD_GYM_SMARTASS ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.LOAD_GYM_SMARTASS] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "LOAD_GYM_SMARTASS",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[DateOpen] [DateOpen]
        , d.[DateClose] [DateClose]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
      FROM [Operation.LOAD_GYM_SMARTASS.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ; 
GO
GRANT SELECT ON dbo.[Operation.LOAD_GYM_SMARTASS] TO jetti;
------------------------------ END Operation.LOAD_GYM_SMARTASS ------------------------------

GO

------------------------------ BEGIN Operation.LOAD_PREPAY_SMARTASS ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.LOAD_PREPAY_SMARTASS] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "LOAD_PREPAY_SMARTASS",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[DateOpen] [DateOpen]
        , d.[DateClose] [DateClose]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([CompanyDepartment.v].description, '') [CompanyDepartment.value], d.[CompanyDepartment] [CompanyDepartment.id], [CompanyDepartment.v].type [CompanyDepartment.type]
        , ISNULL([PaymentAgent_Default.v].description, '') [PaymentAgent_Default.value], d.[PaymentAgent_Default] [PaymentAgent_Default.id], [PaymentAgent_Default.v].type [PaymentAgent_Default.type]
        , ISNULL([BankAccount_Default.v].description, '') [BankAccount_Default.value], d.[BankAccount_Default] [BankAccount_Default.id], [BankAccount_Default.v].type [BankAccount_Default.type]
        , ISNULL([CashRegister_Default.v].description, '') [CashRegister_Default.value], d.[CashRegister_Default] [CashRegister_Default.id], [CashRegister_Default.v].type [CashRegister_Default.type]
        , ISNULL([AcquiringTerminal_Default.v].description, '') [AcquiringTerminal_Default.value], d.[AcquiringTerminal_Default] [AcquiringTerminal_Default.id], [AcquiringTerminal_Default.v].type [AcquiringTerminal_Default.type]
      FROM [Operation.LOAD_PREPAY_SMARTASS.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Company.v] [CompanyDepartment.v] WITH (NOEXPAND) ON [CompanyDepartment.v].id = d.[CompanyDepartment]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [PaymentAgent_Default.v] WITH (NOEXPAND) ON [PaymentAgent_Default.v].id = d.[PaymentAgent_Default]
        LEFT JOIN dbo.[Catalog.BankAccount.v] [BankAccount_Default.v] WITH (NOEXPAND) ON [BankAccount_Default.v].id = d.[BankAccount_Default]
        LEFT JOIN dbo.[Catalog.CashRegister.v] [CashRegister_Default.v] WITH (NOEXPAND) ON [CashRegister_Default.v].id = d.[CashRegister_Default]
        LEFT JOIN dbo.[Catalog.AcquiringTerminal.v] [AcquiringTerminal_Default.v] WITH (NOEXPAND) ON [AcquiringTerminal_Default.v].id = d.[AcquiringTerminal_Default]
    ; 
GO
GRANT SELECT ON dbo.[Operation.LOAD_PREPAY_SMARTASS] TO jetti;
------------------------------ END Operation.LOAD_PREPAY_SMARTASS ------------------------------

GO

------------------------------ BEGIN Operation.Назначение ценового региона ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.Назначение ценового региона] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "Назначение ценового региона",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[Role] [Role]
      FROM [Operation.Назначение ценового региона.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Operation.v] [Operation.v] WITH (NOEXPAND) ON [Operation.v].id = d.[Operation]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Documents] [f1.v] ON [f1.v].id = d.[f1]
        LEFT JOIN dbo.[Documents] [f2.v] ON [f2.v].id = d.[f2]
        LEFT JOIN dbo.[Documents] [f3.v] ON [f3.v].id = d.[f3]
    ; 
GO
GRANT SELECT ON dbo.[Operation.Назначение ценового региона] TO jetti;
------------------------------ END Operation.Назначение ценового региона ------------------------------
