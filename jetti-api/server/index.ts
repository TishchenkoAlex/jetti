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

import { Server as SocketIO } from 'socket.io';
import { createAdapter } from 'socket.io-redis';
import { RedisClient } from 'redis';

import { REDIS_DB_HOST, REDIS_DB_AUTH, DB_NAME } from './env/environment';
import { updateDynamicMeta } from './models/Dynamic/dynamic.common';
import { Global } from './models/global';
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

// tslint:disable: no-shadowed-variable
const app = express();
export const HTTP = httpServer.createServer(app);

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
  res.send('Jetti API 1.0.0');
});

function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  const errAny = err as any;
  const errText = `${err.message}${errAny.response ? ' Response data: ' + JSON.stringify(errAny.response.data) : ''}`;
  console.error(errText);
  const status = err && errAny.status ? errAny.status : 500;
  res.status(status).send(errText);
}

app.use(errorHandler);

export const IO = new SocketIO(HTTP, { cors: { origin: '*.*', methods: ['GET', 'POST'] } });
IO.use(authIO);
const pubClient = new RedisClient({ host: REDIS_DB_HOST, password: REDIS_DB_AUTH });
const subClient = pubClient.duplicate();
IO.adapter(createAdapter({ pubClient, subClient }));
IO.of('/').adapter.on('error', (error) => { });

export const subscriber = new RedisClient(({ host: REDIS_DB_HOST, auth_pass: REDIS_DB_AUTH }));
export const publisher = new RedisClient(({ host: REDIS_DB_HOST, auth_pass: REDIS_DB_AUTH }));
subscriber.on('message', function (channel, message) {
  if (channel === 'updateDynamicMeta') updateDynamicMeta();
});
subscriber.subscribe('updateDynamicMeta');
const port = (process.env.PORT) || '3000';
HTTP.listen(port, () => console.log(`API running on port: ${port}\nDB: ${DB_NAME}\nCPUs: ${os.cpus().length}`));
JQueue.getJobCounts().then(jobs => console.log('JOBS:', jobs));

Global.init().then(e => {
  if (!Global.isProd) {
    let script = '';
    const ef = () => { };

    SQLGenegatorMetadata.CreateViewOperations().then(script => fs.writeFile('OperationsView.sql', script, ef));

    SQLGenegatorMetadata.CreateViewOperationsIndex().then(script => fs.writeFile('OperationsViewIndex.sql', script, ef));

    script = SQLGenegatorMetadata.CreateViewCatalogsIndex();
    fs.writeFile('CatalogsViewIndex.sql', script, ef);

    script = SQLGenegatorMetadata.CreateViewCatalogsIndex(true, true);
    fs.writeFile('CatalogsViewIndexDynamic.sql', script, ef);

    script = SQLGenegatorMetadata.CreateViewCatalogs();
    fs.writeFile('CatalogsView.sql', script, ef);

    script = SQLGenegatorMetadata.CreateViewCatalogs(true);
    fs.writeFile('CatalogsViewDynamic.sql', script, ef);

    script = SQLGenegatorMetadata.CreateRegisterInfoViewIndex();
    fs.writeFile('RegisterInfoViewIndex.sql', script, ef);

    script = SQLGenegatorMetadata.RegisterAccumulationClusteredTables();
    fs.writeFile('RegisterAccumulationClusteredTables.sql', script, ef);

    script = SQLGenegatorMetadata.RegisterAccumulationView();
    fs.writeFile('RegisterAccumulationView.sql', script, ef);

    script = SQLGenegatorMetadata.CreateTableRegisterAccumulationTO();
    fs.writeFile('CreateTableRegisterAccumulationTotals.sql', script, ef);

    script = SQLGenegatorMetadata.CreateTableRegisterAccumulationTOv2();
    fs.writeFile('CreateTableRegisterAccumulationTotalsv2.sql', script, ef);

    script = SQLGenegatorMetadata.CreateRegisterAccumulationViewIndex();
    fs.writeFile('CreateRegisterAccumulationViewIndex.sql', script, ef);

  }
});


