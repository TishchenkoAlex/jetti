import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';
import { SQLPool } from '../sql/sql-pool';

import { ISyncParams, GetMySqlConfig } from './iiko-to-jetti-connection';
import { GetSqlConfig, saveLogProtocol } from './iiko-to-jetti-connection';
import {
	GetCatalog,
	InsertCatalog,
	UpdateCatalog,
} from './iiko-to-jetti-utils';

const syncStage = 'Catalog.RetailClient';
///////////////////////////////////////////////////////////
interface ISmartRetailClient {
	project: string;
	id: string;
	baseid: string;
	type: string;
	email: string;
	name: string;
	first_name: string;
	last_name: string;
	phone: string;
	status: number;
	create_datetime: string;
	update_datetime: string;
}
///////////////////////////////////////////////////////////
const transformRetailClient = (
	syncParams: ISyncParams,
	source: any,
): ISmartRetailClient => {
	return {
		project: syncParams.project.id,
		id: source.id,
		baseid: syncParams.source.id,
		type: 'RetailClient',
		email: source.email,
		name: source.name,
		first_name: source.first_name,
		last_name: source.last_name,
		phone: source.phone,
		status: source.status,
		create_datetime: source.create_datetime,
		update_datetime: source.update_datetime
	};
};

///////////////////////////////////////////////////////////
const newRetailClient = (
	syncParams: ISyncParams,
	SmartRetailClient: ISmartRetailClient,
) => {
	return {
		id: uuidv1().toUpperCase(),
		type: 'Catalog.RetailClient',
		code: syncParams.source.code + '-' + SmartRetailClient.id,
		description: SmartRetailClient.name,
		posted: true,
		deleted: false,
		doc: {
			kind: 'ЮрЛицо',
			// FullName: iikoCounterpartie.name,
			Department: null,
			// Client: iikoCounterpartie.isClient,
			// Supplier: iikoCounterpartie.isSuplier,
			isInternal: false,
			AddressShipping: null,
			AddressBilling: null,
			Phone: null,
			Code1: null,
			Code2: null,
			Code3: null,
			BC: null,
			GLN: null,
		},
		parent: null,
		isfolder: false,
		company: syncParams.source.company,
		user: null,
		info: null,
	};
};

