import { DocumentOptions, Props } from '../models/document';
import { createDocument, RegisteredDocument } from '../models/documents.factory';
import { createRegisterAccumulation, RegisterAccumulationTypes, RegisteredRegisterAccumulation } from '../models/Registers/Accumulation/factory';
import { createRegisterInfo, GetRegisterInfo } from '../models/Registers/Info/factory';
import { excludeRegisterAccumulatioProps, excludeRegisterInfoProps, SQLGenegator } from './SQLGenerator.MSSQL';

// tslint:disable:max-line-length
// tslint:disable:no-shadowed-variable
// tslint:disable:forin

export class SQLGenegatorMetadata {

  static QueryTriggerRegisterAccumulation(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') { return `, ISNULL(JSON_VALUE(data, N'$.${prop}'), 0) "${prop}" \n`; }
      if (type === 'number') {
        return `
        , CAST(ISNULL(JSON_VALUE(data, N'$.${prop}'), 0) AS MONEY) * IIF(kind = 1, 1, -1) "${prop}"
        , CAST(ISNULL(JSON_VALUE(data, N'$.${prop}'), 0) AS MONEY) * IIF(kind = 1, 1, 0) "${prop}.In"
        , CAST(ISNULL(JSON_VALUE(data, N'$.${prop}'), 0) AS MONEY) * IIF(kind = 1, 0, 1) "${prop}.Out" \n`;
      }
      if (type === 'date') { return `
        , ISNULL(JSON_VALUE(data, N'$.${prop}'), '${new Date('1970-01-01').toJSON()}') "${prop}" \n`; }
      if (type === 'datetime') { return `
        , ISNULL(JSON_VALUE(data, N'$.${prop}'), '${new Date('1970-01-01Z00:00:00:000').toJSON()}') "${prop}" \n`; }
      return `
        , ISNULL(JSON_VALUE(data, '$.${prop}'), '') "${prop}" \n`;
    };

    const complexProperty = (prop: string, type: string) => `
        , CAST(ISNULL(JSON_VALUE(data, N'$."${prop}"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "${prop}"\n`;

    let insert = ''; let select = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
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
    CREATE OR ALTER TRIGGER [Accumulation->${type}] ON [dbo].[Accumulation]
    AFTER INSERT AS
    BEGIN
      INSERT INTO [${type}] (DT, id, parent, date, document, company, kind, calculated, exchangeRate${insert})
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
            CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
            ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
          id, parent, CAST(date AS datetime) date, document, company, kind, calculated
        , CAST(ISNULL(JSON_VALUE(data, N'$.exchangeRate'), 1) AS FLOAT) exchangeRate\n ${select}
      FROM INSERTED WHERE type = N'${type}'
    END
    GO

