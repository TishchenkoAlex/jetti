// модуль автосинхронизации IIKO - Jetti
import { ISyncParams, getSyncParams, saveSyncParams, saveLogProtocol, finishSync, GetSqlConfig } from './iiko-to-jetti-connection';
import { ImportProductToJetti } from './iiko-to-jetti-catalog-product';
import { ImportCounterpartieToJetti } from './iiko-to-jetti-catalog-counterpartie';
import { ImportPersonToJetti } from './iiko-to-jetti-person';
import { ImportSalesToJetti } from './iiko-to-jetti-sales';
import { SQLClient } from '../sql/sql-client';
import { SQLPool } from '../sql/sql-pool';
///////////////////////////////////////////////////////////
// Автосинхронизация IIKO - Jetti СМ с помощью sql-процедуры в базе x100-data
export async function AutosyncSMSQL(params: any) {

  const syncParams: ISyncParams = await getSyncParams(params);

  await saveSyncParams(syncParams);
  await saveLogProtocol(syncParams.syncid, 0, 0, 'AutosincSM', `SQL-Autosync data IIKO - Jetti: ${syncParams.source.id} ==> ${syncParams.project.id}.`);
  await saveLogProtocol(syncParams.syncid, 0, 0, 'AutosincSM', `Starting Batch ${syncParams.startTime.toString()}`);
  if (syncParams.projectid === 'SM') {
    const dsql = new SQLClient(new SQLPool(await GetSqlConfig(syncParams.destination)));
    const p1 = JSON.stringify(syncParams);
    await dsql.oneOrNone(`EXEC [x100-data].[exc].[iikoAutosync] @p1;`, [p1]);
  } else {
    await saveLogProtocol(syncParams.syncid, 0, 1, 'AutosincSM', `SQL-sync working only SM Prolect.`);
  }
  // завершение работы автосинхронизации
  syncParams.finishTime = new Date();
  await saveLogProtocol(syncParams.syncid, 0, 0, 'AutosincSM', `Finished Batch ${syncParams.finishTime.toString()}`);
  await finishSync(syncParams);
}
///////////////////////////////////////////////////////////
// автозагрузка документов SM из очереди загрузки
export async function QueueSyncSMSQL(params: any) {

  const syncParams: ISyncParams = await getSyncParams(params);

  await saveSyncParams(syncParams);
  await saveLogProtocol(syncParams.syncid, 0, 0, 'AutosincSM', `SQL-Autosync data IIKO - Jetti: ${syncParams.source.id} ==> ${syncParams.project.id}.`);
  await saveLogProtocol(syncParams.syncid, 0, 0, 'AutosincSM', `Starting Batch ${syncParams.startTime.toString()}`);
  if (syncParams.projectid === 'SM') {
    const dsql = new SQLClient(new SQLPool(await GetSqlConfig(syncParams.destination)));
    const p1 = JSON.stringify(syncParams);
    await dsql.oneOrNone(`EXEC [x100-data].[exc].[iikoAutosync] @p1;`, [p1]);
  } else {
    await saveLogProtocol(syncParams.syncid, 0, 1, 'AutosincSM', `SQL-sync working only SM Prolect.`);
  }
  // завершение работы автосинхронизации
  syncParams.finishTime = new Date();
  await saveLogProtocol(syncParams.syncid, 0, 0, 'AutosincSM', `Finished Batch ${syncParams.finishTime.toString()}`);
  await finishSync(syncParams);
}
///////////////////////////////////////////////////////////
// Автосинхронизация IIKO - Jetti
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
///////////////////////////////////////////////////////////
