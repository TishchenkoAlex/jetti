import { SQLGenegator } from '../../fuctions/SQLGenerator.MSSQL';
import { PostResult } from '../../models/post.interfaces';
import { MSSQL, sdb } from '../../mssql';
import { lib } from '../../std.lib';
import { DocumentBaseServer } from './../../models/ServerDocument';

export async function InsertRegisterstoDB(doc: DocumentBaseServer, Registers: PostResult, tx = sdb) {
  let query = '';
  for (const rec of Registers.Account) {
    query += `
      INSERT INTO "Register.Account" (
        date, document, operation, sum, company,
        dt, dt_subcount1, dt_subcount2, dt_subcount3, dt_subcount4, dt_qty, dt_cur, dt_sum,
        kt, kt_subcount1, kt_subcount2, kt_subcount3, kt_subcount4, kt_qty, kt_cur, kt_sum )
      VALUES (
        '${new Date(doc.date).toJSON()}',
        '${doc.id}', '${rec.operation || doc['Operation'] || '00000000-0000-0000-0000-000000000000'}',
         ${rec.sum || 0}, '${rec.company || doc.company}',
        '${rec.debit.account}',
        '${rec.debit.subcounts[0]}', '${rec.debit.subcounts[1]}',
        '${rec.debit.subcounts[2]}', '${rec.debit.subcounts[3]}',
        ${rec.debit.qty || 0},  '${rec.debit.currency  || doc['currency']}', ${rec.debit.sum || rec.sum || 0},
        '${rec.kredit.account}',
        '${rec.kredit.subcounts[0]}', '${rec.kredit.subcounts[1]}',
        '${rec.kredit.subcounts[2]}', '${rec.kredit.subcounts[3]}',
        ${rec.kredit.qty || 0}, '${rec.kredit.currency || doc['currency']}', ${rec.kredit.sum || rec.sum || 0}
      );`;
  }

  for (const rec of Registers.Accumulation) {
    const date = rec.date ? rec.date : doc.date;
    const data = { ...rec.data, type: rec.type, company: rec.company || doc.company, document: doc.id };
    query += `
    INSERT INTO "Accumulation" (kind, date, type, company, document, data)
    VALUES (${rec.kind ? 1 : 0}, '${new Date(date).toJSON()}', N'${rec.type}' , N'${rec.company || doc.company}',
    '${doc.id}', JSON_QUERY(N'${JSON.stringify(data)}'));`;
  }

  for (const rec of Registers.Info) {
    const data = { ...rec.data, type: rec.type, document: doc.id, company: rec.company || doc.company };
    query += `
    INSERT INTO "Register.Info" (date, type, company, document, data)
    VALUES ('${new Date(doc.date).toJSON()}', N'${rec.type}', N'${rec.company || doc.company}',
    '${doc.id}', JSON_QUERY(N'${JSON.stringify(data)}'));`;
  }
  query = query.replace(/\'undefined\'/g, 'NULL');
  if (query) { await tx.none(query); }
}

export async function doSubscriptions(doc: DocumentBaseServer, script: string, tx: MSSQL) {
  /*   const scripts = await tx.manyOrNone<any>(`
      SELECT "then" FROM "Subscriptions" WHERE "what" ? @p1 AND "when" = @p2 ORDER BY "order"`, [doc.type, script]);
    if (scripts.length) {
      const AsyncFunction = Object.getPrototypeOf(async function () { }).constructor;
      for (const scr of scripts) {
        if (scr) {
          const func = new AsyncFunction('doc, db', scr.then);
          await func(JSON.parse(JSON.stringify(doc)), tx);
        }
      }
    } */
}

export async function buildViewModel(ServerDoc: DocumentBaseServer, tx: MSSQL) {
  const viewModelQuery = SQLGenegator.QueryObjectFromJSON(ServerDoc.Props());
  const NoSqlDocument = JSON.stringify(lib.doc.noSqlDocument(ServerDoc));
  return await tx.oneOrNone<{ [key: string]: any }>(viewModelQuery, [NoSqlDocument]);
}
