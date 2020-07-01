import { RegisteredSyncFunctions } from './../fuctions/syncFunctionsMeta';
import { ISyncParams } from './../exchange/iiko-to-jetti-connection';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { JQueue } from '../Tasks/task';

export const router = express.Router();

router.post('/add', async (req: Request, res: Response, next: NextFunction) => {
  try {

    let { params, opts } = req.body;

    const repeatCron = opts.Cron ? { cron: opts.Cron } : undefined;
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

    // await execJob(await JQueue.add(data, opts));
    // return;
    const job = await JQueue.add(data, opts);

    res.json(job);

  } catch (err) {
    res.status(500).json(err);
    next(err);
  }
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
