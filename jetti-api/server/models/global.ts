import { IDynamicMetadata, getDynamicMeta } from './Dynamic/dynamic.common';
import { AllDocTypes } from './documents.types';
import { x100 } from '../x100.lib';
import { lib } from '../std.lib';
import * as moment from 'moment';
import { getConfigSchema, IConfigSchema } from './config';
import { getIndexedOperationsMap } from './indexedOperation';
import { DocumentBase } from './document';

export class Global {

    static x100 = x100;
    static lib = lib;
    static isProd: boolean = global['isProd'];
    static byCode = lib.doc.byCode;
    static DocBase = DocumentBase;

    static indexedOperations = () => global['indexedOperations'] as Map<string, string>;
    static dynamicMeta = () => global['dynamicMeta'] as IDynamicMetadata;
    static configSchema = () => global['configSchema'] as Map<AllDocTypes, IConfigSchema>;
    static moment = () => global['moment'];

    static async init() {
        global['x100'] = x100;
        global['lib'] = lib;
        global['DOC'] = lib.doc;
        global['byCode'] = lib.doc.byCode;
        global['moment'] = moment;
        global['isProd'] = process.env.NODE_ENV === 'production';
        await this.updateDynamicMeta();
    }

    static async updateDynamicMeta() {
        global['indexedOperations'] = await getIndexedOperationsMap();
        global['dynamicMeta'] = await getDynamicMeta();
        global['configSchema'] = getConfigSchema();
    }
}
