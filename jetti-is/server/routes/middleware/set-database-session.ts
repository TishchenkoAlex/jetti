import { NextFunction, Request, Response } from 'express';
import { SQLClient } from '../../sql/sql-client';
import { DEFAULT_POOL } from '../../sql/DEFAULT_POOL';

export type SessionRequest = Request & { db: SQLClient, user: { [key: string]: any } };

export function setDatabaseSession(req: Request, res: Response, next: NextFunction) {
  req['db'] = new SQLClient(DEFAULT_POOL, req['user']);
  next();
}

