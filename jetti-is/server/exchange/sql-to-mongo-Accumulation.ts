import { MongoClient } from 'mongodb';
import { SQLClient } from '../sql/sql-client';
import { DEFAULT_POOL } from '../sql/DEFAULT_POOL';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { ColumnValue, Request } from 'tedious';

export async function SqlToMongoAccumulation() {
	const uri = process.env.MONGODB!;
	const mongoClient = await new MongoClient(uri, {
		useNewUrlParser: true,
		useUnifiedTopology: true,
	}).connect();
	const collectionDocuments = mongoClient.db('x100').collection('Accumulation');
	await collectionDocuments.deleteMany({});

	const sqlClient = new SQLClient(DEFAULT_POOL);
	let batch: any[] = [];
	let i = 0;
	await sqlClient.manyOrNoneStream(
		`select id as _id, * FROM [Accumulation]`,
		[],
		async (row: ColumnValue[], req: Request) => {
			i++;
			const rawDoc: any = {};
			row.forEach((col) => (rawDoc[col.metadata.colName] = col.value));
			const data = JSON.parse(rawDoc.data, dateReviverUTC);
			delete rawDoc.data;
			delete rawDoc.id;
			const flatDoc = { ...rawDoc, ...data };
			batch.push(flatDoc);
			if (batch.length === 100000) {
				req.pause();
				console.log('inserting to MongoDB', i, 'docs');
				await collectionDocuments.insertMany(batch);
				batch = [];
				req.resume();
			}
		},

		async (rowCount: number, more: boolean) => {
			if (rowCount && !more && batch.length > 0) {
				console.log('inserting tail', batch.length, 'docs');
				await collectionDocuments.insertMany(batch);
			}
		},
	);
}
