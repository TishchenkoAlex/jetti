import { SQLPool } from './../sql/sql-pool';
import * as Queue from 'bull';
import { DB_NAME, REDIS_DB_HOST, REDIS_DB_AUTH } from '../env/environment';
import taskExecution from './taskExecution';
import { RedisOptions } from 'ioredis';
import { ExchangeSqlConfig } from '../exchange/iiko-to-jetti-connection';
import { SQLClient } from '../sql/sql-client';

const redis: RedisOptions = {
	host: REDIS_DB_HOST,
	password: REDIS_DB_AUTH,
	maxRetriesPerRequest: null,
	connectTimeout: 180000,
};

const defaultJobOptions: Queue.JobOptions = {
	removeOnComplete: false,
	removeOnFail: false,
};

const limiter: Queue.RateLimiter = {
	max: 10000,
	duration: 1000,
	bounceBack: false,
};

const settings: Queue.AdvancedSettings = {
	lockDuration: 600000, // Key expiration time for job locks.
	stalledInterval: 5000, // How often check for stalled jobs (use 0 for never checking).
	maxStalledCount: 2, // Max amount of times a stalled job will be re-processed.
	guardInterval: 5000, // Poll interval for delayed jobs and added jobs.
	retryProcessDelay: 30000, // delay before processing next job in case of internal error.
	drainDelay: 5, // A timeout for when the queue is in drained state (empty waiting for jobs).
};

const options: Queue.QueueOptions = {
	redis,
	prefix: DB_NAME,
	defaultJobOptions,
	settings,
	limiter,
};

export const JQueue = new Queue(DB_NAME, options);

// default job worker
JQueue.process(4, async (job) => await taskExecution(job));

// named workers
JQueue.process('AutosyncIIkoToJetty', 1, async (job) => await taskExecution(job));
JQueue.process('AutosyncSMSQL', 1, async (job) => await taskExecution(job));
JQueue.process('QueuePost', 1, async (job) => await taskExecution(job));
JQueue.process('QueueSyncSMSQL', 1, async (job) => await taskExecution(job));
JQueue.process('QueueTesting', 1, async (job) => await taskExecution(job));

JQueue.on('active', async (job) => {
	await updateJobStat(job, { status: 'active' });
});

JQueue.on('failed', async (job, err) => {
	await updateJobStat(job, { status: 'failed', error: err.message });
});

JQueue.on('progress', async (job, progress: number) => {
	await updateJobStat(job, { status: 'active', progress: progress });
});

JQueue.on('completed', async job => {
	await updateJobStat(job, { status: 'completed' });
});

JQueue.on('removed', async job => {
	await updateJobStat(job, { status: 'removed' });
});

export interface IGetTaskParams {
	StartDate?: Date;
	EndDate?: Date;
	Status?: 'completed' | 'waiting' | 'active' | 'delayed' | 'failed' | 'all';
}
export interface IDeleteTaskParams {
	Repeatable?: string[]; // ключи повторяемых задач
	Jobs?: string[]; // ид задач
	All?: boolean; // все задачи?
}

export async function getRepeatableJobs() {
	return (await JQueue.getRepeatableJobs()).map((job) => ({
		...job,
		id: job.id || '',
		flag: false,
		endDate: job.endDate ? new Date(job.endDate) : null,
		everyMin: job.every ? job.every / 1000 / 60 : 0,
		everyString: job.every ? msToTime(job.every) : '',
		next: job.next ? new Date(job.next) : null,
	}));
}

const allJobsStatus = ['completed', 'waiting', 'active', 'delayed', 'failed'];

const mapJob = (job, status: string) => {
	return {
		code: job.id,
		status: status,
		progress: job.progress(),
		attemptsMade: job.attemptsMade,
		failedReason: (job as any).failedReason,
		processedOn: job.processedOn ? new Date(job.processedOn) : null,
		finishedOn: job.finishedOn ? new Date(job.finishedOn) : null,
		duration: msToTime(
			job.processedOn
				? (job.finishedOn ? job.finishedOn : Date.now()) - job.processedOn
				: 0,
		),
		...getInnerJobProps(job),
	};
};

