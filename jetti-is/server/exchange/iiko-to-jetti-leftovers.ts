import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { SQLPool } from '../sql/sql-pool';
import {
	ISyncParams,
	saveLogProtocol,
	GetSqlConfig,
	exchangeManyOrNone,
} from './iiko-to-jetti-connection';
import {
	DateToString,
	GetCatalog,
	Ref,
	UpdateDocument,
	InsertDocumentNoEchange,
} from './iiko-to-jetti-utils';

const syncStage = 'Document.LeftRovers';

export async function ImportLeftRoverToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync LeftRover Documents`,
	);
	if (syncParams.baseType === 'sql')
		await ImportLeftRoverSQLToJetti(syncParams, docList);
}
export async function ImportLeftRoverSQLToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	const intgDate: any = syncParams.periodBegin;
	intgDate.setUTCHours(23);
	intgDate.setMinutes(59);
	intgDate.setSeconds(59);
	const ssqlcfg = await GetSqlConfig(syncParams.source.id);
	const ssql = new SQLClient(new SQLPool(ssqlcfg));
	const dsql = new SQLClient(
		new SQLPool(await GetSqlConfig(syncParams.destination)),
	);
	let dtSQLnormaliz: any = syncParams.periodBegin;

	if (syncParams.periodBegin) {
		dtSQLnormaliz = DateToString(syncParams.periodBegin);
	} else {
		// TODO Иван я забыл какая здесь логика должна быть
	}
	let sw = '';
	//
	let i = 0;
	if (syncParams.exchangeID) {
		sw = ` where ttt.StoreID = '${syncParams.exchangeID}' `;
	} else {
		if (syncParams.source.exchangeStores.length > 0) {
			// ограничение по списку складов
			sw += ` where ttt.StoreID in (`;
			i = 0;
			for (const store of syncParams.source.exchangeStores) {
				i++;
				if (i === 1) sw += `'${store}'`;
				else sw += `, '${store}'`;
			}
			sw += ') ';
		}
	}
	//
	const newSQL = `
	SELECT
			sz.StoreID as SKU2,
			sz.ProductID as SKU,
			sz.Amount as Qty,
			sz.Summa as Amount
	FROM (
	SELECT
			cast(ttt.StoreID as nvarchar(50)) as StoreID,
			cast(ttt.ProductID as nvarchar(50)) as ProductID,
			sum(ttt.Amount) as Amount,
			sum(ttt.Summa) as Summa
	FROM
	(SELECT
			tt.[from_account] as StoreID,
			tt.[from_product] as ProductID,
			coalesce(-tt.[from_amount],0) as Amount,
			coalesce(-tt.[sum],0) as Summa
	FROM [dbo].[AccountingTransaction] as tt
			left join [dbo].[entity] en on (en.id=tt.[from_account])
	WHERE tt.[date]< CONVERT(nvarchar(8),@p1,112)  and en.type='Store'
	and not tt.[from_product] is null
	UNION ALL
	SELECT
			tt.[to_account],
			tt.[to_product],
			coalesce(tt.[to_amount],0),
			coalesce(tt.[sum],0)
	FROM [dbo].[AccountingTransaction] as tt
			left join [dbo].[entity] en on 	(en.id=tt.[to_account])
	WHERE tt.[date]< CONVERT(nvarchar(8),@p1,112)  and en.type='Store'
	and not tt.[to_product] is null
	) ttt
	${sw}
	group by
			ttt.StoreID,
			ttt.ProductID
	having sum(ttt.Amount) <>0) sz
	order by sz.StoreID`;
	const response: any = await ssql.manyOrNone(newSQL, [dtSQLnormaliz]);
	const storeUniqueResponce: any = {};
	const Suppler: String = '5848BB10-CC21-11EA-9CDA-3D7B55893E63';
	const AmountResult = ammountResultList(response);
	for (const docResponce of response) {
		if (storeUniqueResponce[docResponce.SKU2] !== undefined) {
			storeUniqueResponce[docResponce.SKU2].push(docResponce)
		} else {
			storeUniqueResponce[docResponce.SKU2] = [docResponce];
		}
	}

	for (const [key, value] of Object.entries(storeUniqueResponce)) {
		let isNewDoc = true;
		const Operation = 'Document.Operation';
		const dateWrite = syncParams.periodBegin;
		const codez = syncParams.source.code + '-' + Math.random();
		const NOSQLDOC: any = {
			doc: {
				type: 'Document.Operation',
				date: DateToString(intgDate),
				Group: '6A02FB90-D2FD-11E9-9483-1F74290EBA2F',
				Suplier: {},
				Storehouse: {},
				Department: {},
				PayDate: Date,
				Items: [],
			},
		};
		const storeInternal: any = await GetCatalog(
			syncParams.project.id,
			key,
			syncParams.source.id,
			'Storehouse',
			dsql,
		);
		if (storeInternal) {
			const tabelDefComputed = value;
			const QTY_val: Number = computedQTY(tabelDefComputed);
			const company = (await dsql.oneOrNone<{ id: Ref }>(
				`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
				[syncParams.periodBegin, storeInternal.doc.Department],
			))!; // организация
			const pos: any = await exchangeManyOrNone(
				`
				SELECT
					(SELECT top 1 [id] FROM [dbo].[catalog]
					c where [project]=@p1 and
					[exchangeCode]=p.[SKU] and
					[exchangeBase]=@p2 and [exchangeType] = 'Product') as SKU,
					p.[Qty],
					p.[Amount] as Amount
					FROM OPENJSON(@p3) WITH (
							[SKU] UNIQUEIDENTIFIER,
							[Qty] money,
							[Amount] money) as p
				`,
				[
					syncParams.project.id,
					syncParams.source.id,
					JSON.stringify(tabelDefComputed),
				],
			);
			const ResultDocOfBaseRecivier = (await dsql.oneOrNone<{ id: Ref }>(
				` SELECT id FROM [Document.Operation.v] d where d.date=@p1 and d.Operation=@p2 and d.f2=@p3 `,
				[syncParams.periodBegin, storeInternal.doc.Department, storeInternal.id],
			))!; // проверка на сущестоваstoreInternal.doc.Department в базе приемнике
			if (ResultDocOfBaseRecivier) {
				isNewDoc = false;
			}
			(NOSQLDOC.id = uuidv1().toUpperCase()), (NOSQLDOC.date = dateWrite);
			NOSQLDOC.posted = 0;
			NOSQLDOC.code = codez;
			NOSQLDOC.description = '';
			NOSQLDOC.deleted = 0;
			NOSQLDOC.parent = null;
			NOSQLDOC.isfolder = false;
			NOSQLDOC.user = null;
			NOSQLDOC.company = company.id;
			NOSQLDOC.doc.currency = syncParams.source.currency;
			NOSQLDOC.doc.Storehouse = storeInternal.id;
			NOSQLDOC.doc.Department = company;
			NOSQLDOC.doc.PayDate = syncParams.periodBegin;
			NOSQLDOC.doc.Items = pos;
			NOSQLDOC.doc.Suplier = Suppler;
			NOSQLDOC.doc.f1 = Suppler;
			NOSQLDOC.doc.f2 = storeInternal.id;
			NOSQLDOC.doc.f3 = company.id;
			NOSQLDOC.doc.PayDate = null;
			NOSQLDOC.doc.Department = storeInternal.doc.Department;
			NOSQLDOC.doc.Amount = sumAmouted(pos);
			NOSQLDOC.doc.Price = priceComputed(NOSQLDOC.doc.Amount, QTY_val);
			const jsonDoc = JSON.stringify(NOSQLDOC);
			try {
				if (isNewDoc) await InsertDocumentNoEchange(jsonDoc, NOSQLDOC.id, dsql);
				else {
					await UpdateDocument(jsonDoc, NOSQLDOC.id, dsql);
				}
			} catch (exep) {
				console.log(exep);
			}
		} else {
			console.log('STORE not found:', syncParams.project.id, key, syncParams.source.id);
		}
	}
}
function ammountResultList(amountListResponce: any): any {
	const objAmmountedData: any = {};
	for (const document of amountListResponce) {
		if (document) {
			if (objAmmountedData[document.SKU2]) {
				objAmmountedData[document.SKU2].push(document.Amount);
			} else {
				objAmmountedData[document.SKU2] = [document.Amount];
			}
		}
	}
	// console.log(objAmmountedData)
	return objAmmountedData;
}
function computedSKU2(value: any): any {
	const p = Object.keys(value);
	return p[0];
}
function sumAmouted(listNum: any): Number {
	let sum = 0;
	for (const num of listNum) {
		sum += Math.abs(num.Amount);
	}
	return sum;
}
function computedQTY(tabelDefComputed: any): Number {
	let sum: any = 0;
	for (const tabel of tabelDefComputed) {
		sum += tabel.Qty;
	}
	return Math.floor(sum);
}
function priceComputed(amount: any, qty: any): Number {
	if (amount === 0 && qty === 0) {
		return 0;
	} else {
		return amount % qty;
	}
}


