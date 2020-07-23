import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';

import { SQLPool } from '../sql/sql-pool';
import {
	ISyncParams,
	saveLogProtocol,
	exchangeManyOrNone,
	GetSqlConfig,
} from './iiko-to-jetti-connection';
import {
	DateToString,
	GetCatalog,
	Ref,
	InsertDocument,
	GetDocument,
	UpdateDocument,
	setQueuePostDocument,
} from './iiko-to-jetti-utils';
///////////////////////////////////////////////////////////
const syncStage = 'Document.Order';
///////////////////////////////////////////////////////////
interface IiikoWriteOff {
	project: string;
	id: string;
	baseid: string;
	comment: string;
	conception: string;
	date: Date;
	type: string;
	documentNumber: string;
	status: number;
	store: string;
	revision: string;
	dateModified: Date;
	userModified: string;
	account: string;
}
///////////////////////////////////////////////////////////
const transformWriteOff = (
	syncParams: ISyncParams,
	source: any,
): IiikoWriteOff => {
	return {
		project: syncParams.project.id,
		id: source.id,
		comment: source.comment,
		baseid: syncParams.source.id,
		conception: source.conception,
		date: source.dateIncoming,
		type: 'WriteOffDoc',
		documentNumber: source.documentNumber,
		status: source.status,
		store: source.store,
		account: source.account,
		revision: source.revision,
		dateModified: source.dateModified,
		userModified: source.userModified,
	};
};
///////////////////////////////////////////////////////////

const newWriteOff = () => {
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
async function syncWriteSQL(
	syncParams: ISyncParams,
	iikoDoc: IiikoWriteOff,
	sourceSQL: SQLClient,
	destSQL: SQLClient,
): Promise<any> {
	try {
		if (syncParams.logLevel > 1)
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`Inventoryzation ${iikoDoc.id} ${iikoDoc.date.toString()} #${
					iikoDoc.documentNumber
				}`,
			);
		const Group = 'B10E6E0C-C25B-11E7-8D9E-93FE7FC73581';
		const Operation = 'A0B05FAC-C25B-11E7-82D2-BF6A302D5272';
		const store = await GetCatalog(
			syncParams.project.id,
			iikoDoc.store,
			syncParams.source.id,
			'Storehouse',
			destSQL,
		); // склад
		if (!store) throw new Error('Storehouse not exists');

		const company = (await destSQL.oneOrNone<{ id: Ref }>(
			`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
			[iikoDoc.date, store.doc.Department],
		))!; // организация

		const typeFranchise: any = await destSQL.oneOrNone(
			`select dbo.FranchiseOnDate(@p1, @p2) as tf `,
			[iikoDoc.date, store.doc.Department],
		); // тип франшизы
		if (typeFranchise.tf === 'Classic franchise') {
			return;
		}
		let PositionWriteOff: any = await sourceSQL.manyOrNone(
			`SELECT cast(tr.from_product as nvarchar(38)) as SKU,
			coalesce(tr.sum,0) as Amount,
			coalesce(tr.from_amount,0) as Qty,
			case
			when(coalesce(tr.from_amount,0)<>0) then coalesce(tr.sum,0)/coalesce(tr.from_amount,0)
			else 0
			end as price,
			coalesce(tr.sum,0)*100/(100+COALESCE(tr.ndsPercent,0)) as AmountWithoutTax,
			coalesce(tr.sum,0)-coalesce(tr.sum,0)*100/(100+COALESCE(tr.ndsPercent,0)) as Tax
		FROM dbo.accountingtransaction tr
		WHERE tr.type='WROFF' and tr.documentId = @p1
			and coalesce(tr.from_amount,0)>0 and not tr.from_product is null
        `,
			[iikoDoc.id],
		);
		PositionWriteOff = await exchangeManyOrNone(
			`
    SELECT
        (SELECT top 1 [id] FROM dbo.catalog c where [project]=@p1 and [exchangeCode]=p.[SKU] and [exchangeBase]=@p2 and [exchangeType] = 'Product') as [SKU],
		p.[Qty]
    FROM OPENJSON(@p3) WITH (
        [SKU] UNIQUEIDENTIFIER,
		[Amount] money,
		[Qty] money,
		[price] money,
		[AmountWithoutTax] money,
		[Tax] money) as p
    `,
			[
				syncParams.project.id,
				syncParams.source.id,
				JSON.stringify(PositionWriteOff),
			],
		);
		const datez: Date = iikoDoc.date;
		const userModifay: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.userModified,
			syncParams.source.id,
			'Person',
			destSQL,
		);
		datez.setUTCHours(14);
		datez.setMinutes(0);
		datez.setSeconds(0);
		const codez = syncParams.source.code + '-' + iikoDoc.documentNumber;
		const descriptionz: any = await destSQL.oneOrNone(
			`
        SELECT N'Operation ('+d.description+N') #'+@p1+N', '+convert(nvarchar(30), @p2, 127) as dsc FROM [dbo].[Catalog.Operation.v] d WITH (NOEXPAND) where d.[id] = @p3 `,
			[codez, datez.toJSON(), Operation],
		);
		// заполняем документ
		let isNewDoc: Boolean = false;
		let NoSqlDocument: any = await GetDocument(
			iikoDoc.project,
			iikoDoc.id,
			iikoDoc.baseid,
			iikoDoc.type,
			destSQL,
		);
		if (!NoSqlDocument) {
			isNewDoc = true;
			if (syncParams.logLevel > 1) {
				await saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`Write Off ${iikoDoc.id} #${iikoDoc.documentNumber} insert`,
				);
			}
			NoSqlDocument = newWriteOff();
		} else {
			if (syncParams.logLevel > 1) {
				await saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`Write Off ${iikoDoc.id} #${iikoDoc.documentNumber} update`,
				);
			}
		}
		NoSqlDocument.type = 'Document.Operation';
		NoSqlDocument.date = datez;
		NoSqlDocument.code = codez;
		NoSqlDocument.description = descriptionz.dsc;
		NoSqlDocument.posted = 0;
		if (iikoDoc.status === 0 || iikoDoc.status === 2) {
			NoSqlDocument.deleted = true;
		} else {
			NoSqlDocument.deleted = false;
		}
		NoSqlDocument.doc.Group = Group;
		NoSqlDocument.doc.Operation = Operation;
		NoSqlDocument.doc.currency = syncParams.source.currency;
		NoSqlDocument.doc.f1 = store.doc.Department;
		NoSqlDocument.doc.f2 = store;
		NoSqlDocument.doc.Department = store.doc.Department;
		NoSqlDocument.doc.Storehouse = store.id;
		NoSqlDocument.parent = null;
		NoSqlDocument.isfolder = false;
		NoSqlDocument.company = company.id;
		NoSqlDocument.user = null;
		NoSqlDocument.info = null;
		NoSqlDocument.doc.Items = PositionWriteOff;
		NoSqlDocument.doc.ExchangeUser = userModifay.id;
		NoSqlDocument.doc.ExchangeModified = iikoDoc.dateModified;
		NoSqlDocument.doc.ExchangeRevision = iikoDoc.revision;
		const jsonDoc = JSON.stringify(NoSqlDocument);
		if (isNewDoc)
			await InsertDocument(jsonDoc, NoSqlDocument.id, iikoDoc, destSQL);
		else await UpdateDocument(jsonDoc, NoSqlDocument.id, destSQL);
		if (syncParams.flow >= 0) {
			await setQueuePostDocument(
				NoSqlDocument.id,
				NoSqlDocument.company,
				syncParams.flow,
				destSQL,
			);
		}
	} catch (error) {
		await saveLogProtocol(syncParams.syncid, 0, 1, syncStage, error.message);
	}
}

