import * as express from 'express';
import { SQLClient } from '../sql/sql-client';
import { SessionRequest } from './middleware/set-darabase-session';

export const router = express.Router();

interface Document {
  id: string;
  type: string;
  date: string;
  code: string;
  description: string;
  posted: boolean;
  deleted: boolean;
  isfolder: boolean;
  timestamp: string;
  parent: string;
  company: string;
  user: string;
  doc: { [x: string]: any };
}

function flatDocument(doc: Document): { [x: string]: any } {
  const { id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, user } = doc;
  return { ...doc.doc, id, type, date, code, description, posted, deleted, isfolder, timestamp, parent, company, user };
}

async function get(conn: SQLClient, id: string) {
  const query = `SELECT * FROM Documents WHERE id = @p1`;
  const rawDocument = await conn.oneOrNone<Document>(query, [id]);
  if (!rawDocument) return null;
  const result = flatDocument(rawDocument);
  return result;
}

router.get('/:type/:id', async (req: SessionRequest, res, next) => {
  try {
    const result = await get(req.db, req.params.id);
    res.json(result);
  } catch (err) { next(err); }
});

async function post(conn: SQLClient, type: string, json: { [x: string]: any }) {
  const query = `
    INSERT INTO Documents(id, type, date, code, description, posted, deleted, isfolder, parent, company, user, doc)
    OUTPUT INSERTED.*
    VALUES(@p1,@p2,@p3,@p4,@p5,@p6,@p7,@p8,@p9,@p10,@p11,JSON_QUERY(@p12));
  `;
  const { id, date, code, description, posted, deleted, isfolder, parent, company, user } = json;
  const rawDocument = (await conn.oneOrNone<Document>(query, [
    id, type, date, code, description, posted, deleted, isfolder, parent, company, user, JSON.stringify(json)]))!;
  const result = flatDocument(rawDocument);
  return result;
}

router.post('/:type', async (req: SessionRequest, res, next) => {
  try {
    const result = await post(req.db, req.params.type, req.body);
    res.json(result);
  } catch (err) { next(err); }
});


async function patch(conn: SQLClient, id: string, json: { [x: string]: any }) {
  const query = `
    UPDATE Documents
    SET doc = JSON_QUERY(@p2)
    OUTPUT INSERTED.*
    WHERE id = @p1;
  `;
  const rawDocument = (await conn.oneOrNone<Document>(query, [id, JSON.stringify(json)]));
  if (!rawDocument) return null;
  const result = flatDocument(rawDocument);
  return result;
}

router.patch('/:type/:id', async (req: SessionRequest, res, next) => {
  try {
    const result = await patch(req.db, req.params.id, req.body);
    res.json(result);
  } catch (err) { next(err); }
});

async function del(conn: SQLClient, id: string) {
  const query = `
    UPDATE Documents SET
      deleted = 1,
      doc = JSON_MODIFY(doc, '$.deleted', 1)
    OUTPUT INSERTED.*
    WHERE id = @p1;
  `;
  const rawDocument = (await conn.oneOrNone<Document>(query, [id]));
  if (!rawDocument) return null;
  const result = flatDocument(rawDocument);
  return result;
}

router.delete('/:type/:id', async (req: SessionRequest, res, next) => {
  try {
    const result = await del(req.db, req.params.id);
    res.json(result);
  } catch (err) { next(err); }
});

