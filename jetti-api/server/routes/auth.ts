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
import { CatalogSubSystem } from '../models/Catalogs/Catalog.SubSystem';
import { createDocument, IFlatDocument, INoSqlDocument } from '../models/documents.factory';
import { DocTypes } from '../models/documents.types';
import { DocumentOptions, Ref } from '../models/document';
import { createForm } from '../models/Forms/form.factory';

export const router = express.Router();

const sdba = new MSSQL({ email: 'service@service.com', isAdmin: true, description: 'service account', env: {}, roles: [] }, JETTI_POOL);
export async function getUser(email: string): Promise<CatalogUser | null> {
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

const RolesQuery = `
  DROP TABLE IF EXISTS #UserOrGroup;
  SELECT @p1 id INTO #UserOrGroup
  UNION ALL
  SELECT id FROM Documents WITH(NOLOCK)
  CROSS APPLY OPENJSON (doc, N'$.Users')
  WITH
  (
    [UsersGroup.User] UNIQUEIDENTIFIER N'$.User'
  ) AS Users
  WHERE (1=1) AND
    type = 'Catalog.UsersGroup' AND
    [UsersGroup.User] = @p1;

  DROP TABLE IF EXISTS #Roles;
  SELECT [Role] INTO #Roles FROM Documents WITH(NOLOCK)
  CROSS APPLY OPENJSON (doc, N'$.RoleList')
  WITH
  (
    [Role] UNIQUEIDENTIFIER N'$.Role'
  ) AS Roles
  INNER JOIN #UserOrGroup ON #UserOrGroup.id = CAST(JSON_VALUE(doc, N'$.UserOrGroup') AS UNIQUEIDENTIFIER)
  WHERE (1=1) AND
    type = 'Document.UserSettings';

  DROP TABLE IF EXISTS #Subsystems;
  SELECT SubSystem INTO #Subsystems FROM Documents r WITH(NOLOCK)
  CROSS APPLY OPENJSON (doc, N'$.Subsystems')
  WITH
  (
    SubSystem  UNIQUEIDENTIFIER N'$.SubSystem'
  ) AS Subsystems
  WHERE (1=1) AND
    type = 'Catalog.Role' AND
    id IN (SELECT [Role] FROM #Roles);

  SELECT * FROM Documents r WITH(NOLOCK)
  WHERE (1=1) AND
    type = 'Catalog.SubSystem' AND posted = 1 AND
	(id IN (SELECT SubSystem FROM #Subsystems) OR @p2 = 1);
`;

interface MenuItem { type: string; icon: string; label: string; items?: MenuItem[]; routerLink?: string[]; }
router.get('/subsystems', authHTTP, async (req, res, next) => {
  try {
    const payload: IJWTPayload = (<any>req).user;
    const existing = await getUser(payload.email);
    if (!existing) { return res.status(401).json({ message: 'Auth failed' }); }
    const SubSystemsRaw = await sdba.manyOrNone<INoSqlDocument>(RolesQuery, [existing.id, existing.isAdmin]);
    const result = SubSystemsRaw.map(s => lib.doc.flatDocument(s));
    res.json(result);
  } catch (err) { next(err); }
});

router.get('/subsystems/menu', authHTTP, async (req, res, next) => {
  try {
    const payload: IJWTPayload = (<any>req).user;
    const existing = await getUser(payload.email);
    if (!existing) { return []; }
    const result = await buildMenu(existing);
    res.json(result || []);
  } catch (err) { next(err); }
});

export async function buildMenu(user: CatalogUser): Promise<MenuItem[]> {
  const SubSystemsRaw = await sdba.manyOrNone<INoSqlDocument>(RolesQuery, [user.id, user.isAdmin]);
  const sub = SubSystemsRaw.map(async (s) => {
    const flat = lib.doc.flatDocument(s)!;
    const SubSystem = createDocument<CatalogSubSystem>('Catalog.SubSystem', flat);
    return {
      type: SubSystem.type,
      icon: SubSystem.icon,
      label: SubSystem.description,
      items: [
        ...SubSystem.Catalogs.map(el => {
          const prop = createDocument(el.Catalog as DocTypes).Prop() as DocumentOptions;
          return { type: prop.type, icon: prop.icon, routerLink: ['/' + prop.type], label: prop.menu };
        }),
        ...SubSystem.Documents.map(el => {
          const prop = createDocument(el.Document as DocTypes).Prop() as DocumentOptions;
          return { type: prop.type, icon: prop.icon, routerLink: ['/' + prop.type], label: prop.menu };
        }),
        ...SubSystem.Forms.filter(el => el.Form).map(el => {
          const prop = createForm({ type: el.Form as any }).Prop() as DocumentOptions;
          return { type: prop.type, icon: prop.icon, routerLink: ['/' + prop.type], label: prop.menu };
        }),
      ]
    };
  });
  const subs = await Promise.all(sub);
  return subs;
}

