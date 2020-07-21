import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';

import { SQLPool } from '../sql/sql-pool';
import {
	ISyncParams,
	saveLogProtocol,
	exchangeManyOrNone,
	GetSqlConfig,
	GetExchangeCatalogID,
} from './iiko-to-jetti-connection';
import {
	DateToString,
	GetCatalog,
	InsertCatalog,
	UpdateCatalog,
	nullOrID,
	Ref,
	InsertDocument,
	GetDocument,
	UpdateDocument,
	setQueuePostDocument,
} from './iiko-to-jetti-utils';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { text } from 'body-parser';

///////////////////////////////////////////////////////////
const syncStage = 'Document.Invent';
///////////////////////////////////////////////////////////
interface IiikoInvent {
	project: string;
	id: string;
	baseid: string;
	type: string;
	documentNumber: string;
	date: Date;
	comment: string;
	conception: string;
	status: number;
	store: string;
	revision: string;
	dateModified: Date;
	userModified: string;
}
///////////////////////////////////////////////////////////

const transformInvent = (syncParams: ISyncParams, source: any): IiikoInvent => {
	return {
		project: syncParams.project.id,
		id: source.id,
		baseid: syncParams.source.id,
		type: 'InventDoc',
		documentNumber: source.documentNumber,
		date: source.dateIncoming,
		comment: source.comment,
		status: source.status,
		conception: source.conception,
		store: source.store,
		revision: source.revision,
		dateModified: source.dateModified,
		userModified: source.userModified,
	};
};
///////////////////////////////////////////////////////////

const newInventoryzation = () => {
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
			Department: '',
			Storehouse: '',
			Income: '53364DB0-D346-11E9-9B59-A568B1244A3E',
			Analytics_Income: '68BCB5C0-D346-11E9-9B59-A568B1244A3E',
			Expense: '53364DB0-D346-11E9-9B59-A568B1244A3E',
			Analytics_Expense: '633722C0-D346-11E9-9B59-A568B1244A3E', // todo not analytics
			ExchangeUser: '',
			ExchangeModified: '',
			ExchangeRevision: '',
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
async function syncInventSQL(
	syncParams: ISyncParams,
	iikoDoc: IiikoInvent,
	sourceSQL: SQLClient,
	destSQL: SQLClient,
): Promise<any> {
	try {
		// орбработка документа "инвентаризация"
		const startd: number = Date.now();

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
		const Group = '1BBC1180-DBE3-11E9-8DB3-33306EFA1D96';
		const Operation = '3C9E4DB0-DB8D-11E9-AB90-E7CDB79DAB8C';

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
		let PositionInentoryzation: any = await sourceSQL.manyOrNone(
			`
				SELECT  cast(tr.from_product as nvarchar(38)) as SKU,
				cast(0 as numeric(19,9)) as QtyFact,
				coalesce(-tr.from_amount,0) as QtyDiff,
				coalesce(-tr.sum,0) as DifSumma
				FROM dbo.accountingtransaction tr
				WHERE tr.type ='INVENT' and tr.documentId =@p1
				union all
				select cast(di.product as nvarchar(38)) as SKU,
				coalesce(di.amount,0) as QtyFact,cast(0 as numeric(19,9)) as QtyDiff,
				cast(0 as numeric(19,9)) as DifSumma
				from dbo.IncomingInventoryItem di
				where di.inventory_id =@p1
   			`,
			[iikoDoc.id],
		);
		PositionInentoryzation = await exchangeManyOrNone(
			`
				SELECT
				(SELECT top 1 [id] FROM dbo.catalog c where [project]=@p1 and [exchangeCode]=p.[SKU] and [exchangeBase]=@p2 and [exchangeType] = 'Product') as [SKU],
				p.[QtyFact],
				p.[QtyDiff],
				p.[DifSumma] as Amount
				FROM OPENJSON(@p3) WITH (
				[SKU] UNIQUEIDENTIFIER,
				[QtyFact] money,
				[QtyDiff] money,
				[DifSumma] money) as p
  			`,
			[
				syncParams.project.id,
				syncParams.source.id,
				JSON.stringify(PositionInentoryzation),
			],
		);
		const userModifay: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.userModified,
			syncParams.source.id,
			'Person',
			destSQL,
		);
		// пишем документ по времени в  10:00
		const datez: Date = iikoDoc.date;
		datez.setUTCHours(10);
		datez.setMinutes(0);
		datez.setSeconds(0);
		const codez = syncParams.source.code + '-' + iikoDoc.documentNumber;
		const descriptionz: any = await destSQL.oneOrNone(
			`
				SELECT N'Operation ('+d.description+N') #'+@p1+N', '+convert(nvarchar(30), @p2, 127) as dsc 
				FROM [dbo].[Catalog.Operation.v] d WITH (NOEXPAND) where d.[id] = @p3 `,
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
					`Inventoryzation ${iikoDoc.id} #${iikoDoc.documentNumber} insert`,
				);
			}
			NoSqlDocument = newInventoryzation();
		} else {
			if (syncParams.logLevel > 1) {
				await saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`Inventoryzation ${iikoDoc.id} #${iikoDoc.documentNumber} update`,
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
		NoSqlDocument.doc.Items = PositionInentoryzation;
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

export async function ImportInventToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync Inventoryzation Documents`,
	);
	if (syncParams.baseType === 'sql')
		await ImportInventSQLToJetti(syncParams, docList);
}
export async function ImportInventSQLToJetti(
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
	const newSQL = `
		SELECT
			d.id as id,
			COALESCE(cast(d.comment as nvarchar(255)),'') as comment,
			COALESCE(cast(d.conception as nvarchar(50)),'') as conception,
			d.dateIncoming,
			COALESCE(cast(d.documentNumber as nvarchar(33)),'') as documentNumber,
			d.status as status,
			COALESCE(cast(d.store as nvarchar(50)),'') as store,
			cast(d.revision as nvarchar(50)) as revision,
			d.dateModified,
			cast(d.userModified as nvarchar(50)) as userModified
		FROM dbo.IncomingInventory d
		${sw}
		order by d.dateIncoming;`;
	i = 0;
	let batch: IiikoInvent[] = [];
	const response = await ssql.manyOrNoneStream(
		newSQL,
		[],
		async (row: ColumnValue[], req: Request) => {
			i = i + 1;
			const rawDoc: any = {};
			row.forEach((col) => (rawDoc[col.metadata.colName] = col.value));
			batch.push(rawDoc);
			if (batch.length === ssqlcfg.batch.max) {
				req.pause();
				if (syncParams.logLevel > 1)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting to batch ${i} Sales docs`,
					);
				for (const doc of batch) {
					const docResult = transformInvent(syncParams, doc);
					await syncInventSQL(syncParams, docResult, ssql, dsql);
				}
				batch = [];
				req.resume();
			}
		},
		async (rowCount: number, more: boolean) => {
			if (rowCount && !more && batch.length > 0) {
				if (syncParams.logLevel > 1)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting tail ${batch.length} Sales docs`,
					);
				for (const doc of batch) {
					const docResult = transformInvent(syncParams, doc);
					await syncInventSQL(syncParams, docResult, ssql, dsql);
				}
			}
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`Finish sync Sales Docs`,
			);
		},
	);
}
