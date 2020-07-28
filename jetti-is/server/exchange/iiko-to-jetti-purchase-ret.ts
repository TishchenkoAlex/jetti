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
interface IPurchaseRetDOC {
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
	supplier: string;
	incomingDate: Date;
	incomingDocumentNumber: Number;
}
///////////////////////////////////////////////////////////

const transformPurchaseRet = (
	syncParams: ISyncParams,
	source: any,
): IPurchaseRetDOC => {
	return {
		id: source.id,
		comment: source.comment,
		conception: source.conception,
		date: source.dateIncoming,
		documentNumber: source.documentNumber,
		supplier: source.supplier,
		incomingDate: source.incomingDate,
		incomingDocumentNumber: source.incomingDocumentNumber,
		revision: source.revision,
		status: source.status,
		project: syncParams.project.id,
		baseid: syncParams.source.id,
		type: 'PurshaseRetDoc',
		store: source.Store,
		// ? what is typeDOC
		dateModified: source.dateModified,
		userModified: source.userModified,
	};
};
///////////////////////////////////////////////////////////

const newPurchase = () => {
	return {
		id: uuidv1().toUpperCase(),
		type: 'Document.Operation',
		code: '',
		description: '',
		posted: 0,
		deleted: 0,
		doc: {
			Group: 'E74FF926-C149-11E7-BD8F-43B2F3011722',
			Operation: '6A2D525E-C149-11E7-9418-D72026C63174',
			Amount: null,
			currency: '',
			f1: '',
			f2: '',
			PayDate: '',
			Department: '',
			Storehouse: '',
			Suplier: '',
			Contract: '',
			DocNumber: '',
			DocDate: '',
			DocReceived: '',
			OriginalReceived: '',
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
	iikoDoc: IPurchaseRetDOC,
	sourceSQL: SQLClient,
	destSQL: SQLClient,
): Promise<any> {
	try {
		const store: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.store,
			syncParams.source.id,
			'Storehouse',
			destSQL,
		);

		const contrAgent: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.supplier,
			syncParams.source.id,
			'Counterpartie',
			destSQL,
		);

		const company = (await destSQL.oneOrNone<{ id: Ref }>(
			`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
			[iikoDoc.date, store.doc.Department],
		))!;
		if (!contrAgent) {
			await saveLogProtocol(
				syncParams.syncid,
				0,
				1,
				syncStage,
				`log: Contr Agent not found  ${
					iikoDoc.id
				} ${iikoDoc.date.toString()} #${iikoDoc.documentNumber}`,
			);
			throw new Error('Agent not exists');
		}

		const contract = (await destSQL.oneOrNone<{ id: Ref }>(
			`SELECT max([id]), count(id) FROM [sm].[dbo].[Documents] where [type]='Catalog.Contract'
			and deleted=0 and JSON_VALUE(doc,'$.owner')=@p1 and company=@p2 and  JSON_VALUE(doc,'$.currency')=@p3;`,
			[contrAgent.id, company.id, syncParams.source.currency],
		))!; // контракт

		if (syncParams.logLevel > 1)
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`PurchaseRet ${iikoDoc.id} ${iikoDoc.date.toString()} #${
					iikoDoc.documentNumber
				}`,
			);
		const Group = '1BBC1180-DBE3-11E9-8DB3-33306EFA1D96';
		const Operation = '3C9E4DB0-DB8D-11E9-AB90-E7CDB79DAB8C';
		if (!contract) throw new Error('Contract not exists');
		if (!contrAgent) throw new Error('Agent not exists');

		if (!store) throw new Error('Storehouse not exists');

		const typeFranchise: any = await destSQL.oneOrNone(
			`select dbo.FranchiseOnDate(@p1, @p2) as tf `,
			[iikoDoc.date, store.doc.Department],
		); // тип франшизы
		if (typeFranchise.tf === 'Classic franchise') {
			return;
		}

		let PositionPurchaseRet: any = await sourceSQL.manyOrNone(
			`SELECT cast(tr.to_product as nvarchar(38)) as SKU,
            coalesce(tr.sum,0) as Amount,
            coalesce(tr.to_amount,0) as Qty,
            case
                when(coalesce(tr.to_amount,0)<>0) then coalesce(tr.sum,0)/coalesce(tr.to_amount,0)
                else 0
            end as Price,
            round(coalesce(tr.sum,0)*100/(100+COALESCE(tr.ndsPercent,0)), 2) as AmountWithoutTax,
            round(coalesce(tr.sum,0)-round(coalesce(tr.sum,0)*100/(100+COALESCE(tr.ndsPercent,0)), 2)-0.001, 2) as Tax,
            round(coalesce(tr.ndsPercent,0),2) as QtyAcc
            FROM dbo.accountingtransaction tr
            WHERE tr.documentid = @p1
            and not tr.to_product is null`,
			[iikoDoc.id],
		);
		PositionPurchaseRet = await exchangeManyOrNone(
			`SELECT (SELECT top 1 [id] FROM dbo.catalog c where [project]=@p1
		and [exchangeCode]=p.[SKU]  and [exchangeBase]=@p2 and [exchangeType] = 'Product') as [SKU],
        p.[Qty],
        p.[Price],
        p.[Amount],
        p.[Tax],
        p.[AmountWithoutTax],
        p.[QtyAcc]
    FROM OPENJSON(@p3) WITH (
        [SKU] UNIQUEIDENTIFIER,
        [Qty] money,
        [Price] money,
        [Amount] money,
        [Tax] money,
        [AmountWithoutTax] money,
        [QtyAcc] money) as p`,
			[
				syncParams.project.id,
				syncParams.source.id,
				JSON.stringify(PositionPurchaseRet),
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
		datez.setUTCHours(8);
		datez.setMinutes(0);
		datez.setSeconds(0);
		// пишем в документ по времени в 8:00
		const codez = syncParams.source.code + '-' + iikoDoc.documentNumber;
		const descriptionz: any = await destSQL.oneOrNone(
			`
        SELECT N'Operation ('+d.description+N') #'+@p1+N', '+convert(nvarchar(30), @p2, 127) as dsc FROM [dbo].[Catalog.Operation.v] d WITH (NOEXPAND) where d.[id] = @p3 `,
			[codez, datez.toJSON(), Operation],
		);
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
					`PurchaseRet ${iikoDoc.id} #${iikoDoc.documentNumber} insert`,
				);
			}
			NoSqlDocument = newPurchase();
		} else {
			if (syncParams.logLevel > 1) {
				await saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`PurchaseRet ${iikoDoc.id} #${iikoDoc.documentNumber} update`,
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
		NoSqlDocument.parent = null;
		NoSqlDocument.isfolder = false;
		NoSqlDocument.company = company.id;
		NoSqlDocument.user = null;
		NoSqlDocument.info = null;
		NoSqlDocument.doc.DocDate = null;
		NoSqlDocument.doc.Group = Group;
		NoSqlDocument.doc.Items = PositionPurchaseRet;
		NoSqlDocument.doc.ExchangeUser = userModifay.id;
		NoSqlDocument.doc.ExchangeModified = iikoDoc.dateModified;
		NoSqlDocument.doc.ExchangeRevision = iikoDoc.revision;
		NoSqlDocument.doc.currency = syncParams.source.currency;
		NoSqlDocument.doc.f1 = iikoDoc.supplier;
		NoSqlDocument.doc.f2 = store;
		NoSqlDocument.doc.f3 = store.doc.Department;
		NoSqlDocument.doc.Suplier = iikoDoc.supplier;
		NoSqlDocument.doc.Contract = contract.id;
		NoSqlDocument.doc.Department = store.doc.Department;
		NoSqlDocument.doc.Storehouse = store.id;
		NoSqlDocument.doc.PayDate = iikoDoc.date;
		NoSqlDocument.doc.DocNumber = iikoDoc.documentNumber;
		NoSqlDocument.doc.Contract = store.id;
		if (syncParams.source.id === 'Ukraine') {
			// проверка на Украину
			NoSqlDocument.doc.Operation = 'FBDEBFA0-3634-11EA-A656-856C3785004E';
		}

		if (NoSqlDocument.doc.PayDate >= '20200101') {
			NoSqlDocument.doc.Group = 'E74FF926-C149-11E7-BD8F-43B2F3011722';
			NoSqlDocument.doc.Operation = 'B4FE6830-2D40-11EA-A1A8-811EE0404FBB';
		}
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

export async function ImportPurchaseRetToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync Purchase Ret Documents`,
	);
	if (syncParams.baseType === 'sql')
		await ImportPurchaseRetSQLToJetti(syncParams, docList);
}
export async function ImportPurchaseRetSQLToJetti(
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
		sw = ` where ( cast(dateIncoming as DATE) between '${DateToString(
			syncParams.periodBegin,
		)}' and '${DateToString(syncParams.periodEnd)}' `;
		if (syncParams.execFlag === 126 && syncParams.autosync) {
			sw += ` or (cast(dateIncoming as DATE) >= '${DateToString(
				syncParams.firstDate,
			)}' and cast(dateIncoming as DATE) < '${DateToString(
				syncParams.periodBegin,
			)}' and d.dateModified >= '${DateToString(syncParams.lastSyncDate)}' )) `;
		} else sw += ') ';
		if (syncParams.exchangeID === null) {
			if (syncParams.source.exchangeStores.length > 0) {
				// ограничение по списку складов
				sw += ` and  defaultStore in (`;
				i = 0;
				for (const store of syncParams.source.exchangeStores) {
					i++;
					if (i === 1) sw += `'${store}'`;
					else sw += `, '${store}'`;
				}
				sw += ') ';
			}
		} else {
			sw += ` and  defaultStore = '${syncParams.exchangeID}' `;
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
	const newSQL = `SELECT d.id,
                    cast(d.comment as nvarchar(255)) as comment,
                    cast(d.conception as nvarchar(50)) as conception,
                    d.dateIncoming,
                    cast(d.documentNumber as nvarchar(33)) as documentNumber,
                    d.status,
                    cast(d.defaultStore as nvarchar(50)) as Store,
                    cast(d.supplier as nvarchar(50)) as supplier,
                    cast(d.revision as nvarchar(50)) as revision,
                    d.dateModified,
                    cast(d.userModified as nvarchar(50)) as userModified
                    FROM dbo.ReturnedInvoice d ${sw}`;
	i = 0;
	let batch: IPurchaseRetDOC[] = [];
	const response = await ssql.manyOrNoneStream(
		newSQL,
		[],
		async (row: ColumnValue[], req: Request) => {
			i = i + 1;
			const rawDoc: any = {};
			row.forEach((col) => (rawDoc[col.metadata.colName] = col.value));
			batch.push(rawDoc);
			if (batch.length === ssqlcfg.batch.max) {
				if (syncParams.logLevel > 1)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting to batch ${i} Purshase Ret docs`,
					);
				for (const doc of batch) {
					const docResult = transformPurchaseRet(syncParams, doc);
					await syncInventSQL(syncParams, docResult, ssql, dsql);
				}
				req.pause();
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
						`inserting tail ${batch.length} Purshase Ret docs`,
					);
				for (const doc of batch) {
					const docResult = transformPurchaseRet(syncParams, doc);
					await syncInventSQL(syncParams, docResult, ssql, dsql);
				}
			}
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`Finish sync Purshase Ret Docs`,
			);
		},
	);
}
