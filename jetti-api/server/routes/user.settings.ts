import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { IAccount } from '../models/api';
import { sdb, sdba } from '../mssql';
import { FormListSettings, UserDefaultsSettings } from './../models/user.settings';

export const router = express.Router();

export function User(req: Request): string {
  return (<any>req).user.email;
}

router.get('/user/roles', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const email = User(req);
    const query = `select JSON_QUERY(data, '$') data from "accounts" where id = @p1`;
    const result = await sdba.oneOrNone<{data: IAccount}>(query, [email]);
    res.json(result ? result.data && result.data.roles : []);
  } catch (err) { next(err); }
});

router.get('/user/settings/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const query = `select JSON_QUERY(settings, '$."${req.params.type}"') data from users where email = @p1`;
    const result = await sdb.oneOrNone<{ data: FormListSettings }>(query, [user]);
    res.json(result ? result.data : new FormListSettings());
  } catch (err) { next(err); }
});

router.post('/user/settings/:type', async (req, res, next) => {
  try {
    const user = User(req);
    const data = req.body || {};
    const query = `update users set settings = JSON_MODIFY(settings, '$."${req.params.type}"', JSON_QUERY(@p1)) where email = @p2`;
    await sdb.none(query, [JSON.stringify(data), user]);
    res.json(true);
  } catch (err) { next(err); }
});

router.get('/user/settings/defaults', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const query = `select JSON_QUERY(settings, '$."defaults"') data from users where email = @p1`;
    const result = await sdb.oneOrNone<{ data: UserDefaultsSettings }>(query, [user]);
    res.json(result ? result.data : new UserDefaultsSettings());
  } catch (err) { next(err); }
});

router.post('/user/settings/defaults', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const data = req.body || new UserDefaultsSettings();
    const query = `update users set settings = JSON_MODIFY(settings, '$."defaults"', JSON_QUERY(@p1)) where email = @p2`;
    await sdb.none(query, [JSON.stringify(data), user]);
    res.json(true);
  } catch (err) { next(err); }
});
