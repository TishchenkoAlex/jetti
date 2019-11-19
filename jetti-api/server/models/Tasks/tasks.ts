import * as Queue from 'bull';
import { QueueOptions } from 'bull';
import { DB_NAME, REDIS_DB_HOST } from '../../env/environment';
import { userSocketsEmit } from '../../sockets';
import { IJob } from '../common-types';
import cost from './cost';
import post from './post';
import batch from './batch';
import sync from './sync';

export const Jobs: { [key: string]: (job: Queue.Job) => Promise<void> } = {
  post: post,
  cost: cost,
  batch: batch,
  sync: sync
};

const QueOpts: QueueOptions = {
  redis: {
    host: REDIS_DB_HOST,
    maxRetriesPerRequest: null,
    enableReadyCheck: false
  },
  prefix: DB_NAME,
};

export let JQueue = new Queue(DB_NAME, QueOpts);

JQueue.process(5, job => {
  const task = Jobs[job.data.job.id];
  if (task) return task(job);
});

JQueue.on('error', err => {
  console.log('queue error', err.message);
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

JQueue.on('stalled', job => {
  job.data.message = `${job.data.job.id} is stalled`;
  const MapJob = mapJob(job);
  MapJob.finishedOn = new Date().getTime();
  userSocketsEmit(job.data.user, job.data.job.id, MapJob);
});

export function mapJob(j: Queue.Job) {
  const result: IJob = {
    id: j.id.toString(),
    progress: (<any>j)._progress,
    opts: (<any>j).opts,
    delay: (<any>j).delay,
    timestamp: (<any>j).timestamp,
    returnvalue: (<any>j).returnvalue,
    attemptsMade: (<any>j).attemptsMade,
    failedReason: (<any>j).failedReason,
    finishedOn: (<any>j).finishedOn,
    processedOn: (<any>j).processedOn,
    message: j.data.message,
    data: {...j.data,  message: j.data.message }
  };
  return result;
}
