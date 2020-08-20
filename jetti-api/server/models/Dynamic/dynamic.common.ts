import { DocTypes } from './../documents.types';
import { CatalogCatalogServer } from './../Catalogs/Catalog.Catalog.server';
import { JETTI_POOL } from '../../sql.pool.jetti';
import { MSSQL } from '../../mssql';
import { createDocument, RegisteredDocumentType } from '../documents.factory';
import { CatalogDynamic } from './dynamic.prototype';
import { PropOptions, DocumentOptions } from '../document';
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


export async function riseUpdateMetadataEvent() {
    publisher.publish('updateDynamicMeta', '', updateDynamicMeta);
}


export async function updateDynamicMeta() {
    global['dynamicMeta'] = await getDynamicMeta();
    console.log(`Dynamic metadata updated`);
}

export const getDynamicMeta_OneQuery = async () => {
    const tx = new MSSQL(JETTI_POOL);
    const query =
        `SELECT
        cat.id,
        'Catalog.' + cat.typeString [DynamicType],
        cat.prefix Prefix,
        cat.icon Icon,
        cat.menu Menu,
        cat.Description Description,
        cat.presentation Presentation,
        cat.hierarchy Hierarchy,
        cat.module,
        IIF(params.TableDef = '', 0, 1) isTable,
        params.*,
        CopyTo.*
        FROM [dbo].[Catalog.Catalog.v] cat
        INNER JOIN Documents d
        on cat.id = d.id
            CROSS APPLY OPENJSON (d.doc, N'$.Parameters')
            WITH (
                [parameter] VARCHAR(MAX),
                [label] VARCHAR(MAX),
                [type] VARCHAR(MAX),
                [order] INT,
                [required] BIT,
                [change] VARCHAR(MAX),
                [tableDef] VARCHAR(MAX),
                [Props] VARCHAR(MAX)
            ) AS params
        where cat.posted = 1
        order by id, [order]`;

    const queryRes = await tx.manyOrNone<any>(query);
    const types = [...new Set(queryRes.map(e => e.DynamicType))];
    const res: { RegisteredDocument: RegisteredDocumentType[], Metadata: IDynamicMetadata[] } = { RegisteredDocument: [], Metadata: [] };

    const commonDoc = createDocument('Catalog.Dynamic');
    const commonProps = commonDoc.Props();
    const propsKeysInTable = ['label', 'type', 'order', 'required', 'change'];

    for (const type of types) {

        const ob = await lib.doc.createDocServerById(queryRes[0].id, tx);
        const typeProps = queryRes.filter(e => e.DynamicType === type);
        const meta: any[] = [];
        for (const typeProp of typeProps) {

            for (const propKey of propsKeysInTable) {
                meta.push({
                    Name: typeProp.parameter,
                    Options: propKey,
                    Value: typeProp[propKey],
                    TableName: typeProp.isTable ? typeProp.parameter : ''
                });
            }

            if (typeof typeProp.Props === 'object') {
                for (const propKey of Object.keys(typeProp.Props)) {
                    const propVal = typeProp.Props[propKey];
                    for (const propOptions of Object.keys(propVal)) {
                        meta.push({
                            Name: propKey,
                            Options: propOptions,
                            Value: propVal[propOptions],
                            TableName: typeProp.isTable ? typeProp.parameter : ''
                        });
                    }
                }
            }

            if (typeProp.isTable && typeProp.tableDef) {

                for (const propKey of Object.keys(typeProp.tableDef)) {
                    const propVal = typeProp.tableDef[propKey];
                    for (const propOptions of Object.keys(propVal)) {
                        meta.push({
                            Name: propKey,
                            Options: propOptions,
                            Value: propVal[propOptions],
                            TableName: typeProp.parameter
                        });
                    }
                }
            }
        }

        const prop = {
            type: typeProps[0].DynamicType,
            description: typeProps[0].Description,
            presentation: typeProps[0].Presentation,
            icon: typeProps[0].Icon,
            menu: typeProps[0].Menu,
            prefix: typeProps[0].Prefix,
            hierarchy: typeProps[0].Hierarchy,
            module: typeProps[0].module
        };

        res.RegisteredDocument.push({ type: type, Class: CatalogDynamic, dynamic: true });
        res.Metadata.push(buildDynamicMetadata(meta, { ...commonProps }, prop));
    }

    return res;
};

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

function buildDynamicMetadata(meta: any[], props: { [x: string]: PropOptions }, prop: { [x: string]: DocumentOptions }): IDynamicMetadata {
    // add tables
    const parsedOptions = ['value'];
    const addTable = meta.filter(e => e.TableName);
    const tables = [...new Set(addTable.map(e => e.TableName))];
    const getOptionsValue = (opts, value) => value;

    for (const tableName of tables) {
        const tableProps = addTable.filter(e => e.TableName === tableName && e.Name === tableName);
        const tableOb = { type: 'table' };
        tableOb[tableName] = {};
        for (const tableProp of tableProps) {
            tableOb[tableProp.Options] = getOptionsValue(tableProp.Options, tableProp.Value);
        }
        const tableFiledsProps = addTable.filter(e => e.TableName === tableName && e.Name !== tableName);
        const tableFileds = [...new Set(tableFiledsProps.map(e => e.Name))];
        for (const tableFiledName of tableFileds) {
            const tableFiledProps = addTable.filter(e => e.TableName === tableName && e.Name === tableFiledName);
            const tableFieldOb = {};
            for (const tableFiledProp of tableFiledProps) {
                tableFieldOb[tableFiledProp.Options] = getOptionsValue(tableFiledProp.Options, tableFiledProp.Value);
            }
            tableOb[tableName][tableFiledName] = tableFieldOb;
        }
        props[tableName] = tableOb as any;
    }

    // add fields
    const addfileds = meta.filter(e => !e.TableName);
    const fields = [...new Set(addfileds.map(e => e.Name))];
    for (const fieldName of fields) {
        const filedProps = addfileds.filter(e => e.Name === fieldName);
        const fieldOb = {};
        for (const filedProp of filedProps) {
            fieldOb[filedProp.Options] = getOptionsValue(filedProp.Options, filedProp.Value);
        }
        props[fieldName] = fieldOb as any;
    }

    if (props.parent) props.parent = { ...props.parent, type: prop.type as any };
    return {
        type: prop.type as any,
        Props: () => ({ ...props }),
        Prop: () => prop
    };

}
