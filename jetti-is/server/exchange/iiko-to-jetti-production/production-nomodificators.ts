import { SQLClient } from '../../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';

import { SQLPool } from '../../sql/sql-pool';
import {
	ISyncParams,
	saveLogProtocol,
	exchangeManyOrNone,
	GetSqlConfig,
} from '../iiko-to-jetti-connection';
import {
	DateToString,
	GetCatalog,
	Ref,
	InsertDocument,
	GetDocument,
	UpdateDocument,
	setQueuePostDocument,
} from '../iiko-to-jetti-utils';
import e = require('express');
import { AnyTxtRecord } from 'dns';
import { dateReviverUTC } from '../../fuctions/dateReviver';
import { strict } from 'assert';
// без модификаторов
///////////////////////////////////////////////////////////
const syncStage = 'Document.Order';
///////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////

const transformSimpelProdDocs = (
	syncParams: ISyncParams,
	source: any,
): IiikoMergeDoc => {
	return {
		id: source.id,
		comment: source.Comment,
		conception: source.Conception,
		dateIncoming: source.dateIncoming,
		documentNumber: source.documentNumber,
		status: source.Status,
		store: source.Store,
		dateModified: source.dateModified
	};
};
///////////////////////////////////////////////////////////

const newProduction = () => {
	return {
		id: uuidv1().toUpperCase(),
		type: 'Document.Operation',
		code: '',
		description: '',
		posted: 0,
		deleted: 0,
		doc: {
			Group: '',
			Operation: '',
			Amount: null,
			currency: '',
			f1: '',
			f2: '',
			f3: '53364DB0-D346-11E9-9B59-A568B1244A3E',
			Department: '',
			Storehouse: '',
			ExpenseAnalytics: '633722C0-D346-11E9-9B59-A568B1244A3E',
			Expense: '53364DB0-D346-11E9-9B59-A568B1244A3E',
			ExchangeUser: '',
			Items: [],
		},
		parent: null,
		isfolder: false,
		company: '',
		user: null,
		info: null,
	};
};

///////////////////////////////////////////////////////////


// TODO: IiikoMergeDoc

