//
// проведение документов из очереди.
//
import axios, { AxiosInstance } from 'axios';
import { Agent } from 'https';
import {
	ISyncParams,
	getSyncParams,
	saveSyncParams,
	saveLogProtocol,
	finishSync,
	GetSqlConfig,
} from './iiko-to-jetti-connection';
import { SQLClient } from '../sql/sql-client';
import { SQLPool } from '../sql/sql-pool';

const syncStage = 'QueuePost'; // этап синхронизации

export async function getQueueInstanceAPIByQueueId(
	spi: ISyncParams,
): Promise<{ instance: AxiosInstance; token: string }> {
	const host = spi.project.baseURL;
	const instance = axios.create({ baseURL: host });
	const query = 'exchange/login'; // `auth/token`;
	try {
		const res = await instance.post(query, spi.project.authParams, {
			httpsAgent: new Agent({
				rejectUnauthorized: false,
			}),
		});
		return { instance: instance, token: `Bearer ${res.data.token}` };
	} catch (error) {
		throw new Error(`Error on getting queue instance: ${error.message}`);
	}
}

async function QueuePostJetti(sp: ISyncParams) {
	const wt = Date.now();
	const dsql = new SQLClient(new SQLPool(await GetSqlConfig(sp.destination))); // база приемник
	let wf = true;
	// минимальный размер блока 100, максимальный 5000
	let bsz = 100;
	if (sp.execFlag > 100) bsz = sp.execFlag;
	if (sp.execFlag > 5000) bsz = 5000;
	const queueInstance = await getQueueInstanceAPIByQueueId(sp);
	let ic = 2;
	while (wf) {
		// выбираем пачками по bsz документов
		const docs: any[] = await dsql.manyOrNone(
			`
      SELECT top (cast(@p1 as int)) [id], min([Attempts]) as Attempts, max([Date]) as [date]
      FROM [exc].[QueuePost] where flow=@p2
      group by [id]
      having min([Attempts]) = @p3 `,
			[bsz, sp.flow, ic],
		);
		if (docs.length === 0) ic = ic - 1;
		if ((docs.length === 0 && ic === -1) || Date.now() - wt > 40 * 60 * 1000) {
			wf = false; // очередь закончилась или мы проводим больше 40 минут
		}
		if (docs.length > 0) {
			// цикл обработки пачки документов
			let pcnt = 0;
			let ecnt = 0;
			for (const row of docs) {
				await queueInstance.instance
					.get(`${sp.project.baseURL}/${sp.project.queuePostURL}/${row.id}`, {
						headers: { Authorization: queueInstance.token },
						httpsAgent: new Agent({
							rejectUnauthorized: false,
						}),
					})
					.then(async (response) => {
						if (sp.logLevel > 2)
							await saveLogProtocol(
								sp.syncid,
								0,
								0,
								syncStage,
								`Posted document id=${row.id}. Status=${response.status}`,
							);
						await dsql.none(`delete from [exc].[QueuePost] where id = @p1 `, [
							row.id,
						]); // удаляем из очереди
						pcnt = pcnt + 1;
					})
					.catch(async (error) => {
						await saveLogProtocol(
							sp.syncid,
							0,
							1,
							syncStage,
							`Error posting document id=${row.id}: ${error.message}. Status=${error.response.status}. ${error.response.data}`,
						);
						await dsql.none(
							`
              update [exc].[QueuePost]
              set [Attempts]=[Attempts]+1, [Message]=@p1
              where id = @p2 and date <= @p3`,
							[error.response.data, row.id, row.date],
						); // счетчик ошибок
						ecnt = ecnt + 1;
					});
			}
			if (sp.logLevel > 0)
				await saveLogProtocol(
					sp.syncid,
					0,
					ecnt,
					syncStage,
					`Processed ${pcnt + ecnt} Docs. ${pcnt} Posted, ${ecnt} Errors`,
				);
		}
	}
}

export async function QueuePost(params: any) {
	try {
		const syncParams: ISyncParams = await getSyncParams(params);
		await saveSyncParams(syncParams);
		await saveLogProtocol(
			syncParams.syncid,
			0,
			0,
			syncStage,
			`Post queue documents Jetti: ${syncParams.project.id}. Flow ${syncParams.flow}`,
		);
		await saveLogProtocol(
			syncParams.syncid,
			0,
			0,
			syncStage,
			`Starting Batch ${syncParams.startTime.toString()}`,
		);
		if (syncParams.project.baseURL !== '') {
			await QueuePostJetti(syncParams);
		} else
			await saveLogProtocol(
				syncParams.syncid,
				0,
				1,
				syncStage,
				`Error: no documents post module for project ${syncParams.projectid}`,
			);
		syncParams.finishTime = new Date();
		await saveLogProtocol(
			syncParams.syncid,
			0,
			0,
			syncStage,
			`Finished Batch ${syncParams.finishTime.toString()}`,
		);
		await finishSync(syncParams);
	} catch (error) {
		throw new Error(error);
	}
}
