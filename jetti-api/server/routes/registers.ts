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
    const id = req.params.id;
    const query = `SELECT * FROM "Register.Account.View" where "document.id" = '${id}'`;

    await sdb.tx(async tx => {
      const data = await tx.manyOrNoneFromJSON<AccountRegister>(query);
      res.json(data);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/accumulation/list/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const query = `SELECT DISTINCT r.type "type" FROM "Accumulation" r WHERE r.document = '${id}'`;

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<{ type: RegisterAccumulationTypes }>(query);
      const list = result.map(r => {
        const regiter = createRegisterAccumulation({ type: r.type });
        const description = (regiter.Prop() as RegisterAccumulationOptions).description;
        return ({ type: r.type, description });
      });
      res.json(list);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/info/list/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const query = `SELECT DISTINCT r.type "type" FROM "Register.Info" r WHERE r.document = '${id}'`;

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<{ type: RegisterInfoTypes }>(query);
      const list = result.map(r => {
        const description = (createRegisterInfo({ type: r.type }).Prop() as RegisterInfoOptions).description;
        return ({ type: r.type, description });
      });
      res.json(list);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/accumulation/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const type = req.params.type as RegisterAccumulationTypes;
    const query = createRegisterAccumulation({ type }).QueryList();

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<RegisterAccumulation>(`${query} AND r.document = '${id}'`);
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

router.get('/register/info/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const id = req.params.id;
    const type = req.params.type as RegisterInfoTypes;
    const query = createRegisterInfo({ type }).QueryList();

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<RegisterInfo>(`${query} AND r.document = '${id}'`);
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

