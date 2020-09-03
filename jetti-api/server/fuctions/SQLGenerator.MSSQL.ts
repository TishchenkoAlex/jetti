import { AllTypes } from '../models/documents.types';

// tslint:disable:max-line-length
// tslint:disable:no-shadowed-variable
// tslint:disable:forin

export class SQLGenegator {

  static QueryObject(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') return `, ISNULL(CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS BIT), 0) "${prop}"\n`;
      if (type === 'number') return `, CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS MONEY) "${prop}"\n`;
      if (type === 'javascript') return `, (SELECT "${prop}" FROM OPENJSON(d.doc) WITH ("${prop}" NVARCHAR(MAX) '$."${prop}"')) "${prop}"\n`;
      return `, JSON_VALUE(d.doc, N'$."${prop}"') "${prop}"\n`;
    };

    const complexProperty = (prop: string, type: string) =>
      type.startsWith('Types.') ?
        `,  JSON_QUERY(CASE WHEN "${prop}".id IS NULL THEN JSON_QUERY(d.doc, N'$.${prop}')
              ELSE (SELECT "${prop}".id "id", "${prop}".description "value",
                ISNULL("${prop}".type, '${type}') "type", "${prop}".code "code" FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END, '$') "${prop}"\n` :
        `, "${prop}".id "${prop}.id", "${prop}".description "${prop}.value", '${type}' "${prop}.type", "${prop}".code "${prop}.code"\n`;

    const addLeftJoin = (prop: string, type: string) =>
      ` LEFT JOIN "Documents" "${prop}" ON "${prop}".id = CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS UNIQUEIDENTIFIER)\n`;

    const tableProperty = (prop: string, value: any) => {

      const simleProperty = (prop: string, type: string) => {
        if (type === 'boolean') return `, ISNULL(x."${prop}", 0) "${prop}"\n`;
        if (type === 'number') return `, ISNULL(x."${prop}", 0)  "${prop}"\n`;
        return `, x."${prop}"\n`;
      };

      const complexProperty = (prop: string, type: AllTypes) =>
        checkComlexType(type) ?
          `, x."${prop}" "${prop}.id", x."${prop}" "${prop}.value", '${type}' "${prop}.type", x."${prop}" "${prop}.code"\n` :
          type.startsWith('Types.') ?
            `,  JSON_QUERY(CASE WHEN "${prop}".id IS NULL THEN JSON_QUERY(d.doc, N'$.${prop}')
              ELSE (SELECT "${prop}".id "id", "${prop}".description "value",
                ISNULL("${prop}".type, '${type}') "type", "${prop}".code "code" FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END, '$') "${prop}"\n` :
            `, "${prop}".id "${prop}.id", "${prop}".description "${prop}.value", '${type}' "${prop}.type", "${prop}".code "${prop}.code"\n`;

      const addLeftJoin = (prop: string, type: AllTypes) =>
        checkComlexType(type) ?
          `\n` :
          ` LEFT JOIN "Documents" "${prop}" ON "${prop}".id = x."${prop}"\n`;

      function xTableLine(prop: string, type: string) {
        switch (type) {
          case 'number': return `, "${prop}" MONEY\n`;
          case 'boolean': return `, "${prop}" BIT\n`;
          case 'date': return `, "${prop}" DATE\n`;
          case 'datetime': return `, "${prop}" DATETIME\n`;
          default: return `, "${prop}" NVARCHAR(max)\n`;
        }
      }

      let query = ''; let LeftJoin = ''; let xTable = '';
      for (const prop in value) {
        const type: AllTypes = value[prop].type || 'string';
        if (type.includes('.')) {
          query += complexProperty(prop, type);
          LeftJoin += addLeftJoin(prop, type);
          xTable += `, "${prop}" ${checkComlexType(type) ? 'VARCHAR(36)' : 'UNIQUEIDENTIFIER'}\n`;
        } else {
          query += simleProperty(prop, type);
          xTable += xTableLine(prop, type);
        }
      }
      query = query.slice(2); xTable = xTable.slice(2);

      return `,
        ISNULL(
          (SELECT x.[index], ${query} FROM (
            SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) - 1 AS "index", *
          FROM OPENJSON(d.doc, N'$."${prop}"') WITH (
            ${xTable})
          ) x
          ${LeftJoin}
          ORDER BY x.[index]
          FOR JSON PATH, INCLUDE_NULL_VALUES
        ), '[]') "${prop}"\n`;
    };

