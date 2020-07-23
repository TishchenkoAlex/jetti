import { RegisteredSyncFunctions } from './../fuctions/syncFunctionsMeta';
import { ISyncParams } from './../exchange/iiko-to-jetti-connection';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import {
	JQueue,
	IDeleteTaskParams,
	getJobs,
	removeJobs,
	removeJobsALL,
	removeJobsRepeatable,
} from '../Tasks/task';

export const router = express.Router();

interface RepeatOpts {
	cron?: string; // Cron string
	tz?: string; // Timezone
	startDate?: Date | string | number; // Start date when the repeat job should start repeating (only with cron).
	endDate?: Date | string | number; // End date when the repeat job should stop repeating.
	limit?: number; // Number of times the job should repeat at max.
	every?: number; // Repeat every millis (cron setting cannot be used together with this setting.)
	count?: number; // The start value for the repeat iteration count.
}

interface JobOpts {
	priority?: number; // Optional priority value. ranges from 1 (highest priority) to MAX_INT  (lowest priority). Note that
	// using priorities has a slight impact on performance, so do not use it if not required.

	delay?: number; // An amount of miliseconds to wait until this job can be processed. Note that for accurate delays, both
	// server and clients should have their clocks synchronized. [optional].

	attempts?: number; // The total number of attempts to try the job until it completes.

	repeat?: RepeatOpts; // Repeat job according to a cron specification.

	lifo?: boolean; // if true, adds the job to the right of the queue instead of the left (default false)
	timeout?: number; // The number of milliseconds after which the job should be fail with a timeout error [optional]

	jobId?: number | string; // Override the job ID - by default, the job ID is a unique
	// integer, but you can use this setting to override it.
	// If you use this option, it is up to you to ensure the
	// jobId is unique. If you attempt to add a job with an id that
	// already exists, it will not be added.

	removeOnComplete?: boolean | number; // If true, removes the job when it successfully
	// completes. A number specified the amount of jobs to keep. Default behavior is to keep the job in the completed set.

	// tslint:disable-next-line: max-line-length
	removeOnFail?: boolean | number; // If true, removes the job when it fails after all attempts. A number specified the amount of jobs to keep
	// Default behavior is to keep the job in the failed set.
	stackTraceLimit?: number; // Limits the amount of stack trace lines that will be recorded in the stacktrace.
}

router.post('/add', async (req: Request, res: Response, next: NextFunction) => {
	try {
		const { params, opts } = req.body;

		const repeatCron = opts.Cron
			? { cron: opts.Cron, startDate: new Date() }
			: undefined;
		if (repeatCron && opts.StartDate) {
			repeatCron.startDate = new Date(opts.StartDate);
		}
		const repeatEvery = opts.every ? { every: opts.every } : undefined;

		const data = {
			job: {
				id: params.docid,
				description: params.syncFunctionName,
				info: params.info,
			},
			params: params,
		};

		const jobOpts: JobOpts = {
			attempts: opts.attempts || 1,
			repeat: repeatCron || repeatEvery,
			delay: opts.delay || 0,
			priority: opts.priority || 1,
		};

		if (opts.endDate && jobOpts.repeat)
			jobOpts.repeat.endDate = new Date(opts.endDate);

		const job = await JQueue.add(data, jobOpts);

		res.json(job);
	} catch (err) {
		res.status(500).json(err.toString());
		next(err);
	}
});

router.post('/get', async (req: Request, res: Response, next: NextFunction) => {
	try {
		throw new Error('simple test err');
		const jobs = await getJobs(req.body);
		res.json(jobs);
	} catch (err) {
		res.status(500).json(err.toString());
		next(err);
	}
});

router.post(
	'/delete',
	async (req: Request, res: Response, next: NextFunction) => {
		try {
			const params = req.body as IDeleteTaskParams;
			if (params.All) await removeJobsALL();
			if (params.Repeatable && params.Repeatable.length)
				await removeJobsRepeatable(params.Repeatable);
			if (params.Jobs && params.Jobs.length) await removeJobs(params.Jobs);
			res.json('OK');
		} catch (err) {
			res.status(500).json(err.toString());
			next(err);
		}
	},
);

export async function execJob(job) {
	const params = job.data.params as ISyncParams;

	const syncFunction = RegisteredSyncFunctions().get(params.syncFunctionName!);
	if (!syncFunction) {
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
