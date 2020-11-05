import { DocTypes } from './documents.types';
import { MSSQL } from '../mssql';
import { JETTI_POOL } from '../sql.pool.jetti';
import { Global } from './global';

export interface IIndexedOperation { id: string; type: DocTypes; shortName: string; }

export async function getIndexedOperationsMap() {
    const operations = await getIndexedOperations();
    return new Map(operations.map(e => [e.id, e.type]));
}

export async function getIndexedOperations(tx?: MSSQL, operationsId?: string[]) {
    const sdbl = tx ? tx : new MSSQL(JETTI_POOL);
    let query = `
    SELECT id, CONCAT('Operation.', shortName) type, shortName
    FROM [dbo].[Catalog.Operation.v] WHERE posted = 1 and shortName <> ''
    ORDER BY shortName`;
    if (operationsId) query += `and id in (${operationsId.map(e => '\'' + e + '\'').join()})`;
    return await sdbl.manyOrNone<IIndexedOperation>(query);
}

export function getIndexedOperationType(operationId: string): DocTypes | undefined {
    return Global.indexedOperations().get(operationId) as DocTypes || undefined;
}

export function getIndexedOperationById(operationId: string): IIndexedOperation | undefined {
    const operType = Global.indexedOperations().get(operationId);
    if (!operType) return undefined;
    return { id: operationId, type: operType as DocTypes, shortName: operType.replace('Operation.', '') };
}
