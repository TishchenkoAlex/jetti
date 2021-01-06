import { PostResult } from '../../models/post.interfaces';
import { MSSQL } from '../../mssql';
import { DocumentBaseServer } from '../../models/documents.factory.server';
import { v1 } from 'uuid';

export async function InsertRegistersIntoDB(doc: DocumentBaseServer, Registers: PostResult, tx: MSSQL) {
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
        ${rec.debit.qty || 0},  '${rec.debit.currency || doc['currency']}', ${rec.debit.sum || rec.sum || 0},
        '${rec.kredit.account}',
        '${rec.kredit.subcounts[0]}', '${rec.kredit.subcounts[1]}',
        '${rec.kredit.subcounts[2]}', '${rec.kredit.subcounts[3]}',
        ${rec.kredit.qty || 0}, '${rec.kredit.currency || doc['currency']}', ${rec.kredit.sum || rec.sum || 0}
      );`;
  }

  for (const rec of Registers.Accumulation) {
    if (rec.company === '9F00DDE0-F043-11E9-9115-B72821305A00' &&
      (rec.type === 'Register.Accumulation.PL' || rec.type === 'Register.Accumulation.Balance')) continue; // HOLDING
    const date = rec.date ? rec.date : doc.date;
    const data = { ...rec, ...rec['data'], company: rec.company || doc.company, document: doc.id };
    delete data.type; delete data.company; delete data.kind; delete data.calculated;
    delete data.document; delete data.date; delete data.parent;
    query += `
      INSERT INTO "Accumulation" (id, parent, calculated, kind, date, type, company, document, data)
      VALUES ('${rec.id || v1().toUpperCase()}', '${rec.parent}', ${rec.calculated ? 1 : 0}, ${rec.kind ? 1 : 0}, '${new Date(date).toJSON()}', N'${rec.type}' , N'${rec.company || doc.company}',
    '${doc.id}', JSON_QUERY(N'${JSON.stringify(data).replace(/\'/g, '\'\'')}'));`;
  }

  for (const rec of Registers.Info) {
    const date = rec.date ? rec.date : doc.date;
    const data = { ...rec, ...rec['data'], company: rec.company || doc.company, document: doc.id };
    delete data.type; delete data.company; delete data.document; delete data.date;
    query += `
      INSERT INTO "Register.Info" (date, type, company, document, data)
      VALUES ('${new Date(date).toJSON()}', N'${rec.type}', N'${rec.company || doc.company}',
    '${doc.id}', JSON_QUERY(N'${JSON.stringify(data).replace(/\'/g, '\'\'')}'));`;
  }
  // query = query.replace(/\'undefined\'/g, 'NULL').replace(/\'null\'/g, 'NULL');
  query = query.replace(/\'undefined\'|\'null\'/g, 'NULL');

  if (query) { await tx.none(query); }
}
