import { DocumentOptions } from '../models/document';
import { createDocument, RegisteredDocument } from '../models/documents.factory';
import { createRegisterAccumulation, RegisteredRegisterAccumulation } from '../models/Registers/Accumulation/factory';
import { createRegisterInfo, RegisteredRegisterInfo } from '../models/Registers/Info/factory';
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
        , CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) * IIF(kind = 1, 1, -1) "${prop}"
        , CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) * IIF(kind = 1, 1, NULL) "${prop}.In"
        , CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) * IIF(kind = 1, NULL, 1) "${prop}.Out" \n`;
      }
      return `, JSON_VALUE(data, '$.${prop}') "${prop}" \n`;
    };

    const complexProperty = (prop: string, type: string) => `
        , CAST(JSON_VALUE(data, N'$."${prop}"') AS UNIQUEIDENTIFIER) "${prop}"`;

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
      INSERT INTO "${type}" (DT, date, document, company, kind ${insert})
        SELECT
          DATEDIFF_BIG(MICROSECOND, '00010101', [date]) +
          CONVERT(BIGINT, CONVERT (VARBINARY(8), document, 1)) % 10000000 +
          ROW_NUMBER() OVER (PARTITION BY [document] ORDER BY date ASC) DT,
        CAST(date AS datetime) date, document, company, kind ${select}
      FROM INSERTED WHERE type = N'${type}'; \n`;
    return query;
  } // AT TIME ZONE @TimeZone

  static QueryTriggerRegisterInfo(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') { return `\n, ISNULL(JSON_VALUE(data, N'$.${prop}'), 0) "${prop}"`; }
      if (type === 'number') { return `\n, CAST(JSON_VALUE(data, N'$.${prop}') AS MONEY) "${prop}"`; }
      return `\n, JSON_VALUE(data, '$.${prop}') "${prop}"`;
    };

    const complexProperty = (prop: string, type: string) => `\n, CAST(JSON_VALUE(data, N'$."${prop}"') AS UNIQUEIDENTIFIER) "${prop}"`;

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

  static AlterTriggerRegisterAccumulation() {
    let query = '';
    for (const type of RegisteredRegisterAccumulation) {
      const register = createRegisterAccumulation(type.type, true, {});
      query += SQLGenegatorMetadata.QueryTriggerRegisterAccumulation(register.Props(), register.Prop().type.toString());
    }

    query = `
      ALTER TRIGGER "Accumulation.Insert" ON dbo."Accumulation"
      FOR INSERT AS
      BEGIN
        DECLARE @TimeZone NVARCHAR(150);
        DECLARE @company UNIQUEIDENTIFIER;

        SELECT @company = ins.company FROM INSERTED ins;

        SET @TimeZone =
          ISNULL(
            (SELECT CAST(JSON_VALUE(doc, N'$.timeZone') AS NVARCHAR(150))
            FROM Documents WHERE type = 'Catalog.Company' AND id = @company),
          'UTC');

        ${query}
      END;`;
    return query;
  }

  static AlterTriggerRegisterInfo() {
    let query = '';
    for (const type of RegisteredRegisterInfo) {
      const register = createRegisterInfo(type.type, {});
      query += SQLGenegatorMetadata.QueryTriggerRegisterInfo(register.Props(), register.Prop().type.toString());
    }

    query = `
      ALTER TRIGGER "Register.Info.Insert" ON dbo."Register.Info"
      FOR INSERT AS
      BEGIN
        ${query}
      END;`;
    return query;
  }

  static CreateTableRegisterAccumulation() {

    const simleProperty = (prop: string, type: string, required: boolean) => {
      const nullText = required ? ' NOT NULL ' : ' NULL ';
      if (type.includes('.')) { return `, "${prop}" UNIQUEIDENTIFIER ${nullText} \n`; }
      if (type === 'boolean') { return `, "${prop}" BIT ${nullText} \n`; }
      if (type === 'date') { return `, "${prop}" DATE ${nullText} \n`; }
      if (type === 'datetime') { return `, "${prop}" DATE ${nullText} \n`; }

      if (type === 'number') {
        return `
        , "${prop}" MONEY ${nullText}
        , "${prop}.In" MONEY ${nullText}
        , "${prop}.Out" MONEY ${nullText} \n`;
      }

      return `, "${prop}" NVARCHAR(150) \n ${nullText}`;
    };

    let query = '';
    for (const register of RegisteredRegisterAccumulation) {
      const doc = createRegisterAccumulation(register.type, true, {});
      const props = doc.Props();
      let select = '';
      for (const prop in excludeRegisterAccumulatioProps(doc)) {
        select += simleProperty(prop, (props[prop].type || 'string'), !!props[prop].required);
      }

      query += `\n
      DROP TABLE "${register.type}";
      CREATE TABLE "${register.type}" (
        [kind] [bit] NOT NULL,
        [company] [uniqueidentifier] NOT NULL,
        [document] [uniqueidentifier] NOT NULL,
        [date] [date] NOT NULL,
        DT BIGINT NOT NULL
        ${select}
      );
      CREATE CLUSTERED COLUMNSTORE INDEX "cci.${register.type}" ON "${register.type}";
      GRANT SELECT ON "${register.type}" TO jetti;\n`;
    }
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
    for (const register of RegisteredRegisterInfo) {
      const doc = createRegisterInfo(register.type, {});
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
      const name = type.length === 1 ? type[0] : type[type.length - 1];
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
