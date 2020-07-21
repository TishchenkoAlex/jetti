import { RegisteredSyncFunctions } from './../fuctions/syncFunctionsMeta';
import * as Queue from 'bull';
import { ISyncParams } from '../exchange/iiko-to-jetti-connection';

const onError = async (job, text) => {
	job.data.message = text;
	await job.update(job.data);
	await job.progress(0);
};

export default async function (job: Queue.Job) {
	const params = job.data.params as ISyncParams;

	if (!params.syncFunctionName) {
		onError(job, `Sync function is nod defined`);
		return;
	}
	const syncFunction = RegisteredSyncFunctions().get(params.syncFunctionName);
	if (!syncFunction) {
		onError(job, `Unknow sync function ${params.syncFunctionName}`);
		return;
	}

	try {
		await syncFunction(params);
		await job.progress(100);
	} catch (ex) {
		throw ex;
	} finally {
	}
}