async function syncWriteSQL(
	syncParams: ISyncParams,
	iikoDoc: any,
	sourceSQL: SQLClient,
	destSQL: SQLClient,
): Promise<any> {
	try {
		// if (syncParams.logLevel > 1)
		// 	await saveLogProtocol(
		// 		syncParams.syncid,
		// 		0,
		// 		0,
		// 		syncStage,
		// 		`Inventoryzation ${iikoDoc.id} ${iikoDoc.date.toString()} #${iikoDoc.documentNumber
		// 		}`,
		// 	);
		const Group = "6C818FD0-E095-11E9-A0E4-0F60E644189D";
		const Operation = "9B50E630-E095-11E9-A0E4-0F60E644189D";
		const codez = syncParams.source.code + '-' + iikoDoc.documentNumber;
		const tabelResult: Array<IsqlTabelDefResult> = await tabelDef(iikoDoc, sourceSQL);
		const descriptionz: any = await destSQL.oneOrNone(
			`SELECT top(100) [description] FROM [dbo].[Catalog.Operation.v] WHERE id = @p1`,
			[Operation],
		);
		const store = await GetCatalog(
			syncParams.project.id,
			iikoDoc.store,
			syncParams.source.id,
			'Storehouse',
			destSQL,
		); 
		if (!store){ 
			console.log(iikoDoc.store)
			
			throw new Error('Storehouse not exists');
		}
		console.log(store)
		const company = (await destSQL.oneOrNone<{ id: Ref }>(
			`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
			[iikoDoc.dateIncoming, store.doc.Department],
		))!;
		
		const NoSQLDoc = {
			id:uuidv1().toUpperCase(),
			posted:0,
			deleted:0,
			type:'Document.Operation',
			company:company.id,
			code:codez,
			parent:null,
			user:null,
			description:descriptionz.description,
			date:iikoDoc.dateIncoming,
			doc:{
				Group:Group,
				Operation:Operation,
				Department:store.doc.Department,
				f1:store.doc.Department,
				f2:store.doc.id,
				f3:store.doc.id,
				company:company.id,
				currency:syncParams.source.currency,
				ItemsProduction:tabelResult,
				SH_Out: store.doc.id,
				SH_In: store.doc.id
			}
		}
		// 	if (isNewDoc)
		// 		await InsertDocument(jsonDoc, NoSqlDocument.id, iikoDoc, destSQL);
		// 	else await UpdateDocument(jsonDoc, NoSqlDocument.id, destSQL);
		// 	if (syncParams.flow >= 0) {
		// 		await setQueuePostDocument(
		// 			NoSqlDocument.id,
		// 			NoSqlDocument.company,
		// 			syncParams.flow,
		// 			destSQL,
		// 		);
		// 	}
	} catch (error) {
		await saveLogProtocol(syncParams.syncid, 0, 1, syncStage, error.message);
	}
}

export async function ImportProdNoModiToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync Write Off Documents`,
	);
	if (syncParams.baseType === 'sql')
		await ImportProductionNoModificationToJetti(syncParams, docList);
}
export async function ImportProductionNoModificationToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	const ssqlcfg = await GetSqlConfig(syncParams.source.id);
	const ssql = new SQLClient(new SQLPool(ssqlcfg));
	const dsql = new SQLClient(
		new SQLPool(await GetSqlConfig(syncParams.destination)),
	);

	let i = 0;
	// условия к выборке

	// where (cast(z.dateIncoming as DATE) between ? and ?
	// or (cast(z.dateIncoming as DATE)>=? and cast(z.dateIncoming as DATE)<? and z.dateModified>=? and ?=126))
	// and (cast(z.Store as nvarchar(50))=? or ?='')
	// order by z.dateIncoming
	let sw = '';
	if (docList.length === 0) {
		// выборка по интервалу дат
		sw = ` where ( cast(z.dateIncoming as DATE) between '${DateToString(
			syncParams.periodBegin,
		)}' and '${DateToString(syncParams.periodEnd)}' `;
		if (syncParams.execFlag === 126 && syncParams.autosync) {
			sw += ` or (cast(z.dateIncoming as DATE) >= '${DateToString(
				syncParams.firstDate,
			)}' and cast(z.dateIncoming as DATE) < '${DateToString(
				syncParams.periodBegin,
			)}' and z.dateModified >= '${DateToString(syncParams.lastSyncDate)}' )) `;
		} else sw += ') ';
		if (syncParams.exchangeID === null) {
			if (syncParams.source.exchangeStores.length > 0) {
				// ограничение по списку складов
				sw += ` and d.store in (`;
				i = 0;
				for (const store of syncParams.source.exchangeStores) {
					i++;
					if (i === 1) sw += `'${store}'`;
					else sw += `, '${store}'`;
				}
				sw += ') ';
			}
		} else {
			sw += ` and d.store = '${syncParams.exchangeID}' `;
		}
	} else {
		// выборка по списку документов
		i = 0;
		for (const d of docList) {
			i++;
			if (i === 1) sw = ` where pr.sessionid in ('${d}'`;
			else sw += `, '${d}'`;
		}
		sw += ') ';
	}

	const sql = `select
	z.id as id,
	z.Comment,
	z.Conception,
	z.dateIncoming,
	z.documentNumber,
	z.Status,
	z.Store,
	z.dateModified
	from (
	SELECT
	d.id as id,
	COALESCE(d.comment,'') as Comment,
	COALESCE(cast(d.conception as nvarchar(50)),'') as Conception,
	d.dateIncoming,
	COALESCE(d.documentNumber,'') as documentNumber,
	d.status as Status,
	COALESCE(cast(d.store as nvarchar(50)),'') as Store,
	d.dateModified
	FROM dbo.productiondocument d
	union all
	SELECT
	d.id as id,
	COALESCE(d.comment,'') as Comment,
	COALESCE(cast(d.conception as nvarchar(50)),'') as Conception,
	d.dateIncoming,
	COALESCE(d.documentNumber,'') as documentNumber,
	d.status as Status,
	COALESCE(cast(d.storeFrom as nvarchar(50)),'') as Store,
	d.dateModified
	FROM dbo.TransformationDocument d ) z
	${sw}
	order by z.dateIncoming`;
	i = 0;

	let batch: IiikoMergeDoc[] = [];
	const response = await ssql.manyOrNoneStream(
		sql,
		[],
		async (row: ColumnValue[], req: Request) => {
			i = i + 1;
			const rawDoc: any = {};

			row.forEach((col) => (rawDoc[col.metadata.colName] = col.value));
			batch.push(rawDoc);
			req.pause();
			if (syncParams.logLevel > 1)
				// await saveLogProtocol(
				// 	syncParams.syncid,
				// 	0,
				// 	0,
				// 	syncStage,
				// 	`inserting to batch ${i} Write Off docs`,
				// );
			for (const doc of batch) {
				const p = transformSimpelProdDocs(syncParams, doc)
				syncWriteSQL(syncParams, p, ssql, dsql)
			}
			batch = [];
			req.resume();
		},
		async (rowCount: number, more: boolean) => {
			if (rowCount && !more && batch.length > 0) {
				if (syncParams.logLevel > 1)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting tail ${batch.length} Write Off docs`,
					);
				for (const doc of batch) {

				}
			}
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`Finish sync Write Off Docs`,
			);
		},
	);
}


async function tabelDef(doc: IiikoMergeDoc, tx: SQLClient) {
	const _SQL_TabelDef = `SELECT
	cast('PROD' as nvarchar(50)) as TypeItem,
	0  AS Rank,
  --  cast(tr.documentItemId as nvarchar(38)) as ПозицияИД,
	null as ПозицияИД,
	cast(tr.department as nvarchar(38)) as ДепратаментИД,
	cast(tr.conception as nvarchar(38)) as КонцепцияИД,
	cast(tr.from_account as nvarchar(38)) as СкладИД,
	cast(tr.from_product as nvarchar(38)) as ПродуктОткудаИД,
	0 as ПродуктОткудаТип,
	cast(tr.to_product as nvarchar(38)) as ПродуктКудаИД,
	sum(coalesce(tr.sum,0)) as Сумма,
	sum(coalesce(tr.sumnds,0)) as СуммаНДС,
	sum(coalesce(tr.from_amount,0)) as КоличествоОткуда ,
	sum(coalesce(tr.to_amount,0)) as КоличествоКуда
  FROM dbo.accountingtransaction tr
  -- left join dbo.entity e on e.id = tr.from_product
  WHERE tr.type in ('PROD', 'SWROFF', 'TRANS')
	 and tr.documentId = @p1
  group by
	cast(tr.department as nvarchar(38)),
	cast(tr.conception as nvarchar(38)),
	cast(tr.from_account as nvarchar(38)),
	cast(tr.from_product as nvarchar(38)),
	cast(tr.to_product as nvarchar(38))
	`
	const result: any = await tx.manyOrNone(_SQL_TabelDef, [doc.id])
	const tabel: Array<IsqlTabelDefResult> = result
	const items_Result: any | Array<IitemsDef> = []
	let counter: number = 0;
	if (tabel) {
		for (let tab = 0; tabel.length > tab; tab++) {
			if (tab % 2 == 0) {
				counter++
			}
			items_Result.push({
				CodeRow: counter - 1,
				SKU_Out: tabel[tab].ПродуктОткудаИД,
				SKU_In: tabel[tab].ПродуктКудаИД,
				Qty_Out: tabel[tab].КоличествоКуда,
				Qty_In: tabel[tab].КоличествоКуда
			})
		}
		return items_Result;
	} else {
		console.log("ERORR TABEL DEF:")
	}
}
interface IitemsDef {
	CodeRow: Number
	SKU_Out: Number,
	SKU_In: String,
	Qty_Out: Number,
	Qty_In: Number

}

interface IsqlTabelDefResult {
	TypeItem: String,
	Rank: Number,
	ПозицияИД: any,
	ДепратаментИД: String,
	КонцепцияИД: null,
	СкладИД: String,
	ПродуктОткудаИД: null,
	ПродуктОткудаТип: Number,
	ПродуктКудаИД: String,
	Сумма: Number,
	СуммаНДС: Number,
	КоличествоОткуда: Number,
	КоличествоКуда: Number
}
interface IiikoMergeDoc {
	id: String,
	comment: String,
	conception: String,
	dateIncoming: Date,
	documentNumber: String,
	status: Number,
	store: String,
	dateModified: Date
}

// TODO: https://github.com/x100group/jetti-back-is/blob/master/specification-sync/pipeline.ts#L94