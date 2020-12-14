import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { IJWTPayload } from '../models/common-types';
import { UserSettingsManager } from './../models/user.settings';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

export function User(req: Request): IJWTPayload {
  return (<any>req).user as IJWTPayload;
}

router.get('/user/settings/:type/:user', async (req: Request, res: Response, next: NextFunction) => {
  try {
    // const user = User(req);
    const sdb = SDB(req);
    res.json(await UserSettingsManager.getSettings({
      type: req.params.type || '',
      user: req.params.user || '',
      description: req.body.description || '',
      id: req.body.id || ''
    }, sdb));
  } catch (err) { next(err); }
});

// router.post('/user/settings', async (req, res, next) => {
//   try {
//     res.json(await UserSettingsManager.saveSettingsArray(req.body, SDB(req)));
//   } catch (err) { next(err); }
// });

router.post('/user/settings', async (req, res, next) => {
  try {
    switch (req.body.command) {
      case 'save':
        res.json(await UserSettingsManager.saveSettingsArray(req.body.settings, SDB(req)));
        break;
      case 'delete':
        await UserSettingsManager.deleteSettingsById(req.body.id, SDB(req));
        res.json({});
        break;
      default:
        res.status(405);
        res.json({ error: 'unknow command: ' + req.body.command });
        break;
    }
  } catch (err) { next(err); }
});

router.get('/user/roles', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const sdb = SDB(req);
    const result = ['Admin'];
    res.json(result);
  } catch (err) { next(err); }
});
