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
import { configSchemaStatic, ConfigSchemaFromRegisteredDocument, IConfigSchema } from '../config';


export interface IDynamicMetadata {
    type: string;
    Prop: Function;
    Props: Function;
}

export function riseUpdateMetadataEvent() {
    publisher.publish('updateDynamicMeta', 'button clck');
}

export async function updateDynamicMeta() {
    console.log(`Dynamic metadata updated`);
    global['dynamicMeta'] = await getDynamicMeta();
    global['configSchema'] = getConfigSchema();

}

function getConfigSchema() {
    return new Map(
        [...configSchemaStatic,
        ...ConfigSchemaFromRegisteredDocument(RegisteredDocumentDynamic())
        ]
            .map((i): [AllDocTypes, IConfigSchema] => [i.type, i]));
}

export const getDynamicMeta = async (): Promise<{ RegisteredDocument: RegisteredDocumentType[], Metadata: IDynamicMetadata[] }> => {
    const tx = new MSSQL(JETTI_POOL);
    const catalogsMeta = await getDynamicMetaCatalog(tx);
    const operationsMeta = await getDynamicMetaOperation(tx);
    return {
        RegisteredDocument: [...catalogsMeta.RegisteredDocument, ...operationsMeta.RegisteredDocument],
        Metadata: [...catalogsMeta.Metadata, ...operationsMeta.Metadata]
    };
};

export const getDynamicMetaCatalog = async (tx: MSSQL) => {

    const query = `SELECT id, typeString type FROM [dbo].[Catalog.Catalog.v] where posted = 1`;
    const cats = await tx.manyOrNone<{ id: string }>(query);
    const res: { RegisteredDocument: RegisteredDocumentType[], Metadata: IDynamicMetadata[] } = { RegisteredDocument: [], Metadata: [] };

    for (const cat of cats) {
        const ob = await lib.doc.createDocServerById<CatalogCatalogServer>(cat.id, tx);
        const meta = await ob!.getDynamicMetadata();
        res.RegisteredDocument.push({ type: meta.type as DocTypes, Class: CatalogDynamic, dynamic: true });
        res.Metadata.push(meta);
    }
    return res;
};

export const getDynamicMetaOperation = async (tx: MSSQL) => {

    const query = `SELECT id FROM [dbo].[Catalog.Operation.v] WHERE posted = 1 and shortName <> ''`;
    const operations = await tx.manyOrNone<{ id: string }>(query);
    const res: { RegisteredDocument: RegisteredDocumentType[], Metadata: IDynamicMetadata[] } = { RegisteredDocument: [], Metadata: [] };

    for (const operation of operations) {
        const ob = await lib.doc.createDocServerById<CatalogOperationServer>(operation.id, tx);
        const meta = await ob!.getDynamicMetadata(tx);
        res.RegisteredDocument.push({ type: meta.type as DocTypes, Class: DocumentOperation, dynamic: true });
        res.Metadata.push(meta);
    }
    return res;
};

export function dynamicMeta(): IDynamicMetadata[] {
    return [...global['dynamicMeta'] || []];
}

