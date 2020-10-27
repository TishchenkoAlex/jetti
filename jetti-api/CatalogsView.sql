CREATE OR ALTER VIEW[dbo].[Catalog.Documents] AS
    SELECT
    'https://x100-jetti.web.app/' + d.type + '/' + TRY_CONVERT(varchar(36), d.id) as link,
      d.id, d.date[date],
      d.description Presentation,
        d.info,
        d.type, CAST(JSON_VALUE(doc, N'$.DocReceived') as bit) DocReceived
    FROM dbo.[Documents] d
    GO
    GRANT SELECT ON[dbo].[Catalog.Documents] TO jetti;
    GO
      
------------------------------ BEGIN Operation.AdditionalParametersDepartment ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Operation.AdditionalParametersDepartment] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "AdditionalParametersDepartment", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        , ISNULL(l5.description, d.description) [AdditionalParametersDepartment.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [AdditionalParametersDepartment.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [AdditionalParametersDepartment.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [AdditionalParametersDepartment.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [AdditionalParametersDepartment.Level1]
      FROM [Operation.AdditionalParametersDepartment.v] d WITH (NOEXPAND)
        LEFT JOIN [Operation.AdditionalParametersDepartment.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Operation.AdditionalParametersDepartment.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Operation.AdditionalParametersDepartment.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Operation.AdditionalParametersDepartment.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Operation.AdditionalParametersDepartment.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
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

      
      
------------------------------ BEGIN Operation.LotModelsVsDepartment ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Operation.LotModelsVsDepartment] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "LotModelsVsDepartment", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        , ISNULL(l5.description, d.description) [LotModelsVsDepartment.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [LotModelsVsDepartment.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [LotModelsVsDepartment.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [LotModelsVsDepartment.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [LotModelsVsDepartment.Level1]
      FROM [Operation.LotModelsVsDepartment.v] d WITH (NOEXPAND)
        LEFT JOIN [Operation.LotModelsVsDepartment.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Operation.LotModelsVsDepartment.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Operation.LotModelsVsDepartment.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Operation.LotModelsVsDepartment.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Operation.LotModelsVsDepartment.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
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

      
      
------------------------------ BEGIN Catalog.ResponsibilityCenter ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.ResponsibilityCenter] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ResponsibilityCenter", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[kind] [kind]
        , ISNULL([ResponsiblePerson.v].description, '') [ResponsiblePerson.value], d.[ResponsiblePerson] [ResponsiblePerson.id], [ResponsiblePerson.v].type [ResponsiblePerson.type]
        , ISNULL([Currency.v].description, '') [Currency.value], d.[Currency] [Currency.id], [Currency.v].type [Currency.type]
      
        , ISNULL(l5.description, d.description) [ResponsibilityCenter.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ResponsibilityCenter.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ResponsibilityCenter.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ResponsibilityCenter.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ResponsibilityCenter.Level1]
      FROM [Catalog.ResponsibilityCenter.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.ResponsibilityCenter.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.ResponsibilityCenter.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.ResponsibilityCenter.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.ResponsibilityCenter.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.ResponsibilityCenter.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Person.v] [ResponsiblePerson.v] WITH (NOEXPAND) ON [ResponsiblePerson.v].id = d.[ResponsiblePerson]
        LEFT JOIN dbo.[Catalog.Currency.v] [Currency.v] WITH (NOEXPAND) ON [Currency.v].id = d.[Currency]
    ;
GO
GRANT SELECT ON dbo.[Catalog.ResponsibilityCenter] TO jetti;
GO

      
------------------------------ END Catalog.ResponsibilityCenter ------------------------------

      
      
------------------------------ BEGIN Catalog.Dynamic ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Dynamic] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Dynamic", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [Dynamic.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Dynamic.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Dynamic.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Dynamic.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Dynamic.Level1]
      FROM [Catalog.Dynamic.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Dynamic.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Dynamic.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Dynamic.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Dynamic.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Dynamic.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Dynamic] TO jetti;
GO

      
------------------------------ END Catalog.Dynamic ------------------------------

      
      
------------------------------ BEGIN Catalog.Attachment ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Attachment] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Attachment", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , ISNULL([AttachmentType.v].description, '') [AttachmentType.value], d.[AttachmentType] [AttachmentType.id], [AttachmentType.v].type [AttachmentType.type]
        , d.[Storage] [Storage]
        , d.[Tags] [Tags]
        , d.[FileSize] [FileSize]
        , d.[FileName] [FileName]
        , d.[MIMEType] [MIMEType]
      
        , ISNULL(l5.description, d.description) [Attachment.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Attachment.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Attachment.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Attachment.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Attachment.Level1]
      FROM [Catalog.Attachment.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Attachment.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Attachment.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Attachment.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Attachment.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Attachment.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Documents] [owner.v] ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.Attachment.Type.v] [AttachmentType.v] WITH (NOEXPAND) ON [AttachmentType.v].id = d.[AttachmentType]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Attachment] TO jetti;
GO

      
------------------------------ END Catalog.Attachment ------------------------------

      
      
------------------------------ BEGIN Catalog.Attachment.Type ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Attachment.Type] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "AttachmentType", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[AllDocuments] [AllDocuments]
        , d.[AllCatalogs] [AllCatalogs]
        , d.[MaxFileSize] [MaxFileSize]
        , d.[FileFilter] [FileFilter]
        , d.[StorageType] [StorageType]
        , d.[IconURL] [IconURL]
        , d.[Tags] [Tags]
        , d.[LoadDataOnInit] [LoadDataOnInit]
      
        , ISNULL(l5.description, d.description) [AttachmentType.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [AttachmentType.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [AttachmentType.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [AttachmentType.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [AttachmentType.Level1]
      FROM [Catalog.Attachment.Type.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Attachment.Type.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Attachment.Type.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Attachment.Type.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Attachment.Type.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Attachment.Type.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Attachment.Type] TO jetti;
GO

      
------------------------------ END Catalog.Attachment.Type ------------------------------

      
      
------------------------------ BEGIN Catalog.AllUnic.Lot ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.AllUnic.Lot] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "AllUnicLot", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[SalesStartDate] [SalesStartDate]
        , d.[Cost] [Cost]
        , ISNULL([Currency.v].description, '') [Currency.value], d.[Currency] [Currency.id], [Currency.v].type [Currency.type]
        , ISNULL([Product.v].description, '') [Product.value], d.[Product] [Product.id], [Product.v].type [Product.type]
      
        , ISNULL(l5.description, d.description) [AllUnicLot.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [AllUnicLot.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [AllUnicLot.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [AllUnicLot.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [AllUnicLot.Level1]
      FROM [Catalog.AllUnic.Lot.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.AllUnic.Lot.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.AllUnic.Lot.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.AllUnic.Lot.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.AllUnic.Lot.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.AllUnic.Lot.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [Currency.v] WITH (NOEXPAND) ON [Currency.v].id = d.[Currency]
        LEFT JOIN dbo.[Catalog.Product.v] [Product.v] WITH (NOEXPAND) ON [Product.v].id = d.[Product]
    ;
GO
GRANT SELECT ON dbo.[Catalog.AllUnic.Lot] TO jetti;
GO

      
------------------------------ END Catalog.AllUnic.Lot ------------------------------

      
      
------------------------------ BEGIN Catalog.Account ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Account] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Account", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Account] TO jetti;
GO

      
------------------------------ END Catalog.Account ------------------------------

      
      
------------------------------ BEGIN Catalog.Balance ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Balance] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Balance", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[isActive] [isActive]
        , d.[isPassive] [isPassive]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Balance] TO jetti;
GO

      
------------------------------ END Catalog.Balance ------------------------------

      
      
------------------------------ BEGIN Catalog.Balance.Analytics ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Balance.Analytics] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BalanceAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Balance.Analytics] TO jetti;
GO

      
------------------------------ END Catalog.Balance.Analytics ------------------------------

      
      
------------------------------ BEGIN Catalog.BankAccount ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.BankAccount] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BankAccount", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Bank.v] [Bank.v] WITH (NOEXPAND) ON [Bank.v].id = d.[Bank]
    ;
GO
GRANT SELECT ON dbo.[Catalog.BankAccount] TO jetti;
GO

      
------------------------------ END Catalog.BankAccount ------------------------------

      
      
------------------------------ BEGIN Catalog.CashFlow ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.CashFlow] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashFlow", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.CashFlow] TO jetti;
GO

      
------------------------------ END Catalog.CashFlow ------------------------------

      
      
------------------------------ BEGIN Catalog.CashRegister ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.CashRegister] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashRegister", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ;
GO
GRANT SELECT ON dbo.[Catalog.CashRegister] TO jetti;
GO

      
------------------------------ END Catalog.CashRegister ------------------------------

      
      
------------------------------ BEGIN Catalog.Currency ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Currency] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Currency", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[ShortName] [ShortName]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Currency] TO jetti;
GO

      
------------------------------ END Catalog.Currency ------------------------------

      
      
------------------------------ BEGIN Catalog.Company ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Company] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Company", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[kind] [kind]
        , d.[FullName] [FullName]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[prefix] [prefix]
        , ISNULL([Group.v].description, '') [Group.value], d.[Group] [Group.id], [Group.v].type [Group.type]
        , ISNULL([Intercompany.v].description, '') [Intercompany.value], d.[Intercompany] [Intercompany.id], [Intercompany.v].type [Intercompany.type]
        , ISNULL([Country.v].description, '') [Country.value], d.[Country] [Country.id], [Country.v].type [Country.type]
        , ISNULL([ResponsibilityCenter.v].description, '') [ResponsibilityCenter.value], d.[ResponsibilityCenter] [ResponsibilityCenter.id], [ResponsibilityCenter.v].type [ResponsibilityCenter.type]
        , d.[AddressShipping] [AddressShipping]
        , d.[AddressBilling] [AddressBilling]
        , d.[Phone] [Phone]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Code3] [Code3]
        , d.[BC] [BC]
        , d.[timeZone] [timeZone]
        , ISNULL([TaxOffice.v].description, '') [TaxOffice.value], d.[TaxOffice] [TaxOffice.id], [TaxOffice.v].type [TaxOffice.type]
        , d.[GLN] [GLN]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Company.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
        LEFT JOIN dbo.[Catalog.Company.v] [Intercompany.v] WITH (NOEXPAND) ON [Intercompany.v].id = d.[Intercompany]
        LEFT JOIN dbo.[Catalog.Country.v] [Country.v] WITH (NOEXPAND) ON [Country.v].id = d.[Country]
        LEFT JOIN dbo.[Catalog.ResponsibilityCenter.v] [ResponsibilityCenter.v] WITH (NOEXPAND) ON [ResponsibilityCenter.v].id = d.[ResponsibilityCenter]
        LEFT JOIN dbo.[Catalog.TaxOffice.v] [TaxOffice.v] WITH (NOEXPAND) ON [TaxOffice.v].id = d.[TaxOffice]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Company] TO jetti;
