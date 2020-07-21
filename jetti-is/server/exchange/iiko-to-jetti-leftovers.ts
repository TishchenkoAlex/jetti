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

///////////////////////////////////////////////////////////
const syncStage = 'Document.Purshase';
///////////////////////////////////////////////////////////
interface IPurchaseLeftRover {
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

const transformLeftRover = (
	syncParams: ISyncParams,
	source: any,
): IPurchaseLeftRover => {
	console.log(source);
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
		type: 'PurshaseDoc',
		store: source.defaultStore,
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
			// todo if (souce.id === urkaina) FBDEBFA0-3634-11EA-A656-856C3785004E
			Operation: '6A2D525E-C149-11E7-9418-D72026C63174',
			// todo first date
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
async function syncLeftRoverSQL(
	syncParams: ISyncParams,
	iikoDoc: IPurchaseLeftRover,
	sourceSQL: SQLClient,
	destSQL: SQLClient,
): Promise<any> {
	try {
	} catch (error) {
		await saveLogProtocol(syncParams.syncid, 0, 1, syncStage, error.message);
	}
}

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
			sw = syncParams.exchangeID;
			const newSQL = `SELECT
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
    WHERE tt.[date]< CONVERT(nvarchar(8),'@p2',112)  and en.type='Store'
    and not tt.[from_product] is null
    UNION ALL
    SELECT
        tt.[to_account],
        tt.[to_product],
        coalesce(tt.[to_amount],0),
        coalesce(tt.[sum],0)
    FROM [dbo].[AccountingTransaction] as tt
        left join [dbo].[entity] en on (en.id=tt.[to_account])
    WHERE tt.[date]< CONVERT(nvarchar(8),'@p2',112)  and en.type='Store'
    and not tt.[to_product] is null
    ) ttt
    group by
        ttt.StoreID,
        ttt.ProductID
    having sum(ttt.Amount) <>0) sz where sz.StoreID = @p1
	order by sz.StoreID`;
			console.log(newSQL);
			const response = await ssql.manyOrNone(newSQL, [sw, dtSQLnormaliz]);
			console.log(response);
		}
	}
}
