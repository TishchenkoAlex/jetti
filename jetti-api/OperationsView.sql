
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

------------------------------ BEGIN Operation.AutoAdditionSettings ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.AutoAdditionSettings] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "AutoAdditionSettings",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([RetailNetwork.v].description, '') [RetailNetwork.value], d.[RetailNetwork] [RetailNetwork.id], [RetailNetwork.v].type [RetailNetwork.type]
        , d.[AdditionalType] [AdditionalType]
        , ISNULL([MainSKU.v].description, '') [MainSKU.value], d.[MainSKU] [MainSKU.id], [MainSKU.v].type [MainSKU.type]
        , d.[Qty] [Qty]
      FROM [Operation.AutoAdditionSettings.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.RetailNetwork.v] [RetailNetwork.v] WITH (NOEXPAND) ON [RetailNetwork.v].id = d.[RetailNetwork]
        LEFT JOIN dbo.[Catalog.Product.v] [MainSKU.v] WITH (NOEXPAND) ON [MainSKU.v].id = d.[MainSKU]
    ; 
GO
GRANT SELECT ON dbo.[Operation.AutoAdditionSettings] TO jetti;
GO

      
------------------------------ END Operation.AutoAdditionSettings ------------------------------

------------------------------ BEGIN Operation.CashShifts ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.CashShifts] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashShifts",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([UserId.v].description, '') [UserId.value], d.[UserId] [UserId.id], [UserId.v].type [UserId.type]
        , d.[SashShiftNumber] [SashShiftNumber]
        , d.[StartDate] [StartDate]
        , d.[EndDate] [EndDate]
        , d.[ChecksLoaded] [ChecksLoaded]
        , d.[ProductionCalculated] [ProductionCalculated]
        , d.[startBalance] [startBalance]
        , d.[endBalance] [endBalance]
      FROM [Operation.CashShifts.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.Person.v] [UserId.v] WITH (NOEXPAND) ON [UserId.v].id = d.[UserId]
    ; 
GO
GRANT SELECT ON dbo.[Operation.CashShifts] TO jetti;
GO

      
------------------------------ END Operation.CashShifts ------------------------------

------------------------------ BEGIN Operation.CHECK_JETTI_FRONT ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.CHECK_JETTI_FRONT] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "CHECK_JETTI_FRONT",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([Customer.v].description, '') [Customer.value], d.[Customer] [Customer.id], [Customer.v].type [Customer.type]
        , ISNULL([Manager.v].description, '') [Manager.value], d.[Manager] [Manager.id], [Manager.v].type [Manager.type]
        , ISNULL([Storehouse.v].description, '') [Storehouse.value], d.[Storehouse] [Storehouse.id], [Storehouse.v].type [Storehouse.type]
        , d.[DiscountDoc] [DiscountDoc]
        , d.[TypeDocument] [TypeDocument]
        , d.[NumCashShift] [NumCashShift]
        , d.[counterpartyId] [counterpartyId]
        , d.[orderId] [orderId]
      FROM [Operation.CHECK_JETTI_FRONT.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Customer.v] WITH (NOEXPAND) ON [Customer.v].id = d.[Customer]
        LEFT JOIN dbo.[Catalog.Person.v] [Manager.v] WITH (NOEXPAND) ON [Manager.v].id = d.[Manager]
        LEFT JOIN dbo.[Catalog.Storehouse.v] [Storehouse.v] WITH (NOEXPAND) ON [Storehouse.v].id = d.[Storehouse]
    ; 
GO
GRANT SELECT ON dbo.[Operation.CHECK_JETTI_FRONT] TO jetti;
GO

      
------------------------------ END Operation.CHECK_JETTI_FRONT ------------------------------

------------------------------ BEGIN Operation.CRAUD_INTEGRATION ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.CRAUD_INTEGRATION] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "CRAUD_INTEGRATION",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[alias] [alias]
        , ISNULL([OperationJETTI.v].description, '') [OperationJETTI.value], d.[OperationJETTI] [OperationJETTI.id], [OperationJETTI.v].type [OperationJETTI.type]
        , d.[Status] [Status]
        , d.[StatusPosted] [StatusPosted]
      FROM [Operation.CRAUD_INTEGRATION.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.Operation.v] [OperationJETTI.v] WITH (NOEXPAND) ON [OperationJETTI.v].id = d.[OperationJETTI]
    ; 
GO
GRANT SELECT ON dbo.[Operation.CRAUD_INTEGRATION] TO jetti;
GO

      
------------------------------ END Operation.CRAUD_INTEGRATION ------------------------------

------------------------------ BEGIN Operation.CRAUD_INTEGRATION_CREATE_LOAN ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.CRAUD_INTEGRATION_CREATE_LOAN] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "CRAUD_INTEGRATION_CREATE_LOAN",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[Status] [Status]
        , d.[ScriptFindLoan] [ScriptFindLoan]
      FROM [Operation.CRAUD_INTEGRATION_CREATE_LOAN.v] d WITH (NOEXPAND)
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
GRANT SELECT ON dbo.[Operation.CRAUD_INTEGRATION_CREATE_LOAN] TO jetti;
GO

      
------------------------------ END Operation.CRAUD_INTEGRATION_CREATE_LOAN ------------------------------

------------------------------ BEGIN Operation.DeliveryAreas ------------------------------

      CREATE OR ALTER VIEW dbo.[Operation.DeliveryAreas] AS
      
      SELECT
        d.id, d.type, d.date, d.code, d.description "DeliveryAreas",  d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , ISNULL([RetailNetwork.v].description, '') [RetailNetwork.value], d.[RetailNetwork] [RetailNetwork.id], [RetailNetwork.v].type [RetailNetwork.type]
        , d.[MapUrl] [MapUrl]
        , d.[LoadFolder] [LoadFolder]
      FROM [Operation.DeliveryAreas.v] d WITH (NOEXPAND)
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
        LEFT JOIN dbo.[Catalog.RetailNetwork.v] [RetailNetwork.v] WITH (NOEXPAND) ON [RetailNetwork.v].id = d.[RetailNetwork]
    ; 
GO
GRANT SELECT ON dbo.[Operation.DeliveryAreas] TO jetti;
GO

      
------------------------------ END Operation.DeliveryAreas ------------------------------

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
