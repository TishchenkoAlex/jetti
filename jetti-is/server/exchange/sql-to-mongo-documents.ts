import { MongoClient } from 'mongodb';
import { SQLClient } from '../sql/sql-client';
import { DEFAULT_POOL } from '../sql/DEFAULT_POOL';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { ColumnValue, Request } from 'tedious';

export async function SqlToMongoDocuments() {
  const uri = process.env.MONGODB!;
  const mongoClient = await new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true }).connect();
  const collectionDocuments = mongoClient.db('x100').collection('Documents');
  await collectionDocuments.deleteMany({});

  const sqlClient = new SQLClient(DEFAULT_POOL);
  let batch: any[] = []; let i = 0;
  await sqlClient.manyOrNoneStream(`select id as _id, * FROM [Documents]`, [],
    async (row: ColumnValue[], req: Request) => {
      i++;
      const rawDoc: any = {};
      row.forEach(col => rawDoc[col.metadata.colName] = col.value);
      const doc = JSON.parse(rawDoc.doc, dateReviverUTC);
      delete rawDoc.doc; delete rawDoc.id;
      const flatDoc = { ...rawDoc, ...doc };
      batch.push(flatDoc);
      if (batch.length === 100000) {
        req.pause();
        console.log('inserting to MongoDB', i, 'docs')
        await collectionDocuments.insertMany(batch);
        batch = [];
        req.resume();
      }
    },

    async (rowCount: number, more: boolean) => {
      if (rowCount && !more && batch.length > 0) {
        console.log('inserting tail', batch.length, 'docs')
        await collectionDocuments.insertMany(batch);
      }
    });
}
