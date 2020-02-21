import { DocTypes, AllDocTypes } from './../../models/documents.types';
// tslint:disable:prefer-const
import { DocListRequestBody, DocListResponse } from '../../models/common-types';
import { DocumentBase } from '../../models/document';
import { configSchema } from './../../models/config';
import { FilterInterval, FormListFilter } from './../../models/user.settings';
import { MSSQL } from '../../mssql';

export async function List(params: DocListRequestBody, tx: MSSQL): Promise<DocListResponse> {
  params.filter = (params.filter || []).filter(el => !(el.right === null || el.right === undefined));
  params.command = params.command || 'first';

  const cs = configSchema.get(params.type);
  let { QueryList, Props } = cs!;

  let row: DocumentBase | null = null;
  let query = '';
  let tempTabe = '';

  if (!params.withHierarchy && params.id) row = (await tx.oneOrNone<DocumentBase>(`SELECT * FROM (${QueryList}) d WHERE d.id = '${params.id}'`));
  if (!row && params.command !== 'last') params.command = 'first';
  const isFirstLast = params.command === 'last' || params.command === 'first';
  if (row && isFirstLast) row = null;

  params.order.forEach(el => el.field += (Props[el.field].type as string).includes('.') ? '.value' : '');
  params.filter.forEach(el => el.left += (Props[el.left] && Props[el.left].type && (Props[el.left].type as string).includes('.')) ? '.id' : '');
  let valueOrder: { field: string, order: 'asc' | 'desc', value: any }[] = [];
  params.order.filter(el => el.order).forEach(el => {
    const value = row ? el.field.includes('.value') ? row[el.field.split('.')[0]].value : row[el.field] : '';
    valueOrder.push({ field: el.field, order: el.order || 'asc', value: row ? value : '' });
  });

  const lastORDER = valueOrder.length ? valueOrder[valueOrder.length - 1].order === 'asc' : true;
  valueOrder.push({ field: 'id', order: lastORDER ? 'asc' : 'desc', value: params.id });
  let orderbyBefore = ' ORDER BY '; let orderbyAfter = orderbyBefore;
  valueOrder.forEach(o => orderbyBefore += '"' + o.field + (o.order === 'asc' ? '" DESC, ' : '" ASC, '));
  orderbyBefore = orderbyBefore.slice(0, -2);
  valueOrder.forEach(o => orderbyAfter += '"' + o.field + (o.order === 'asc' ? '" ASC, ' : '" DESC, '));
  orderbyAfter = orderbyAfter.slice(0, -2);

  valueOrder = valueOrder.filter(el => !(el.value === null || el.value === undefined));

  const filterBuilder = (filter: FormListFilter[]) => {
    let where = ' (1 = 1) ';

    const filterList = filter.filter(f => !(f.right === null || f.right === undefined));
    for (const f of filterList) {
      switch (f.center) {
        case '=':
        case '>=':
        case '<=':
        case '>':
        case '<':
          if (Array.isArray(f.right)) { // time interval
            if (f.right[0])
              where += ` AND "${f.left}" >= '${f.right[0]}'`;
            if (f.right[1])
              where += ` AND "${f.left}" <= '${f.right[1]}'`;
            break;
          }
          if (typeof f.right === 'number') {
            where += ` AND "${f.left}" ${f.center} '${f.right}'`;
            break;
          }
          if (typeof f.right === 'boolean') {
            where += ` AND "${f.left}" ${f.center} '${f.right}'`;
            break;
          }
          if (typeof f.right === 'object') {
            if (!f.right.id)
              where += ` AND "${f.left}" IS NULL `;
            else {
              if (f.left === 'parent.id') {
                where += ` AND "${f.left}" = '${f.right.id}'`;
              } else {
                if (tempTabe.indexOf(`[#${f.left}]`) < 0)
                  tempTabe += `SELECT id INTO [#${f.left}] FROM dbo.[Descendants]('${f.right.id}', '${f.right.type}');\n`;
                where += ` AND "${f.left}" IN (SELECT id FROM [#${f.left}])`;
              }
            }
            break;
          }
          if (typeof f.right === 'string')
            f.right = f.right.toString().replace('\'', '\'\'');
          if (!f.right)
            where += ` AND "${f.left}" IS NULL `;
          else
            where += ` AND "${f.left}" ${f.center} N'${f.right}'`;
          break;
        case 'like':
          where += ` AND "${f.left}" LIKE N'%${(f.right['value'] || f.right).toString().replace('\'', '\'\'')}%' `;
          break;
        case 'beetwen':
          const interval = f.right as FilterInterval;
          if (interval.start)
            where += ` AND "${f.left}" BEETWEN '${interval.start}' AND '${interval.end}' `;
          break;
        case 'is null':
          where += ` AND "${f.left}" IS NULL `;
          break;
      }
    }
    return where;
  };

  const queryBuilder = (isAfter: boolean) => {
    if (valueOrder.length === 0) return '';
    const fb = filterBuilder(params.filter);
    const order = valueOrder.slice();
    const dir = lastORDER ? isAfter ? '>' : '<' : isAfter ? '<' : '>';
    let queryBuilderResult = `
      SELECT TOP ${params.count + 1} id FROM (${QueryList}) d
      WHERE ${(filterBuilder(params.filter))} AND (`;

    valueOrder.forEach(_or => {
      let where = '(';
      order.forEach(_o =>
        where += ` "${_o.field}" ${_o !== order[order.length - 1] ? '=' :
          dir + ((_o.field === 'id') && isAfter ? '=' : '')} N'${_o.value instanceof Date ? _o.value.toJSON() : _o.value}' AND `
      );
      where = where.slice(0, -4);
      order.length--;
      queryBuilderResult += ` ${where} ) OR \n`;
    });
    queryBuilderResult = queryBuilderResult.slice(0, -4) + ')';

    queryBuilderResult += `\n${lastORDER ?
      (dir === '>') ? orderbyAfter : orderbyBefore :
      (dir === '<') ? orderbyAfter : orderbyBefore}\n`;
    return queryBuilderResult;
  };

  const queryBefore = queryBuilder(false);
  const queryAfter = queryBuilder(true);
  if (queryBefore && queryAfter && row) {
    query = `${tempTabe}
    SELECT * FROM (${QueryList}) d WHERE id IN (
      SELECT id FROM (${queryBefore}) q1
      UNION ALL
      SELECT id FROM (${queryAfter}) q2
    )
    ${orderbyAfter}`;
  } else {
    const filter = filterBuilder(params.filter);
    if (params.withHierarchy) {
      QueryList = addHierarchyToQuery(QueryList, params.type, params.id, filter, orderbyBefore );
      query = `${QueryList}`;
    }
    else if (params.command === 'last')
      query = `${tempTabe}SELECT * FROM (SELECT TOP ${params.count + 1} * FROM (${QueryList}) d WHERE ${(filter)} ${orderbyBefore}) d ${orderbyAfter}`;
    else
      query = `${tempTabe}SELECT TOP ${params.count + 1} * FROM (${QueryList}) d WHERE ${(filter)} ${orderbyAfter}`;
  }
  // if (process.env.NODE_ENV !== 'production') console.log(query);
  const data = await tx.manyOrNone<any>(query);

  return listPostProcess(data, params);
}