///////////////////////////////////////////////////////////
/*
async function syncRetailClient(
	syncParams: ISyncParams,
	iikoCounterpartie: ISmartRetailClient,
	destSQL: SQLClient,
): Promise<any> {
	let response = await GetCatalog(
		iikoCounterpartie.project,
		iikoCounterpartie.id,
		iikoCounterpartie.baseid,
		'Counterpartie',
		destSQL,
	);
	if (response === null) {
		if (syncParams.logLevel > 1)
			saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`insert Counterpartie ${iikoCounterpartie.name}`,
			);
		const NoSqlDocument: any = newCounterpartie(syncParams, iikoCounterpartie);
		const jsonDoc = JSON.stringify(NoSqlDocument);
		response = await InsertCatalog(
			jsonDoc,
			NoSqlDocument.id,
			iikoCounterpartie,
			destSQL,
		);
	} else {
		if (syncParams.forcedUpdate) {
			if (syncParams.logLevel > 1)
				saveLogProtocol(
					syncParams.syncid,
					0,
					0,
					syncStage,
					`update Counterpartie ${iikoCounterpartie.name}`,
				);
			response.type = 'Catalog.Counterpartie';
			response.code = syncParams.source.code + '-' + iikoCounterpartie.code;
			response.description = iikoCounterpartie.name;
			response.posted = !iikoCounterpartie.deleted;
			response.deleted = !!iikoCounterpartie.deleted;
			response.doc.kind = 'ЮрЛицо';
			response.doc.FullName = iikoCounterpartie.name;
			response.doc.Client = iikoCounterpartie.isClient;
			response.doc.Supplier = iikoCounterpartie.isSuplier;
			response.doc.isInternal = false;
			response.isfolder = iikoCounterpartie.isfolder;
			response.company = syncParams.source.company;
			response.parent = syncParams.source.CounterpartieFolder;
			response.user = null;
			response.info = null;

			const jsonDoc = JSON.stringify(response);
			response = await UpdateCatalog(
				jsonDoc,
				response.id,
				iikoCounterpartie,
				destSQL,
			);
		}
	}
	return response;
}
*/
///////////////////////////////////////////////////////////
export async function ImportRetailClientToJetti(syncParams: ISyncParams) {
	await saveLogProtocol(
		syncParams.syncid,
		0,
		0,
		syncStage,
		`Start sync RetailClient`,
	);

	const ssqlcfg = await GetMySqlConfig(syncParams.source.id);
	const dsqlcfg = await GetSqlConfig(syncParams.destination);

	const mysql = require('mysql');
	const ssql  = mysql.createPool(ssqlcfg);
	const dsql = new SQLClient(new SQLPool(dsqlcfg));
	await ssql.query(`
		select  id, email, name, first_name, last_name, phone, status, create_datetime, update_datetime
		from smartass.pe2_user
		limit 1 `,
	await function (error, results, fields) {
		if (error) throw error;
		for (const row in results) {
			console.log(transformRetailClient(syncParams, results[row]));
		}
	});

/*
	let i = 0;
	let batch: any[] = [];
	await ssql.manyOrNoneStream(
		`
    SELECT
      cast(spr.id as nvarchar(50)) as id,
      coalesce(spr.deleted,0) as deleted,
      coalesce(cast(spr.[xml] as xml).value('(/r/name/customValue)[1]' ,'nvarchar(255)'),
      cast(spr.[xml] as xml).value('(/r/name)[1]' ,'nvarchar(255)'), null) as name,
      cast(spr.[xml] as xml).value('(/r/parent)[1]' ,'nvarchar(255)') as parentid,
      cast(spr.[xml] as xml).value('(/r/code)[1]' ,'nvarchar(255)') as code,
      cast(spr.[xml] as xml).value('(/r/supplier)[1]' ,'bit') as isSupplier
    FROM dbo.entity spr
    WHERE (1 = 1)
      AND spr.type = 'User' and cast(spr.[xml] as xml).value('(/r/supplier)[1]' ,'bit') = 1
      AND cast(CONVERT(datetime2(0), cast(spr.[xml] as xml).value('(/r/modified)[1]' ,'nvarchar(255)'), 126) as date) >= @p1
    -- and spr.id = 'A9527964-4184-4191-8D42-37FFBBD6D2BC' -- Ввод остатков
    --  and spr.id = '0339CD20-594B-4CCC-AF7A-00268C2A8C11'`,
		[syncParams.lastSyncDate],

		async (row: ColumnValue[], req: Request) => {
			const rawDoc: any = {};
			i = i + 1;
			// читаем содержимое справочника порциями по ssqlcfg.batch.max
			row.forEach((col) => (rawDoc[col.metadata.colName] = col.value));
			const iikoCounterpartie: IiikoCounterpartie = transformCounterpartie(
				syncParams,
				rawDoc,
			);
			batch.push(iikoCounterpartie);

			if (batch.length === ssqlcfg.batch.max) {
				req.pause();
				if (syncParams.logLevel > 0)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting to batch ${i} Counterparties`,
					);
				for (const doc of batch) await syncCounterpartie(syncParams, doc, dsql);
				batch = [];
				req.resume();
			}
		},

		async (rowCount: number, more: boolean) => {
			if (rowCount && !more && batch.length > 0) {
				if (syncParams.logLevel > 0)
					await saveLogProtocol(
						syncParams.syncid,
						0,
						0,
						syncStage,
						`inserting tail ${batch.length} Counterparties`,
					);
				for (const doc of batch) await syncCounterpartie(syncParams, doc, dsql);
			}
			await saveLogProtocol(
				syncParams.syncid,
				0,
				0,
				syncStage,
				`Finish sync Counterparties`,
			);
		},
	);
*/
/*	ssql.end(function (err) {
		// all connections in the pool have ended
	}); */
}
///////////////////////////////////////////////////////////

