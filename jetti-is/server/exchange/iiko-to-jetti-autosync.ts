// модуль автосинхронизации IIKO - Jetti

import { ISyncParams, getSyncParams, saveSyncParams, saveLogProtocol, finishSync } from './iiko-to-jetti-connection';
import { IJettiProject, RussiaSource } from './jetti-projects';
import { ImportProductToJetti } from './iiko-to-jetti-catalog-product';
import { ImportCounterpartieToJetti } from './iiko-to-jetti-catalog-counterpartie';
import { ImportPersonToJetti } from './iiko-to-jetti-person';
import { ImportSalesToJetti } from './iiko-to-jetti-sales';

export async function AutosyncIIkoToJetty(params: any) {

  const syncParams: ISyncParams = await getSyncParams(params);

  await saveSyncParams(syncParams);
  await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Autosync data IIKO - Jetti: ${syncParams.source.id} ==> ${syncParams.project.id}.`);
  await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Starting Batch ${syncParams.startTime.toString()}`);
  // справочники
  if (syncParams.autosync && syncParams.execFlag === 126) {
    try {
      await Promise.all([
        ImportProductToJetti(syncParams),
        ImportCounterpartieToJetti(syncParams),
        ImportPersonToJetti(syncParams)
      ]);
      await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `All Tasks Catalogs Complete.`);
    } catch (error) {
      saveLogProtocol(syncParams.syncid, 0, 1, 'Autosinc', `Task Catalogs Errored: ${error.message}`);
    }
  }
  // документы
  const syncFunc: any[] = [];
  if ((syncParams.execFlag && 32) === 32) syncFunc.push(ImportSalesToJetti(syncParams));
  try {
    await Promise.all(syncFunc);
    await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `All Tasks Documents Complete.`);
  } catch (error) {
    await saveLogProtocol(syncParams.syncid, 0, 1, 'Autosinc', `Task Documents Errored: ${error.message}`);
  }
  // завершение работы автосинхронизации
  syncParams.finishTime = new Date();
  await saveLogProtocol(syncParams.syncid, 0, 0, 'Autosinc', `Finished Batch ${syncParams.finishTime.toString()}`);
  await finishSync(syncParams);

}
