import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { AccountRegister } from '../models/account.register';
import { createRegisterAccumulation, RegisterAccumulationTypes } from '../models/Registers/Accumulation/factory';
import { RegisterAccumulation, RegisterAccumulationOptions } from '../models/Registers/Accumulation/RegisterAccumulation';
import { createRegisterInfo, RegisterInfoTypes } from '../models/Registers/Info/factory';
import { RegisterInfo, RegisterInfoOptions } from '../models/Registers/Info/RegisterInfo';
import { sdb } from '../mssql';
import { User } from './user.settings';

export const router = express.Router();

router.get('/register/account/movements/view/:id', async (req, res, next) => {
  try {
    await sdb.tx(async tx => {
      const query = `SELECT * FROM "Register.Account.View" where "document.id" = @p1`;
      const data = await tx.manyOrNoneFromJSON<AccountRegister>(query, [req.params.id]);
      res.json(data);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/accumulation/list/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<{ type: RegisterAccumulationTypes }>(`
        SELECT DISTINCT r.type "type" FROM "Accumulation" r
        WHERE r.document = @p1`, [req.params.id]);
      const list = result.map(r => {
        const regiter = createRegisterAccumulation(r.type, true, {});
        const description = (regiter.Prop() as RegisterAccumulationOptions).description;
        return ({ type: r.type, description });
      });
      res.json(list);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/info/list/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<{ type: RegisterInfoTypes }>(`
        SELECT DISTINCT r.type "type" FROM "Register.Info" r
        WHERE r.document = @p1`, [req.params.id]);
      const list = result.map(r => {
        const description = (createRegisterInfo(r.type, {}).Prop() as RegisterInfoOptions).description;
        return ({ type: r.type, description });
      });
      res.json(list);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/accumulation/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      let result: RegisterAccumulation[]; let config_schema;
      const JRegister = createRegisterAccumulation(req.params.type as RegisterAccumulationTypes, true, {});
      config_schema = { queryObject: JRegister.QueryList() };
      result = await tx.manyOrNone<RegisterAccumulation>(`${config_schema.queryObject} AND r.document = @p1`, [req.params.id]);
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/info/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      let result: RegisterInfo[]; let config_schema;
      const JRegister = createRegisterInfo(req.params.type as RegisterInfoTypes, {});
      config_schema = { queryObject: JRegister.QueryList() };
      result = await tx.manyOrNone<RegisterInfo>(`${config_schema.queryObject} AND r.document = @p1`, [req.params.id]);
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