GO

      
------------------------------ END Catalog.Company ------------------------------

      
      
------------------------------ BEGIN Catalog.Company.Group ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Company.Group] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CompanyGroup", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[FullName] [FullName]
      
        , ISNULL(l5.description, d.description) [CompanyGroup.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [CompanyGroup.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [CompanyGroup.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [CompanyGroup.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [CompanyGroup.Level1]
      FROM [Catalog.Company.Group.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Company.Group.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Company.Group.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Company.Group.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Company.Group.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Company.Group.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Company.Group] TO jetti;
GO

      
------------------------------ END Catalog.Company.Group ------------------------------

      
      
------------------------------ BEGIN Catalog.Country ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Country] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Country", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Currency.v].description, '') [Currency.value], d.[Currency] [Currency.id], [Currency.v].type [Currency.type]
      
        , ISNULL(l5.description, d.description) [Country.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Country.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Country.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Country.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Country.Level1]
      FROM [Catalog.Country.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Country.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Country.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Country.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Country.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Country.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [Currency.v] WITH (NOEXPAND) ON [Currency.v].id = d.[Currency]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Country] TO jetti;
GO

      
------------------------------ END Catalog.Country ------------------------------

      
      
------------------------------ BEGIN Catalog.Counterpartie ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Counterpartie", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
        , d.[BC] [BC]
        , d.[GLN] [GLN]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Counterpartie] TO jetti;
GO

      
------------------------------ END Catalog.Counterpartie ------------------------------

      
      
------------------------------ BEGIN Catalog.Counterpartie.BankAccount ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Counterpartie.BankAccount] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CounterpartieBankAccount", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Bank.v] [Bank.v] WITH (NOEXPAND) ON [Bank.v].id = d.[Bank]
        LEFT JOIN dbo.[Documents] [owner.v] ON [owner.v].id = d.[owner]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Counterpartie.BankAccount] TO jetti;
GO

      
------------------------------ END Catalog.Counterpartie.BankAccount ------------------------------

      
      
------------------------------ BEGIN Catalog.Contract ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Contract] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Contract", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , d.[Status] [Status]
        , d.[kind] [kind]
        , d.[StartDate] [StartDate]
        , d.[EndDate] [EndDate]
        , d.[Indulgence] [Indulgence]
        , d.[Amount] [Amount]
        , ISNULL([BusinessDirection.v].description, '') [BusinessDirection.value], d.[BusinessDirection] [BusinessDirection.id], [BusinessDirection.v].type [BusinessDirection.type]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
        , ISNULL([Manager.v].description, '') [Manager.value], d.[Manager] [Manager.id], [Manager.v].type [Manager.type]
        , d.[isDefault] [isDefault]
        , d.[notAccounting] [notAccounting]
        , d.[RoyaltyArrangements] [RoyaltyArrangements]
        , d.[RoyaltyDelayTo] [RoyaltyDelayTo]
        , d.[PaymentKC] [PaymentKC]
        , d.[RoyaltyPercent] [RoyaltyPercent]
        , d.[PaymentOVM] [PaymentOVM]
        , d.[PaymentOKK] [PaymentOKK]
        , d.[PaymentKRO] [PaymentKRO]
        , d.[OtherServices] [OtherServices]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [owner.v] WITH (NOEXPAND) ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.BusinessDirection.v] [BusinessDirection.v] WITH (NOEXPAND) ON [BusinessDirection.v].id = d.[BusinessDirection]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Counterpartie.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
        LEFT JOIN dbo.[Catalog.Manager.v] [Manager.v] WITH (NOEXPAND) ON [Manager.v].id = d.[Manager]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Contract] TO jetti;
GO

      
------------------------------ END Catalog.Contract ------------------------------

      
      
------------------------------ BEGIN Catalog.Contract.Intercompany ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Contract.Intercompany] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ContractIntercompany", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([KorrCompany.v].description, '') [KorrCompany.value], d.[KorrCompany] [KorrCompany.id], [KorrCompany.v].type [KorrCompany.type]
        , d.[Status] [Status]
        , d.[StartDate] [StartDate]
        , d.[EndDate] [EndDate]
        , d.[Amount] [Amount]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[isDefault] [isDefault]
        , d.[notAccounting] [notAccounting]
      
        , ISNULL(l5.description, d.description) [ContractIntercompany.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ContractIntercompany.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ContractIntercompany.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ContractIntercompany.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ContractIntercompany.Level1]
      FROM [Catalog.Contract.Intercompany.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Contract.Intercompany.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Contract.Intercompany.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Contract.Intercompany.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Contract.Intercompany.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Contract.Intercompany.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Company.v] [KorrCompany.v] WITH (NOEXPAND) ON [KorrCompany.v].id = d.[KorrCompany]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Contract.Intercompany] TO jetti;
GO

      
------------------------------ END Catalog.Contract.Intercompany ------------------------------

      
      
------------------------------ BEGIN Catalog.BusinessDirection ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.BusinessDirection] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BusinessDirection", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.BusinessDirection] TO jetti;
GO

      
------------------------------ END Catalog.BusinessDirection ------------------------------

      
      
------------------------------ BEGIN Catalog.Salary.Analytics ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Salary.Analytics] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "SalaryAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[SalaryKind] [SalaryKind]
        , ISNULL([Unit.v].description, '') [Unit.value], d.[Unit] [Unit.id], [Unit.v].type [Unit.type]
      
        , ISNULL(l5.description, d.description) [SalaryAnalytics.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [SalaryAnalytics.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [SalaryAnalytics.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [SalaryAnalytics.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [SalaryAnalytics.Level1]
      FROM [Catalog.Salary.Analytics.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Salary.Analytics.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Salary.Analytics.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Salary.Analytics.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Salary.Analytics.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Salary.Analytics.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Unit.v] [Unit.v] WITH (NOEXPAND) ON [Unit.v].id = d.[Unit]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Salary.Analytics] TO jetti;
GO

      
------------------------------ END Catalog.Salary.Analytics ------------------------------

      
      
------------------------------ BEGIN Catalog.Department ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Department] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Department", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[ShortName] [ShortName]
        , ISNULL([BusinessRegion.v].description, '') [BusinessRegion.value], d.[BusinessRegion] [BusinessRegion.id], [BusinessRegion.v].type [BusinessRegion.type]
        , ISNULL([ResponsibilityCenter.v].description, '') [ResponsibilityCenter.value], d.[ResponsibilityCenter] [ResponsibilityCenter.id], [ResponsibilityCenter.v].type [ResponsibilityCenter.type]
        , d.[OpeningDate] [OpeningDate]
        , d.[ClosingDate] [ClosingDate]
        , ISNULL([TaxOffice.v].description, '') [TaxOffice.value], d.[TaxOffice] [TaxOffice.id], [TaxOffice.v].type [TaxOffice.type]
        , ISNULL([Manager.v].description, '') [Manager.value], d.[Manager] [Manager.id], [Manager.v].type [Manager.type]
        , ISNULL([Brand.v].description, '') [Brand.value], d.[Brand] [Brand.id], [Brand.v].type [Brand.type]
        , ISNULL([PriceType.v].description, '') [PriceType.value], d.[PriceType] [PriceType.id], [PriceType.v].type [PriceType.type]
        , ISNULL([kind.v].description, '') [kind.value], d.[kind] [kind.id], [kind.v].type [kind.type]
        , d.[Mail] [Mail]
        , d.[Phone] [Phone]
        , d.[Address] [Address]
        , d.[AddressLegal] [AddressLegal]
        , d.[Longitude] [Longitude]
        , d.[Latitude] [Latitude]
        , d.[IntegrationType] [IntegrationType]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.BusinessRegion.v] [BusinessRegion.v] WITH (NOEXPAND) ON [BusinessRegion.v].id = d.[BusinessRegion]
        LEFT JOIN dbo.[Catalog.ResponsibilityCenter.v] [ResponsibilityCenter.v] WITH (NOEXPAND) ON [ResponsibilityCenter.v].id = d.[ResponsibilityCenter]
        LEFT JOIN dbo.[Catalog.TaxOffice.v] [TaxOffice.v] WITH (NOEXPAND) ON [TaxOffice.v].id = d.[TaxOffice]
        LEFT JOIN dbo.[Catalog.Person.v] [Manager.v] WITH (NOEXPAND) ON [Manager.v].id = d.[Manager]
        LEFT JOIN dbo.[Catalog.Brand.v] [Brand.v] WITH (NOEXPAND) ON [Brand.v].id = d.[Brand]
        LEFT JOIN dbo.[Catalog.PriceType.v] [PriceType.v] WITH (NOEXPAND) ON [PriceType.v].id = d.[PriceType]
        LEFT JOIN dbo.[Catalog.Department.Kind.v] [kind.v] WITH (NOEXPAND) ON [kind.v].id = d.[kind]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Department] TO jetti;