    CREATE OR ALTER TRIGGER [dbo].[Accumulation<-${type}] ON [dbo].[Accumulation]
    AFTER DELETE AS
    BEGIN
      IF (ROWCOUNT_BIG() = 0) RETURN;
	    DELETE FROM [dbo].[${type}] WHERE id IN (SELECT id from deleted WHERE type = '${type}');
    END
    GO\n\n`;
    return query;
  }

  static AlterTriggerRegisterAccumulation() {
    let query = '';
    for (const type of RegisteredRegisterAccumulation) {
      const register = createRegisterAccumulation({ type: type.type });
      query += SQLGenegatorMetadata.QueryTriggerRegisterAccumulation(register.Props(), register.Prop().type.toString());
    }
    return query;
  }

  static QueryTriggerRegisterInfo(doc: { [x: string]: any }, type: RegisterAccumulationTypes) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') { return `\n, ISNULL(JSON_VALUE(data, N'$.${prop}'), 0) "${prop}"`; }
      if (type === 'number') { return `\n, CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) "${prop}"`; }
      if (type === 'date') { return `, ISNULL(JSON_VALUE(data, N'$.${prop}'), '${new Date('1970-01-01').toJSON()}') "${prop}" \n`; }
      if (type === 'datetime') { return `, ISNULL(JSON_VALUE(data, N'$.${prop}'), '${new Date('1970-01-01Z00:00:00:000').toJSON()}') "${prop}" \n`; }
      return `, ISNULL(JSON_VALUE(data, '$.${prop}'), '') "${prop}" \n`;
    };

    const complexProperty = (prop: string, type: string) => `
        , CAST(ISNULL(JSON_VALUE(data, N'$."${prop}"'), '00000000-0000-0000-0000-000000000000') AS UNIQUEIDENTIFIER) "${prop}"\n`;

    let insert = ''; let select = '';
    for (const prop in excludeRegisterInfoProps(doc)) {
      const type: string = doc[prop].type || 'string';
      insert += `, "${prop}"`;

      if (type.includes('.')) {
        select += complexProperty(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
      INSERT INTO "${type}" (date, document, company ${insert})
      SELECT
        CAST(date AS datetime) date, document, company ${select}
      FROM INSERTED WHERE type = N'${type}'; \n\n`;
    return query;
  }

  static AlterTriggerRegisterInfo() {
    let query = '';
    for (const type of GetRegisterInfo()) {
      const register = createRegisterInfo({ type: type.type });
      query += SQLGenegatorMetadata.QueryTriggerRegisterInfo(register.Props(), register.Prop().type.toString() as RegisterAccumulationTypes);
    }

    query = `
      ALTER TRIGGER "Register.Info.Insert" ON dbo."Register.Info"
      FOR INSERT AS
      BEGIN
        ${query}
      END;`;
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
      GO`;
    }

    return query;
  }

  static CreateTableRegisterAccumulation() {

    const simleProperty = (prop: string, type: string, required: boolean, defailts: string) => {
      let nullText = required ? 'NOT NULL' : 'NOT NULL';
      if (defailts) nullText = `${nullText} DEFAULT ${defailts}`;
      if (type.includes('.')) {
        return `
        , "${prop}" UNIQUEIDENTIFIER ${nullText} \n`;
      }
      if (type === 'boolean') {
        return `
        , "${prop}" BIT ${nullText} \n`;
      }
      if (type === 'date') {
        return `
        , "${prop}" DATE ${nullText} \n`;
      }
      if (type === 'datetime') {
        return `
        , "${prop}" DATE ${nullText} \n`;
      }
      if (type === 'number') {
        return `
        , "${prop}" MONEY ${nullText}
        , "${prop}.In" MONEY ${nullText}
        , "${prop}.Out" MONEY ${nullText} \n`;
      }
      return `
        , "${prop}" NVARCHAR(150) ${nullText} \n`;
    };

    let query = '';
    for (const register of RegisteredRegisterAccumulation) {
      const doc = createRegisterAccumulation({ type: register.type });
      const props = doc.Props();
      let select = '';
      for (const prop in excludeRegisterAccumulatioProps(doc)) {
        select += simleProperty(prop, (props[prop].type || 'string'), !!props[prop].required, props[prop].value);
      }

      query += `\n
      DROP VIEW IF EXISTS "${register.type}.Totals";
      DROP TABLE IF EXISTS "${register.type}";
      CREATE TABLE "${register.type}" (
        [kind] [bit] NOT NULL,
        [id] [uniqueidentifier] PRIMARY KEY NONCLUSTERED DEFAULT NEWID(),
        [calculated] [bit] NOT NULL DEFAULT 0,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        [DT] [BIGINT] NOT NULL,
        [parent] [uniqueidentifier] NULL,
        [exchangeRate] [float] NOT NULL DEFAULT 1
        ${select}
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.${register.type}" ON "${register.type}";
      GRANT SELECT ON "${register.type}" TO jetti;\n`;
    }

    query = `
      DROP TABLE IF EXISTS [Accumulation.Copy];
      SELECT * INTO [Accumulation.Copy] FROM [Accumulation];
      BEGIN TRANSACTION
      BEGIN TRY
      TRUNCATE TABLE [Accumulation];
      ${query}

      END TRY
      BEGIN CATCH
        IF @@TRANCOUNT > 0
          ROLLBACK TRANSACTION;
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
      END CATCH;
      IF @@TRANCOUNT > 0
        COMMIT TRANSACTION;
      GO
      ${this.AlterTriggerRegisterAccumulation()}
      GO

      INSERT INTO [Accumulation] SELECT * FROM [Accumulation.COPY];
    `;
    return query;
  }

  static CreateTableRegisterInfo() {

    const simleProperty = (prop: string, type: string, required: boolean) => {
      const nullText = required ? ' NOT NULL ' : ' NULL ';
      if (type.includes('.')) { return `, "${prop}" UNIQUEIDENTIFIER ${nullText} \n`; }
      if (type === 'boolean') { return `, "${prop}" BIT ${nullText} \n`; }
      if (type === 'date') { return `, "${prop}" DATE ${nullText} \n`; }
      if (type === 'datetime') { return `, "${prop}" DATE ${nullText} \n`; }
      if (type === 'number') { return `, "${prop}" MONEY ${nullText}\n`; }
      return `, "${prop}" NVARCHAR(150) \n ${nullText}`;
    };

    let query = '';
    for (const register of GetRegisterInfo()) {
      const doc = createRegisterInfo({ type: register.type });
      const props = doc.Props();
      let select = '';
      for (const prop in excludeRegisterInfoProps(doc)) {
        select += simleProperty(prop, (props[prop].type || 'string'), !!props[prop].required);
      }

      query += `\n
      DROP TABLE "${register.type}";
      CREATE TABLE "${register.type}" (
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL
        ${select}
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.${register.type}" ON "${register.type}";
      GRANT SELECT ON "${register.type}" TO jetti;\n`;
    }
    return query;
  }

  static CreateViewCatalogs() {

    let query = '';
    for (const catalog of RegisteredDocument) {
      const doc = createDocument(catalog.type);
      let select = SQLGenegator.QueryList(doc.Props(), doc.type);
      const type = (doc.Prop() as DocumentOptions).type.split('.');
      let name = '';
      for (let i = 1; i < type.length; i++) name += type[i];
      select = select.replace('FROM dbo\.\"Documents\" d', `

      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description ) as "${name}.Level4"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)) "${name}.Level3"
      ,COALESCE(
        (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
          (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent]))),
        COALESCE(
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id =
            (SELECT [parent] from [dbo].[Documents] where [dbo].[Documents].id = d.[parent])),
          COALESCE(
            (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description))) "${name}.Level2"
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
          (SELECT description from [dbo].[Documents] where [dbo].[Documents].id = d.[parent] ), d.description)))) as "${name}.Level1"
      FROM dbo."Documents" d\n`).replace('d.description,', `d.description "${name}",`);

      query += `\n
      CREATE OR ALTER VIEW dbo."${catalog.type}" WITH SCHEMABINDING AS
        ${select}
      GO`;
    }
    return query;
  }
}
