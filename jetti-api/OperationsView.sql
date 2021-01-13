
------------------------------ BEGIN Operation.balance ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.balance] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "balance",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[RegisterName] [RegisterName]
        , d.[BalanceDate] [BalanceDate]
        , d.[Fields] [Fields]
        , d.[GroupBy] [GroupBy]
        , d.[TopRows] [TopRows]
      FROM [Operation.balance.v] d WITH (NOEXPAND)
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
GRANT SELECT ON dbo.[Operation.balance] TO jetti;
GO

      
------------------------------ END Operation.balance ------------------------------

------------------------------ BEGIN Operation.load ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.load] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "load",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[CSV] [CSV]
        , ISNULL([UsersParent.v].description, '') [UsersParent.value], d.[UsersParent] [UsersParent.id], [UsersParent.v].type [UsersParent.type]
      FROM [Operation.load.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.User.v] [UsersParent.v] WITH (NOEXPAND) ON [UsersParent.v].id = d.[UsersParent]
    ; 
GO
GRANT SELECT ON dbo.[Operation.load] TO jetti;
GO

      
------------------------------ END Operation.load ------------------------------

------------------------------ BEGIN Operation.OperName1 ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.OperName1] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "OperName1",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[BankConfirm] [BankConfirm]
        , d.[BankDocNumber] [BankDocNumber]
        , d.[BankConfirmDate] [BankConfirmDate]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
        , ISNULL([Counterpartie.v].description, '') [Counterpartie.value], d.[Counterpartie] [Counterpartie.id], [Counterpartie.v].type [Counterpartie.type]
        , ISNULL([Loan.v].description, '') [Loan.value], d.[Loan] [Loan.id], [Loan.v].type [Loan.type]
        , d.[PaymentKind] [PaymentKind]
        , ISNULL([BankAccountSupplier.v].description, '') [BankAccountSupplier.value], d.[BankAccountSupplier] [BankAccountSupplier.id], [BankAccountSupplier.v].type [BankAccountSupplier.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
      FROM [Operation.OperName1.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Counterpartie.v] WITH (NOEXPAND) ON [Counterpartie.v].id = d.[Counterpartie]
        LEFT JOIN dbo.[Catalog.Loan.v] [Loan.v] WITH (NOEXPAND) ON [Loan.v].id = d.[Loan]
        LEFT JOIN dbo.[Catalog.Counterpartie.BankAccount.v] [BankAccountSupplier.v] WITH (NOEXPAND) ON [BankAccountSupplier.v].id = d.[BankAccountSupplier]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
    ; 
GO
GRANT SELECT ON dbo.[Operation.OperName1] TO jetti;
GO

      
------------------------------ END Operation.OperName1 ------------------------------

------------------------------ BEGIN Operation.OperName2 ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.OperName2] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "OperName2",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[BankConfirm] [BankConfirm]
        , d.[BankConfirmDate] [BankConfirmDate]
        , d.[BankDocNumber] [BankDocNumber]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
        , ISNULL([Supplier.v].description, '') [Supplier.value], d.[Supplier] [Supplier.id], [Supplier.v].type [Supplier.type]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([BankAccountSupplier.v].description, '') [BankAccountSupplier.value], d.[BankAccountSupplier] [BankAccountSupplier.id], [BankAccountSupplier.v].type [BankAccountSupplier.type]
        , ISNULL([CashFlowAPersons.v].description, '') [CashFlowAPersons.value], d.[CashFlowAPersons] [CashFlowAPersons.id], [CashFlowAPersons.v].type [CashFlowAPersons.type]
        , ISNULL([TaxPaymentCode.v].description, '') [TaxPaymentCode.value], d.[TaxPaymentCode] [TaxPaymentCode.id], [TaxPaymentCode.v].type [TaxPaymentCode.type]
        , d.[TaxOfficeCode2] [TaxOfficeCode2]
        , d.[TaxKPP] [TaxKPP]
        , ISNULL([TaxPayerStatus.v].description, '') [TaxPayerStatus.value], d.[TaxPayerStatus] [TaxPayerStatus.id], [TaxPayerStatus.v].type [TaxPayerStatus.type]
        , ISNULL([TaxBasisPayment.v].description, '') [TaxBasisPayment.value], d.[TaxBasisPayment] [TaxBasisPayment.id], [TaxBasisPayment.v].type [TaxBasisPayment.type]
        , ISNULL([TaxPaymentPeriod.v].description, '') [TaxPaymentPeriod.value], d.[TaxPaymentPeriod] [TaxPaymentPeriod.id], [TaxPaymentPeriod.v].type [TaxPaymentPeriod.type]
        , d.[TaxDocNumber] [TaxDocNumber]
        , d.[TaxDocDate] [TaxDocDate]
        , ISNULL([CompanyParent.v].description, '') [CompanyParent.value], d.[CompanyParent] [CompanyParent.id], [CompanyParent.v].type [CompanyParent.type]
      FROM [Operation.OperName2.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Supplier.v] WITH (NOEXPAND) ON [Supplier.v].id = d.[Supplier]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Counterpartie.BankAccount.v] [BankAccountSupplier.v] WITH (NOEXPAND) ON [BankAccountSupplier.v].id = d.[BankAccountSupplier]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlowAPersons.v] WITH (NOEXPAND) ON [CashFlowAPersons.v].id = d.[CashFlowAPersons]
        LEFT JOIN dbo.[Catalog.TaxPaymentCode.v] [TaxPaymentCode.v] WITH (NOEXPAND) ON [TaxPaymentCode.v].id = d.[TaxPaymentCode]
        LEFT JOIN dbo.[Catalog.TaxPayerStatus.v] [TaxPayerStatus.v] WITH (NOEXPAND) ON [TaxPayerStatus.v].id = d.[TaxPayerStatus]
        LEFT JOIN dbo.[Catalog.TaxBasisPayment.v] [TaxBasisPayment.v] WITH (NOEXPAND) ON [TaxBasisPayment.v].id = d.[TaxBasisPayment]
        LEFT JOIN dbo.[Catalog.TaxPaymentPeriod.v] [TaxPaymentPeriod.v] WITH (NOEXPAND) ON [TaxPaymentPeriod.v].id = d.[TaxPaymentPeriod]
        LEFT JOIN dbo.[Catalog.Company.v] [CompanyParent.v] WITH (NOEXPAND) ON [CompanyParent.v].id = d.[CompanyParent]
    ; 
