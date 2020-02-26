import { x100 } from '../x100.lib';
import { lib } from '../std.lib';
import moment = require('moment');

export const initGlobal = () => {
    global['x100'] = x100;
    global['lib'] = lib;
    global['DOC'] = lib.doc;
    global['byCode'] = lib.doc.byCode;
    global['moment'] = moment;
};
