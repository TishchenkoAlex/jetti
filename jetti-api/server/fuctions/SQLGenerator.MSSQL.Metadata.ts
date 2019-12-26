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
      if (type === 'boolean') { return `
        , ISNULL(CAST(JSON_VALUE(data, N'$.${prop}') AS BIT), 0) "${prop}"`; }
      if (type === 'number') {
        return `
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) * IIF(kind = 1, 1, -1) AS MONEY), 0) "${prop}"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) * IIF(kind = 1, 1, 0) AS MONEY), 0) "${prop}.In"
        , ISNULL(CAST(CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) * IIF(kind = 1, 0, 1) AS MONEY), 0) "${prop}.Out"`;
      }
      if (type === 'date') { return `
        , ISNULL(CONVERT(DATE,JSON_VALUE(data, N'$.${prop}'),127), CONVERT(DATE, '1970-01-01', 102)) "${prop}"`; }
      if (type === 'datetime') { return `
        , ISNULL(CONVERT(DATETIME,JSON_VALUE(data, N'$.${prop}'),127), CONVERT(DATETIME, '1970-01-01', 102)) "${prop}"`; }
      return `
        , ISNULL(JSON_VALUE(data, '$.${prop}'), '') "${prop}" \n`;
    };

    const complexProperty = (prop: string, type: string) => `
        , ISNULL(CAST(JSON_VALUE(data, N'$."${prop}"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "${prop}"`;

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
    CREATE OR ALTER VIEW [${type}]
    WITH SCHEMABINDING
    AS
    SELECT
      id, ISNULL(parent, '00000000-0000-0000-0000-000000000000') parent, date, document, company, kind, calculated
        , ISNULL(CAST(JSON_VALUE(data, N'$.exchangeRate') AS NUMERIC(15,10)), 1) exchangeRate${select}
      FROM dbo.[Accumulation] WHERE type = N'${type}';
    GO
    GRANT SELECT,DELETE ON [${type}] TO JETTI;
    GO
    CREATE UNIQUE CLUSTERED INDEX [${type}] ON [dbo].[${type}](
      date,company,calculated,id
    )
    GO
    `;
    return query;
  }

  static CreateRegisterAccumulationView() {
    let query = '';
    for (const type of RegisteredRegisterAccumulation) {
      const register = createRegisterAccumulation({ type: type.type });
      query += SQLGenegatorMetadata.QueryRegisterAccumulationView(register.Props(), register.Prop().type.toString());
    }
    return query;
  }

  static QueryRegisterIntoView(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') { return `
        , ISNULL(CAST(JSON_VALUE(data, N'$.${prop}') AS BIT), 0) "${prop}"`; }
      if (type === 'number') {
        return `
        , ISNULL(CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY), 0) "${prop}"`;
      }
      if (type === 'date') { return `
        , ISNULL(CONVERT(DATE,JSON_VALUE(data, N'$.${prop}'),127), CONVERT(DATE, '1970-01-01', 102)) "${prop}"`; }
      if (type === 'datetime') { return `
        , ISNULL(CONVERT(DATETIME,JSON_VALUE(data, N'$.${prop}'),127), CONVERT(DATETIME, '1970-01-01', 102)) "${prop}"`; }
      return `
        , ISNULL(JSON_VALUE(data, '$.${prop}'), '') "${prop}"`;
    };

    const complexProperty = (prop: string, type: string) => `
        , ISNULL(CAST(JSON_VALUE(data, N'$."${prop}"') AS UNIQUEIDENTIFIER), '00000000-0000-0000-0000-000000000000') "${prop}"`;

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
      date,company,id
    )
    GO
    `;
    return query;
  }

  static CreateRegisterInfoView() {
    let query = '';
    for (const type of GetRegisterInfo()) {
      const register = createRegisterInfo({ type: type.type });
      query += SQLGenegatorMetadata.QueryRegisterIntoView(register.Props(), register.Prop().type.toString());
    }
    return query;
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

  static CreateViewCatalogs() {

    let query = '';
    for (const catalog of RegisteredDocument) {
      const doc = createDocument(catalog.type);
      if (doc['QueryList']) continue;
      let select = SQLGenegator.QueryList(doc.Props(), doc.type);
      const type = (doc.Prop() as DocumentOptions).type.split('.');
      let name = '';
      for (let i = 1; i < type.length; i++) name += type[i];
      select = select.replace('FROM dbo\.\"Documents\" d', `
      , ISNULL(l5.description, d.description) [${name}.Level5]
      , ISNULL(l4.description, ISNULL(l5.description, d.description)) [${name}.Level4]
      , ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))) [${name}.Level3]
      , ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description)))) [${name}.Level2]
      , ISNULL(l1.description, ISNULL(l2.description, ISNULL(l3.description, ISNULL(l4.description, ISNULL(l5.description, d.description))))) [${name}.Level1]
      FROM dbo.Documents d
        LEFT JOIN  dbo.Documents l5 ON (l5.id = d.parent)
        LEFT JOIN  dbo.Documents l4 ON (l4.id = l5.parent)
        LEFT JOIN  dbo.Documents l3 ON (l3.id = l4.parent)
        LEFT JOIN  dbo.Documents l2 ON (l2.id = l3.parent)
        LEFT JOIN  dbo.Documents l1 ON (l1.id = l2.parent)
      `).replace('d.description,', `d.description "${name}",`);

      query += `\n
      CREATE OR ALTER VIEW dbo.[${catalog.type}] WITH SCHEMABINDING AS
        ${select}
      GO
      GRANT SELECT ON dbo.[${catalog.type}] TO jetti;
      GO
      `;
    }
    query = `
    CREATE OR ALTER VIEW [dbo].[Catalog.Documents] WITH SCHEMABINDING AS
    SELECT
      'https://x100-jetti.web.app/' + d.type + '/' + CAST(d.id as varchar(36)) as link,
      d.id, d.date [date],
      d.description Presentation
      FROM dbo.[Documents] d
    GO
    GRANT SELECT ON [dbo].[Catalog.Documents] TO jetti;
    GO

    ${query}
    `;
    return query;
  }

  static CreateDocumentIndexes() {

    let select = '';
    for (const catalog of RegisteredDocument.filter(d => d.type.includes('Catalog.') )) {
      const doc = createDocument(catalog.type);
      if (doc['QueryList']) continue;
      select += `
    DROP INDEX IF EXISTS [${catalog.type}] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}]
    ON [dbo].[Documents]([description],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[date],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='${catalog.type}')`;
    }
    for (const catalog of RegisteredDocument.filter(d => d.type.includes('Document.') )) {
      select += `
    DROP INDEX IF EXISTS [${catalog.type}] ON Documents;
    CREATE UNIQUE NONCLUSTERED INDEX [${catalog.type}]
    ON [dbo].[Documents]([date],[id],[parent])
    INCLUDE([posted],[deleted],[isfolder],[description],[code],[doc],[user],[info],[timestamp],[ExchangeCode],[ExchangeBase],[type],[company])
    WHERE ([type]='${catalog.type}')`;
    }
    return select;
  }
}
