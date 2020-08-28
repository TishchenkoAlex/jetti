import { DocListRequestBody, DocListResponse } from '../../models/common-types';
import { DocumentBase } from '../../models/document';
import { configSchema } from './../../models/config';
import { FormListFilter } from './../../models/user.settings';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { filterBuilder } from '../../fuctions/filterBuilder';

export async function List(params: DocListRequestBody, tx: MSSQL): Promise<DocListResponse> {
  params.filter = (params.filter || []).filter(el => !(el.right === null || el.right === undefined));

  if (params.listOptions && params.listOptions!.withHierarchy) {
    let parent: any = null;
    if (params.id) {
      const ob = await lib.doc.byId(params.id, tx);
      parent = ob!.isfolder && params.listOptions.hierarchyDirectionUp ? params.id : ob!.parent;
    }
    // folders
    const queryList = configSchema().get(params.type)!.QueryList;
    const parentWhere = parent ? 'd.[parent.id] = @p1' : 'd.[parent.id] is NULL';
    let queryText = `SELECT * FROM (${queryList}) d WHERE ${parentWhere} and isfolder = 1`;
    if (parent) {
      const ancestors = await lib.doc.Ancestors(params.id, tx) as any[];
      const ancestorsId = ancestors.filter(el => el.parent !== parent).map(e => '\'' + e.id + '\'').join();
      queryText = `${queryText} UNION SELECT * FROM (${queryList}) d WHERE id IN (${ancestorsId})`;
    }
    queryText = queryText + 'ORDER BY description';
    const folders = await tx.manyOrNone(queryText, [parent]);
    // elements
    const deletedFilter = params.filter.find(e => e.left === 'deleted');
    params.filter = [];
    params.filter.push(new FormListFilter('parent', '=', { id: parent, type: params.type }));
    params.filter.push(new FormListFilter('isfolder', '=', 0));
    if (deletedFilter) params.filter.push(new FormListFilter('deleted', '=', 0));
    params.listOptions.withHierarchy = false;
    const result = await List(params, tx);

    result.data = folders.concat(result.data);

    return result;
  }

  params.command = params.command || 'first';


  // function indexedOperationType(type: DocTypes, id: string) {
  //   if (type !== 'Document.Operation') return '';
  //   const operType = indexedOperations().get(id);
  //   return operType || '';
  // }

  const cs = configSchema().get(params.type);

  // if (params.type === 'Document.Operation') {
  //   const operFilter = params.filter.find(e => e.left === 'Operation');
  //   if (operFilter && operFilter.right && operFilter.right.id) {
  //     const operType = indexedOperationType(params.type, operFilter.right.id);
  //     if (operType) cs = configSchema().get(operType as DocTypes);
  //   }
  // }

  const { QueryList, Props } = cs!;

  let row: DocumentBase | null = null;
  let query = '';

  if (params.id) row = (await tx.oneOrNone<DocumentBase>(`SELECT * FROM (${QueryList}) d WHERE d.id = '${params.id}'`));
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

  const queryBuilder = (isAfter: boolean) => {
    if (valueOrder.length === 0) return '';
    const order = valueOrder.slice();
    const dir = lastORDER ? isAfter ? '>' : '<' : isAfter ? '<' : '>';
    let queryBuilderResult = `
      SELECT TOP ${params.count + 1} id FROM (${QueryList}) d
      WHERE ${(filterBuilder(params.filter).where)} AND (`;

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

  const queryFilter = filterBuilder(params.filter);
  const queryBefore = queryBuilder(false);
  const queryAfter = queryBuilder(true);
  if (queryBefore && queryAfter && row) {
    query = `${queryFilter.tempTable}
    SELECT * FROM (${QueryList}) d WHERE id IN (
      SELECT id FROM (${queryBefore}) q1
      UNION ALL
      SELECT id FROM (${queryAfter}) q2
    )
    ${orderbyAfter}`;
  } else {
    // const filter = filterBuilder(params.filter);
    if (params.command === 'last')
      query = `${queryFilter.tempTable}SELECT * FROM (SELECT TOP ${params.count + 1} * FROM (${QueryList}) d WHERE ${(queryFilter.where)} ${orderbyBefore}) d ${orderbyAfter}`;
    else
      query = `${queryFilter.tempTable}SELECT TOP ${params.count + 1} * FROM (${QueryList}) d WHERE ${(queryFilter.where)} ${orderbyAfter}`;
  }
  // if (process.env.NODE_ENV !== 'production') console.log(query);
  const data = await tx.manyOrNone<any>(query);

  return listPostProcess(data, params);
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
