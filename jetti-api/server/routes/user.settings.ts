import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { IAccount, IJWTPayload } from '../models/common-types';
import { MSSQL } from '../mssql';
import { FormListSettings, UserDefaultsSettings } from './../models/user.settings';
import { ACCOUNTS_POOL } from '../sql.pool.accounts';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

export function User(req: Request): IJWTPayload {
  return (<any>req).user as IJWTPayload;
}

router.get('/user/roles', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const email = User(req);
    const sdba = new MSSQL({email: '', isAdmin: true, description: '', env: {}, roles: []}, ACCOUNTS_POOL);
    const query = `select JSON_QUERY(data, '$') data from "accounts" where id = @p1`;
    const result = await sdba.oneOrNone<{data: IAccount}>(query, [email.email]);
    res.json(result ? result.data && result.data.roles : []);
  } catch (err) { next(err); }
});

router.get('/user/settings/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const sdb = SDB(req);
    const query = `select JSON_QUERY(settings, '$."${req.params.type}"') data from users where email = @p1`;
    const result = await sdb.oneOrNone<{ data: FormListSettings }>(query, [user.email]);
    res.json(result ? result.data : new FormListSettings());
  } catch (err) { next(err); }
});

router.post('/user/settings/:type', async (req, res, next) => {
  try {
    const user = User(req);
    const sdb = SDB(req);
    const data = req.body || {};
    const query = `update users set settings = JSON_MODIFY(settings, '$."${req.params.type}"', JSON_QUERY(@p1)) where email = @p2`;
    await sdb.none(query, [JSON.stringify(data), user.email]);
    res.json(true);
  } catch (err) { next(err); }
});

router.get('/user/settings/defaults', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const sdb = SDB(req);
    const query = `select JSON_QUERY(settings, '$."defaults"') data from users where email = @p1`;
    const result = await sdb.oneOrNone<{ data: UserDefaultsSettings }>(query, [user.email]);
    res.json(result ? result.data : new UserDefaultsSettings());
  } catch (err) { next(err); }
});

router.post('/user/settings/defaults', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = User(req);
    const sdb = SDB(req);
    const data = req.body || new UserDefaultsSettings();
    const query = `update users set settings = JSON_MODIFY(settings, '$."defaults"', JSON_QUERY(@p1)) where email = @p2`;
    await sdb.none(query, [JSON.stringify(data), user.email]);
    res.json(true);
  } catch (err) { next(err); }
});
