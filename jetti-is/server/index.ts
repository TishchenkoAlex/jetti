import * as bodyParser from 'body-parser';
import * as compression from 'compression';
import * as cors from 'cors';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import * as httpServer from 'http';
import * as socketIO from 'socket.io';
import * as ioredis from 'socket.io-redis';
import { REDIS_DB_HOST, REDIS_DB_AUTH, DB_NAME } from './env/environment';
import { checkAuth, authIO } from './routes/middleware/check-auth';
import { router as auth } from './routes/auth';
import { router as document } from './routes/document';
import { setDatabaseSession } from './routes/middleware/set-database-session';

const root = './';
const app = express();
app.use(compression());
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: false }));

const api = `/api/v1.0`;
app.use(`${api}/document`, checkAuth, setDatabaseSession, document);
app.use('/auth', setDatabaseSession, auth);

app.get('*', (req: Request, res: Response) => {
  res.status(200);
  res.send('Jetti IS API 1.0');
});

app.use(errorHandler);
function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  console.error(err.message);
  const status = err && (err as any).status ? (err as any).status : 500;
  res.status(status).send(err.message);
}

export const HTTP = httpServer.createServer(app);
export const IO = socketIO(HTTP);
IO.use(authIO);
IO.adapter(ioredis({ host: REDIS_DB_HOST, auth_pass: REDIS_DB_AUTH }));
IO.of('/').adapter.on('error', (error) => { });

const port = (process.env.PORT) || '3000';
HTTP.listen(port, () => console.log(`API running on port: ${port}\nDB: ${DB_NAME}`));