export async function ImportWriteOffToJetti(
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
		await ImportWriteOffSQLToJetti(syncParams, docList);
}
export async function ImportWriteOffSQLToJetti(
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
	let sw = '';
	if (docList.length === 0) {
		// выборка по интервалу дат
		sw = ` where ( cast(d.dateIncoming as DATE) between '${DateToString(
			syncParams.periodBegin,
		)}' and '${DateToString(syncParams.periodEnd)}' `;
		if (syncParams.execFlag === 126 && syncParams.autosync) {
			sw += ` or (cast(d.dateIncoming as DATE) >= '${DateToString(
				syncParams.firstDate,
			)}' and cast(d.dateIncoming as DATE) < '${DateToString(
				syncParams.periodBegin,
			)}' and d.dateModified >= '${DateToString(syncParams.lastSyncDate)}' )) `;
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

	const sql = `SELECT d.id as id,
    cast(d.comment as nvarchar(255)) as comment,
    cast(d.conception as nvarchar(50)) as conception,
    d.dateIncoming,
    cast(d.documentNumber as nvarchar(33)) as documentNumber,
    d.status as Status,
    cast(d.Store as nvarchar(50)) as store,
    cast(d.accountTo as nvarchar(50)) as account,
    cast(d.revision as nvarchar(50)) as revision,
    d.dateModified,
    cast(d.userModified as nvarchar(50)) as userModified
    FROM dbo.WriteoffDocument d ${sw} order by d.dateIncoming;`;
	i = 0;
	let batch: IiikoWriteOff[] = [];
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
				await saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`inserting to batch ${i} Write Off docs`,
				);
			for (const doc of batch) {
				const docResult = transformWriteOff(syncParams, doc);
				await syncWriteSQL(syncParams, docResult, ssql, dsql);
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
					const docResult = transformWriteOff(syncParams, doc);
					await syncWriteSQL(syncParams, docResult, ssql, dsql);
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
