import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { SQLPool } from '../sql/sql-pool';
import {
	ISyncParams,
	saveLogProtocol,
	GetSqlConfig,
} from './iiko-to-jetti-connection';
import {
	DateToString,
	GetCatalog,
	Ref,
	UpdateDocument,
	InsertDocumentNoEchange,
} from './iiko-to-jetti-utils';
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
		// TODO Иван я забыл какая здесь логика должна быть
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

	const response:any = await ssql.manyOrNone(newSQL, [dtSQLnormaliz]);
	const storeUniqueResponce = {};
	const Suppler: String = '5848BB10-CC21-11EA-9CDA-3D7B55893E63';

	for (const docResponce of response) {
		if (storeUniqueResponce[docResponce.SKU2] !== undefined) {
			return;
		} else {
			storeUniqueResponce[docResponce.SKU2] = docResponce;
		}
	}

	for (const [key, value] of Object.entries(storeUniqueResponce)) {
		let isNewDoc = true;
		const Operation = 'Document.Operation';
		const dateWrite = new Date();
		const codez = syncParams.source.code + '-' + Math.random();
		const NOSQLDOC: any = {
			type: 'Document.Operation',
			doc: {
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
		const company = (await dsql.oneOrNone<{ id: Ref }>(
			`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
			[syncParams.periodBegin, storeInternal.doc.Department],
		))!; // организация
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
		NOSQLDOC.company = syncParams.exchangeID;
		NOSQLDOC.doc.Storehouse = storeInternal.id;
		NOSQLDOC.doc.Department = company;
		NOSQLDOC.doc.PayDate = syncParams.periodBegin;
		NOSQLDOC.doc.Items = value;
		NOSQLDOC.doc.Suplier = Suppler;
		const jsonDoc = JSON.stringify(NOSQLDOC);
		try {
			if (isNewDoc)
				await InsertDocumentNoEchange(
					jsonDoc,
					NOSQLDOC.id,
					dsql,
				);
			else await UpdateDocument(jsonDoc, NOSQLDOC.id, dsql);
		} catch (exep) {
			console.log(exep);
		}
	}
}
