// tslint:disable: max-line-length
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { SDB } from './middleware/db-sessions';
import { User } from './user.settings';
import axios from 'axios';

export const router = express.Router();

router.get('/BP/GetUserTasksByMail', async (req: Request, res: Response, next: NextFunction) => {
  try {

    const email = User(req).email;
    // return res.json(email);
    const instance = axios.create({ baseURL: 'http://35.204.78.79' });
    const query = `/JettiProcesses/hs/Query/pwd/GetUserTasksByMail?UserMail=${email}&CountOfCompleted=${req.query.CountOfCompleted}`;
    return res.json((await instance.get(query)).data);

  } catch (err) { next(err); }
});

router.post('/BP/CompleteTask', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: 'http://35.204.78.79' });
    const query = `/JettiProcesses/hs/Tasks/pwd/CompleteTask`;
    req.body.UserID = User(req).email;
    return res.json((await instance.post(query, req.body)).data);

  } catch (err) { next(err); }
});

router.get('/BP/GetUsersByProcessID', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: 'http://35.204.78.79' });
    const query = `/JettiProcesses/hs/Processes/pwd/GetUsersByProcessID/CashApplication?ProcessID=${req.query.ProcessID}`;
    return res.json((await instance.get(query)).data);

  } catch (err) { next(err); }
});

router.get('/BP/GetMapByProcessID', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: 'http://35.204.78.79' });
    const query = `/JettiProcesses/hs/Processes/pwd/GetMapByProcessID/CashApplication?ProcessID=${req.query.ProcessID}`;
    return (await instance.get(query)).data;

  } catch (err) { next(err); }
});

// StartProcess/CashApplication?AuthorID=dbez@outlook.com&DocumentID=049fe234-7b46-4b7e-b414-9dee0a8cd4da&SubdivisionID=959680e5-1523-11ea-ae46-d8e1ce3b07c9&Sum=100000&ItemID=1942b9df-1524-11ea-ae46-d8e1ce3b07c9

router.post('/BP/StartProcess', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const instance = axios.create({ baseURL: 'http://35.204.78.79' });
    const query = `/JettiProcesses/hs/Processes/pwd/StartProcess/CashApplication`;
    return res.json((await instance.post(query, req.body)).data);

  } catch (err) { next(err); }
});
