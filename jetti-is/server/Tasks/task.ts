import * as Queue from 'bull';
import { DB_NAME, REDIS_DB_HOST, REDIS_DB_AUTH } from '../env/environment';
import taskExecution from './taskExecution';
import { RedisOptions } from 'ioredis';

export const Jobs: { [key: string]: (job: Queue.Job) => Promise<void> } = {
  taskExecution: taskExecution
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

JQueue.process(async job => {
  await taskExecution(job);
});
