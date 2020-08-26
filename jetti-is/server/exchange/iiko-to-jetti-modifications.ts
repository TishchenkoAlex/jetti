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
	InsertDocumentNoEchange,
} from './iiko-to-jetti-utils';

const syncStage = 'Document.Purshase';
interface IdocOfModification {
	XMLuuid: string;
	UUIDmsSQL: string;
}
interface Modification {
	Product: String;
	Modifier: String;
	Qty: Number;
}
interface ModificationSQL {
	Array: [Modification] | null;
}
export async function ImportModificationToJetti(
	syncParams: ISyncParams,
	docList: any[] = [],
) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync Modificators Documents`,
	);
	if (syncParams.baseType === 'sql')
		await ImportModificationSQLToJetti(syncParams, docList);
}

export async function ImportModificationSQLToJetti(
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
	const newSQL = `
	select upper(cast(t.id as nvarchar(50))) as Product,  upper(t2.m.value('modifier[1]' ,'nvarchar(50)')) as Modifier , cast(1 as money)  as Qty
	from
	(select id, cast([xml] as xml) doc
	from dbo.entity
	where type ='Product'
	and cast([xml] as xml).value('(/r/type)[1]' ,'nvarchar(50)')='DISH'
	and cast([xml] as xml).exist('/r/modifiers/i')=1) t
	cross apply t.doc.nodes('/r/modifiers/i') as t2(m)
	where t2.m.value('(modifier/@cls)[1]' ,'nvarchar(50)') = N'Product'
	union all
	-- второй уровень
	select upper(cast(t.id as nvarchar(50))) as Product, upper(t2.m.value('modifier[1]' ,'nvarchar(50)')) as Modifier , 1 as Qty
	from
	(select id, cast([xml] as xml) doc
	from dbo.entity
	where type ='Product'
	and cast([xml] as xml).value('(/r/type)[1]' ,'nvarchar(50)')='DISH'
	and cast([xml] as xml).exist('/r/modifiers/i/childModifiers/i')=1) t
	cross apply t.doc.nodes('/r/modifiers/i/childModifiers/i') as t2(m)
	where t2.m.value('(modifier/@cls)[1]' ,'nvarchar(50)') = N'Product'
    `;
	const RESPONCE: any = await ssql.manyOrNone(newSQL, []);
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`inserting to batch  Modificators docs`,
	);
	const NOSQLDOC: any = {
		type: 'Document.Operation',
		id: uuidv1().toUpperCase(),
		date: DateToString(intgDate),
		posted: 0,
		code: '5.004',
		description: '',
		deleted: 0,
		parent: null,
		isfolder: false,
		user: null,
		doc: {
			Group: '6C818FD0-E095-11E9-A0E4-0F60E644189D',
			Operation: '9A0B11F0-D096-11EA-889E-37071E5A4BE1',
			currency: syncParams.source.currency,
			company: syncParams.source.company,
			Items: []
		},
	};
	const codez = syncParams.source.code;
	const tabelDefs: any = await tabelDef(RESPONCE, syncParams, dsql);
	const descrpSQL = `use smv SELECT description FROM [dbo].[Catalog.Operation.v] where id=@p1`;
	const descpi: any = await dsql.manyOrNone(descrpSQL, [NOSQLDOC.doc.Operation]);
	NOSQLDOC.doc.description = descpi[0].description;
	NOSQLDOC.doc.Items = tabelDefs;
	await InsertDocumentNoEchange(JSON.stringify(NOSQLDOC), NOSQLDOC.id, dsql);
}




async function syncInventSQL(
	syncParams: ISyncParams,
	iikoDoc: IdocOfModification,
	sourceSQL: SQLClient,
	destSQL: SQLClient,
): Promise<any> {
}


function IsValidGUID(GUID: any) {
	if (typeof GUID === 'string') {
		return GUID;
	} else {
		return;
	}
}
async function tabelDef(ArrayRes: any, syncParams: ISyncParams, dsql: any) {
	const pos: any = await exchangeManyOrNone(
		`
		SELECT
		(SELECT top 1 [id] FROM [dbo].[catalog]
		c where [project]=@p1 and
		[exchangeCode]=p.[Product] and
		[exchangeBase]=@p2 and [exchangeType] = 'Product') as Product,
		(SELECT top 1 [id] FROM [dbo].[catalog] c where [project]=@p1 and
		[exchangeCode]=p.[Modifier] and
		[exchangeBase]=@p2 and [exchangeType] = 'Product') as Modifier,
		p.[Qty]
		FROM OPENJSON(@p3) WITH (
		[Product] UNIQUEIDENTIFIER,
		[Modifier] UNIQUEIDENTIFIER,
		[Qty] money) as p
		`,
		[
			syncParams.project.id,
			syncParams.source.id,
			JSON.stringify(ArrayRes)]);

	return pos;
}
