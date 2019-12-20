import * as express from 'express';
import axios from 'axios';
import * as jwt from 'jsonwebtoken';
import { JTW_KEY } from '../env/environment';
import { IJWTPayload } from '../models/common-types';
import { authHTTP } from './middleware/check-auth';
import { CatalogUser } from '../models/Catalogs/Catalog.User';
import { MSSQL } from '../mssql';
import { JETTI_POOL } from '../sql.pool.jetti';
import { lib } from '../std.lib';

export const router = express.Router();

export async function getUser(email: string): Promise<CatalogUser | null> {
  const sdba = new MSSQL({ email: 'service@service.com', isAdmin: true, description: 'service account', env: {}, roles: [] }, JETTI_POOL);
  let user: CatalogUser | null = null;
  const userID = await lib.doc.byCode('Catalog.User', email, sdba);
  if (userID) user = await lib.doc.byIdT<CatalogUser>(userID, sdba);
  return user;
}

router.post('/login', async (req, res, next) => {
  try {
    const instance = axios.create({ baseURL: 'https://graph.microsoft.com' });
    instance.defaults.headers.common['Authorization'] = `Bearer ${req.body.token}`;
    const me = (await instance.get('/v1.0/me/')).data;
    const mail = req.body.email;
    const existing = await getUser(mail);
    if (!existing) { return res.status(401).json({ message: 'Auth failed' }); }
    const payload: IJWTPayload = {
      email: me.userPrincipalName,
      description: me.displayName,
      isAdmin: existing.isAdmin === true ? true : false,
      roles: [],
      env: {},
    };
    const token = jwt.sign(payload, JTW_KEY, { expiresIn: '24h' });
    return res.json({ account: payload, token });
  } catch (err) { next(err); }
});

router.get('/account', authHTTP, async (req, res, next) => {
  try {
    const user = await getUser((<any>req).user.email);
    if (!user) { return res.status(401).json({ message: 'Auth failed' }); }
    const payload: IJWTPayload = {
      email: user.code,
      description: user.description,
      isAdmin: user.isAdmin === true ? true : false,
      roles: [],
      env: {},
    };
    res.json(payload);
  } catch (err) { next(err); }
});

router.post('/refresh', authHTTP, async (req, res, next) => {
  try {
    const payload: IJWTPayload = (<any>req).user;
    const existing = await getUser(payload.email);
    if (!existing) { return res.status(401).json({ message: 'Auth failed' }); }
    const new_payload: IJWTPayload = {
      email: existing.id,
      description: existing.description,
      isAdmin: existing.isAdmin === true ? true : false,
      roles: [],
      env: {},
    };
    const token = jwt.sign(new_payload, JTW_KEY, { expiresIn: '24h' });
    return res.json({ account: existing, token });
  } catch (err) { next(err); }
});