GO

      
------------------------------ END Catalog.Department ------------------------------

      
      
------------------------------ BEGIN Catalog.Department.Kind ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Department.Kind] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "DepartmentKind", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [DepartmentKind.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [DepartmentKind.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [DepartmentKind.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [DepartmentKind.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [DepartmentKind.Level1]
      FROM [Catalog.Department.Kind.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Department.Kind.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Department.Kind.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Department.Kind.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Department.Kind.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Department.Kind.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Department.Kind] TO jetti;
GO

      
------------------------------ END Catalog.Department.Kind ------------------------------

      
      
------------------------------ BEGIN Catalog.Department.Company ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Department.Company] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "DepartmentCompany", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[kind] [kind]
        , d.[ShortName] [ShortName]
        , d.[SecurityGroup] [SecurityGroup]
        , ISNULL([StaffingPositionManager.v].description, '') [StaffingPositionManager.value], d.[StaffingPositionManager] [StaffingPositionManager.id], [StaffingPositionManager.v].type [StaffingPositionManager.type]
      
        , ISNULL(l5.description, d.description) [DepartmentCompany.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [DepartmentCompany.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [DepartmentCompany.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [DepartmentCompany.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [DepartmentCompany.Level1]
      FROM [Catalog.Department.Company.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Department.Company.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Department.Company.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Department.Company.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Department.Company.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Department.Company.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.StaffingTable.v] [StaffingPositionManager.v] WITH (NOEXPAND) ON [StaffingPositionManager.v].id = d.[StaffingPositionManager]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Department.Company] TO jetti;
GO

      
------------------------------ END Catalog.Department.Company ------------------------------

      
      
------------------------------ BEGIN Catalog.Department.StatusReason ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Department.StatusReason] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "DepartmentStatusReason", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [DepartmentStatusReason.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [DepartmentStatusReason.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [DepartmentStatusReason.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [DepartmentStatusReason.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [DepartmentStatusReason.Level1]
      FROM [Catalog.Department.StatusReason.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Department.StatusReason.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Department.StatusReason.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Department.StatusReason.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Department.StatusReason.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Department.StatusReason.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Department.StatusReason] TO jetti;
GO

      
------------------------------ END Catalog.Department.StatusReason ------------------------------

      
      
------------------------------ BEGIN Catalog.Expense ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Expense] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Expense", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Account.v].description, '') [Account.value], d.[Account] [Account.id], [Account.v].type [Account.type]
        , ISNULL([BudgetItem.v].description, '') [BudgetItem.value], d.[BudgetItem] [BudgetItem.id], [BudgetItem.v].type [BudgetItem.type]
        , d.[Assign] [Assign]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Account.v] [Account.v] WITH (NOEXPAND) ON [Account.v].id = d.[Account]
        LEFT JOIN dbo.[Catalog.BudgetItem.v] [BudgetItem.v] WITH (NOEXPAND) ON [BudgetItem.v].id = d.[BudgetItem]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Expense] TO jetti;
GO

      
------------------------------ END Catalog.Expense ------------------------------

      
      
------------------------------ BEGIN Catalog.Expense.Analytics ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Expense.Analytics] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ExpenseAnalytics", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([BudgetItem.v].description, '') [BudgetItem.value], d.[BudgetItem] [BudgetItem.id], [BudgetItem.v].type [BudgetItem.type]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.BudgetItem.v] [BudgetItem.v] WITH (NOEXPAND) ON [BudgetItem.v].id = d.[BudgetItem]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Expense.Analytics] TO jetti;
GO

      
------------------------------ END Catalog.Expense.Analytics ------------------------------

      
      
------------------------------ BEGIN Catalog.Income ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Income] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Income", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Account.v].description, '') [Account.value], d.[Account] [Account.id], [Account.v].type [Account.type]
        , ISNULL([BudgetItem.v].description, '') [BudgetItem.value], d.[BudgetItem] [BudgetItem.id], [BudgetItem.v].type [BudgetItem.type]
        , d.[Assign] [Assign]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Account.v] [Account.v] WITH (NOEXPAND) ON [Account.v].id = d.[Account]
        LEFT JOIN dbo.[Catalog.BudgetItem.v] [BudgetItem.v] WITH (NOEXPAND) ON [BudgetItem.v].id = d.[BudgetItem]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Income] TO jetti;
GO

      
------------------------------ END Catalog.Income ------------------------------

      
      
------------------------------ BEGIN Catalog.Loan ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Loan] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Loan", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[PayDay] [PayDay]
        , d.[CloseDay] [CloseDay]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , ISNULL([OwnerBankAccount.v].description, '') [OwnerBankAccount.value], d.[OwnerBankAccount] [OwnerBankAccount.id], [OwnerBankAccount.v].type [OwnerBankAccount.type]
        , d.[CashKind] [CashKind]
        , d.[kind] [kind]
        , d.[Status] [Status]
        , ISNULL([InvestorGroup.v].description, '') [InvestorGroup.value], d.[InvestorGroup] [InvestorGroup.id], [InvestorGroup.v].type [InvestorGroup.type]
        , d.[InterestRate] [InterestRate]
        , d.[InterestDeadline] [InterestDeadline]
        , ISNULL([loanType.v].description, '') [loanType.value], d.[loanType] [loanType.id], [loanType.v].type [loanType.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[AmountLoan] [AmountLoan]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , ISNULL([Country.v].description, '') [Country.value], d.[Country] [Country.id], [Country.v].type [Country.type]
        , ISNULL([Lot.v].description, '') [Lot.value], d.[Lot] [Lot.id], [Lot.v].type [Lot.type]
        , d.[LotQty] [LotQty]
        , ISNULL([LoanRepaymentProcedure.v].description, '') [LoanRepaymentProcedure.value], d.[LoanRepaymentProcedure] [LoanRepaymentProcedure.id], [LoanRepaymentProcedure.v].type [LoanRepaymentProcedure.type]
        , d.[PayDeadline] [PayDeadline]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Documents] [owner.v] ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.Counterpartie.BankAccount.v] [OwnerBankAccount.v] WITH (NOEXPAND) ON [OwnerBankAccount.v].id = d.[OwnerBankAccount]
        LEFT JOIN dbo.[Catalog.InvestorGroup.v] [InvestorGroup.v] WITH (NOEXPAND) ON [InvestorGroup.v].id = d.[InvestorGroup]
        LEFT JOIN dbo.[Catalog.LoanTypes.v] [loanType.v] WITH (NOEXPAND) ON [loanType.v].id = d.[loanType]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Country.v] [Country.v] WITH (NOEXPAND) ON [Country.v].id = d.[Country]
        LEFT JOIN dbo.[Catalog.Product.v] [Lot.v] WITH (NOEXPAND) ON [Lot.v].id = d.[Lot]
        LEFT JOIN dbo.[Catalog.LoanRepaymentProcedure.v] [LoanRepaymentProcedure.v] WITH (NOEXPAND) ON [LoanRepaymentProcedure.v].id = d.[LoanRepaymentProcedure]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Loan] TO jetti;
GO

      
------------------------------ END Catalog.Loan ------------------------------

      
      
------------------------------ BEGIN Catalog.LoanRepaymentProcedure ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.LoanRepaymentProcedure] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "LoanRepaymentProcedure", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [LoanRepaymentProcedure.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [LoanRepaymentProcedure.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [LoanRepaymentProcedure.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [LoanRepaymentProcedure.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [LoanRepaymentProcedure.Level1]
      FROM [Catalog.LoanRepaymentProcedure.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.LoanRepaymentProcedure.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.LoanRepaymentProcedure.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.LoanRepaymentProcedure.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.LoanRepaymentProcedure.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.LoanRepaymentProcedure.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.LoanRepaymentProcedure] TO jetti;
GO

      
------------------------------ END Catalog.LoanRepaymentProcedure ------------------------------

      
      
------------------------------ BEGIN Catalog.LoanTypes ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.LoanTypes] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "LoanTypes", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Balance.v].description, '') [Balance.value], d.[Balance] [Balance.id], [Balance.v].type [Balance.type]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Balance.v] [Balance.v] WITH (NOEXPAND) ON [Balance.v].id = d.[Balance]
    ;
GO
GRANT SELECT ON dbo.[Catalog.LoanTypes] TO jetti;
GO

      
------------------------------ END Catalog.LoanTypes ------------------------------

      
      
------------------------------ BEGIN Catalog.Manager ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Manager] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Manager", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Manager] TO jetti;
GO

      
------------------------------ END Catalog.Manager ------------------------------

      
      
