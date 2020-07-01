import { RegisteredSyncFunctions } from './../fuctions/syncFunctionsMeta';
import { ISyncParams } from './../exchange/iiko-to-jetti-connection';
import { Jobs } from './../Tasks/task';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { JQueue } from '../Tasks/task';
import { SQLPool } from '../sql/sql-pool';
import { SQLClient } from '../sql/sql-client';
import { ExchangeSqlConfig } from '../exchange/iiko-to-jetti-connection';
import { AutosincIkoToJetty } from '../exchange/iiko-to-jetti-autosync';

export const router = express.Router();

router.post('/add', async (req: Request, res: Response, next: NextFunction) => {
  try {

    let { params, opts } = req.body;

    const repeatCron = opts.Cron ? { cron: opts.Cron, startDate: opts.StartDate as Date } : undefined;
    const repeatEvery = opts.Every ? { every: opts.Every * 1000 * 60 } : undefined;

    const data = {
      job: { id: params.docid, description: `${params.syncFunctionName}` },
      params: params
    };

    opts = {
      attempts: opts.Attempts || 1,
      repeat: repeatCron || repeatEvery
    };

    if (opts.Delay) opts.delay = opts.Delay * 1000 * 60;

    // const job = await JQueue.add(data, opts);
    // await execJob(job);
    // return;

    res.json(await JQueue.add(data, opts));

  } catch (err) { next(err); }
});


export async function execJob(job) {
  const params = job.data.params as ISyncParams;

  const syncFunction = RegisteredSyncFunctions().get(params.syncFunctionName!);
  if (!syncFunction) {
    return;
  }

  try {
    await syncFunction(params);
    await job.progress(100);
  } catch (ex) { throw ex; }
  finally {

  }
}
