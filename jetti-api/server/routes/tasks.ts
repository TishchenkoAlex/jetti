import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { IJobs } from '../models/common-types';
import { JQueue, mapJob } from '../models/Tasks/tasks';
import { User } from '../routes/user.settings';
import { SDB } from './middleware/db-sessions';
import { lib } from '../std.lib';

export const router = express.Router();

router.post('/jobs/add', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdbq = SDB(req);
    await sdbq.tx(async tx => {
      try {
        await lib.util.postMode(true, tx);
        req.body.data.user = User(req);
        req.body.data.userId = User(req).email;
        req.body.data.tx = tx;
        const result = await JQueue.add(req.body.data, req.body.opts);
        res.json(mapJob(result));
      } catch (err) { throw err; }
      finally { await lib.util.postMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.get('/jobs', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const all = await Promise.all([
      JQueue.getActive(),
      JQueue.getCompleted(),
      JQueue.getDelayed(),
      JQueue.getFailed(),
      JQueue.getWaiting(),
    ]);
    const result: IJobs = {
      Active: all[0].map(el => mapJob(el)),
      Completed: all[1].map(el => mapJob(el)),
      Delayed: all[2].map(el => mapJob(el)),
      Failed: all[3].map(el => mapJob(el)),
      Waiting: all[4].map(el => mapJob(el)),
    };
    result.Completed.length = Math.min(5, result.Completed.length);
    result.Delayed.length = Math.min(5, result.Delayed.length);
    result.Failed.length = Math.min(5, result.Failed.length);
    result.Waiting.length = Math.min(5, result.Waiting.length);
    res.json(result);
  } catch (err) { next(err); }
});

router.get('/jobs/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const job = await JQueue.getJob(req.params.id);
    res.json(mapJob(job!));
  } catch (err) { next(err); }
});

