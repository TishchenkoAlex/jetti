import { ISyncParams, getSyncParams, saveSyncParams, saveLogProtocol, finishSync } from './iiko-to-jetti-connection';
import { ImportRetailClientToJetti } from './smart-to-jetti-catalog-retail-client';
import { parse } from 'path';

// Автосинхронизация Smartass - Jetti
export async function AutosyncSmartToJetty(params: any) {
	console.log(params);
	const syncParams: ISyncParams = await getSyncParams(params);

	await saveSyncParams(syncParams);
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		'Autosinc',
		`Autosync data Smartass - Jetti: ${syncParams.source.id} ==> ${syncParams.project.id}.`,
	);
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		'Autosinc',
		`Starting Batch ${syncParams.startTime.toString()}`,
	);
	const syncFunc: any[] = [];
	// справочники
	syncFunc.push(ImportRetailClientToJetti(syncParams));
	// документы

	try {
		await Promise.all(syncFunc);
		await saveLogProtocol(
			syncParams.syncid,
			0,
			0,
			'Autosinc',
			`All Tasks Complete.`,
		);
	} catch (error) {
		await saveLogProtocol(
			syncParams.syncid,
			0,
			1,
			'Autosinc',
			`Task Errored: ${error.message}`,
		);
	}
	// завершение работы автосинхронизации
	syncParams.finishTime = new Date();
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		'Autosinc',
		`Finished Batch ${syncParams.finishTime.toString()}`,
	);
	await finishSync(syncParams);
}
///////////////////////////////////////////////////////////
