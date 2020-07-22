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
import responceLEFTROVERS = require('./responce_leftovers.json');
const syncStage = 'Document.Purshase';

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
	const ssqlcfg = await GetSqlConfig(syncParams.source.id);
	const ssql = new SQLClient(new SQLPool(ssqlcfg));
	const dsql = new SQLClient(
		new SQLPool(await GetSqlConfig(syncParams.destination)),
	);
	let dtSQLnormaliz: any = syncParams.periodBegin;

	if (syncParams.periodBegin) {
		dtSQLnormaliz = DateToString(syncParams.periodBegin);
	} else {
		// todo
	}
	let sw = '';
	if (syncParams.exchangeID) {
		if (syncParams.exchangeID.length > 0) {
			sw = ` where ttt.StoreID = '${syncParams.exchangeID}' `;
		}
	}
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
			left join [dbo].[entity] en on (en.id=tt.[to_account])
	WHERE tt.[date]< CONVERT(nvarchar(8),@p1,112)  and en.type='Store'
	and not tt.[to_product] is null
	) ttt
	${sw}
	group by
			ttt.StoreID,
			ttt.ProductID
	having sum(ttt.Amount) <>0) sz
	order by sz.StoreID`;

	// const response = await ssql.manyOrNone(newSQL, [dtSQLnormaliz]);
	const storeUniqueResponce = {};


	for (const { SKU2 } of responceLEFTROVERS) {
		if (storeUniqueResponce[SKU2] !== undefined) {
			return;
		} else {
			storeUniqueResponce[SKU2] = '';
		}
	}
	for (const [storeGUID] of Object.entries(storeUniqueResponce)) {
		let NOSQLDOC: any = {
			Suplier: {},
			Storehouse: {},
			Department: {},
			PayDate: Date,
			Items: []
		}
		const storeInternal: any = await GetCatalog(
			syncParams.project.id,
			storeGUID,
			syncParams.source.id,
			'Storehouse',
			dsql,
		);
		const company = (await dsql.oneOrNone<{ id: Ref }>(
			// ! todo Nikita say:  я не уверен что это правильно?
			`SELECT * from [Catalog.Company.v] where id=@p1`,
			[storeInternal.company],
		))!; // компания

		const department = (await dsql.oneOrNone<{ id: Ref }>(
			// ! todo Nikita say:  я не уверен что это правильно?
			`SELECT * from [Catalog.Department.v] where id=@p1`,
			[storeInternal.doc.Department],
		))!; // департамент
		const ResultDocOfBaseRecivier = (await dsql.oneOrNone<{ id: Ref }>(
			// ! todo Nikita say:  я не уверен что это правильно?
			` SELECT id FROM [Document.Operation.v] d where d.date=@p1 and d.Operation=@p2 and d.f2=@p3 `,
			[syncParams.periodBegin, department.id, storeInternal.id],
		))!; // проверка на сущестование документа в базе приемнике
		if (ResultDocOfBaseRecivier) {

		} else {
			NOSQLDOC.Storehouse = storeInternal;
			NOSQLDOC.Department = department;
			NOSQLDOC.Suplier 
			// todo ? https://smv-jetti.web.app/Catalog.Operation/4CF6EAC0-D2FD-11E9-A931-91F77FF9385E согласны этим данным у нас есть Supler
			NOSQLDOC.PayDate = syncParams.periodBegin;
			// ! todo Nikita say:  я не уверен что это правильно?
			NOSQLDOC.Items = storeInternal;
		}
	}
}