------------------------------ BEGIN Catalog.Person ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Person] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Person", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Gender] [Gender]
        , d.[FirstName] [FirstName]
        , d.[LastName] [LastName]
        , d.[MiddleName] [MiddleName]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Address] [Address]
        , d.[AddressResidence] [AddressResidence]
        , d.[City] [City]
        , d.[Phone] [Phone]
        , d.[Email] [Email]
        , d.[EmploymentDate] [EmploymentDate]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([JobTitle.v].description, '') [JobTitle.value], d.[JobTitle] [JobTitle.id], [JobTitle.v].type [JobTitle.type]
        , ISNULL([Country.v].description, '') [Country.value], d.[Country] [Country.id], [Country.v].type [Country.type]
        , d.[Profile] [Profile]
        , ISNULL([DocumentType.v].description, '') [DocumentType.value], d.[DocumentType] [DocumentType.id], [DocumentType.v].type [DocumentType.type]
        , d.[DocumentCode] [DocumentCode]
        , d.[DocumentNumber] [DocumentNumber]
        , d.[DocumentDate] [DocumentDate]
        , d.[DocumentAuthority] [DocumentAuthority]
        , d.[AccountAD] [AccountAD]
        , d.[Pincode] [Pincode]
        , d.[Fired] [Fired]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.JobTitle.v] [JobTitle.v] WITH (NOEXPAND) ON [JobTitle.v].id = d.[JobTitle]
        LEFT JOIN dbo.[Catalog.Country.v] [Country.v] WITH (NOEXPAND) ON [Country.v].id = d.[Country]
        LEFT JOIN dbo.[Catalog.PersonIdentity.v] [DocumentType.v] WITH (NOEXPAND) ON [DocumentType.v].id = d.[DocumentType]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Person] TO jetti;
GO

      
------------------------------ END Catalog.Person ------------------------------

      
      
------------------------------ BEGIN Catalog.PriceType ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.PriceType] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PriceType", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[TaxInclude] [TaxInclude]
        , ISNULL([Brand.v].description, '') [Brand.value], d.[Brand] [Brand.id], [Brand.v].type [Brand.type]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Brand.v] [Brand.v] WITH (NOEXPAND) ON [Brand.v].id = d.[Brand]
    ;
GO
GRANT SELECT ON dbo.[Catalog.PriceType] TO jetti;
GO

      
------------------------------ END Catalog.PriceType ------------------------------

      
      
------------------------------ BEGIN Catalog.Product ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Product] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Product", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([ProductKind.v].description, '') [ProductKind.value], d.[ProductKind] [ProductKind.id], [ProductKind.v].type [ProductKind.type]
        , ISNULL([ProductCategory.v].description, '') [ProductCategory.value], d.[ProductCategory] [ProductCategory.id], [ProductCategory.v].type [ProductCategory.type]
        , ISNULL([Specification.v].description, '') [Specification.value], d.[Specification] [Specification.id], [Specification.v].type [Specification.type]
        , ISNULL([Brand.v].description, '') [Brand.value], d.[Brand] [Brand.id], [Brand.v].type [Brand.type]
        , ISNULL([Unit.v].description, '') [Unit.value], d.[Unit] [Unit.id], [Unit.v].type [Unit.type]
        , ISNULL([Expense.v].description, '') [Expense.value], d.[Expense] [Expense.id], [Expense.v].type [Expense.type]
        , ISNULL([Analytics.v].description, '') [Analytics.value], d.[Analytics] [Analytics.id], [Analytics.v].type [Analytics.type]
        , ISNULL([ProductReport.v].description, '') [ProductReport.value], d.[ProductReport] [ProductReport.id], [ProductReport.v].type [ProductReport.type]
        , ISNULL([Settings.v].description, '') [Settings.value], d.[Settings] [Settings.id], [Settings.v].type [Settings.type]
        , d.[Purchased] [Purchased]
        , d.[ShortCode] [ShortCode]
        , d.[ShortName] [ShortName]
        , d.[Tags] [Tags]
        , d.[Weight] [Weight]
        , d.[Volume] [Volume]
        , d.[Calorie] [Calorie]
        , d.[Carbohydrates] [Carbohydrates]
        , d.[Fat] [Fat]
        , d.[Proteins] [Proteins]
        , d.[CookingTime] [CookingTime]
        , d.[Composition] [Composition]
        , d.[CookingPlace] [CookingPlace]
        , d.[Order] [Order]
        , d.[Barcode] [Barcode]
        , d.[Eancode] [Eancode]
        , d.[isVegan] [isVegan]
        , d.[isHot] [isHot]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.ProductKind.v] [ProductKind.v] WITH (NOEXPAND) ON [ProductKind.v].id = d.[ProductKind]
        LEFT JOIN dbo.[Catalog.ProductCategory.v] [ProductCategory.v] WITH (NOEXPAND) ON [ProductCategory.v].id = d.[ProductCategory]
        LEFT JOIN dbo.[Catalog.Specification.v] [Specification.v] WITH (NOEXPAND) ON [Specification.v].id = d.[Specification]
        LEFT JOIN dbo.[Catalog.Brand.v] [Brand.v] WITH (NOEXPAND) ON [Brand.v].id = d.[Brand]
        LEFT JOIN dbo.[Catalog.Unit.v] [Unit.v] WITH (NOEXPAND) ON [Unit.v].id = d.[Unit]
        LEFT JOIN dbo.[Catalog.Expense.v] [Expense.v] WITH (NOEXPAND) ON [Expense.v].id = d.[Expense]
        LEFT JOIN dbo.[Catalog.Expense.Analytics.v] [Analytics.v] WITH (NOEXPAND) ON [Analytics.v].id = d.[Analytics]
        LEFT JOIN dbo.[Catalog.Product.Report.v] [ProductReport.v] WITH (NOEXPAND) ON [ProductReport.v].id = d.[ProductReport]
        LEFT JOIN dbo.[Document.Operation.v] [Settings.v] WITH (NOEXPAND) ON [Settings.v].id = d.[Settings]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Product] TO jetti;
GO

      
------------------------------ END Catalog.Product ------------------------------

      
      
------------------------------ BEGIN Catalog.PlanningScenario ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.PlanningScenario] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PlanningScenario", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [PlanningScenario.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PlanningScenario.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PlanningScenario.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PlanningScenario.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PlanningScenario.Level1]
      FROM [Catalog.PlanningScenario.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.PlanningScenario.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.PlanningScenario.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.PlanningScenario.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.PlanningScenario.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.PlanningScenario.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.PlanningScenario] TO jetti;
GO

      
------------------------------ END Catalog.PlanningScenario ------------------------------

      
      
------------------------------ BEGIN Catalog.ProductCategory ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.ProductCategory] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductCategory", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Order] [Order]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.ProductCategory] TO jetti;
GO

      
------------------------------ END Catalog.ProductCategory ------------------------------

      
      
------------------------------ BEGIN Catalog.ProductKind ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.ProductKind] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductKind", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.ProductKind] TO jetti;
GO

      
------------------------------ END Catalog.ProductKind ------------------------------

      
      
------------------------------ BEGIN Catalog.Product.Report ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Product.Report] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductReport", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Brand.v].description, '') [Brand.value], d.[Brand] [Brand.id], [Brand.v].type [Brand.type]
        , ISNULL([Unit.v].description, '') [Unit.value], d.[Unit] [Unit.id], [Unit.v].type [Unit.type]
      
        , ISNULL(l5.description, d.description) [ProductReport.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductReport.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductReport.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductReport.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductReport.Level1]
      FROM [Catalog.Product.Report.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Product.Report.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Product.Report.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Product.Report.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Product.Report.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Product.Report.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Brand.v] [Brand.v] WITH (NOEXPAND) ON [Brand.v].id = d.[Brand]
        LEFT JOIN dbo.[Catalog.Unit.v] [Unit.v] WITH (NOEXPAND) ON [Unit.v].id = d.[Unit]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Product.Report] TO jetti;
GO

      
------------------------------ END Catalog.Product.Report ------------------------------

      
      
------------------------------ BEGIN Catalog.PromotionChannel ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.PromotionChannel] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PromotionChannel", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [PromotionChannel.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PromotionChannel.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PromotionChannel.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PromotionChannel.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PromotionChannel.Level1]
      FROM [Catalog.PromotionChannel.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.PromotionChannel.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.PromotionChannel.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.PromotionChannel.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.PromotionChannel.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.PromotionChannel.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.PromotionChannel] TO jetti;
GO

      
------------------------------ END Catalog.PromotionChannel ------------------------------

      
      
------------------------------ BEGIN Catalog.Storehouse ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Storehouse] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Storehouse", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Storehouse] TO jetti;
GO

      
------------------------------ END Catalog.Storehouse ------------------------------

      
      
------------------------------ BEGIN Catalog.Operation ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Operation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Group.v].description, '') [Group.value], d.[Group] [Group.id], [Group.v].type [Group.type]
        , d.[shortName] [shortName]
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Operation.Group.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Operation] TO jetti;
GO

      
------------------------------ END Catalog.Operation ------------------------------

      
      
------------------------------ BEGIN Catalog.Operation.Group ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Group] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "OperationGroup", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Prefix] [Prefix]
        , d.[menu] [menu]
        , d.[icon] [icon]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Operation.Group] TO jetti;
GO

      
------------------------------ END Catalog.Operation.Group ------------------------------

      
      
------------------------------ BEGIN Catalog.Operation.Type ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Operation.Type] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "OperationType", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Operation.Type] TO jetti;
GO

      
------------------------------ END Catalog.Operation.Type ------------------------------

      
      
