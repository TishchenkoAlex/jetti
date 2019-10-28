import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { IJobs } from '../models/api';
import { JQueue, mapJob } from '../models/Tasks/tasks';
import { sdbq } from '../mssql';
import { User } from '../routes/user.settings';

export const router = express.Router();

router.post('/jobs/add', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdbq.tx(async tx => {
      req.body.data.user = User(req);
      req.body.data.userId = req.body.data.user;
      req.body.data.tx = tx;
      const result = await JQueue.add(req.body.data, req.body.opts);
      res.json(mapJob(result));
    }, User(req));
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

