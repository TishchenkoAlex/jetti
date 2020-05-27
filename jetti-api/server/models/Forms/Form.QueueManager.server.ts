import { JQueue, processId } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { FormQueueManager } from './Form.QueueManager';
import { JobStatus } from 'bull';
import Bull = require('bull');

export default class FormQueueManagerServer extends FormQueueManager implements IServerForm {
  async Execute() {

    // const activeJobs = await JQueue.getActive();
    // const jobs = activeJobs.filter(j => j.data.job.id === `sync` && j.data.company === row.company);
    // if (jobs.length === 0) await JQueue.add(data, { attempts: 3, priority: 100 });

    return this;
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

  async cancelJobsAll() {
    await this.removeJobs((this['AnyTable'] as any)
      .map(e => e.code));
  }

  async cancelJobsSelected() {
    await this.removeJobs((this['AnyTable'] as any)
      .filter(e => e['selected'])
      .map(e => e.code));
  }


  async cancelJobs(jobsCodes: string[]) {
    await JQueue.whenCurrentJobsFinished();
    for (const jobCode of jobsCodes) {
      const job = await JQueue.getJob('' + jobCode);
      if (!job) continue;
      job.moveToFailed({ message: `Canceled by ${this.user}` });
    }
    await this.getJobsStat();
  }

  async removeJobsAll() {
    await this.removeJobs((this['AnyTable'] as any)
      .map(e => e.code));
  }

  async removeJobsSelected() {
    await this.removeJobs((this['AnyTable'] as any)
      .filter(e => e['selected'])
      .map(e => e.code));
  }


  async removeJobs(jobsCodes: string[]) {
    await JQueue.whenCurrentJobsFinished();
    for (const jobCode of jobsCodes) {
      const job = await JQueue.getJob('' + jobCode);
      if (!job) continue;
      job.remove();
    }
    await this.getJobsStat();
  }

  async getJobsStat() {

    const jobsStatus: JobStatus[] = ['completed', 'waiting', 'active', 'delayed', 'failed'];
    const result: any[] = [];
    for (const status of jobsStatus) {
      let jobs = (await JQueue.getJobs([status])).filter(e => e);
      if (this.StartDate && this.EndDate) {
        const dates = { start: this.StartDate?.valueOf(), end: this.EndDate?.valueOf() };
        jobs = jobs.filter(e => (!e.processedOn || (e.processedOn && e.processedOn > dates.start))
          && (!e.finishedOn || (e.finishedOn && e.finishedOn < dates.end)));
      }
      for (const job of jobs) {
        result.push({
          code: +job.id,
          // name: job.name,
          status: status,
          progress: job.progress(),
          attemptsMade: job.attemptsMade,
          processedOn: job.processedOn ? new Date(job.processedOn) : null,
          finishedOn: job.finishedOn ? new Date(job.finishedOn) : null,
          durationSeconds: (job.processedOn ? ((job.finishedOn ? job.finishedOn : Date.now()) - job.processedOn) : 0) / 1000,
          ...this.getInnerJobProps(job)
        });
      }
    }

    const setId = 'getJobsStat';
    if (result.length && !this.dynamicProps.find(e => e.SetId === setId)) {
      // this.DynamicPropsClearSet(setId);
      // this.DynamicPropsPush('add', 'type', 'table', '', 'JobStat', setId);
      this.DynamicPropsPush('add', 'label', 'Jobs stat', '', 'AnyTable', setId);
      this.DynamicPropsPush('add', 'type', 'boolean', 'selected', 'AnyTable', setId);
      this.DynamicPropsPush('add', 'label', ' ', 'selected', 'AnyTable', setId);
      this.DynamicPropsAddForObject(result, 'AnyTable', setId);
    }
    result.sort((a, b) => b.code - a.code);
    this['AnyTable'] = result;

  }

  getInnerJobProps(job: Bull.Job) {
    const res = { ...job.data ? job.data : {}, ...job.data.job ? job.data.job : {} };
    delete res.job;
    delete res.StartDate;
    delete res.EndDate;
    return res;
  }

  async addJobTimeout() {
    const procId = processId();
    const data = {
      job: { id: `timeout`, description: `timeout` },
      user: this.user,
      timeout: this.timeout || 10000,
      processId: procId
    };
    const job = await JQueue.add(data, { attempts: 3, priority: 100 });
  }

  async addJobCustomTask() {
    const procId = processId();
    const data = {
      job: { id: `customTask`, description: `Custom task` },
      user: this.user,
      timeout: this.timeout || 10000,
      processId: procId,
      TaskOperation: this.CustomTask,
    };
  }
}