------------------------------ BEGIN Catalog.OrderSource ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.OrderSource] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "OrderSource", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Kind] [Kind]
      
        , ISNULL(l5.description, d.description) [OrderSource.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [OrderSource.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [OrderSource.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [OrderSource.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [OrderSource.Level1]
      FROM [Catalog.OrderSource.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.OrderSource.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.OrderSource.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.OrderSource.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.OrderSource.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.OrderSource.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.OrderSource] TO jetti;
GO

      
------------------------------ END Catalog.OrderSource ------------------------------

      
      
------------------------------ BEGIN Catalog.Unit ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Unit] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Unit", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([BaseUnit.v].description, '') [BaseUnit.value], d.[BaseUnit] [BaseUnit.id], [BaseUnit.v].type [BaseUnit.type]
        , d.[Rate] [Rate]
        , d.[kind] [kind]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Unit.v] [BaseUnit.v] WITH (NOEXPAND) ON [BaseUnit.v].id = d.[BaseUnit]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Unit] TO jetti;
GO

      
------------------------------ END Catalog.Unit ------------------------------

      
      
------------------------------ BEGIN Catalog.User ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.User] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "User", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[isAdmin] [isAdmin]
        , d.[isDisabled] [isDisabled]
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Person.v] [Person.v] WITH (NOEXPAND) ON [Person.v].id = d.[Person]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ;
GO
GRANT SELECT ON dbo.[Catalog.User] TO jetti;
GO

      
------------------------------ END Catalog.User ------------------------------

      
      
------------------------------ BEGIN Catalog.UsersGroup ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.UsersGroup] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "UsersGroup", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.UsersGroup] TO jetti;
GO

      
------------------------------ END Catalog.UsersGroup ------------------------------

      
      
------------------------------ BEGIN Catalog.Role ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Role] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Role", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Role] TO jetti;
GO

      
------------------------------ END Catalog.Role ------------------------------

      
      
------------------------------ BEGIN Catalog.SubSystem ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.SubSystem] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "SubSystem", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.SubSystem] TO jetti;
GO

      
------------------------------ END Catalog.SubSystem ------------------------------

      
      
------------------------------ BEGIN Catalog.JobTitle ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.JobTitle] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "JobTitle", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Category.v].description, '') [Category.value], d.[Category] [Category.id], [Category.v].type [Category.type]
        , d.[TO] [TO]
        , d.[CO] [CO]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.JobTitle.Category.v] [Category.v] WITH (NOEXPAND) ON [Category.v].id = d.[Category]
    ;
GO
GRANT SELECT ON dbo.[Catalog.JobTitle] TO jetti;
GO

      
------------------------------ END Catalog.JobTitle ------------------------------

      
      
------------------------------ BEGIN Catalog.JobTitle.Category ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.JobTitle.Category] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "JobTitleCategory", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [JobTitleCategory.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [JobTitleCategory.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [JobTitleCategory.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [JobTitleCategory.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [JobTitleCategory.Level1]
      FROM [Catalog.JobTitle.Category.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.JobTitle.Category.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.JobTitle.Category.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.JobTitle.Category.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.JobTitle.Category.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.JobTitle.Category.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.JobTitle.Category] TO jetti;
GO

      
------------------------------ END Catalog.JobTitle.Category ------------------------------

      
      
------------------------------ BEGIN Catalog.PersonIdentity ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.PersonIdentity] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PersonIdentity", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [PersonIdentity.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PersonIdentity.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PersonIdentity.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PersonIdentity.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PersonIdentity.Level1]
      FROM [Catalog.PersonIdentity.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.PersonIdentity.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.PersonIdentity.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.PersonIdentity.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.PersonIdentity.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.PersonIdentity.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.PersonIdentity] TO jetti;
GO

      
------------------------------ END Catalog.PersonIdentity ------------------------------

      
      
------------------------------ BEGIN Catalog.ReasonTypes ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.ReasonTypes] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ReasonTypes", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [ReasonTypes.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ReasonTypes.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ReasonTypes.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ReasonTypes.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ReasonTypes.Level1]
      FROM [Catalog.ReasonTypes.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.ReasonTypes.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.ReasonTypes.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.ReasonTypes.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.ReasonTypes.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.ReasonTypes.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.ReasonTypes] TO jetti;
GO

      
------------------------------ END Catalog.ReasonTypes ------------------------------

      
      
------------------------------ BEGIN Catalog.Product.Package ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Product.Package] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductPackage", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Product.v].description, '') [Product.value], d.[Product] [Product.id], [Product.v].type [Product.type]
        , d.[Qty] [Qty]
        , d.[isActive] [isActive]
        , d.[Label] [Label]
      
        , ISNULL(l5.description, d.description) [ProductPackage.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductPackage.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductPackage.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductPackage.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductPackage.Level1]
      FROM [Catalog.Product.Package.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Product.Package.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Product.Package.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Product.Package.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Product.Package.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Product.Package.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Product.v] [Product.v] WITH (NOEXPAND) ON [Product.v].id = d.[Product]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Product.Package] TO jetti;
GO

      
------------------------------ END Catalog.Product.Package ------------------------------

      
      
------------------------------ BEGIN Catalog.Product.Analytic ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Product.Analytic] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ProductAnalytic", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Note] [Note]
        , d.[isActive] [isActive]
        , d.[SortOrder] [SortOrder]
      
        , ISNULL(l5.description, d.description) [ProductAnalytic.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ProductAnalytic.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ProductAnalytic.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ProductAnalytic.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ProductAnalytic.Level1]
      FROM [Catalog.Product.Analytic.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Product.Analytic.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Product.Analytic.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Product.Analytic.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Product.Analytic.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Product.Analytic.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Product.Analytic] TO jetti;
GO

      
------------------------------ END Catalog.Product.Analytic ------------------------------

      
      
------------------------------ BEGIN Catalog.Documents ------------------------------

      
      
------------------------------ END Catalog.Documents ------------------------------

      
      
------------------------------ BEGIN Catalog.Catalogs ------------------------------

      
      
------------------------------ END Catalog.Catalogs ------------------------------

      
      
------------------------------ BEGIN Catalog.Forms ------------------------------

      
      
------------------------------ END Catalog.Forms ------------------------------

      
      
------------------------------ BEGIN Catalog.Objects ------------------------------

      
      
------------------------------ END Catalog.Objects ------------------------------

      
      
------------------------------ BEGIN Catalog.Subcount ------------------------------

      
      
------------------------------ END Catalog.Subcount ------------------------------

      
      
------------------------------ BEGIN Catalog.StaffingTable ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.StaffingTable] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "StaffingTable", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([JobTitle.v].description, '') [JobTitle.value], d.[JobTitle] [JobTitle.id], [JobTitle.v].type [JobTitle.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([DepartmentCompany.v].description, '') [DepartmentCompany.value], d.[DepartmentCompany] [DepartmentCompany.id], [DepartmentCompany.v].type [DepartmentCompany.type]
        , ISNULL([Currency.v].description, '') [Currency.value], d.[Currency] [Currency.id], [Currency.v].type [Currency.type]
        , d.[ActivationDate] [ActivationDate]
        , d.[CloseDate] [CloseDate]
        , d.[Qty] [Qty]
        , d.[Cost] [Cost]
      
        , ISNULL(l5.description, d.description) [StaffingTable.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [StaffingTable.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [StaffingTable.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [StaffingTable.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [StaffingTable.Level1]
      FROM [Catalog.StaffingTable.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.StaffingTable.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.StaffingTable.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.StaffingTable.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.StaffingTable.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.StaffingTable.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.JobTitle.v] [JobTitle.v] WITH (NOEXPAND) ON [JobTitle.v].id = d.[JobTitle]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Department.Company.v] [DepartmentCompany.v] WITH (NOEXPAND) ON [DepartmentCompany.v].id = d.[DepartmentCompany]
        LEFT JOIN dbo.[Catalog.Currency.v] [Currency.v] WITH (NOEXPAND) ON [Currency.v].id = d.[Currency]
    ;
GO
GRANT SELECT ON dbo.[Catalog.StaffingTable] TO jetti;
GO

      
------------------------------ END Catalog.StaffingTable ------------------------------

      
      
------------------------------ BEGIN Catalog.Brand ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Brand] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Brand", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Brand] TO jetti;
GO

      
------------------------------ END Catalog.Brand ------------------------------

      
      
------------------------------ BEGIN Catalog.GroupObjectsExploitation ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.GroupObjectsExploitation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "GroupObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.GroupObjectsExploitation] TO jetti;
GO

      
------------------------------ END Catalog.GroupObjectsExploitation ------------------------------

      
      
------------------------------ BEGIN Catalog.ObjectsExploitation ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.ObjectsExploitation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ObjectsExploitation", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.ObjectsExploitation.v] [Group.v] WITH (NOEXPAND) ON [Group.v].id = d.[Group]
    ;
GO
GRANT SELECT ON dbo.[Catalog.ObjectsExploitation] TO jetti;
GO

      
------------------------------ END Catalog.ObjectsExploitation ------------------------------

      
      
------------------------------ BEGIN Catalog.Catalog ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Catalog] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Catalog", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[typeString] [typeString]
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Catalog] TO jetti;
GO

      
------------------------------ END Catalog.Catalog ------------------------------

      
      
------------------------------ BEGIN Catalog.BudgetItem ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.BudgetItem] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BudgetItem", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([parent2.v].description, '') [parent2.value], d.[parent2] [parent2.id], [parent2.v].type [parent2.type]
        , d.[UnaryOperator] [UnaryOperator]
        , d.[DescriptionENG] [DescriptionENG]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.BudgetItem.v] [parent2.v] WITH (NOEXPAND) ON [parent2.v].id = d.[parent2]
    ;
