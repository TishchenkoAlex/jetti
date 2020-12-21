import { IDynamicMetadata, getDynamicMeta } from './Dynamic/dynamic.common';
import { AllDocTypes, DocTypes } from './documents.types';
import { x100 } from '../x100.lib';
import { lib } from '../std.lib';
import * as moment from 'moment';
import { getConfigSchema, getRegisteredDocuments, IConfigSchema } from './config';
import { getIndexedOperationsMap } from './indexedOperation';
import { DocumentBase } from './document';
import { RegisteredDocumentType } from './documents.factory';

export class Global {

    private static _dynamicFields = ['RegisteredDocuments', 'dynamicMeta', 'indexedOperations', 'configSchema'];
    static x100 = x100;
    static lib = lib;
    static isProd: boolean = global['isProd'];
    // static byCode = lib.doc.byCode;
    static DocBase = DocumentBase;

    static indexedOperations = () => global['indexedOperations'] as Map<string, string>;
    static dynamicMeta = () => global['dynamicMeta'] as IDynamicMetadata;
    static configSchema = () => global['configSchema'] as Map<AllDocTypes, IConfigSchema> || new Map;
    static RegisteredDocuments = () => global['RegisteredDocuments'] as Map<DocTypes, RegisteredDocumentType> || new Map;
    static RegisteredDocumentDynamic = () =>
        (global['dynamicMeta'] ? global['dynamicMeta']['RegisteredDocument'] : []) as RegisteredDocumentType[]
    static moment = () => global['moment'];

    static async init() {
        global['x100'] = x100;
        global['lib'] = lib;
        global['DOC'] = lib.doc;
        global['byCode'] = lib.doc.byCode;
        global['moment'] = moment;
        global['isProd'] = process.env.NODE_ENV === 'production';
        await this.updateDynamicMeta();
        // console.log(global['RegisteredDocuments']);
    }

    static async updateDynamicMeta() {
        Global._dynamicFields.forEach(field => delete global[field]);
        global['RegisteredDocuments'] = await getRegisteredDocuments(); // only static
        global['dynamicMeta'] = await getDynamicMeta();
        global['indexedOperations'] = await getIndexedOperationsMap();
        global['RegisteredDocuments'] = await getRegisteredDocuments(); // static + dynamic
        global['configSchema'] = getConfigSchema();
    }
}
