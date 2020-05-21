import { Jobs } from './../Tasks/tasks';
import { JQueue } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { FormQueueManager } from './Form.QueueManager';
import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { Ref } from '../document';
import { JobStatus } from 'bull';
import { delay, duration } from 'tarn/lib/utils';
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

  async cancelJobs() {
    await JQueue.whenCurrentJobsFinished();
    const acitiveJob = await JQueue.getActive();
    for (const job of acitiveJob) {
      await job.remove();
    }
    await this.getJobsStat();
  }

  async cancelSelectedJobs() {
    await JQueue.whenCurrentJobsFinished();
    const selectedJobs = this.AnyTable.filter(e => e['selected']);
    for (const selectedJob of selectedJobs) {
      const job = await JQueue.getJob('' + selectedJob['code']);
      if (!job) continue;
      job.remove();
    }
    await this.getJobsStat();
  }

  async getJobsStat() {

    const jobsStatus: JobStatus[] = ['completed', 'waiting', 'active', 'delayed', 'failed'];
    const result: any[] = [];
    for (const status of jobsStatus) {
      const jobs = await JQueue.getJobs([status]);
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
    if (!this.dynamicProps.find(e => e.SetId === setId)) {
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

  async addJobs() {
    const jobsStatus: JobStatus[] = ['completed', 'waiting', 'active', 'delayed', 'failed'];
    const res = await JQueue.getJobs(jobsStatus);
  }
}
