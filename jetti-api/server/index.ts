import * as bodyParser from 'body-parser';
import * as compression from 'compression';
import * as cors from 'cors';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import * as fs from 'fs';
import * as httpServer from 'http';
import * as path from 'path';
import * as os from 'os';
import 'reflect-metadata';
import * as socketIO from 'socket.io';
import * as ioredis from 'socket.io-redis';
import { REDIS_DB_HOST, REDIS_DB_AUTH, DB_NAME } from './env/environment';
import { SQLGenegatorMetadata } from './fuctions/SQLGenerator.MSSQL.Metadata';
import { JQueue } from './models/Tasks/tasks';
import { router as auth } from './routes/auth';
import { router as utils } from './routes/utils';
import { router as documents } from './routes/documents';
import { authHTTP, authIO } from './routes/middleware/check-auth';
import { router as registers } from './routes/registers';
import { router as suggests } from './routes/suggest';
import { router as swagger } from './routes/swagger';
import { router as tasks } from './routes/tasks';
import { router as userSettings } from './routes/user.settings';
import { router as form } from './routes/form';
import { router as bp } from './routes/bp';
import { router as exchange } from './routes/exchange';
import { jettiDB, tasksDB } from './routes/middleware/db-sessions';
import * as swaggerDocument from './swagger.json';
import * as swaggerUi from 'swagger-ui-express';
import * as redis from 'redis';
import { updateDynamicMeta } from './models/Dynamic/dynamic.common';
import { Global } from './models/global';

// tslint:disable: no-shadowed-variable

const app = express();
export const HTTP = httpServer.createServer(app);
export const IO = socketIO(HTTP);

export const subscriber = redis.createClient({ host: REDIS_DB_HOST, auth_pass: REDIS_DB_AUTH });
export const publisher = redis.createClient({ host: REDIS_DB_HOST, auth_pass: REDIS_DB_AUTH });

subscriber.on('message', function (channel, message) {
  if (channel === 'updateDynamicMeta') updateDynamicMeta();
});
subscriber.subscribe('updateDynamicMeta');

const root = './';
app.use(compression());
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: false }));
app.use(express.static(path.join(root, 'dist')));

const api = `/api`;
app.use(api, authHTTP, jettiDB, utils);
app.use(api, authHTTP, jettiDB, documents);
app.use(api, authHTTP, jettiDB, userSettings);
app.use(api, authHTTP, jettiDB, suggests);
app.use(api, authHTTP, jettiDB, registers);
app.use(api, authHTTP, tasksDB, tasks);
app.use(api, authHTTP, tasksDB, form);
app.use(api, authHTTP, jettiDB, bp);
app.use(api, authHTTP, jettiDB, swagger);
app.use('/auth', jettiDB, auth);
app.use('/exchange', jettiDB, exchange);
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.get('*', (req: Request, res: Response) => {
  res.status(200);
  res.send('Jetti API');
});

function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  const errAny = err as any;
  const errText = `${err.message}${errAny.response ? ' Response data: ' + JSON.stringify(errAny.response.data) : ''}`;
  console.error(errText);
  const status = err && errAny.status ? errAny.status : 500;
  res.status(status).send(errText);
}

app.use(errorHandler);

IO.use(authIO);
IO.adapter(ioredis({ host: REDIS_DB_HOST, auth_pass: REDIS_DB_AUTH }));
IO.of('/').adapter.on('error', (error) => { });

let script = '';

const port = (process.env.PORT) || '3000';
HTTP.listen(port, () => console.log(`API running on port: ${port}\nDB: ${DB_NAME}\nCPUs: ${os.cpus().length}`));
JQueue.getJobCounts().then(jobs => console.log('JOBS:', jobs));

Global.init().then(e => {
  if (!Global.isProd) {

    SQLGenegatorMetadata.CreateViewOperations().then(script => fs.writeFile('OperationsView.sql', script, (err) => { }));

    SQLGenegatorMetadata.CreateViewOperationsIndex().then(script => fs.writeFile('OperationsViewIndex.sql', script, (err) => { }));

    script = SQLGenegatorMetadata.CreateViewCatalogsIndex() as string;
    fs.writeFile('CatalogsViewIndex.sql', script, (err) => { });

    script = SQLGenegatorMetadata.CreateViewCatalogs() as string;
    fs.writeFile('CatalogsView.sql', script, (err) => { });

    script = SQLGenegatorMetadata.CreateRegisterInfoViewIndex();
    fs.writeFile('RegisterInfoViewIndex.sql', script, (err) => { });

    script = SQLGenegatorMetadata.RegisterAccumulationClusteredTables();
    fs.writeFile('RegisterAccumulationClusteredTables.sql', script, (err) => { });

    script = SQLGenegatorMetadata.RegisterAccumulationView();
    fs.writeFile('RegisterAccumulationView.sql', script, (err) => { });

    script = SQLGenegatorMetadata.CreateTableRegisterAccumulationTO();
    fs.writeFile('CreateTableRegisterAccumulationTotals.sql', script, (err) => { });

    script = SQLGenegatorMetadata.CreateRegisterAccumulationViewIndex();
    fs.writeFile('CreateRegisterAccumulationViewIndex.sql', script, (err) => { });

    script = SQLGenegatorMetadata.CreateRegisterAccumulationViewIndex();
    fs.writeFile('CreateRegisterAccumulationViewIndex.sql', script, (err) => { });
  }
});

