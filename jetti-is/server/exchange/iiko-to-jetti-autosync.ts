// модуль автосинхронизации IIKO - Jetti

import { v1 as uuidv1 } from 'uuid';
import { ISyncParams, saveSyncParams, saveLogProtocol } from "./iiko-to-jetti-connection";
import { IJettiProject } from "./jetti-projects";
import { RussiaSource } from "./jetti-projects";
import { ImportCounterpartieToJetti } from "./iiko-to-jetti-catalog-counterpartie";
import { ImportProductToJetti } from "./iiko-to-jetti-catalog-product";
import { ImportPersonToJetti } from "./iiko-to-jetti-person";
import { ImportSalesToJetti } from "./iiko-to-jetti-sales";

export async function AutosincIkoToJetty(project: IJettiProject, syncSource: string) {
    const dt = new Date();
    //! временно, эти патаметры будем определять из excange базы по проекту и базе источнику...
    let syncParams: ISyncParams  = {
        syncid: uuidv1().toUpperCase(),
        project: project,
        source: RussiaSource,
        baseType: 'sql',
        destination: project.destination,
        periodBegin: new Date(2020,5,1),
        periodEnd: new Date(2020,5,2),
        firstDate: RussiaSource.firstDate,
        lastSyncDate: new Date(2020,5,23,8,0,0),  // ! временно для примера
        exchangeID: 'B72A88A5-E93A-4959-B2DC-287B798CA171', // тестово по одному складу
        autosync: true,
        forcedUpdate: true, // ! пока обновление только новых данных
        logLevel: 2,
        execFlag: 1,
        startTime: dt,
        finishTime: null
    };
    await saveSyncParams(syncParams);
    saveLogProtocol(syncParams.syncid, 0, 0, "Autosinc", `Autosync data IIKO - Jetti: ${syncSource} ==> ${project.id}.`);
    saveLogProtocol(syncParams.syncid, 0, 0, "Autosinc", `Starting Batch ${dt.toString()}`);

    //console.log("Start sync Products");
    //ImportProductToJetti(syncParams).catch(() => { });

    //console.log("Start sync Counterpartie");
    //ImportCounterpartieToJetti(syncParams).catch(() => { });

    ImportPersonToJetti(syncParams).catch(() => { });

//    console.log("Start sync Sales docs");
//    ImportSalesToJetti(syncParams, ['C9CAC9B4-1E97-42E1-AC58-23C419888B46']).catch(() => { });

}
