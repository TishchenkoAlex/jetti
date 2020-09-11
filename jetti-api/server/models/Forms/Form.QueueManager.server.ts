import { JQueue, processId } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { FormQueueManager } from './Form.QueueManager';
import * as Bull from 'bull';
import { lib } from '../../std.lib';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { MSSQL } from '../../mssql';

export default class FormQueueManagerServer extends FormQueueManager implements IServerForm {
  async Execute() {

    // const activeJobs = await JQueue.getActive();
    // const jobs = activeJobs.filter(j => j.data.job.id === `sync` && j.data.company === row.company);
    // if (jobs.length === 0) await JQueue.add(data, { attempts: 3, priority: 100 });

    return this;
  }

  getTX(): MSSQL {
    return new MSSQL(TASKS_POOL, this.user);
  }

  async suspendJobs() {
    await JQueue.pause();
    await this.getJobsStat();
  }

  async processJobs() {
    await JQueue.resume();
    await this.getJobsStat();
  }

  async getWorkers() {
    const work = await JQueue.getWorkers();
  }

  // async cancelJobsAll() {
  //   await this.removeJobs((this['AnyTable'] as any)
  //     .map(e => e.code));
  // }

  // async cancelJobsSelected() {
  //   await this.removeJobs((this['AnyTable'] as any)
  //     .filter(e => e['selected'])
  //     .map(e => e.code));
  // }


  // async cancelJobs(jobsCodes: string[]) {
  //   await JQueue.whenCurrentJobsFinished();
  //   for (const jobCode of jobsCodes) {
  //     const job = await JQueue.getJob('' + jobCode);
  //     if (!job) continue;
  //     job.moveToFailed({ message: `Canceled by ${this.user}` });
  //   }
  //   await this.getJobsStat();
  // }

  async removeJobsAll() {
    if (this.QueueId === 'JETTI') {
      await this.removeJobs((this.JobsStat)
        .map(e => e.code));
    } else {
      await lib.queue.deleteTasks(this.QueueId, { All: true });
    }

    await this.getJobsStat();
  }

  async removeJobsSelected() {
    const repeatableKeys = this.Repeatable.filter(e => e.flag).map(e => e.key);
    const jobsCodes = this.JobsStat.filter(e => e['selected']).map(e => e.code);

    if (this.QueueId === 'JETTI') {
      await this.removeJobs(jobsCodes);
      await this.removeJobsRepeatable(repeatableKeys);
      setTimeout(() => { }, 2000);
    } else {
      await lib.queue.deleteTasks(this.QueueId,
        {
          All: false
          , Repeatable: repeatableKeys
          , Jobs: jobsCodes
        });
    }
    await this.getJobsStat();
  }

  async removeJobsRepeatable(jobsKeys: string[]) {
    jobsKeys.forEach(async key => await JQueue.removeRepeatableByKey(key));
  }

  async removeJobs(jobsCodes: string[]) {
    await JQueue.whenCurrentJobsFinished();
    for (const jobCode of jobsCodes) {
      const job = await JQueue.getJob('' + jobCode);
      if (!job) continue;
      job.remove();
    }
  }

  async getRepeatableJobs() {
    this.Repeatable = ((await JQueue.getRepeatableJobs()) as any)
      .map(job => ({
        ...job,
        id: job.id || '',
        flag: false,
        endDate: job.endDate ? new Date(job.endDate) : null,
        everyMin: job.every ? job.every / 1000 / 60 : 0,
        everyString: job.every ? msToTime(job.every) : ''
      }));
  }

  async getJobsStatJETTI() {

    await this.getRepeatableJobs();

    const jobsStatus = this.Status !== 'all' ? [this.Status] : ['completed', 'waiting', 'active', 'delayed', 'failed'];
    const result: any[] = [];

    for (const status of jobsStatus) {
      let jobs = (await JQueue.getJobs([status as any])).filter(e => e);
      if (this.StartDate && this.EndDate) {
        const dates = { start: this.StartDate!.valueOf(), end: this.EndDate!.valueOf() };
        jobs = jobs.filter(e => (!e.processedOn || (e.processedOn && e.processedOn > dates.start))
          && (!e.finishedOn || (e.finishedOn && e.finishedOn < dates.end)));
      }
      for (const job of jobs) {
        result.push(mapJob(job, status));
      }
    }

    result.sort((a, b) => b.code - a.code);
    this.JobsStat = result;

  }

  async getJobsStat() {
    if (this.QueueId === 'JETTI') {
      await this.getJobsStatJETTI();
      return;
    }
    const jobStats = await lib.queue.getTasks(this.QueueId,
      {
        EndDate: this.EndDate ? this.EndDate : undefined,
        StartDate: this.StartDate ? this.StartDate : undefined,
        Status: this.Status as any
      }
    );
    this.Repeatable = jobStats.repeatable;
    this.JobsStat = jobStats.jobs;
  }

  async addJobCustomTask() {

    const procId = processId();
    const tx = this.getTX();
    const serverDoc = await lib.doc.createDocServerById(this.CustomTask as string, tx);
    if (!serverDoc) throw Error(`Task operation not defined`);

    const repeatCron = this.CronExpression ? { cron: this.CronExpression, startDate: this.StartDate as Date } : undefined;
    const repeatEvery = this.Every ? { every: this.Every * 1000 * 60 } : undefined;

    const data = {
      job: { id: `customTask`, description: `Custom task: ${serverDoc.description}` },
      user: this.user.description,
      processId: procId,
      TaskOperation: this.CustomTask
    };

    const opts: Bull.JobOptions = {
      attempts: this.Attempts || 1,
      repeat: repeatCron || repeatEvery
    };

    if (this.Delay) opts.delay = this.Delay * 1000 * 60;

    const beforeTaskAdd: (args: { [key: string]: any }) => Promise<void> = serverDoc['serverModule']['beforeTaskAdd'];
    if (typeof beforeTaskAdd === 'function') await beforeTaskAdd({ jobData: data, opts: opts });

    let job: Bull.Job;
    if (this.JobName) job = await JQueue.add(this.JobName, data, opts);
    else job = await JQueue.add(data, opts);

    const afterTaskAdd: (args: { [key: string]: any }) => Promise<void> = serverDoc['serverModule']['afterTaskAdd'];
    if (typeof afterTaskAdd === 'function') await afterTaskAdd({ job: job });

  }

}

const mapJob = (job: Bull.Job, status: string) => {
  return {
    code: job.id,
    status: status,
    progress: job.progress(),
    attemptsMade: job.attemptsMade,
    failedReason: (job as any).failedReason,
    processedOn: job.processedOn ? new Date(job.processedOn) : null,
    finishedOn: job.finishedOn ? new Date(job.finishedOn) : null,
    duration: msToTime(job.processedOn ? ((job.finishedOn ? job.finishedOn : Date.now()) - job.processedOn) : 0),
    ...getInnerJobProps(job)
  };
};

const getInnerJobProps = (job: Bull.Job) => {
  const res = {
    ...job.data ? job.data : {},
    ...job.data.job ? job.data.job : {},
    ...job.opts ? job.opts : {},
    ...job.opts.repeat ? job.opts.repeat : {}
  };
  if (res.delay) res.delay = res.delay / 1000 / 3600;
  delete res.job;
  delete res.timestamp;
  delete res.prevMillis;
  delete res.EndDate;
  return res;
};

function msToTime(s: number): string {

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
