import * as Queue from 'bull';
import { DB_NAME, REDIS_DB_HOST, REDIS_DB_AUTH } from '../../env/environment';
import { userSocketsEmit } from '../../sockets';
import { IJob } from '../common-types';
import sync from './sync';
import { RedisOptions } from 'ioredis';
import * as os from 'os';

export const Jobs: { [key: string]: (job: Queue.Job) => Promise<void> } = {
  sync: sync
};

const redis: RedisOptions = {
  host: REDIS_DB_HOST,
  password: REDIS_DB_AUTH,
  maxRetriesPerRequest: null,
  connectTimeout: 180000
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
  redis, prefix: DB_NAME, defaultJobOptions, settings, limiter
};

export const JQueue = new Queue(DB_NAME, options);

export const processId = () => `${os.hostname()}:${process.pid}`;

JQueue.process(1, job => {
  if (job.data.processId && job.data.processId === processId() ) return null;
  const task = Jobs[job.data.job.id];
  if (task) return task(job);
});

JQueue.on('error', err => {
  console.error('queue error', err.message);
});

JQueue.on('active', (job, jobPromise) => {
  job.data.message = `${job.data.job.id} is active`;
  userSocketsEmit(job.data.user, job.data.job.id, mapJob(job));
});

JQueue.on('failed', (job, err) => {
  job.data.message = `${job.data.job.id} failed, ${err.message}`;
  const MapJob = mapJob(job);
  MapJob.failedReason = err.message;
  MapJob.finishedOn = new Date().getTime();
  userSocketsEmit(job.data.user, job.data.job.id, MapJob);
});

JQueue.on('progress', (job, progress: number) => {
  userSocketsEmit(job.data.user, job.data.job.id, mapJob(job));
});

JQueue.on('completed', job => {
  job.data.message = `${job.data.job.id} completed`;
  const MapJob = mapJob(job);
  MapJob.finishedOn = new Date().getTime();
  userSocketsEmit(job.data.user, job.data.job.id, MapJob);
});

JQueue.on('removed', job => {
  job.data.message = `${jobFullDescription(job)}"  is removed`;
  const MapJob = mapJob(job);
  MapJob.finishedOn = new Date().getTime();
  userSocketsEmit(job.data.user, job.data.job.id, MapJob);
});

JQueue.on('stalled', job => {
  job.data.message = `${job.data.job.id} is stalled`;
  const MapJob = mapJob(job);
  MapJob.finishedOn = new Date().getTime();
  userSocketsEmit(job.data.user, job.data.job.id, MapJob);
});

export function jobFullDescription(j: Queue.Job): string {
  return `${j.data.job.id}:${j.id} "${j.data.job.description}"`;
}

export function mapJob(j: Queue.Job) {
  const job = j.toJSON();
  const result: IJob = {
    id: job.id.toString(),
    progress: job.progress,
    opts: job.opts,
    delay: job.delay,
    timestamp: job.timestamp,
    returnvalue: job.returnvalue,
    attemptsMade: job.attemptsMade,
    failedReason: job.failedReason,
    finishedOn: job.finishedOn!,
    processedOn: job.processedOn!,
    message: job.data.message,
    data: { ...job.data, message: job.data.message }
  };
  return result;
}
