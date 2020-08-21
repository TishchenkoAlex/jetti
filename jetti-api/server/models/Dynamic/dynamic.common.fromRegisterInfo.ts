import { JETTI_POOL } from '../../sql.pool.jetti';
import { MSSQL } from '../../mssql';
import { createDocument, RegisteredDocumentType } from '../documents.factory';
import { CatalogDynamic } from './dynamic.prototype';
import { PropOptions } from '../document';


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

export const getDynamicMeta = async () => {
    const tx = new MSSQL(JETTI_POOL);
    const query =
        `SELECT md.PropType type,
        md.PropDescription Description,
        md.PropIcon Icon,
        md.PropMenu Menu,
        md.PropPrefix Prefix,
        md.PropHierarchy Hierarchy,
        mdp.Name Name,
        mdp.Options,
        mdp.Value,
        mdp.TableName
        FROM [dbo].[Register.Info.Metadata] md
        LEFT JOIN [dbo].[Register.Info.Metadata.Props] mdp
        on md.PropType = mdp.OwnerType`;
    const queryRes = await tx.manyOrNone<any>(query);
    const types = [...new Set(queryRes.map(e => e.type))];
    const res: { RegisteredDocument: RegisteredDocumentType[], Metadata: IDynamicMetadata[] } = { RegisteredDocument: [], Metadata: [] };

    const commonDoc = createDocument('Catalog.Dynamic');
    const props = commonDoc.Props();

    for (const type of types) {
        res.RegisteredDocument.push({ type: type, Class: CatalogDynamic, dynamic: true });
        res.Metadata.push(buildDynamicMetadata(queryRes.filter(e => e.type === type), { ...props }));
    }

    return res;
};



function buildDynamicMetadata(meta: any[], props: { [x: string]: PropOptions }): IDynamicMetadata {
    // add tables
    const parsedOptions = ['value'];
    const addTable = meta.filter(e => e.TableName);
    const tables = [...new Set(addTable.map(e => e.TableName))];
    const getOptionsValue = (opts, value) => parsedOptions.indexOf(opts) > -1 ? JSON.parse(value) : value;

    for (const tableName of tables) {
        const tableProps = addTable.filter(e => e.TableName === tableName && !e.Name);
        const tableOb = { type: 'table' };
        tableOb[tableName] = {};
        for (const tableProp of tableProps) {
            tableOb[tableProp.Options] = getOptionsValue(tableProp.Options, tableProp.Value);
        }
        const tableFiledsProps = addTable.filter(e => e.TableName === tableName && e.Name);
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

    if (props.parent) props.parent = { ...props.parent, type: meta[0].type };
    return {
        type: meta[0].type,
        Props: () => ({ ...props }),
        Prop: () => (
            {
                type: meta[0].type,
                description: meta[0].Description,
                icon: meta[0].Icon,
                menu: meta[0].Menu,
                prefix: meta[0].Prefix,
                hierarchy: meta[0].Hierarchy
            }
        )
    };

}
