import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { JQueue } from '../Tasks/task';

export const router = express.Router();

router.post('/add', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const result = await JQueue.add(req.body.data, req.body.opts);
    res.json(result);
  } catch (err) { next(err); }
});