GO
GRANT SELECT ON dbo.[Catalog.BudgetItem] TO jetti;
GO

      
------------------------------ END Catalog.BudgetItem ------------------------------

      
      
------------------------------ BEGIN Catalog.Scenario ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Scenario] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Scenario", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Scenario] TO jetti;
GO

      
------------------------------ END Catalog.Scenario ------------------------------

      
      
------------------------------ BEGIN Catalog.ManufactureLocation ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.ManufactureLocation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ManufactureLocation", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [ManufactureLocation.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [ManufactureLocation.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [ManufactureLocation.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [ManufactureLocation.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [ManufactureLocation.Level1]
      FROM [Catalog.ManufactureLocation.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.ManufactureLocation.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.ManufactureLocation.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.ManufactureLocation.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.ManufactureLocation.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.ManufactureLocation.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.ManufactureLocation] TO jetti;
GO

      
------------------------------ END Catalog.ManufactureLocation ------------------------------

      
      
------------------------------ BEGIN Catalog.AcquiringTerminal ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.AcquiringTerminal] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "AcquiringTerminal", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
        , ISNULL([Counterpartie.v].description, '') [Counterpartie.value], d.[Counterpartie] [Counterpartie.id], [Counterpartie.v].type [Counterpartie.type]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , d.[isDefault] [isDefault]
        , d.[Code1] [Code1]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Counterpartie.v] WITH (NOEXPAND) ON [Counterpartie.v].id = d.[Counterpartie]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
    ;
GO
GRANT SELECT ON dbo.[Catalog.AcquiringTerminal] TO jetti;
GO

      
------------------------------ END Catalog.AcquiringTerminal ------------------------------

      
      
------------------------------ BEGIN Catalog.Bank ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Bank] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Bank", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Address] [Address]
        , d.[KorrAccount] [KorrAccount]
        , ISNULL([ExportRule.v].description, '') [ExportRule.value], d.[ExportRule] [ExportRule.id], [ExportRule.v].type [ExportRule.type]
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Document.Operation.v] [ExportRule.v] WITH (NOEXPAND) ON [ExportRule.v].id = d.[ExportRule]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Bank] TO jetti;
GO

      
------------------------------ END Catalog.Bank ------------------------------

      
      
------------------------------ BEGIN Catalog.Person.BankAccount ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Person.BankAccount] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PersonBankAccount", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , ISNULL([Bank.v].description, '') [Bank.value], d.[Bank] [Bank.id], [Bank.v].type [Bank.type]
        , ISNULL([SalaryProject.v].description, '') [SalaryProject.value], d.[SalaryProject] [SalaryProject.id], [SalaryProject.v].type [SalaryProject.type]
        , d.[OpenDate] [OpenDate]
      
        , ISNULL(l5.description, d.description) [PersonBankAccount.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PersonBankAccount.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PersonBankAccount.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PersonBankAccount.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PersonBankAccount.Level1]
      FROM [Catalog.Person.BankAccount.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Person.BankAccount.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Person.BankAccount.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Person.BankAccount.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Person.BankAccount.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Person.BankAccount.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Person.v] [owner.v] WITH (NOEXPAND) ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.Bank.v] [Bank.v] WITH (NOEXPAND) ON [Bank.v].id = d.[Bank]
        LEFT JOIN dbo.[Catalog.SalaryProject.v] [SalaryProject.v] WITH (NOEXPAND) ON [SalaryProject.v].id = d.[SalaryProject]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Person.BankAccount] TO jetti;
GO

      
------------------------------ END Catalog.Person.BankAccount ------------------------------

      
      
------------------------------ BEGIN Catalog.Person.Contract ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Person.Contract] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PersonContract", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([owner.v].description, '') [owner.value], d.[owner] [owner.id], [owner.v].type [owner.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[Status] [Status]
        , d.[StartDate] [StartDate]
        , d.[EndDate] [EndDate]
        , ISNULL([BankAccount.v].description, '') [BankAccount.value], d.[BankAccount] [BankAccount.id], [BankAccount.v].type [BankAccount.type]
      
        , ISNULL(l5.description, d.description) [PersonContract.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [PersonContract.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [PersonContract.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [PersonContract.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [PersonContract.Level1]
      FROM [Catalog.Person.Contract.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Person.Contract.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Person.Contract.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Person.Contract.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Person.Contract.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Person.Contract.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Person.v] [owner.v] WITH (NOEXPAND) ON [owner.v].id = d.[owner]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
        LEFT JOIN dbo.[Catalog.Person.BankAccount.v] [BankAccount.v] WITH (NOEXPAND) ON [BankAccount.v].id = d.[BankAccount]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Person.Contract] TO jetti;
GO

      
------------------------------ END Catalog.Person.Contract ------------------------------

      
      
------------------------------ BEGIN Catalog.BusinessRegion ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.BusinessRegion] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "BusinessRegion", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.BusinessRegion] TO jetti;
GO

      
------------------------------ END Catalog.BusinessRegion ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxRate ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxRate] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxRate", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxRate] TO jetti;
GO

      
------------------------------ END Catalog.TaxRate ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxAssignmentCode ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxAssignmentCode] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxAssignmentCode", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[FullDescription] [FullDescription]
      
        , ISNULL(l5.description, d.description) [TaxAssignmentCode.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxAssignmentCode.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxAssignmentCode.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxAssignmentCode.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxAssignmentCode.Level1]
      FROM [Catalog.TaxAssignmentCode.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxAssignmentCode.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxAssignmentCode.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxAssignmentCode.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxAssignmentCode.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxAssignmentCode.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxAssignmentCode] TO jetti;
GO

      
------------------------------ END Catalog.TaxAssignmentCode ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxPaymentCode ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxPaymentCode] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxPaymentCode", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[FullDescription] [FullDescription]
        , ISNULL([BalanceAnalytics.v].description, '') [BalanceAnalytics.value], d.[BalanceAnalytics] [BalanceAnalytics.id], [BalanceAnalytics.v].type [BalanceAnalytics.type]
      
        , ISNULL(l5.description, d.description) [TaxPaymentCode.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxPaymentCode.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxPaymentCode.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxPaymentCode.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxPaymentCode.Level1]
      FROM [Catalog.TaxPaymentCode.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxPaymentCode.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxPaymentCode.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxPaymentCode.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxPaymentCode.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxPaymentCode.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Balance.Analytics.v] [BalanceAnalytics.v] WITH (NOEXPAND) ON [BalanceAnalytics.v].id = d.[BalanceAnalytics]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxPaymentCode] TO jetti;
GO

      
------------------------------ END Catalog.TaxPaymentCode ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxBasisPayment ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxBasisPayment] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxBasisPayment", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [TaxBasisPayment.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxBasisPayment.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxBasisPayment.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxBasisPayment.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxBasisPayment.Level1]
      FROM [Catalog.TaxBasisPayment.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxBasisPayment.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxBasisPayment.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxBasisPayment.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxBasisPayment.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxBasisPayment.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxBasisPayment] TO jetti;
GO

      
------------------------------ END Catalog.TaxBasisPayment ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxPaymentPeriod ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxPaymentPeriod] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxPaymentPeriod", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [TaxPaymentPeriod.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxPaymentPeriod.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxPaymentPeriod.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxPaymentPeriod.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxPaymentPeriod.Level1]
      FROM [Catalog.TaxPaymentPeriod.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxPaymentPeriod.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxPaymentPeriod.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxPaymentPeriod.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxPaymentPeriod.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxPaymentPeriod.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxPaymentPeriod] TO jetti;
GO

      
------------------------------ END Catalog.TaxPaymentPeriod ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxPayerStatus ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxPayerStatus] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxPayerStatus", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[FullDescription] [FullDescription]
      
        , ISNULL(l5.description, d.description) [TaxPayerStatus.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxPayerStatus.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxPayerStatus.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxPayerStatus.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxPayerStatus.Level1]
      FROM [Catalog.TaxPayerStatus.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxPayerStatus.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxPayerStatus.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxPayerStatus.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxPayerStatus.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxPayerStatus.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxPayerStatus] TO jetti;
GO

      
------------------------------ END Catalog.TaxPayerStatus ------------------------------

      
      
