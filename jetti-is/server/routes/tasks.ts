import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { JQueue } from '../Tasks/task';
import { SQLPool } from '../sql/sql-pool';
import { SQLClient } from '../sql/sql-client';
import { ExchangeSqlConfig } from '../exchange/iiko-to-jetti-connection';

export const router = express.Router();

router.post('/add', async (req: Request, res: Response, next: NextFunction) => {
  try {

    // const exchangeSQLAdmin = new SQLPool(ExchangeSqlConfig);
    // const esql = new SQLClient(exchangeSQLAdmin);
    // await esql.oneOrNone(`INSERT INTO dbo.projects (id,  description) VALUES ('test', 'test')`);
    // return;

    let { params, opts } = req.body;

    const repeatCron = opts.Cron ? { cron: opts.Cron, startDate: opts.StartDate as Date } : undefined;
    const repeatEvery = opts.Every ? { every: opts.Every * 1000 * 60 } : undefined;

    const data = {
      job: { id: params.syncid, description: `${params.syncFunctionName}` },
      params: params
    };

    opts = {
      attempts: opts.Attempts || 1,
      repeat: repeatCron || repeatEvery
    };

    if (opts.Delay) opts.delay = opts.Delay * 1000 * 60;

    res.json(await JQueue.add(data, opts));

  } catch (err) { next(err); }
});
