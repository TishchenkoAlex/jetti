import * as bodyParser from 'body-parser';
import * as compression from 'compression';
import * as cors from 'cors';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import * as fs from 'fs';
import * as httpServer from 'http';
import * as path from 'path';
import 'reflect-metadata';
import * as socketIO from 'socket.io';
import * as ioredis from 'socket.io-redis';
import { REDIS_DB_HOST } from './env/environment';
import { SQLGenegatorMetadata } from './fuctions/SQLGenerator.MSSQL.Metadata';
import { JQueue } from './models/Tasks/tasks';
import { router as auth } from './routes/auth';
import { router as documents } from './routes/documents';
import { authHTTP, authIO } from './routes/middleware/check-auth';
import { router as registers } from './routes/registers';
import { router as suggests } from './routes/suggest';
import { router as tasks } from './routes/tasks';
import { router as userSettings } from './routes/user.settings';
import { router as form } from './routes/form';
import { router as utils } from './routes/utils';
import { jettiDB, tasksDB, accountDB } from './routes/middleware/db-sessions';

const root = './';
const app = express();

app.use(compression());
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(path.join(root, 'dist')));

const api = `/api`;
app.use(api, authHTTP, jettiDB, documents);
app.use(api, authHTTP, jettiDB, userSettings);
app.use(api, authHTTP, jettiDB, suggests);
app.use(api, authHTTP, jettiDB, utils);
app.use(api, authHTTP, jettiDB, registers);
app.use(api, authHTTP, tasksDB, tasks);
app.use(api, authHTTP, tasksDB, form);
app.use('/auth', accountDB, auth);

app.get('*', (req: Request, res: Response) => {
  res.sendFile('dist/index.html', { root: root });
});

app.use(errorHandler);
function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  console.log(err.message);
  const status = err && (err as any).status ? (err as any).status : 500;
  res.status(status).send(err.message);
}

export const HTTP = httpServer.createServer(app);
export const IO = socketIO(HTTP);
IO.use(authIO);
IO.adapter(ioredis({ host: REDIS_DB_HOST }));

const port = (process.env.PORT) || '3000';
HTTP.listen(port, () => console.log(`API running on port:${port}`));
JQueue.getJobCounts().then(jobs => console.log('JOBS:', jobs));

// const script = SQLGenegatorMetadata.CreateTableRegisterAccumulationTotals();
// const script = SQLGenegatorMetadata.CreateTableRegisterAccumulation();
// const script = SQLGenegatorMetadata.CreateTableRegisterInfo();
// fs.writeFile('CreateTableRegisterAccumulation.sql', script, (err) => {});
