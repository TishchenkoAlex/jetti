// tslint:disable: max-line-length
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { SDB } from './middleware/db-sessions';
import { User } from './user.settings';
import axios from 'axios';
import { bpApiHost } from '../env/environment';
import { lib } from '../std.lib';

export const router = express.Router();

export async function DeleteProcess(processID: string) {
  if (!processID) return;
  const instance = axios.create({ baseURL: bpApiHost });
  const query = `/Processes/pwd/DeleteProcess/CashApplication?ProcessID=${processID}`;
  await instance.get(query);
}

router.get('/BP/GetUserTasksByMail', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const email = User(req).email;
    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Query/pwd/GetUserTasksByMail?UserMail=${email}&CountOfCompleted=${req.query.CountOfCompleted}`;
    return res.json((await instance.get(query)).data);
  } catch (err) { next(err); }
});

router.post('/BP/CompleteTask', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Tasks/pwd/CompleteTask`;
    req.body.UserID = User(req).email;
    return res.json((await instance.post(query, req.body)).data);
  } catch (err) { next(err); }
});

router.get('/BP/GetUsersByProcessID', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Processes/pwd/GetUsersByProcessID/CashApplication?ProcessID=${req.query.ProcessID}`;
    return res.json((await instance.get(query)).data);
  } catch (err) { next(err); }
});

router.get('/BP/GetMapByProcessID', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Processes/pwd/GetMapByProcessID/CashApplication?ProcessID=${req.query.ProcessID}`;
    return (await instance.get(query)).data;
  } catch (err) { next(err); }
});

router.get('/BP/isUserCurrentExecutant', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Processes/pwd/isUserCurrentExecutant/CashApplication?UserMail=${User(req).email}&ProcessID=${req.query.ProcessID}`;
    return res.json((await instance.get(query)).data);
  } catch (err) {
    if (err.response) return res.json(err.response.data);
    next(err);
  }
});
// StartProcess/CashApplication?AuthorID=dbez@outlook.com&DocumentID=049fe234-7b46-4b7e-b414-9dee0a8cd4da&SubdivisionID=959680e5-1523-11ea-ae46-d8e1ce3b07c9&Sum=100000&ItemID=1942b9df-1524-11ea-ae46-d8e1ce3b07c9

router.post('/BP/StartProcess', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { OperationTypeID, DocumentID } = req.body;

    if (OperationTypeID === 'Выплата заработной платы без ведомости' && DocumentID) {
      const tx = SDB(req);
      const servDoc = await lib.doc.createDocServerById(DocumentID, tx);
      const err = await servDoc!['checkTaxCheck'](tx);
      if (err) return res.json({error: true, message: err});
    }

    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Processes/pwd/StartProcess/CashApplication`;
    return res.json((await instance.post(query, req.body)).data);
  } catch (err) { next(err); }
});

router.post('/BP/ModifyProcess', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: bpApiHost });
    const query = `/Processes/pwd/ModifyProcess/CashApplication`;
    return res.json((await instance.post(query, req.body)).data);
  } catch (err) { next(err); }
});

router.get('/CashRequestDesktop', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const query = `SELECT r.*,
    Company.Company [company_name],
    CashRequest.description [CashRequest_name],
    [CashOrBank].description [CashOrBank_name],
    [CashRecipient].description [CashRecipient_name],
    [currency].description [currency_name],
    'false' [Selected]
    FROM
    (select  [company], [CashRequest],[CashOrBank], [CashRecipient], [currency],
    -SUM(Amount) [Amount],
    -SUM(Amount) [AmountToPay]
    FROM [dbo].[Register.Accumulation.CashToPay] r -- WITH (NOEXPAND)
    GROUP BY [company], [CashRequest],[CashOrBank], [CashRecipient], [currency]
    HAVING SUM(Amount) < 0) r
    LEFT JOIN [Catalog.Company] Company ON Company.id =r.[company]
    LEFT JOIN Documents CashRequest ON CashRequest.id =r.[CashRequest]
    LEFT JOIN Documents [CashOrBank] ON [CashOrBank].id =r.[CashOrBank]
    LEFT JOIN Documents [CashRecipient] ON [CashRecipient].id =r.[CashRecipient]
    LEFT JOIN Documents [currency] ON [currency].id =r.[currency]`;
    const result = await sdb.manyOrNone(query);
    return res.json(result);
  } catch (err) { next(err); }
});