function getHierarchyQuery(type: AllDocTypes, id: string): { queryText: string, orderText: string } {

  if (!id) { //top level
    return {
      queryText: `
    DROP TABLE IF EXISTS #Hierarchy;
    SELECT doc.id, doc.parent hparent, 0 hlevel INTO #Hierarchy
    FROM Documents doc
    WHERE doc.parent is NULL and type = '@p1'; 
    SELECT
        h.hparent, h.hlevel, d.description value, `.replace('@p1', type),
      orderText: 'order by isfolder desc'
    }

  } else {
    return {
      queryText: `
    DROP TABLE IF EXISTS #Tree;
    DROP TABLE IF EXISTS #Hierarchy;

    SELECT id, [parent.id], description, LevelUp
    INTO #Tree
    FROM dbo.[Ancestors]('@p1');
    
    SELECT res.id, res.parent hparent, MIN(res.LevelUp) hlevel  INTO #Hierarchy
    from (
      SELECT doc.id id, doc.parent parent, doc.isfolder, doc.description, tree.LevelUp
        FROM #Tree tree INNER JOIN Documents doc ON tree.[parent.id] = doc.parent and tree.id = '@p1'
      UNION
      SELECT tree.id id, tree.[parent.id] parent, 1, tree.description, tree.LevelUp
        FROM #Tree tree
        WHERE tree.id <> '@p1'
      UNION
      SELECT doc.id, doc.parent, doc.isfolder, doc.description, 9 LevelUp
        FROM Documents doc
        WHERE id = '@p1'
      UNION
      SELECT doc.id, doc.parent, doc.isfolder, doc.description, 10 LevelUp
        FROM Documents doc
        WHERE doc.parent = '@p1') res LEFT JOIN Documents doc on doc.id = res.id
    GROUP BY res.id, res.parent;
    SELECT
    h.hparent, h.hlevel, d.description value, `.replace(/@p1/g, id),
      orderText: 'order by hlevel, isfolder desc'
    };
  }
}

function addHierarchyToQuery(queryText: string, type: AllDocTypes, id: string, filter?: string, order?: string): string {
  const HierarchyQuery = getHierarchyQuery(type, id);
  let result = queryText.replace('SELECT', `${HierarchyQuery.queryText}`);
  return `${result}\nINNER JOIN #Hierarchy h ON d.id = h.id\n${HierarchyQuery.orderText}`
}

function listPostProcess(data: any[], params: DocListRequestBody) {
  let result: any[] = [];
  const continuation = { first: null, last: null };
  const continuationIndex = data.findIndex(d => d.id === params.id);
  const pageSize = Math.min(data.length, params.count);
  switch (params.command) {
    case 'first':
      continuation.first = null;
      continuation.last = data[pageSize];
      result = data.slice(0, pageSize);
      break;
    case 'last':
      continuation.first = data[data.length - 1 - params.count];
      continuation.last = null;
      result = data.slice(-pageSize);
      break;
    default:
      const direction = params.command !== 'prev';
      if (direction) {
        continuation.first = data[continuationIndex - params.offset - 1];
        continuation.last = data[continuationIndex + pageSize - params.offset];
        result = data.slice(continuation.first ? continuationIndex - params.offset : 0, continuationIndex + pageSize - params.offset);
        if (result.length < pageSize) {
          const first = Math.max(continuationIndex - params.offset - (pageSize - result.length), 0);
          const last = Math.max(continuationIndex - params.offset + result.length, pageSize);
          continuation.first = data[first - 1];
          continuation.last = data[last + 1] || data[last];
          result = data.slice(first, last);
        }
      } else {
        continuation.first = data[continuationIndex - pageSize - params.offset];
        continuation.last = data[continuationIndex + 1 - params.offset];
        result = data.slice(continuation.first ?
          continuationIndex - pageSize + 1 - params.offset : 0, continuationIndex + 1 - params.offset);
        if (result.length < pageSize) {
          continuation.first = null;
          continuation.last = data[pageSize + 1];
          result = data.slice(0, pageSize);
        }
      }
  }
  result.length = Math.min(result.length, params.count);
  return { data: result, continuation: continuation };
}
