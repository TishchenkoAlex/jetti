import { DocTypes } from './../documents.types';
import { CatalogCatalogServer } from './../Catalogs/Catalog.Catalog.server';
import { JETTI_POOL } from '../../sql.pool.jetti';
import { MSSQL } from '../../mssql';
import { RegisteredDocumentType } from '../documents.factory';
import { CatalogDynamic } from './dynamic.prototype';
import { lib } from '../../std.lib';
import { publisher } from '../..';


export interface IDynamicMetadata {
    type: string;
    Prop: Function;
    Props: Function;
}

export interface IDynamicPropsOptions {
    Name: string;
    Options: string;
    Value: any;
    TableName: string;
}

export function riseUpdateMetadataEvent() {
    publisher.publish('updateDynamicMeta', 'button clck');
}

export async function updateDynamicMeta() {
    console.log(`Dynamic metadata updated`);
    global['dynamicMeta'] = await getDynamicMeta();
}

export const getDynamicMeta = async () => {

    const tx = new MSSQL(JETTI_POOL);
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

export function dynamicMeta(): IDynamicMetadata[] {
    return [...global['dynamicMeta'] || []];
}

