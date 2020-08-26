import { x100 } from '../x100.lib';
import { lib } from '../std.lib';
import moment = require('moment');
import { getDynamicMeta } from '../models/Dynamic/dynamic.common';

export const initGlobal = async () => {

    global['x100'] = x100;
    global['lib'] = lib;
    global['DOC'] = lib.doc;
    global['byCode'] = lib.doc.byCode;
    global['moment'] = moment;
    global['isProd'] = process.env.NODE_ENV === 'production';
    global['dynamicMeta'] = await getDynamicMeta();

};