------------------------------ BEGIN Catalog.TaxOffice ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.TaxOffice] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "TaxOffice", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[FullName] [FullName]
        , d.[Code1] [Code1]
        , d.[Code2] [Code2]
        , d.[Code3] [Code3]
      
        , ISNULL(l5.description, d.description) [TaxOffice.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [TaxOffice.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [TaxOffice.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [TaxOffice.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [TaxOffice.Level1]
      FROM [Catalog.TaxOffice.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.TaxOffice.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.TaxOffice.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.TaxOffice.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.TaxOffice.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.TaxOffice.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.TaxOffice] TO jetti;
GO

      
------------------------------ END Catalog.TaxOffice ------------------------------

      
      
------------------------------ BEGIN Catalog.RetailClient ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.RetailClient] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "RetailClient", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Gender] [Gender]
        , d.[isActive] [isActive]
        , d.[CreateDate] [CreateDate]
        , d.[Birthday] [Birthday]
        , d.[FirstName] [FirstName]
        , d.[LastName] [LastName]
        , d.[MiddleName] [MiddleName]
        , d.[Phone] [Phone]
        , d.[Address] [Address]
        , d.[Email] [Email]
      
        , ISNULL(l5.description, d.description) [RetailClient.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [RetailClient.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [RetailClient.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [RetailClient.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [RetailClient.Level1]
      FROM [Catalog.RetailClient.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.RetailClient.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.RetailClient.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.RetailClient.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.RetailClient.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.RetailClient.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.RetailClient] TO jetti;
GO

      
------------------------------ END Catalog.RetailClient ------------------------------

      
      
------------------------------ BEGIN Catalog.SalaryProject ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.SalaryProject] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "SalaryProject", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([bank.v].description, '') [bank.value], d.[bank] [bank.id], [bank.v].type [bank.type]
        , ISNULL([currency.v].description, '') [currency.value], d.[currency] [currency.id], [currency.v].type [currency.type]
        , d.[OpenDate] [OpenDate]
        , d.[BankBranch] [BankBranch]
        , d.[BankBranchOffice] [BankBranchOffice]
        , d.[BankAccount] [BankAccount]
      
        , ISNULL(l5.description, d.description) [SalaryProject.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [SalaryProject.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [SalaryProject.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [SalaryProject.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [SalaryProject.Level1]
      FROM [Catalog.SalaryProject.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.SalaryProject.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.SalaryProject.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.SalaryProject.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.SalaryProject.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.SalaryProject.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Bank.v] [bank.v] WITH (NOEXPAND) ON [bank.v].id = d.[bank]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    ;
GO
GRANT SELECT ON dbo.[Catalog.SalaryProject] TO jetti;
GO

      
------------------------------ END Catalog.SalaryProject ------------------------------

      
      
------------------------------ BEGIN Catalog.Specification ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Specification] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Specification", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Brand.v].description, '') [Brand.value], d.[Brand] [Brand.id], [Brand.v].type [Brand.type]
        , ISNULL([MainProduct.v].description, '') [MainProduct.value], d.[MainProduct] [MainProduct.id], [MainProduct.v].type [MainProduct.type]
        , d.[Status] [Status]
        , d.[FullDescription] [FullDescription]
        , d.[StartDate] [StartDate]
        , d.[EndDate] [EndDate]
        , ISNULL([ResponsiblePerson.v].description, '') [ResponsiblePerson.value], d.[ResponsiblePerson] [ResponsiblePerson.id], [ResponsiblePerson.v].type [ResponsiblePerson.type]
      
        , ISNULL(l5.description, d.description) [Specification.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Specification.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Specification.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Specification.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Specification.Level1]
      FROM [Catalog.Specification.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Specification.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Specification.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Specification.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Specification.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Specification.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Brand.v] [Brand.v] WITH (NOEXPAND) ON [Brand.v].id = d.[Brand]
        LEFT JOIN dbo.[Catalog.Product.v] [MainProduct.v] WITH (NOEXPAND) ON [MainProduct.v].id = d.[MainProduct]
        LEFT JOIN dbo.[Catalog.Person.v] [ResponsiblePerson.v] WITH (NOEXPAND) ON [ResponsiblePerson.v].id = d.[ResponsiblePerson]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Specification] TO jetti;
GO

      
------------------------------ END Catalog.Specification ------------------------------

      
      
------------------------------ BEGIN Catalog.InvestorGroup ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.InvestorGroup] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "InvestorGroup", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
      
        , ISNULL(l5.description, d.description) [InvestorGroup.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [InvestorGroup.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [InvestorGroup.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [InvestorGroup.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [InvestorGroup.Level1]
      FROM [Catalog.InvestorGroup.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.InvestorGroup.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.InvestorGroup.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.InvestorGroup.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.InvestorGroup.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.InvestorGroup.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Catalog.InvestorGroup] TO jetti;
GO

      
------------------------------ END Catalog.InvestorGroup ------------------------------

      
      
------------------------------ BEGIN Catalog.Employee ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Catalog.Employee] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Employee", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , ISNULL([Person.v].description, '') [Person.value], d.[Person] [Person.id], [Person.v].type [Person.type]
      
        , ISNULL(l5.description, d.description) [Employee.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [Employee.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [Employee.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [Employee.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [Employee.Level1]
      FROM [Catalog.Employee.v] d WITH (NOEXPAND)
        LEFT JOIN [Catalog.Employee.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [Catalog.Employee.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [Catalog.Employee.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [Catalog.Employee.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [Catalog.Employee.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Person.v] [Person.v] WITH (NOEXPAND) ON [Person.v].id = d.[Person]
    ;
GO
GRANT SELECT ON dbo.[Catalog.Employee] TO jetti;
GO

      
------------------------------ END Catalog.Employee ------------------------------

      
      
------------------------------ BEGIN Document.ExchangeRates ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.ExchangeRates] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "ExchangeRates", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
    ;
GO
GRANT SELECT ON dbo.[Document.ExchangeRates] TO jetti;
GO

      
------------------------------ END Document.ExchangeRates ------------------------------

      
      
------------------------------ BEGIN Document.Invoice ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.Invoice] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Invoice", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Catalog.Storehouse.v] [Storehouse.v] WITH (NOEXPAND) ON [Storehouse.v].id = d.[Storehouse]
        LEFT JOIN dbo.[Catalog.Counterpartie.v] [Customer.v] WITH (NOEXPAND) ON [Customer.v].id = d.[Customer]
        LEFT JOIN dbo.[Catalog.Manager.v] [Manager.v] WITH (NOEXPAND) ON [Manager.v].id = d.[Manager]
        LEFT JOIN dbo.[Catalog.Currency.v] [currency.v] WITH (NOEXPAND) ON [currency.v].id = d.[currency]
    ;
GO
GRANT SELECT ON dbo.[Document.Invoice] TO jetti;
GO

      
------------------------------ END Document.Invoice ------------------------------

      
      
------------------------------ BEGIN Document.Operation ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.Operation] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Operation", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
GRANT SELECT ON dbo.[Document.Operation] TO jetti;
GO

      
------------------------------ END Document.Operation ------------------------------

      
      
------------------------------ BEGIN Document.PriceList ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.PriceList] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "PriceList", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.PriceType.v] [PriceType.v] WITH (NOEXPAND) ON [PriceType.v].id = d.[PriceType]
    ;
GO
GRANT SELECT ON dbo.[Document.PriceList] TO jetti;
GO

      
------------------------------ END Document.PriceList ------------------------------

      
      
------------------------------ BEGIN Document.Settings ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.Settings] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "Settings", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Currency.v] [balanceCurrency.v] WITH (NOEXPAND) ON [balanceCurrency.v].id = d.[balanceCurrency]
        LEFT JOIN dbo.[Catalog.Currency.v] [accountingCurrency.v] WITH (NOEXPAND) ON [accountingCurrency.v].id = d.[accountingCurrency]
    ;
GO
GRANT SELECT ON dbo.[Document.Settings] TO jetti;
GO

      
------------------------------ END Document.Settings ------------------------------

      
      
------------------------------ BEGIN Document.UserSettings ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.UserSettings] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "UserSettings", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Documents] [UserOrGroup.v] ON [UserOrGroup.v].id = d.[UserOrGroup]
    ;
GO
GRANT SELECT ON dbo.[Document.UserSettings] TO jetti;
GO

      
------------------------------ END Document.UserSettings ------------------------------

      
      
------------------------------ BEGIN Document.WorkFlow ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.WorkFlow] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "WorkFlow", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Documents] [Document.v] ON [Document.v].id = d.[Document]
    ;
GO
GRANT SELECT ON dbo.[Document.WorkFlow] TO jetti;
GO

      
------------------------------ END Document.WorkFlow ------------------------------

      
      
------------------------------ BEGIN Document.CashRequest ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.CashRequest] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashRequest", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Status] [Status]
        , d.[Operation] [Operation]
        , d.[PaymentKind] [PaymentKind]
        , d.[EnforcementProceedings] [EnforcementProceedings]
        , d.[CashKind] [CashKind]
        , d.[PayRollKind] [PayRollKind]
        , ISNULL([Department.v].description, '') [Department.value], d.[Department] [Department.id], [Department.v].type [Department.type]
        , ISNULL([CashRecipient.v].description, '') [CashRecipient.value], d.[CashRecipient] [CashRecipient.id], [CashRecipient.v].type [CashRecipient.type]
        , ISNULL([Contract.v].description, '') [Contract.value], d.[Contract] [Contract.id], [Contract.v].type [Contract.type]
        , ISNULL([ContractIntercompany.v].description, '') [ContractIntercompany.value], d.[ContractIntercompany] [ContractIntercompany.id], [ContractIntercompany.v].type [ContractIntercompany.type]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([SalaryProject.v].description, '') [SalaryProject.value], d.[SalaryProject] [SalaryProject.id], [SalaryProject.v].type [SalaryProject.type]
        , ISNULL([Loan.v].description, '') [Loan.value], d.[Loan] [Loan.id], [Loan.v].type [Loan.type]
        , ISNULL([CashOrBank.v].description, '') [CashOrBank.value], d.[CashOrBank] [CashOrBank.id], [CashOrBank.v].type [CashOrBank.type]
        , ISNULL([CashRecipientBankAccount.v].description, '') [CashRecipientBankAccount.value], d.[CashRecipientBankAccount] [CashRecipientBankAccount.id], [CashRecipientBankAccount.v].type [CashRecipientBankAccount.type]
        , ISNULL([CashOrBankIn.v].description, '') [CashOrBankIn.value], d.[CashOrBankIn] [CashOrBankIn.id], [CashOrBankIn.v].type [CashOrBankIn.type]
        , d.[PayDay] [PayDay]
        , d.[Amount] [Amount]
        , d.[AmountPenalty] [AmountPenalty]
        , ISNULL([сurrency.v].description, '') [сurrency.value], d.[сurrency] [сurrency.id], [сurrency.v].type [сurrency.type]
        , ISNULL([ExpenseOrBalance.v].description, '') [ExpenseOrBalance.value], d.[ExpenseOrBalance] [ExpenseOrBalance.id], [ExpenseOrBalance.v].type [ExpenseOrBalance.type]
        , ISNULL([ExpenseAnalytics.v].description, '') [ExpenseAnalytics.value], d.[ExpenseAnalytics] [ExpenseAnalytics.id], [ExpenseAnalytics.v].type [ExpenseAnalytics.type]
        , ISNULL([SalaryAnalitics.v].description, '') [SalaryAnalitics.value], d.[SalaryAnalitics] [SalaryAnalitics.id], [SalaryAnalitics.v].type [SalaryAnalitics.type]
        , ISNULL([SKU.v].description, '') [SKU.value], d.[SKU] [SKU.id], [SKU.v].type [SKU.type]
        , ISNULL([TaxRate.v].description, '') [TaxRate.value], d.[TaxRate] [TaxRate.id], [TaxRate.v].type [TaxRate.type]
        , d.[TaxKPP] [TaxKPP]
        , ISNULL([TaxPaymentCode.v].description, '') [TaxPaymentCode.value], d.[TaxPaymentCode] [TaxPaymentCode.id], [TaxPaymentCode.v].type [TaxPaymentCode.type]
        , ISNULL([TaxAssignmentCode.v].description, '') [TaxAssignmentCode.value], d.[TaxAssignmentCode] [TaxAssignmentCode.id], [TaxAssignmentCode.v].type [TaxAssignmentCode.type]
        , ISNULL([TaxPayerStatus.v].description, '') [TaxPayerStatus.value], d.[TaxPayerStatus] [TaxPayerStatus.id], [TaxPayerStatus.v].type [TaxPayerStatus.type]
        , ISNULL([TaxBasisPayment.v].description, '') [TaxBasisPayment.value], d.[TaxBasisPayment] [TaxBasisPayment.id], [TaxBasisPayment.v].type [TaxBasisPayment.type]
        , ISNULL([TaxPaymentPeriod.v].description, '') [TaxPaymentPeriod.value], d.[TaxPaymentPeriod] [TaxPaymentPeriod.id], [TaxPaymentPeriod.v].type [TaxPaymentPeriod.type]
        , d.[TaxDocNumber] [TaxDocNumber]
        , d.[TaxDocDate] [TaxDocDate]
        , d.[TaxOfficeCode2] [TaxOfficeCode2]
        , ISNULL([BalanceAnalytics.v].description, '') [BalanceAnalytics.value], d.[BalanceAnalytics] [BalanceAnalytics.id], [BalanceAnalytics.v].type [BalanceAnalytics.type]
        , d.[workflowID] [workflowID]
        , d.[ManualInfo] [ManualInfo]
        , d.[BudgetPayment] [BudgetPayment]
        , d.[RelatedURL] [RelatedURL]
        , ISNULL([tempCompanyParent.v].description, '') [tempCompanyParent.value], d.[tempCompanyParent] [tempCompanyParent.id], [tempCompanyParent.v].type [tempCompanyParent.type]
        , d.[tempSalaryKind] [tempSalaryKind]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.Department.v] [Department.v] WITH (NOEXPAND) ON [Department.v].id = d.[Department]
        LEFT JOIN dbo.[Documents] [CashRecipient.v] ON [CashRecipient.v].id = d.[CashRecipient]
        LEFT JOIN dbo.[Catalog.Contract.v] [Contract.v] WITH (NOEXPAND) ON [Contract.v].id = d.[Contract]
        LEFT JOIN dbo.[Catalog.Contract.Intercompany.v] [ContractIntercompany.v] WITH (NOEXPAND) ON [ContractIntercompany.v].id = d.[ContractIntercompany]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.SalaryProject.v] [SalaryProject.v] WITH (NOEXPAND) ON [SalaryProject.v].id = d.[SalaryProject]
        LEFT JOIN dbo.[Catalog.Loan.v] [Loan.v] WITH (NOEXPAND) ON [Loan.v].id = d.[Loan]
        LEFT JOIN dbo.[Documents] [CashOrBank.v] ON [CashOrBank.v].id = d.[CashOrBank]
        LEFT JOIN dbo.[Documents] [CashRecipientBankAccount.v] ON [CashRecipientBankAccount.v].id = d.[CashRecipientBankAccount]
        LEFT JOIN dbo.[Documents] [CashOrBankIn.v] ON [CashOrBankIn.v].id = d.[CashOrBankIn]
        LEFT JOIN dbo.[Catalog.Currency.v] [сurrency.v] WITH (NOEXPAND) ON [сurrency.v].id = d.[сurrency]
        LEFT JOIN dbo.[Documents] [ExpenseOrBalance.v] ON [ExpenseOrBalance.v].id = d.[ExpenseOrBalance]
        LEFT JOIN dbo.[Catalog.Expense.Analytics.v] [ExpenseAnalytics.v] WITH (NOEXPAND) ON [ExpenseAnalytics.v].id = d.[ExpenseAnalytics]
        LEFT JOIN dbo.[Catalog.Salary.Analytics.v] [SalaryAnalitics.v] WITH (NOEXPAND) ON [SalaryAnalitics.v].id = d.[SalaryAnalitics]
        LEFT JOIN dbo.[Catalog.Product.v] [SKU.v] WITH (NOEXPAND) ON [SKU.v].id = d.[SKU]
        LEFT JOIN dbo.[Catalog.TaxRate.v] [TaxRate.v] WITH (NOEXPAND) ON [TaxRate.v].id = d.[TaxRate]
        LEFT JOIN dbo.[Catalog.TaxPaymentCode.v] [TaxPaymentCode.v] WITH (NOEXPAND) ON [TaxPaymentCode.v].id = d.[TaxPaymentCode]
        LEFT JOIN dbo.[Catalog.TaxAssignmentCode.v] [TaxAssignmentCode.v] WITH (NOEXPAND) ON [TaxAssignmentCode.v].id = d.[TaxAssignmentCode]
        LEFT JOIN dbo.[Catalog.TaxPayerStatus.v] [TaxPayerStatus.v] WITH (NOEXPAND) ON [TaxPayerStatus.v].id = d.[TaxPayerStatus]
        LEFT JOIN dbo.[Catalog.TaxBasisPayment.v] [TaxBasisPayment.v] WITH (NOEXPAND) ON [TaxBasisPayment.v].id = d.[TaxBasisPayment]
        LEFT JOIN dbo.[Catalog.TaxPaymentPeriod.v] [TaxPaymentPeriod.v] WITH (NOEXPAND) ON [TaxPaymentPeriod.v].id = d.[TaxPaymentPeriod]
        LEFT JOIN dbo.[Catalog.Balance.Analytics.v] [BalanceAnalytics.v] WITH (NOEXPAND) ON [BalanceAnalytics.v].id = d.[BalanceAnalytics]
        LEFT JOIN dbo.[Catalog.Company.v] [tempCompanyParent.v] WITH (NOEXPAND) ON [tempCompanyParent.v].id = d.[tempCompanyParent]
    ;
GO
GRANT SELECT ON dbo.[Document.CashRequest] TO jetti;
GO

      
------------------------------ END Document.CashRequest ------------------------------

      
      
------------------------------ BEGIN Document.CashRequestRegistry ------------------------------

      
      CREATE OR ALTER VIEW dbo.[Document.CashRequestRegistry] AS
        
      SELECT
        d.id, d.type, d.date, d.code, d.description "CashRequestRegistry", d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"
        , ISNULL([workflow.v].description, '') [workflow.value], d.[workflow] [workflow.id], [workflow.v].type [workflow.type]
        , d.[Status] [Status]
        , d.[Operation] [Operation]
        , d.[CashKind] [CashKind]
        , ISNULL([CashFlow.v].description, '') [CashFlow.value], d.[CashFlow] [CashFlow.id], [CashFlow.v].type [CashFlow.type]
        , ISNULL([BusinessDirection.v].description, '') [BusinessDirection.value], d.[BusinessDirection] [BusinessDirection.id], [BusinessDirection.v].type [BusinessDirection.type]
        , d.[Amount] [Amount]
        , ISNULL([сurrency.v].description, '') [сurrency.value], d.[сurrency] [сurrency.id], [сurrency.v].type [сurrency.type]
        , d.[BankUploadDate] [BankUploadDate]
        , d.[DocumentsCreationDate] [DocumentsCreationDate]
      
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
      
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company
        LEFT JOIN dbo.[Document.WorkFlow.v] [workflow.v] WITH (NOEXPAND) ON [workflow.v].id = d.[workflow]
        LEFT JOIN dbo.[Catalog.CashFlow.v] [CashFlow.v] WITH (NOEXPAND) ON [CashFlow.v].id = d.[CashFlow]
        LEFT JOIN dbo.[Catalog.BusinessDirection.v] [BusinessDirection.v] WITH (NOEXPAND) ON [BusinessDirection.v].id = d.[BusinessDirection]
        LEFT JOIN dbo.[Catalog.Currency.v] [сurrency.v] WITH (NOEXPAND) ON [сurrency.v].id = d.[сurrency]
    ;
GO
GRANT SELECT ON dbo.[Document.CashRequestRegistry] TO jetti;
GO

      
------------------------------ END Document.CashRequestRegistry ------------------------------

      