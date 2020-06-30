// модуль автосинхронизации IIKO - Jetti

import { v1 as uuidv1 } from 'uuid';
import { ISyncParams, getSyncParams, saveSyncParams, saveLogProtocol, finishSync } from './iiko-to-jetti-connection';
import { IJettiProject, RussiaSource } from './jetti-projects';
import { ImportCounterpartieToJetti } from './iiko-to-jetti-catalog-counterpartie';
import { ImportProductToJetti } from './iiko-to-jetti-catalog-product';
import { ImportPersonToJetti } from './iiko-to-jetti-person';
import { ImportSalesToJetti } from './iiko-to-jetti-sales';

export async function AutosincIkoToJetty(params: any) {
    return new Promise(async (resolve, reject) => {
      try {
        // const {project, syncSource} = params;
        // console.log(params);
        // console.log(params.project);
        const syncParams: ISyncParams = await getSyncParams(params.project, params.syncSource);
        // if (!syncParams) throw new Error('Error get sync params.');
        await saveSyncParams(syncParams);
        await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Autosync data IIKO - Jetti: ${syncParams.source.id} ==> ${syncParams.project.id}.`);
        await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Starting Batch ${syncParams.startTime.toString()}`);
        /*// справочники
        await Promise.all([
          ImportProductToJetti(syncParams),
          ImportCounterpartieToJetti(syncParams),
          ImportPersonToJetti(syncParams)
        ]).then(() => {
          saveLogProtocol(syncParams.syncid, 0, 0, "Autosinc", `All Tasks Catalogs Complete.`);
        }, (error) => {
          saveLogProtocol(syncParams.syncid, 0, 0, "Autosinc", `Task Catalogs Errored: ${error.message}`);
        }); */

        // документы
        await Promise.all([
          ImportSalesToJetti(syncParams, ['C9CAC9B4-1E97-42E1-AC58-23C419888B46'])
        ]).then(() => {
          saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `All Tasks Documants Complete.`);
        }, (error) => {
          saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Task Documents Errored: ${error.message}`);

        });
        // завершение работы автосинхронизации
        syncParams.finishTime = new Date();
        await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Finished Batch ${syncParams.finishTime.toString()}`);
        await finishSync(syncParams);
        resolve('done');
        process.exit(0); // !
      } catch (error) {
        reject(error);
      }
    });
}