const getInnerJobProps = (job) => {
	const res = {
		...(job.data ? job.data : {}),
		...(job.data.job ? job.data.job : {}),
		...(job.opts ? job.opts : {}),
		...(job.opts.repeat ? job.opts.repeat : {}),
	};
	if (job.name === '__default__' && job.data.job.description)
		job.name = job.data.job.description;
	if (res.delay) res.delay = res.delay / 1000 / 3600;
	delete res.job;
	delete res.timestamp;
	delete res.prevMillis;
	delete res.EndDate;
	return res;
};

export async function getJobs(
	params: IGetTaskParams,
): Promise<{ repeatable: any[]; jobs: any[] }> {
	const repeatable = await getRepeatableJobs();

	const jobsStatus =
		!params.Status || params.Status === 'all' ? allJobsStatus : [params.Status];
	const jobs: any[] = [];

	for (const status of jobsStatus) {
		let jobsByStatus = (await JQueue.getJobs([status as any])).filter((e) => e);
		if (params.StartDate && params.EndDate) {
			const dates = {
				start: params.StartDate?.valueOf(),
				end: params.EndDate?.valueOf(),
			};
			jobsByStatus = jobsByStatus.filter(
				(e) =>
					(!e.processedOn || (e.processedOn && e.processedOn > dates.start)) &&
					(!e.finishedOn || (e.finishedOn && e.finishedOn < dates.end)),
			);
		}
		for (const job of jobsByStatus) {
			jobs.push(mapJob(job, status));
		}
	}

	jobs.sort((a, b) => b.code - a.code);

	return { repeatable: repeatable, jobs: jobs };
}

export async function removeJobsALL(): Promise<void> {
	await removeJobsRepeatable((await getRepeatableJobs()).map((e) => e.key));
	const allJobsCodes = (await JQueue.getJobs(allJobsStatus))
		.filter((e) => e)
		.map((e) => e.id);
	await removeJobs(allJobsCodes);
}

export async function removeJobsRepeatable(jobsKeys: string[]) {
	jobsKeys.forEach(async (key) => await JQueue.removeRepeatableByKey(key));
}

export async function removeJobs(jobsCodes: string[]) {
	await JQueue.whenCurrentJobsFinished();
	for (const jobCode of jobsCodes) {
		const job = await JQueue.getJob('' + jobCode);
		if (!job) continue;
		job.remove();
	}
}

export function msToTime(s: number): string {
	// Pad to 2 or 3 digits, default is 2

	function pad(n, z = 2) {
		return ('00' + n).slice(-z);
	}

	const ms = s % 1000;
	s = (s - ms) / 1000;
	const secs = s % 60;
	s = (s - secs) / 60;
	const mins = s % 60;
	const hrs = (s - mins) / 60;

	return pad(hrs) + ':' + pad(mins) + ':' + pad(secs) + '.' + pad(ms, 3);
}


const exchangeSQLAdmin = new SQLPool(ExchangeSqlConfig);
const esql = new SQLClient(exchangeSQLAdmin);

export const updateJobStat = async (job, updatedData) => {
	const jobId = job.data.job.id;
	await esql.none(
		`UPDATE dbo.jobStats
        SET
          ${Object.keys(updatedData).map((key, index) => '' + key + ' = @p' + (index + 1)).join(', ')}
		WHERE
			docid = '${jobId}'`, Object.values(updatedData));
};

export const insertJobStat = async (data, jobOpts, status) => {

	await esql.none(
		`INSERT INTO dbo.jobStats
		(created, finished, status, docid, description, info, params, options)
		select created, finished, status, docid, description, info, params, options
		from OPENJSON(@p1) WITH (
		[created] [datetime],
		[finished] [datetime],
		[status] [nvarchar](50),
		[docid] UNIQUEIDENTIFIER,
		[description] nvarchar(150),
		[info] nvarchar(max),
		[params] NVARCHAR(max) N'$.params' AS JSON,
		[options] NVARCHAR(max) N'$.options' AS JSON
		)`,
		[
			JSON.stringify({
				docid: data.job.id,
				created: new Date,
				finished: null,
				status: status,
				description: data.job.description,
				info: data.job.info,
				params: data.params,
				options: jobOpts,
			}),
		],
	);
};