GO
GRANT SELECT ON dbo.[Operation.OperName2] TO jetti;
GO

      
------------------------------ END Operation.OperName2 ------------------------------

<<<<<<< HEAD
------------------------------ BEGIN Operation.respPerson ------------------------------
=======
------------------------------ BEGIN Operation.LOT_Sales ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.LOT_Sales] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "LOT_Sales",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([Customer.v].description, '') [Customer.value], d.[Customer] [Customer.id], [Customer.v].type [Customer.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([CompanySeller.v].description, '') [CompanySeller.value], d.[CompanySeller] [CompanySeller.id], [CompanySeller.v].type [CompanySeller.type]
        , ISNULL([Department_CompanySeller.v].description, '') [Department_CompanySeller.value], d.[Department_CompanySeller] [Department_CompanySeller.id], [Department_CompanySeller.v].type [Department_CompanySeller.type]
        , ISNULL([Loan_Customer.v].description, '') [Loan_Customer.value], d.[Loan_Customer] [Loan_Customer.id], [Loan_Customer.v].type [Loan_Customer.type]
        , d.[Transaction_Id] [Transaction_Id]
        , d.[Alias] [Alias]
        , d.[Title] [Title]
        , ISNULL([Income_CompanySeller.v].description, '') [Income_CompanySeller.value], d.[Income_CompanySeller] [Income_CompanySeller.id], [Income_CompanySeller.v].type [Income_CompanySeller.type]
        , ISNULL([Expense_CompanySeller.v].description, '') [Expense_CompanySeller.value], d.[Expense_CompanySeller] [Expense_CompanySeller.id], [Expense_CompanySeller.v].type [Expense_CompanySeller.type]
        , ISNULL([Income.v].description, '') [Income.value], d.[Income] [Income.id], [Income.v].type [Income.type]
        , d.[DocReceived] [DocReceived]
      FROM [Operation.LOT_Sales.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.Person.v] [Customer.v] WITH (NOEXPAND) ON [Customer.v].id = d.[Customer]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Company.v] [CompanySeller.v] WITH (NOEXPAND) ON [CompanySeller.v].id = d.[CompanySeller]
        LEFT JOIN dbo.[Catalog.Department.v] [Department_CompanySeller.v] WITH (NOEXPAND) ON [Department_CompanySeller.v].id = d.[Department_CompanySeller]
        LEFT JOIN dbo.[Catalog.Loan.v] [Loan_Customer.v] WITH (NOEXPAND) ON [Loan_Customer.v].id = d.[Loan_Customer]
        LEFT JOIN dbo.[Catalog.Income.v] [Income_CompanySeller.v] WITH (NOEXPAND) ON [Income_CompanySeller.v].id = d.[Income_CompanySeller]
        LEFT JOIN dbo.[Catalog.Expense.v] [Expense_CompanySeller.v] WITH (NOEXPAND) ON [Expense_CompanySeller.v].id = d.[Expense_CompanySeller]
        LEFT JOIN dbo.[Catalog.Income.v] [Income.v] WITH (NOEXPAND) ON [Income.v].id = d.[Income]
    ; 
GO
GRANT SELECT ON dbo.[Operation.LOT_Sales] TO jetti;
GO

      
------------------------------ END Operation.LOT_Sales ------------------------------

------------------------------ BEGIN Operation.LotModelsVsDepartment ------------------------------
>>>>>>> 994c07af61a0529f4e27f3a25bc59889422deac5

      CREATE OR ALTER VIEW dbo.[Operation.respPerson] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "respPerson",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      FROM [Operation.respPerson.v] d WITH (NOEXPAND)
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
GRANT SELECT ON dbo.[Operation.respPerson] TO jetti;
GO

      
------------------------------ END Operation.respPerson ------------------------------
