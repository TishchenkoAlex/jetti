
------------------------------ BEGIN Operation.AdditionalParametersDepartment ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.AdditionalParametersDepartment] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "AdditionalParametersDepartment",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([MainStoreHouse.v].description, '') [MainStoreHouse.value], d.[MainStoreHouse] [MainStoreHouse.id], [MainStoreHouse.v].type [MainStoreHouse.type]
        , d.[FrontType] [FrontType]
      FROM [Operation.AdditionalParametersDepartment.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.Storehouse.v] [MainStoreHouse.v] WITH (NOEXPAND) ON [MainStoreHouse.v].id = d.[MainStoreHouse]
    ; 
GO
GRANT SELECT ON dbo.[Operation.AdditionalParametersDepartment] TO jetti;
GO

      
------------------------------ END Operation.AdditionalParametersDepartment ------------------------------

------------------------------ BEGIN Operation.IncomeBank_CRAUD_LoanInternational ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.IncomeBank_CRAUD_LoanInternational] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "IncomeBank_CRAUD_LoanInternational",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([BankAccountIN.v].description, '') [BankAccountIN.value], d.[BankAccountIN] [BankAccountIN.id], [BankAccountIN.v].type [BankAccountIN.type]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([IntercompanyIN.v].description, '') [IntercompanyIN.value], d.[IntercompanyIN] [IntercompanyIN.id], [IntercompanyIN.v].type [IntercompanyIN.type]
        , ISNULL([IntercompanyOUT.v].description, '') [IntercompanyOUT.value], d.[IntercompanyOUT] [IntercompanyOUT.id], [IntercompanyOUT.v].type [IntercompanyOUT.type]
        , ISNULL([CurrencyVia.v].description, '') [CurrencyVia.value], d.[CurrencyVia] [CurrencyVia.id], [CurrencyVia.v].type [CurrencyVia.type]
        , ISNULL([LoanViaIntercompanyIN.v].description, '') [LoanViaIntercompanyIN.value], d.[LoanViaIntercompanyIN] [LoanViaIntercompanyIN.id], [LoanViaIntercompanyIN.v].type [LoanViaIntercompanyIN.type]
        , ISNULL([LoanViaIntercompanyOUT.v].description, '') [LoanViaIntercompanyOUT.value], d.[LoanViaIntercompanyOUT] [LoanViaIntercompanyOUT.id], [LoanViaIntercompanyOUT.v].type [LoanViaIntercompanyOUT.type]
        , d.[AmountVia] [AmountVia]
        , d.[BankConfirm] [BankConfirm]
        , d.[BankDocNumber] [BankDocNumber]
        , d.[BankConfirmDate] [BankConfirmDate]
        , ISNULL([Intercompany_CRAUD.v].description, '') [Intercompany_CRAUD.value], d.[Intercompany_CRAUD] [Intercompany_CRAUD.id], [Intercompany_CRAUD.v].type [Intercompany_CRAUD.type]
        , ISNULL([Customer.v].description, '') [Customer.value], d.[Customer] [Customer.id], [Customer.v].type [Customer.type]
        , ISNULL([Loan_Customer.v].description, '') [Loan_Customer.value], d.[Loan_Customer] [Loan_Customer.id], [Loan_Customer.v].type [Loan_Customer.type]
        , ISNULL([SKU.v].description, '') [SKU.value], d.[SKU] [SKU.id], [SKU.v].type [SKU.type]
        , ISNULL([Loan_Customer_Company.v].description, '') [Loan_Customer_Company.value], d.[Loan_Customer_Company] [Loan_Customer_Company.id], [Loan_Customer_Company.v].type [Loan_Customer_Company.type]
        , d.[Amount_Loan_Customer_Company] [Amount_Loan_Customer_Company]
      FROM [Operation.IncomeBank_CRAUD_LoanInternational.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.BankAccount.v] [BankAccountIN.v] WITH (NOEXPAND) ON [BankAccountIN.v].id = d.[BankAccountIN]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.Company.v] [IntercompanyIN.v] WITH (NOEXPAND) ON [IntercompanyIN.v].id = d.[IntercompanyIN]
        LEFT JOIN dbo.[Catalog.Company.v] [IntercompanyOUT.v] WITH (NOEXPAND) ON [IntercompanyOUT.v].id = d.[IntercompanyOUT]
        LEFT JOIN dbo.[Catalog.Currency.v] [CurrencyVia.v] WITH (NOEXPAND) ON [CurrencyVia.v].id = d.[CurrencyVia]
        LEFT JOIN dbo.[Catalog.Loan.v] [LoanViaIntercompanyIN.v] WITH (NOEXPAND) ON [LoanViaIntercompanyIN.v].id = d.[LoanViaIntercompanyIN]
        LEFT JOIN dbo.[Catalog.Loan.v] [LoanViaIntercompanyOUT.v] WITH (NOEXPAND) ON [LoanViaIntercompanyOUT.v].id = d.[LoanViaIntercompanyOUT]
        LEFT JOIN dbo.[Catalog.Company.v] [Intercompany_CRAUD.v] WITH (NOEXPAND) ON [Intercompany_CRAUD.v].id = d.[Intercompany_CRAUD]
        LEFT JOIN dbo.[Catalog.Person.v] [Customer.v] WITH (NOEXPAND) ON [Customer.v].id = d.[Customer]
        LEFT JOIN dbo.[Catalog.Loan.v] [Loan_Customer.v] WITH (NOEXPAND) ON [Loan_Customer.v].id = d.[Loan_Customer]
        LEFT JOIN dbo.[Catalog.Product.v] [SKU.v] WITH (NOEXPAND) ON [SKU.v].id = d.[SKU]
        LEFT JOIN dbo.[Catalog.Loan.v] [Loan_Customer_Company.v] WITH (NOEXPAND) ON [Loan_Customer_Company.v].id = d.[Loan_Customer_Company]
    ; 
GO
GRANT SELECT ON dbo.[Operation.IncomeBank_CRAUD_LoanInternational] TO jetti;
GO

      
------------------------------ END Operation.IncomeBank_CRAUD_LoanInternational ------------------------------

------------------------------ BEGIN Operation.LotModelsVsDepartment ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.LotModelsVsDepartment] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "LotModelsVsDepartment",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[Lot] [Lot]
        , d.[isProfitability] [isProfitability]
        , d.[Lot_BonusManager] [Lot_BonusManager]
        , d.[Lot_CommisionAllUnic] [Lot_CommisionAllUnic]
        , d.[Lot_ShareDistribution] [Lot_ShareDistribution]
        , d.[Lot_ShareInvestor] [Lot_ShareInvestor]
      FROM [Operation.LotModelsVsDepartment.v] d WITH (NOEXPAND)
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
GRANT SELECT ON dbo.[Operation.LotModelsVsDepartment] TO jetti;
GO

      
------------------------------ END Operation.LotModelsVsDepartment ------------------------------
