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
import { stdout } from 'process';
import { countReset } from 'console';
import { config as dotenv } from 'dotenv';

///////////////////////////////////////////////////////////
const syncStage = 'Document.Purshase';
///////////////////////////////////////////////////////////
interface ITransferInt {
	project: string;
	id: string;
	dtype: number;
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

const transformTransferInt = (
	syncParams: ISyncParams,
	source: any,
): ITransferInt => {
	return {
		id: source.id,
		dtype: source.dtype,
		comment: source.Comment,
		conception: source.conception,
		date: source.dateIncoming,
		documentNumber: source.documentNumber,
		supplier: source.supplier,
		incomingDate: source.dateIncoming,
		incomingDocumentNumber: source.incomingDocumentNumber,
		revision: source.revision,
		status: source.status,
		type: 'TRNSF',
		store: source.store,
		dateModified: source.dateModified,
		userModified: source.userModified,
		project: syncParams.project.id,
		baseid: syncParams.source.id,
	};
};
///////////////////////////////////////////////////////////

const newTransferInt = () => {
	return {
		id: uuidv1().toUpperCase(),
		type: 'Document.Operation',
		code: '',
		description: '',
		posted: 0,
		deleted: 0,
		doc: {
			Group: 'A6B7A54C-C7C2-11E7-B896-F7EA6E20FCFD',
			Operation: 'E323D028-C7C2-11E7-BA63-8F52A98E9388',
			Amount: null,
			currency: '',
			f1: '',
			f2: '',
			f3: '',
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
async function syncTransferSQL(
	syncParams: ISyncParams,
	iikoDoc: ITransferInt,
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
				`TransferInt ${iikoDoc.id} ${iikoDoc.date.toString()} #${
					iikoDoc.documentNumber
				}`,
			);
		const Group = 'A6B7A54C-C7C2-11E7-B896-F7EA6E20FCFD';
		const Operation = 'E323D028-C7C2-11E7-BA63-8F52A98E9388';
		const contrAgent: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.supplier,
			syncParams.source.id,
			'Counterpartie',
			destSQL,
		);
		if (!iikoDoc.dtype) throw new Error('Dtype is not exists');
		if (!contrAgent) throw new Error('ContrAgent is not exists');
		const store: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.store,
			syncParams.source.id,
			'Storehouse',
			destSQL,
		);
		const company = (await destSQL.oneOrNone<{ id: Ref }>(
			`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
			[iikoDoc.date, store.doc.Department],
		))!;
		const contract = (await destSQL.oneOrNone<{ id: Ref }>(
			`SELECT max([id]), count(id) FROM [sm].[dbo].[Documents] where [type]='Catalog.Contract' and deleted=0 and JSON_VALUE(doc,'$.owner')=@p1 and company=@p2 and  JSON_VALUE(doc,'$.currency')=@p3;`,
			[contrAgent.id, company.id, syncParams.source.currency],
		))!;

		const PositionTransfer: any = await sourceSQL.manyOrNone(
			`SELECT cast(tr.type as nvarchar(50)) as TypeItem,
            cast(tr.from_product as nvarchar(38)) as SKU,
            cast(tr.to_product as nvarchar(38)) as SKU2,
            coalesce(tr.from_amount,0) as Qty,
            coalesce(tr.to_amount,0) as QtyFact,
            coalesce(tr.sum,0) as Amount
            FROM dbo.accountingtransaction tr
            WHERE tr.documentid = cast(@p1 as nvarchar(50))
            and ((tr.type='TRNSF' and tr.to_amount=tr.from_amount) or (tr.type='INVOIC' and tr.from_account = '56729828-F09B-D58E-04BE-ED0F2E4E10E1') )
            union all
            SELECT cast(tr.type as nvarchar(50)),
            cast(tr.from_product as nvarchar(38)),
            cast(tr.from_product as nvarchar(38)),
            coalesce(tr.from_amount,0),
            coalesce(tr.from_amount,0),
            coalesce(tr.sum,0)
            FROM dbo.accountingtransaction tr
            WHERE tr.documentid =cast(@p1 as nvarchar(50)) and tr.type = 'OUTREV'`,
			[iikoDoc.id],
		);
		const datez: Date = iikoDoc.date;
		const userModifay: any = await GetCatalog(
			syncParams.project.id,
			iikoDoc.userModified,
			syncParams.source.id,
			'Person',
			destSQL,
		);
		datez.setUTCHours(9);
		datez.setMinutes(30);
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
					`TransferInt doc ${iikoDoc.id} #${iikoDoc.documentNumber} insert`,
				);
			}
		} else {
			if (syncParams.logLevel > 1) {
				await saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`TransferInt doc ${iikoDoc.id} #${iikoDoc.documentNumber} update`,
				);
			}
		}
		NoSqlDocument = newTransferInt();
		const ammountResult = ammountItems(PositionTransfer);
		NoSqlDocument.type = 'Document.Operation';
		NoSqlDocument.date = datez;
		NoSqlDocument.code = codez;
		NoSqlDocument.description = descriptionz.dsc;
		NoSqlDocument.posted = 0;
		NoSqlDocument.parent = iikoDoc.userModified;
		NoSqlDocument.isfolder = false;
		NoSqlDocument.user = iikoDoc.userModified;
		NoSqlDocument.info = null;
		NoSqlDocument.company = company.id;
		NoSqlDocument.doc.Items = PositionTransfer;
		switch (iikoDoc.dtype) {
			case 1:
				// если dtype = 1 нужно проставить, склад откуда всегда равен пути
				NoSqlDocument.doc.StorehouseIn = syncParams.source.TransitStorehouse;
				NoSqlDocument.doc.StorehouseOut = store.id;
				break;
			case 2:
				//  если dtype = 2 нужно проставить склад куда всегда равен пути
				NoSqlDocument.doc.StorehouseIn = store.id;
				NoSqlDocument.doc.StorehouseOut = syncParams.source.TransitStorehouse;
				break;
			case 3:
				//  если dtype = 3 в складе откуда, а в контрагенте куда.
				NoSqlDocument.doc.StorehouseIn = store;
				// todo я не уврен что это правильно?
				NoSqlDocument.doc.StorehouseOut = syncParams.source.TransitStorehouse;
			// tslint:disable-next-line: no-switch-case-fall-through
			default:
				// todo  возможно нужно сделать какое то логирование
				break;
		}
		NoSqlDocument.doc.ExchangeRevision = iikoDoc.revision;
		NoSqlDocument.doc.currency = syncParams.source.currency;
		NoSqlDocument.doc.supplier = iikoDoc.supplier;
		NoSqlDocument.doc.docNumber = iikoDoc.documentNumber;
		NoSqlDocument.doc.Amount = ammountResult;
		NoSqlDocument.doc.f1 = NoSqlDocument.doc.StorehouseOut; // ! возможно это ошибка
		NoSqlDocument.doc.f2 = NoSqlDocument.doc.StorehouseIn;
		NoSqlDocument.doc.f3 = store.doc.Department;
		NoSqlDocument.doc.DepartmentTransit = store.doc.Department;
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

