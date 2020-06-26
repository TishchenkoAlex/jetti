import { DocumentOptions } from '../models/document';
import { createDocument, RegisteredDocument } from '../models/documents.factory';
import { createRegisterAccumulation, RegisteredRegisterAccumulation } from '../models/Registers/Accumulation/factory';
import { createRegisterInfo, GetRegisterInfo } from '../models/Registers/Info/factory';
import { excludeRegisterAccumulatioProps, SQLGenegator } from './SQLGenerator.MSSQL';

// tslint:disable:max-line-length
// tslint:disable:no-shadowed-variable
// tslint:disable:forin

export class SQLGenegatorMetadata {

  static QueryRegisterAccumulationView(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') {
        return `
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.${prop}') "${prop}"`;
      }
      if (type === 'number') {
        return `
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.${prop}')) * IIF(kind = 1, 1, -1) "${prop}"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.${prop}')) * IIF(kind = 1, 1,  null) "${prop}.In"
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.${prop}')) * IIF(kind = 1, null,  1) "${prop}.Out"`;
      }
      if (type === 'date') {
        return `
        , TRY_CONVERT(DATE, JSON_VALUE(data, N'$.${prop}'),127) "${prop}"`;
      }
      if (type === 'datetime') {
        return `
        , TRY_CONVERT(DATETIME, JSON_VALUE(data, N'$.${prop}'),127) "${prop}"`;
      }
      return `
        , TRY_CONVERT(NVARCHAR(150), JSON_VALUE(data, '$.${prop}')) "${prop}" \n`;
    };

    const complexProperty = (prop: string, type: string) => `
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."${prop}"')) "${prop}"`;

    let insert = ''; let select = ''; let fields = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
      fields += prop + ',';
      const type: string = doc[prop].type || 'string';
      insert += `
        , "${prop}"`;
      if (type === 'number') {
        insert += `
        , "${prop}.In"
        , "${prop}.Out"`;
      }

      if (type.includes('.')) {
        select += complexProperty(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
    RAISERROR('${type} start', 0 ,1) WITH NOWAIT;
    GO
    CREATE OR ALTER VIEW [${type}]
    WITH SCHEMABINDING
    AS
    SELECT
      id, parent, CAST(date AS DATE) date, document, company, kind, calculated
        , TRY_CONVERT(NUMERIC(15,10), JSON_VALUE(data, N'$.exchangeRate')) exchangeRate${select}
      FROM dbo.[Accumulation] WHERE type = N'${type}';
    GO
    GRANT SELECT,DELETE ON [${type}] TO JETTI;
    GO
      CREATE UNIQUE INDEX [${type}.id] ON [dbo].[${type}](id);
      CREATE UNIQUE CLUSTERED INDEX [${type}] ON [dbo].[${type}](company,date,calculated,id);
      GO
    RAISERROR('${type} finish', 0 ,1) WITH NOWAIT;
    GO
    `;
    return query;
  }

  static CreateRegisterAccumulationViewIndex() {
    let query = '';
    for (const type of RegisteredRegisterAccumulation) {
      const register = createRegisterAccumulation({ type: type.type });
      query += SQLGenegatorMetadata.QueryRegisterAccumulationView(register.Props(), register.Prop().type.toString());
    }
    query = `
    ${query}
    EXEC [rpt].[CreateIndexReportHelper]
    GO
    `;
    return query;
  }

  static QueryRegisterIntoView(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') {
        return `
        , TRY_CONVERT(BIT, JSON_VALUE(data, N'$.${prop}')) "${prop}"`;
      }
      if (type === 'number') {
        return `
        , TRY_CONVERT(MONEY, JSON_VALUE(data, N'$.${prop}')) "${prop}"`;
      }
      if (type === 'date') {
        return `
        , TRY_CONVERT(DATE,JSON_VALUE(data, N'$.${prop}'),127) "${prop}"`;
      }
      if (type === 'datetime') {
        return `
        , TRY_CONVERT(DATETIME,JSON_VALUE(data, N'$.${prop}'),127) "${prop}"`;
      }
      return `
        , ISNULL(JSON_VALUE(data, '$.${prop}'), '') "${prop}"`;
    };

    const complexProperty = (prop: string, type: string) => `
        , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(data, N'$."${prop}"')) "${prop}"`;

    let insert = ''; let select = ''; let fields = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
      fields += `[${prop}],`;
      const type: string = doc[prop].type || 'string';
      insert += `
        , "${prop}"`;
      if (type === 'number') {
        insert += `
        , "${prop}.In"
        , "${prop}.Out"`;
      }

      if (type.includes('.')) {
        select += complexProperty(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
    CREATE OR ALTER VIEW [${type}]
    WITH SCHEMABINDING
    AS
    SELECT
      id, date, document, company${select}
      FROM dbo.[Register.Info] WHERE type = N'${type}';
    GO
    GRANT SELECT,DELETE ON [${type}] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [${type}] ON [dbo].[${type}](
      company,date,id
    )
    GO
    `;
    return query;
  }

  static CreateRegisterInfoViewIndex() {
    let query = '';
    for (const type of GetRegisterInfo()) {
      const register = createRegisterInfo({ type: type.type });
      query += SQLGenegatorMetadata.QueryRegisterIntoView(register.Props(), register.Prop().type.toString());
    }
    return query;
  }

  static CreateViewCatalogs() {

    let query = '';
    for (const catalog of RegisteredDocument) {
      const doc = createDocument(catalog.type);
      if (doc['QueryList']) continue;
      const Props = doc.Props();
      const type = (doc.Prop() as DocumentOptions).type;
      let select = SQLGenegator.QueryList(Props, doc.type);
      const typeSplit = type.split('.');
      let name = '';
      for (let i = 1; i < typeSplit.length; i++) name += typeSplit[i];
      select = select.replace(`FROM [${type}.v] d WITH (NOEXPAND)`, `
        , ISNULL(l5.description, d.description) [${name}.Level5]
        , ISNULL(l4.description, ISNULL(l5.description, d.description)) [${name}.Level4]
        , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [${name}.Level3]
        , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [${name}.Level2]
        , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [${name}.Level1]
      FROM [${type}.v] d WITH (NOEXPAND)
        LEFT JOIN [${type}.v] l5 WITH (NOEXPAND) ON (l5.id = d.parent)
        LEFT JOIN [${type}.v] l4 WITH (NOEXPAND) ON (l4.id = l5.parent)
        LEFT JOIN [${type}.v] l3 WITH (NOEXPAND) ON (l3.id = l4.parent)
        LEFT JOIN [${type}.v] l2 WITH (NOEXPAND) ON (l2.id = l3.parent)
        LEFT JOIN [${type}.v] l1 WITH (NOEXPAND) ON (l1.id = l2.parent)
      `).replace('d.description,', `d.description "${name}",`);

      query += `\n
      CREATE OR ALTER VIEW dbo.[${catalog.type}] AS
        ${select}
      GO
      GRANT SELECT ON dbo.[${catalog.type}] TO jetti;
      GO
      `;
    }
    query = `
    CREATE OR ALTER VIEW [dbo].[Catalog.Documents] AS
    SELECT
      'https://x100-jetti.web.app/' + d.type + '/' + TRY_CONVERT(varchar(36), d.id) as link,
      d.id, d.date [date],
      d.description Presentation,
      d.info,
      d.type,CAST(JSON_VALUE(doc, N'$.DocReceived') as bit) DocReceived
    FROM dbo.[Documents] d
    GO
    GRANT SELECT ON [dbo].[Catalog.Documents] TO jetti;
    GO

    ${query}
    `;
    return query;
  }

  static CreateViewCatalogsIndex() {

    let query = `
    --DROP SECURITY POLICY IF EXISTS [rls].[companyAccessPolicy];
    --GO

    --CREATE SECURITY POLICY [rls].[companyAccessPolicy]
      --ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[Documents.Hisroty]
      --WITH (STATE = ON);
    --GO
    `;
    for (const catalog of RegisteredDocument) {
      const doc = createDocument(catalog.type);
      if (doc['QueryList']) continue;
      const select = SQLGenegator.QueryListRaw(doc.Props(), doc.type);

      query += `
      ALTER SECURITY POLICY [rls].[companyAccessPolicy] DROP FILTER PREDICATE ON [dbo].[${catalog.type}.v];
      GO

      CREATE OR ALTER VIEW dbo.[${catalog.type}.v] WITH SCHEMABINDING AS${select}
      GO

      CREATE UNIQUE CLUSTERED INDEX [${catalog.type}.v] ON [${catalog.type}.v](id);
      ${doc.type.startsWith('Document.') ? `
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.date] ON [${catalog.type}.v](date,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.parent] ON [${catalog.type}.v](parent,id) INCLUDE([company]);` : `
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.code.f] ON [${catalog.type}.v](parent,isfolder,code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.description.f] ON [${catalog.type}.v](parent,isfolder,description,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.description] ON [${catalog.type}.v](description,id) INCLUDE([company]);`}
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.code] ON [${catalog.type}.v](code,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.user] ON [${catalog.type}.v]([user],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}.v.company] ON [${catalog.type}.v](company,id) INCLUDE([date]);

      GRANT SELECT ON dbo.[${catalog.type}.v] TO jetti;
      GO

      ALTER SECURITY POLICY [rls].[companyAccessPolicy]
        ADD FILTER PREDICATE [rls].[fn_companyAccessPredicate]([company]) ON [dbo].[${catalog.type}.v];
      GO

      RAISERROR('${catalog.type} complete', 0 ,1) WITH NOWAIT;
      GO
      --------------------------------------------------------------------------------------
      `;
    }

    query = `
      ${query}
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Amount] ON [Document.Operation.v](Amount,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Group] ON [Document.Operation.v]([Group],id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.Operation] ON [Document.Operation.v](Operation,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.currency] ON [Document.Operation.v](currency,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f1] ON [Document.Operation.v](f1,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f2] ON [Document.Operation.v](f2,id) INCLUDE([company]);
      CREATE UNIQUE NONCLUSTERED INDEX [Document.Operation.v.f3] ON [Document.Operation.v](f3,id) INCLUDE([company]);

`;
    return query;
  }

  static CreateDocumentIndexes() {

    let select = '';
    for (const catalog of RegisteredDocument.filter(d => d.type.includes('Catalog.'))) {
      const doc = createDocument(catalog.type);
      if (doc['QueryList']) continue;
      select += `
    DROP INDEX IF EXISTS [${catalog.type}] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='${catalog.type}')`;
    }
    for (const catalog of RegisteredDocument.filter(d => d.type.includes('Document.'))) {
      select += `
    DROP INDEX IF EXISTS [${catalog.type}] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='${catalog.type}')`;
    }
    return select;
  }

  static CreateTableRegisterAccumulationTotals() {

    const simleProperty = (prop: string, type: string) => {
      if (type.includes('.')) { return `, [${prop}]`; }

      if (type === 'number') {
        return `
        , SUM([${prop}]) [${prop}]
        , SUM([${prop}.In]) [${prop}.In]
        , SUM([${prop}.Out]) [${prop}.Out]`;
      }

      if (type === 'string') { return `, [${prop}]`; }
    };

    let query = '';
    for (const register of RegisteredRegisterAccumulation) {
      const doc = createRegisterAccumulation({ type: register.type });
      const props = doc.Props();
      let select = ''; let groupBy = '';
      for (const prop in excludeRegisterAccumulatioProps(doc)) {
        const dimension = !!props[prop].dimension;
        const resource = !!props[prop].resource;
        const type = props[prop].type || 'string';
        const field = simleProperty(prop, type) || '';
        if (dimension) groupBy += field;
        else if (resource) select += field;
      }

      query += `\n
      CREATE OR ALTER VIEW [dbo].[${register.type}.Totals]
      WITH SCHEMABINDING
      AS
        SELECT [company], [date]${groupBy}
        ${select}
	      , COUNT_BIG(*) AS COUNT
      FROM [dbo].[${register.type}]
      GROUP BY [company], [date]${groupBy}
      GO
      CREATE UNIQUE CLUSTERED INDEX [ci${register.type}.Totals] ON [dbo].[${register.type}.Totals]
      ([company], [date] ${groupBy})
      GO
      GRANT SELECT ON [dbo].[${register.type}.Totals] TO jetti;
      GO`;
    }

    return query;
  }

  static RegisterAccumulationClusteredTable(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') {
        return `
        , [${prop}] BIT N'$.${prop}'`;
      }
      if (type === 'number') {
        return `
        , [${prop}] MONEY N'$.${prop}'`;
      }
      if (type === 'date') {
        return `
        , [${prop}] DATE N'$.${prop}'`;
      }
      if (type === 'datetime') {
        return `
        , [${prop}] DATETIME N'$.${prop}'`;
      }
      return `
        , [${prop}] NVARCHAR(250) N'$.${prop}'`;
    };

    const complexProperty = (prop: string, type: string) => `
        , [${prop}] CHAR(36) N'$.${prop}'`;

    let insert = ''; let select = ''; let fields = ''; let columns = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
      const type: string = doc[prop].type || 'string';
      columns += `, [${prop}]`;
      if (type === 'number') fields += `
      , d.[${prop}] * IIF(r.kind = 1, 1, -1) [${prop}], d.[${prop}] * IIF(r.kind = 1, 1, null) [${prop}.In], d.[${prop}] * IIF(r.kind = 1, null, 1) [${prop}.Out]`;
      else fields += `, [${prop}]`;

      insert += `
        , "${prop}"`;
      if (type === 'number') {
        insert += `
        , "${prop}.In"
        , "${prop}.Out"`;
      }

      if (type.includes('.')) {
        select += complexProperty(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
    RAISERROR('${type} start', 0 ,1) WITH NOWAIT;
    GO

    DROP TABLE IF EXISTS [${type}];
    SELECT
      r.id, r.parent, CAST(r.date AS DATE) date, CAST(r.document AS CHAR(36)) document, CAST(r.company AS CHAR(36)) company, r.kind, r.calculated,
      d.exchangeRate${fields}
    INTO [${type}]
    FROM [Accumulation] r
    CROSS APPLY OPENJSON (data, N'$')
    WITH (
      exchangeRate NUMERIC(15,10) N'$.exchangeRate'${select}
    ) AS d
    WHERE r.type = N'${type}';
    GO

    CREATE OR ALTER TRIGGER [${type}.t] ON [Accumulation] AFTER INSERT, UPDATE, DELETE
    AS
    BEGIN
      SET NOCOUNT ON;
      DELETE FROM [${type}] WHERE id IN (SELECT id FROM deleted);
      INSERT INTO [${type}]
      SELECT
        r.id, r.parent, r.date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate${fields}
        FROM inserted r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'${select}
        ) AS d
        WHERE r.type = N'${type}';
    END
    GO

    GRANT SELECT,INSERT,DELETE ON [${type}] TO JETTI;
    GO

    CREATE NONCLUSTERED COLUMNSTORE INDEX [${type}] ON [${type}] (
      id, parent, date, document, company, kind, calculated, exchangeRate${columns}) WITH (MAXDOP=4);
    ALTER TABLE [${type}] ADD CONSTRAINT [PK_${type}] PRIMARY KEY NONCLUSTERED (id) WITH (MAXDOP=4);

    RAISERROR('${type} finish', 0 ,1) WITH NOWAIT;
    GO
    `;
    return query;
  }

  static RegisterAccumulationClusteredTables() {
    let query = '';
    for (const type of RegisteredRegisterAccumulation) {
      const register = createRegisterAccumulation({ type: type.type });
      query += SQLGenegatorMetadata.RegisterAccumulationClusteredTable(register.Props(), register.Prop().type.toString());
    }
    query = `
    DROP INDEX IF EXISTS [Documents.parent] ON [dbo].[Documents];
    CREATE UNIQUE NONCLUSTERED INDEX [Documents.parent] ON [dbo].[Documents]([parent], [id]);

    ${query}
    `;
    return query;
  }


  static RegisterAccumulationViewQuery(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') {
        return `
        , [${prop}] BIT N'$.${prop}'`;
      }
      if (type === 'number') {
        return `
        , [${prop}] MONEY N'$.${prop}'`;
      }
      if (type === 'date') {
        return `
        , [${prop}] DATE N'$.${prop}'`;
      }
      if (type === 'datetime') {
        return `
        , [${prop}] DATETIME N'$.${prop}'`;
      }
      return `
        , [${prop}] NVARCHAR(250) N'$.${prop}'`;
    };

    const complexProperty = (prop: string, type: string) => `
        , [${prop}] UNIQUEIDENTIFIER N'$.${prop}'`;

    let insert = ''; let select = ''; let fields = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
      const type: string = doc[prop].type || 'string';
      if (type === 'number') fields += `
      , d.[${prop}] * IIF(r.kind = 1, 1, -1) [${prop}], d.[${prop}] * IIF(r.kind = 1, 1, null) [${prop}.In], d.[${prop}] * IIF(r.kind = 1, null, 1) [${prop}.Out]`;
      else fields += ', ' + prop;

      insert += `
        , "${prop}"`;
      if (type === 'number') {
        insert += `
        , "${prop}.In"
        , "${prop}.Out"`;
      }

      if (type.includes('.')) {
        select += complexProperty(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
    CREATE OR ALTER VIEW [${type}]
    AS
      SELECT
        r.id, r.owner, r.parent, CAST(r.date AS DATE) date, r.document, r.company, r.kind, r.calculated,
        d.exchangeRate${fields}
        FROM [dbo].Accumulation r
        CROSS APPLY OPENJSON (data, N'$')
        WITH (
          exchangeRate NUMERIC(15,10) N'$.exchangeRate'${select}
        ) AS d
        WHERE r.type = N'${type}';
    GO

    GRANT SELECT,DELETE ON [${type}] TO JETTI;
    GO
    `;
    return query;
  }

  static RegisterAccumulationView() {
    let query = '';
    for (const type of RegisteredRegisterAccumulation) {
      const register = createRegisterAccumulation({ type: type.type });
      query += SQLGenegatorMetadata.RegisterAccumulationViewQuery(register.Props(), register.Prop().type.toString());
    }
    query = `
    ${query}
    `;
    return query;
  }

}
