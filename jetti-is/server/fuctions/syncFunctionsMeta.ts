import { AutosincIkoToJetty } from '../exchange/iiko-to-jetti-autosync';
import { ImportProductToJetti } from '../exchange/iiko-to-jetti-catalog-product';
import { ImportCounterpartieToJetti } from '../exchange/iiko-to-jetti-catalog-counterpartie';
import { ImportSalesToJetti } from '../exchange/iiko-to-jetti-sales';

export const RegisteredSyncFunctions = (): Map<string, Function> => {
    const res = new Map;
    [
        AutosincIkoToJetty,
        ImportProductToJetti,
        ImportCounterpartieToJetti,
        ImportSalesToJetti
    ]
        .forEach(e => res.set(e.name, e));
    return res;
};
