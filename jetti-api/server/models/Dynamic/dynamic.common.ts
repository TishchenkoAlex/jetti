import { DocumentOperationServer } from './../Documents/Document.Operation.server';
import { CatalogOperationServer } from './../Catalogs/Catalog.Operation.server';
import { DocumentOperation } from './../Documents/Document.Operation';
import { DocTypes, AllDocTypes } from './../documents.types';
import { CatalogCatalogServer } from './../Catalogs/Catalog.Catalog.server';
import { JETTI_POOL } from '../../sql.pool.jetti';
import { MSSQL } from '../../mssql';
import { RegisteredDocumentType, RegisteredDocumentDynamic } from '../documents.factory';
import { CatalogDynamic } from './dynamic.prototype';
import { lib } from '../../std.lib';
import { publisher } from '../..';
import { Global } from '../global';
import { getIndexedOperations } from '../indexedOperation';


export interface IDynamicProps {
    type: string;
    Prop: Function;
    Props: Function;
}

export interface IDynamicMetadata {
    Metadata: IDynamicProps[];
    RegisteredDocument: RegisteredDocumentType[];
    RegisteredServerDocument: RegisteredDocumentType[];
}

export function riseUpdateMetadataEvent() {
    publisher.publish('updateDynamicMeta', 'button clck');
}

export async function updateDynamicMeta() {
    Global.updateDynamicMeta();
    console.log(`Dynamic metadata updated`);
}

export const getDynamicMeta = async (): Promise<IDynamicMetadata> => {
    const tx = new MSSQL(JETTI_POOL);
    const catalogsMeta = await getDynamicMetaCatalog(tx);
    const operationsMeta = await getDynamicMetaOperation(tx);
    return {
        Metadata: [...catalogsMeta.Metadata, ...operationsMeta.Metadata],
        RegisteredDocument: [...catalogsMeta.RegisteredDocument, ...operationsMeta.RegisteredDocument],
        RegisteredServerDocument: [...catalogsMeta.RegisteredServerDocument, ...operationsMeta.RegisteredServerDocument],
    };
};

export const getDynamicMetaCatalog = async (tx: MSSQL) => {

    const query = `SELECT id, typeString type FROM [dbo].[Catalog.Catalog.v] where posted = 1`;
    const cats = await tx.manyOrNone<{ id: string }>(query);
    const res: IDynamicMetadata = { RegisteredDocument: [], Metadata: [], RegisteredServerDocument: [] };

    for (const cat of cats) {
        const ob = await lib.doc.createDocServerById<CatalogCatalogServer>(cat.id, tx);
        const meta = await ob!.getDynamicMetadata();
        res.RegisteredDocument.push({ type: meta.type as DocTypes, Class: CatalogDynamic, dynamic: true });
        res.Metadata.push(meta);
    }
    return res;
};

export const getDynamicMetaOperation = async (tx: MSSQL) => {

    const operations = await getIndexedOperations(tx);
    const res: IDynamicMetadata = { RegisteredDocument: [], Metadata: [], RegisteredServerDocument: [] };

    for (const operation of operations) {
        const ob = await lib.doc.createDocServerById<CatalogOperationServer>(operation.id, tx);
        const meta = await ob!.getDynamicMetadata(tx);
        res.RegisteredDocument.push({ type: meta.type as DocTypes, Class: DocumentOperation, dynamic: true });
        res.RegisteredServerDocument.push({ type: meta.type as DocTypes, Class: DocumentOperationServer, dynamic: true });
        res.Metadata.push(meta);
    }
    return res;
};

