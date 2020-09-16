import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { lib } from './../std.lib';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

router.post('/accum/balance', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { registerName, date, fields, groupBy, filter, topRows } = req.body;
    res.json(await lib.accum.balance(registerName, date, fields, groupBy, filter, topRows));
  } catch (err) { next(err); }
});

router.post('/accum/turnover', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { registerName, period, fields, groupBy, filter, topRows } = req.body;
    res.json(await lib.accum.turnover(registerName, period, fields, groupBy, filter, topRows));
  } catch (err) { next(err); }
});

router.post('/info/sliceLast', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { type, date, company, analytics } = req.body;
    res.json(await lib.info.sliceLast(type, date, company, analytics, SDB(req)));
  } catch (err) { next(err); }
});