    let query = `
      SELECT d.id, d.type, d.date, d.code, d.description, d.posted, d.deleted, d.isfolder, d.info, d.timestamp,

      "company".id "company.id",
      "company".description "company.value",
      "company".code "company.code",
      'Catalog.Company' "company.type",

      "user".id "user.id",
      "user".description "user.value",
      "user".code "user.code",
      'Catalog.User' "user.type",

      "parent".id "parent.id",
      "parent".description "parent.value",
      "parent".code "parent.code",
      ISNULL("parent".type, 'Types.Document') "parent.type"\n`;

    let LeftJoin = '';

    for (const prop in excludeProps(doc)) {
      const type: string = doc[prop].type || 'string';
      if (type.includes('.')) {
        query += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else if (type === 'table') {
        query += tableProperty(prop, (<any>doc[prop])[prop]);
      } else {
        query += simleProperty(prop, type);
      }
    }

    query += `
      FROM "Documents" d
      LEFT JOIN "Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN "Documents" "user" ON "user".id = d."user"
      LEFT JOIN "Documents" "company" ON "company".id = d.company
      ${LeftJoin}
      WHERE d.type = '${type}' `;
    return query;
  }

  static QueryObjectFromJSON(schema: { [x: string]: any }) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') { return `, ISNULL(CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS BIT), 0) "${prop}"\n`; }
      if (type === 'number') { return `,  CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS MONEY) "${prop}"\n`; }
      if (type === 'javascript') return `, (SELECT "${prop}" FROM OPENJSON(d.doc) WITH ("${prop}" NVARCHAR(MAX) '$."${prop}"')) "${prop}"\n`;
      return `, JSON_VALUE(d.doc, N'$."${prop}"') "${prop}"\n`;
    };

    const complexProperty = (prop: string, type: string) =>
      type.startsWith('Types.') ?
        `,  JSON_QUERY(CASE WHEN "${prop}".id IS NULL THEN JSON_QUERY(d.doc, N'$.${prop}')
              ELSE (SELECT "${prop}".id "id", "${prop}".description "value",
                ISNULL("${prop}".type, '${type}') "type", "${prop}".code "code" FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END, '$') "${prop}"\n` :
        `, "${prop}".id "${prop}.id", "${prop}".description "${prop}.value", '${type}' "${prop}.type", "${prop}".code "${prop}.code"\n`;

    const addLeftJoin = (prop: string, type: string) =>
      ` LEFT JOIN "Documents" "${prop}" ON "${prop}".id = CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS UNIQUEIDENTIFIER)\n`;

    const tableProperty = (prop: string, value: any) => {

      const simleProperty = (prop: string, type: string) => {
        if (type === 'boolean') { return `, ISNULL(x."${prop}", 0) "${prop}"\n`; }
        if (type === 'number') { return `, x."${prop}"  "${prop}"\n`; }
        return `, x."${prop}"\n`;
      };

      const complexProperty = (prop: string, type: AllTypes) =>
        checkComlexType(type) ?
          `, x."${prop}" "${prop}.id", x."${prop}" "${prop}.value", '${type}' "${prop}.type", x."${prop}" "${prop}.code"\n` :
          type.startsWith('Types.') ?
            `,  JSON_QUERY(CASE WHEN "${prop}".id IS NULL THEN JSON_QUERY(d.doc, N'$.${prop}')
              ELSE (SELECT "${prop}".id "id", "${prop}".description "value",
                ISNULL("${prop}".type, '${type}') "type", "${prop}".code "code" FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) END, '$') "${prop}"\n` :
            `, "${prop}".id "${prop}.id", "${prop}".description "${prop}.value", '${type}' "${prop}.type", "${prop}".code "${prop}.code"\n`;

      const addLeftJoin = (prop: string, type: AllTypes) =>
        checkComlexType(type) ?
          `\n` :
          ` LEFT JOIN "Documents" "${prop}" ON "${prop}".id = x."${prop}"\n`;

      function xTableLine(prop: string, type: string) {
        switch (type) {
          case 'number': return `, "${prop}" MONEY\n`;
          case 'boolean': return `, "${prop}" BIT\n`;
          case 'date': return `, "${prop}" DATE\n`;
          case 'datetime': return `, "${prop}" DATETIME\n`;
          default: return `, "${prop}" NVARCHAR(max)\n`;
        }
      }

      let query = ''; let LeftJoin = ''; let xTable = '';
      for (const prop in value) {
        const type: AllTypes = value[prop].type || 'string';
        if (type.includes('.')) {
          query += complexProperty(prop, type);
          LeftJoin += addLeftJoin(prop, type);
          xTable += `, "${prop}" ${checkComlexType(type) ? 'VARCHAR(36)' : 'UNIQUEIDENTIFIER'}\n`;
        } else {
          query += simleProperty(prop, type);
          xTable += xTableLine(prop, type);
        }
      }
      query = query.slice(2); xTable = xTable.slice(2);

      return `,
      ISNULL(
        (SELECT x.[index], ${query} FROM (
          SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) - 1 AS "index", *
        FROM OPENJSON(d.doc, N'$."${prop}"') WITH (
          ${xTable})
        ) x
        ${LeftJoin}
        ORDER BY x.[index]
        FOR JSON PATH, INCLUDE_NULL_VALUES
      ), '[]') "${prop}"\n`;
    };

    let query = `
      SELECT d.id, d.type, d.date, d.code, d.description, d.posted, d.deleted, d.isfolder, d.info, d.timestamp,

      "company".id "company.id",
      "company".description "company.value",
      "company".code "company.code",
      'Catalog.Company' "company.type",

      "user".id "user.id",
      "user".description "user.value",
      "user".code "user.code",
      'Catalog.User' "user.type",

      "parent".id "parent.id",
      "parent".description "parent.value",
      "parent".code "parent.code",
      ISNULL("parent".type, 'Types.Document') "parent.type"\n`;

    let LeftJoin = '';

    for (const prop in excludeProps(schema)) {
      const type: string = schema[prop].type || 'string';
      if (type.includes('.')) {
        query += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else if (type === 'table') {
        query += tableProperty(prop, (<any>schema[prop])[prop]);
      } else {
        query += simleProperty(prop, type);
      }
    }

    query += `
      FROM (SELECT * FROM OPENJSON(@p1)
        WITH (
          [id] UNIQUEIDENTIFIER,
          [type] NVARCHAR(100),
          [date] datetime,
          [code] NVARCHAR(36),
          [description] NVARCHAR(150),
          [posted] BIT,
          [deleted] BIT,
          [isfolder] BIT,
          [info] NVARCHAR(MAX),
          [timestamp] DATETIME2(0),
          [company] UNIQUEIDENTIFIER,
          [user] UNIQUEIDENTIFIER,
          [parent] UNIQUEIDENTIFIER,
          [doc] NVARCHAR(max) N'$.doc' AS JSON
        )
      ) d
      LEFT JOIN "Documents" "parent" ON "parent".id = d."parent"
      LEFT JOIN "Documents" "user" ON "user".id = d."user"
      LEFT JOIN "Documents" "company" ON "company".id = d.company
      ${LeftJoin}\n`;
    return query;
  }

  static QueryListHierarchy(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') return `
        , ISNULL(CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS BIT), 0) "${prop}"`;
      if (type === 'number') return `
        , ISNULL(CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS NUMERIC(15,2)), 0) "${prop}"`;
      return `
        , ISNULL(JSON_VALUE(d.doc, N'$."${prop}"'), '') "${prop}"`;
    };

    const complexProperty = (prop: string, type: string) =>
      type.startsWith('Types.') ? `
        , IIF("${prop}".id IS NULL, JSON_VALUE(d.doc, N'$."${prop}".id'), "${prop}".id) "${prop}.id"
        , IIF("${prop}".id IS NULL, JSON_VALUE(d.doc, N'$."${prop}".value'), "${prop}".description) "${prop}.value"
        , IIF("${prop}".id IS NULL, JSON_VALUE(d.doc, N'$."${prop}".type'), "${prop}".type) "${prop}.type"` : `
        , ISNULL("${prop}".description, N'') "${prop}.value", ISNULL("${prop}".type, N'${type}') "${prop}.type"
        , CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS UNIQUEIDENTIFIER) "${prop}.id"`;

    const addLeftJoin = (prop: string, type: string) => `
        LEFT JOIN dbo."Documents" "${prop}" ON "${prop}".id = CAST(JSON_VALUE(d.doc, N'$."${prop}"') AS UNIQUEIDENTIFIER)`;

    let query = `
      SELECT
        d.id, d.type, d.date, d.code, d.description, d.posted, d.deleted, d.isfolder, d.timestamp
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"`;

    let LeftJoin = '';

    for (const prop in excludeProps(doc)) {
      const type = doc[prop].type || 'string';
      if (type.includes('.')) {
        query += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else if (type !== 'table') {
        query += simleProperty(prop, type);
      }
    }

    query += `
      FROM dbo."Documents" d
        LEFT JOIN dbo."Documents" "parent" ON "parent".id = d."parent"
        LEFT JOIN dbo."Documents" "user" ON "user".id = d."user"
        LEFT JOIN dbo."Documents" "company" ON "company".id = d.company${LeftJoin}
      WHERE d.[type] = '${type}' `;

    return query;
  }

  static QueryList(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      return `
        , d.[${prop}] [${prop}]`;
    };

    const complexProperty = (prop: string, type: string) => `
        , ISNULL([${prop}.v].description, '') [${prop}.value], d.[${prop}] [${prop}.id], [${prop}.v].type [${prop}.type]`;

    const addLeftJoin = (prop: string, type: string) =>
      type.startsWith('Types.') ? `
        LEFT JOIN dbo.[Documents] [${prop}.v] ON [${prop}.v].id = d.[${prop}]` : `
        LEFT JOIN dbo.[${type}.v] [${prop}.v] WITH (NOEXPAND) ON [${prop}.v].id = d.[${prop}]`;

    let query = `
      SELECT
        d.id, d.type, d.date, d.code, d.description, d.posted, d.deleted, d.isfolder, d.timestamp, d.version
        , ISNULL("parent".description, '') "parent.value", d."parent" "parent.id", "parent".type "parent.type"
        , ISNULL("company".description, '') "company.value", d."company" "company.id", "company".type "company.type"
        , ISNULL("user".description, '') "user.value", d."user" "user.id", "user".type "user.type"`;

    let LeftJoin = '';

    for (const prop in excludeProps(doc)) {
      const type = doc[prop].type || 'string';
      if (type.includes('.')) {
        query += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else if (type !== 'table') {
        query += simleProperty(prop, type);
      }
    }

    query += `
      FROM [${type}.v] d WITH (NOEXPAND)
        LEFT JOIN dbo.[Documents] [parent] ON [parent].id = d.[parent]
        LEFT JOIN dbo.[Catalog.User.v] [user] WITH (NOEXPAND) ON [user].id = d.[user]
        LEFT JOIN dbo.[Catalog.Company.v] [company] WITH (NOEXPAND) ON [company].id = d.company${LeftJoin}
    `;

    return query;
  }

  static QueryListRaw(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') return `
      , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(doc, N'$."${prop}"')), 0) [${prop}]`;
      if (type === 'number') return `
      , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(doc, N'$."${prop}"')), 0) [${prop}]`;
      if (type === 'date') return `
      , TRY_CONVERT(DATE, JSON_VALUE(doc, N'$.${prop}'),127) [${prop}]`;
      if (type === 'datetime') return `
      , TRY_CONVERT(DATETIME, JSON_VALUE(doc, N'$.${prop}'),127) [${prop}]`;
      if (type.includes('.')) return `
      , TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(doc, N'$."${prop}"')) [${prop}]`;
      return `
      , ISNULL(TRY_CONVERT(NVARCHAR(250), JSON_VALUE(doc, N'$."${prop}"')), '') [${prop}]`;
    };

    let query = ``;
    for (const prop in excludeProps(doc)) {
      const type = doc[prop].type || 'string';
      if (type !== 'table') {
        query += simleProperty(prop, type);
      }
    }

    query = `
      SELECT id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, [user], [version]${query}
      FROM dbo.[Documents]
      WHERE [type] = '${type}'
    `;

    return query;
  }

  static QueryRegisterAccumulatioList(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') return `
        , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(r.data, N'$.${prop}')), 0) [${prop}]`;
      if (type === 'number') return `
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(r.data, N'$.${prop}')), 0) [${prop}]`;
      if (type === 'date') return `
        , TRY_CONVERT(DATE, JSON_VALUE(r.data, N'$.${prop}'),127) [${prop}]`;
      if (type === 'datetime') return `
        , TRY_CONVERT(DATETIME, JSON_VALUE(r.data, N'$.${prop}'),127) [${prop}]`;
      return `
        , JSON_VALUE(r.data, N'$.${prop}') "${prop}"`;
    };

    const complexProperty = (prop: string, type: string) => `
        , [${prop}].id [${prop}.id], [${prop}].description [${prop}.value], '${type}' [${prop}.type], [${prop}].code [${prop}.code]`;

    const addLeftJoin = (prop: string, type: string) => `
      LEFT JOIN dbo.[Documents] [${prop}] ON [${prop}].id = TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(r.data, N'$.${prop}'))`;

    let LeftJoin = ''; let select = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
      const type: string = doc[prop].type || 'string';
      if (type.includes('.')) {
        select += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
      SELECT r.id, r.parent, r.date, r."kind", r.calculated,
        "company".id "company.id", "company".description "company.value", "company".code "company.code", 'Catalog.Company' "company.type"
      ${select}
      FROM dbo.[Accumulation] r
        LEFT JOIN dbo.[Documents] company ON company.id = r.company
        ${LeftJoin}
      WHERE r.type = '${type}' `;
    return query;
  }

  static QueryRegisterAccumulatioList2(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') return `
        , ISNULL(TRY_CONVERT(BIT, r.[${prop}]), 0) [${prop}]`;
      if (type === 'number') return `
        , ISNULL(TRY_CONVERT(MONEY, r.[${prop}]), 0) * IIF(kind = 1, 1, -1) [${prop}]`;
      return `
        , r.[${prop}] [${prop}]`;
    };

    const complexProperty = (prop: string, type: string) =>
      `, [${prop}].id [${prop}.id], [${prop}].description [${prop}.value], '${type}' [${prop}.type], [${prop}].code [${prop}.code]`;

    const addLeftJoin = (prop: string, type: string) => `
        LEFT JOIN dbo.[Documents] [${prop}] ON [${prop}].id = r.[${prop}]`;

    let LeftJoin = ''; let select = '';
    for (const prop in excludeRegisterAccumulatioProps(doc)) {
      const type: string = doc[prop].type || 'string';
      if (type.includes('.')) {
        select += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
      SELECT r.id, r.kind, r.date, r.parent, r.calculated, r.exchangeRate,
      "company".id "company.id", "company".description "company.value", "company".code "company.code", 'Catalog.Company' "company.type"
      ${select}
      FROM "${type}" r
        LEFT JOIN [Documents] company ON company.id = r.company
        ${LeftJoin} WHERE (1 = 1)
                                                                                    \n`;
    return query;
  }

  static QueryRegisterInfoList(doc: { [x: string]: any }, type: string) {

    const simleProperty = (prop: string, type: string) => {
      if (type === 'boolean') return `
        , ISNULL(TRY_CONVERT(BIT, JSON_VALUE(r.data, N'$.${prop}')), 0) [${prop}]`;
      if (type === 'number') return `
        , ISNULL(TRY_CONVERT(MONEY, JSON_VALUE(r.data, N'$.${prop}')), 0) [${prop}]`;
      if (type === 'date') return `
        , TRY_CONVERT(DATE, JSON_VALUE(r.data, N'$.${prop}'),127) [${prop}]`;
      if (type === 'datetime') return `
        , TRY_CONVERT(DATETIME, JSON_VALUE(r.data, N'$.${prop}'),127) [${prop}]`;
      return `
        , JSON_VALUE(r.data, N'$.${prop}') [${prop}]`;
    };

    const complexProperty = (prop: string, type: string) => `
        , [${prop}].id [${prop}.id], [${prop}].description [${prop}.value], '${type}' [${prop}.type], [${prop}].code [${prop}.code]`;

    const addLeftJoin = (prop: string, type: string) => `
      LEFT JOIN dbo.[Documents] [${prop}] ON [${prop}].id = TRY_CONVERT(UNIQUEIDENTIFIER, JSON_VALUE(r.data, N'$.${prop}'))`;

    let LeftJoin = ''; let select = '';
    for (const prop in excludeRegisterInfoProps(doc)) {
      const type: string = doc[prop].type || 'string';
      if (type.includes('.')) {
        select += complexProperty(prop, type);
        LeftJoin += addLeftJoin(prop, type);
      } else {
        select += simleProperty(prop, type);
      }
    }

    const query = `
      SELECT r.date,
      "company".id "company.id", "company".description "company.value", "company".code "company.code", 'Catalog.Company' "company.type"
      ${select}
      FROM [Register.Info] r
        LEFT JOIN [Documents] company ON company.id = r.company
        ${LeftJoin}
      WHERE r.type = '${type}' `;
    return query;
  }
}

