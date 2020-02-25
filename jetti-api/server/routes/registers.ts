import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { AccountRegister } from '../models/account.register';
import { createRegisterAccumulation, RegisterAccumulationTypes } from '../models/Registers/Accumulation/factory';
import { RegisterAccumulation, RegisterAccumulationOptions } from '../models/Registers/Accumulation/RegisterAccumulation';
import { createRegisterInfo, RegisterInfoTypes } from '../models/Registers/Info/factory';
import { RegisterInfo, RegisterInfoOptions } from '../models/Registers/Info/RegisterInfo';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

router.get('/register/movements/list/:id', async (req, res, next) => {
  try {
    const sdb = SDB(req);
    const query = `SELECT *
    FROM (
        SELECT COUNT(id) records, r.type N'type', 'Accumulation' kind
            FROM [dbo].[Accumulation] r
            WHERE r.document = @p1
            group by r.type
        UNION
            SELECT COUNT(id) records, r.type N'type', 'Info'
            FROM [dbo].[Register.Info] r
            WHERE r.document = @p1
            group by r.type
        UNION
            SELECT COUNT(date) records, N'Register.Account' N'type', 'Account'
            FROM [dbo].[Register.Account] r
            WHERE r.document = @p1) as res
    where res.[records] > 0
    order by res.[type]`;

    const getRegisterFromQueryResult = (queryResult, kind, creationFunc: Function): [] => {
      return queryResult.filter(el => el.kind === kind).map(r => {
        const Register = creationFunc({ type: r.type });
        const description = (Register.Prop()).description;
        return ({ type: r.type, description: `${description} [${r.records}]`, kind: r.kind });
      })
    }

    const result = await sdb.manyOrNone<{ records: number, kind: string, type: RegisterAccumulationTypes | RegisterInfoTypes | string }>(query, [req.params.id]);
    const listAccumulation = getRegisterFromQueryResult(result, 'Accumulation', createRegisterAccumulation);
    const listInfo = getRegisterFromQueryResult(result, 'Info', createRegisterInfo);
    const listAccount = getRegisterFromQueryResult(result, 'Account', ({ some }) => {return { description: 'Хозрасчетный' }});
    const reslist = listAccumulation.concat(listInfo, listAccount);
    res.json(reslist);
  }
  catch (err) { next(err); }
});

router.get('/register/account/movements/view/:id', async (req, res, next) => {
  try {
    const sdb = SDB(req);
    const id = req.params.id;
    const query = `SELECT * FROM "Register.Account.View" where "document.id" = '${id}'`;

    await sdb.tx(async tx => {
      const data = await tx.manyOrNone<AccountRegister>(query);
      res.json(data);
    });
  } catch (err) { next(err); }
});

router.get('/register/accumulation/list/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
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
    });
  } catch (err) { next(err); }
});

router.get('/register/info/list/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const id = req.params.id;
    const query = `SELECT DISTINCT r.type "type" FROM "Register.Info" r WHERE r.document = '${id}'`;

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<{ type: RegisterInfoTypes }>(query);
      const list = result.map(r => {
        const description = (createRegisterInfo({ type: r.type }).Prop() as RegisterInfoOptions).description;
        return ({ type: r.type, description });
      });
      res.json(list);
    });
  } catch (err) { next(err); }
});

router.get('/register/accumulation/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const id = req.params.id;
    const type = req.params.type as RegisterAccumulationTypes;
    const query = createRegisterAccumulation({ type }).QueryList();

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<RegisterAccumulation>(`${query} AND r.document = '${id}'`);
      res.json(result);
    });
  } catch (err) { next(err); }
});

router.get('/register/info/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const id = req.params.id;
    const type = req.params.type as RegisterInfoTypes;
    const query = createRegisterInfo({ type }).QueryList();

    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<RegisterInfo>(`${query} AND r.document = '${id}'`);
      res.json(result);
    });
  } catch (err) { next(err); }
});

router.post('/register/info/byFilter/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const type = req.params.type as RegisterInfoTypes;
    let query = createRegisterInfo({ type }).QueryList()
    const filter = req.body;
    let filterText = '';
    query = query.replace('SELECT','SELECT r.document docId, ')
    filter.forEach(element => filterText += ` AND ${element.key} = '${element.value}'`);
    await sdb.tx(async tx => {
      const result = await tx.manyOrNone<RegisterInfo>(query + filterText);
      res.json(result);
    });
  } catch (err) { next(err); }
});