export async function ImportTransferIntToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync Purchase Documents`,
	);
	if (syncParams.baseType === 'sql')
		await ImportTransferIntSQLToJetti(syncParams, docList);
}
export async function ImportTransferIntSQLToJetti(
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
				sw += ` and  store in (`;
				i = 0;
				for (const store of syncParams.source.exchangeStores) {
					i++;
					if (i === 1) sw += `'${store}'`;
					else sw += `, '${store}'`;
				}
				sw += ') ';
			}
		} else {
			sw += ` and  store = '${syncParams.exchangeID}' `;
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
	const newSQL = `select
    	z.id,
    	z.dtype,
    	cast(z.Comment as nvarchar(255)) as Comment,
    	cast(z.conception as nvarchar(50)) as conception,
    	z.dateIncoming,
    	cast(z.documentNumber as nvarchar(33)) as documentNumber,
    	z.status,
    	cast(z.Store as nvarchar(50)) as store,
    	cast(z.Supplier as nvarchar(50)) as supplier,
		cast(z.revision as nvarchar(50)) as revision,
    	z.dateModified,
    	cast(z.userModified as nvarchar(50)) as userModified
    from (
    SELECT d.id,
    	cast(1 as int) as dtype,
    	d.comment as comment,
    	d.conception,
    	d.dateIncoming,
    	d.documentNumber,
    	d.status,
    	d.defaultStore as Store,
    	d.supplier as supplier,
    	d.revision,
    	d.dateModified,
    	d.userModified
    FROM dbo.IncomingInvoice d
    union all
    SELECT d.id,
        cast(2 as int) as dtype,
        d.comment,
        d.conception,
        d.dateIncoming,
        d.documentNumber,
        d.status,
        d.defaultStore,
        d.supplier,
        d.revision,
        d.dateModified,
        d.userModified
    FROM dbo.OutgoingInvoice d
    union all
    SELECT d.id,
        cast(3 as int) dtype,
        d.comment,
        d.conception,
        d.dateIncoming,
        d.documentNumber,
        d.status,
        d.storeFrom,
        d.storeTo,
        d.revision,
        d.dateModified,
        d.userModified
    FROM dbo.InternalTransfer d
    ) as z ${sw} and z.id='351ECDAF-8457-4A2C-9B31-46AEB66730BD'
    order by z.dateIncoming`;
	// ? supplier
	i = 0;
	let batch: ITransferInt[] = [];
	const response = await ssql.manyOrNoneStream(
		newSQL,
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
					`inserting to batch ${i} Purshase docs`,
				);

			// if (batch.length === ssqlcfg.batch.max) {
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
				const docResult = transformTransferInt(syncParams, doc);
				await syncTransferSQL(syncParams, docResult, ssql, dsql);
			}
			batch = [];
			req.resume();
			// }
		},
		async (rowCount: number, more: boolean) => {
			if (rowCount && !more && batch.length > 0) {
				if (syncParams.logLevel > 1)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting tail ${batch.length} TransferInt docs`,
					);
				for (const doc of batch) {
					const docResult = transformTransferInt(syncParams, doc);
					await syncTransferSQL(syncParams, docResult, ssql, dsql);
				}
			}
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`Finish sync TransferInt Docs`,
			);
		},
	);
}

function ammountItems(Items): Number {
	let sum: Number = 0;
	Items.forEach((element) => {
		sum += element.Amount;
	});
	return sum;
}

function validGUID(str) {
	return /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/.test(
		`${str}`,
	);
}