export function buildTypesQueryList(select: { type: string; description: string; }[]) {
  let query = '';
  for (const row of select) {
    query += `SELECT
      '${row.type}' AS "id",
      '${row.type}' "type",
      '${row.type}' "code",
      N'${row.description}' "description",
      CAST(1 AS BIT) posted,
      CAST(0 AS BIT) deleted,
      CAST(0 AS BIT) isfolder,
      NULL parent
      UNION ALL\n`;
  }
  query = `SELECT * FROM (${query.slice(0, -(`UNION ALL\n`).length)}) d WHERE (1=1)\n`;
  return query;
}

export function buildSubcountQueryList(select: { type: string; description: string; }[]) {
  let query = '';
  for (const row of select) {
    query += `
      SELECT
        '${row.type}' AS "id",
        'Catalog.Subcount' "type",
        '${row.type}' "code",
        N'${row.description}' "description",
        CAST(1 AS BIT) posted,
        CAST(0 AS BIT) deleted,
        CAST(0 AS BIT) isfolder,
        NULL parent
      UNION ALL\n`;
  }
  query = `SELECT * FROM (${query.slice(0, -(`UNION ALL\n`).length)}) d WHERE (1=1)\n`;
  return query;
}

export function excludeProps(doc) {
  const { user, company, parent, info, isfolder, description, id, type, date, code, posted, deleted, timestamp, version, ...newObject } = doc;
  return newObject;
}

export function excludeRegisterAccumulatioProps(doc) {
  const { id, parent, kind, date, type, company, data, document, exchangeRate, calculated, internal, ...newObject } = doc;
  return newObject;
}

export function excludeRegisterInfoProps(doc) {
  const { date, type, company, data, document, ...newObject } = doc;
  return newObject;
}

function checkComlexType(type: AllTypes) {
  const types: AllTypes[] = ['Catalog.Subcount', 'Catalog.Catalogs', 'Catalog.Documents', 'Catalog.Objects', 'Catalog.Forms'];
  return (types.indexOf(type)) > -1;
}
