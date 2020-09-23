import { v1 as uuidv1 } from 'uuid';
import { SQLClient } from '../sql/sql-client';
import { SQLPool } from '../sql/sql-pool';
import { config as dotenv } from 'dotenv';
import { SQLConnectionConfig } from '../sql/interfaces';
import { Ref } from './iiko-to-jetti-utils';
import {
	IJettiProject,
	IExchangeSource,
	RussiaSourceSMV,
	SMVProject,
} from './jetti-projects';

dotenv();
export interface ISyncParams {
	// параметры синхронизации
	docid: string;              // id документа, запустившего синхронизацию
	projectid: string;          // id проекта cинхронизации
	sourceid: string;           // id базы источника
	autosync: boolean;          // автосинхронизация данных/ручная синхронизация
	// (только указанные типы документов, только за указанный период)
	periodBegin: Date;          // дата с которой синхронизируются данные
	periodEnd: Date;            // дата по которую синхронизируются данные
	exchangeID: Ref;            // загрузка по ID (склад, подразделение)
	execFlag: number;           // флаг обработки автосинхронизации (код документа для загрузки)
	objectList?: string[];      // список объектов для синхронизации
	forcedUpdate: boolean;      // принудитеольное обновление данных (если false - обновляются только новые
	// и у которых не совпадает версия данных)
	logLevel: number;           // уровень логирования: 0-ошибки, 1-общая информация, 2-детальная информация и т.д.
	flow: number;               // поток проведения (-1 - не проводить)
	info?: string;              // описание задачи
	syncFunctionName?: string;  // имя функции синхронизации
	// дополнительные параметры. добавляются уже внутри процедуры синхронизации
	syncid: string;             // id синхронизации
	project: IJettiProject;     // проект
	source: IExchangeSource;    // база источник
	baseType: string;           // тип базы источника: sql - mssql, pg - postgree
	destination: string;        // ид база приемник
	firstDate: Date;            // начальная дата, с которой для базы источника ведется синхронизация
	lastSyncDate: Date;         // дата последней автосинхронизации
	startTime: Date;            // время старта
	finishTime: Date | null;    // время завершение
	job?: any;					// задача из очереди, выполняющая синхронизацию
}
export interface ISyncCatalog {
	// элемент таблицы dbo.catalog
	project: string; // проект
	exchangeCode: string; // код в базе обмена
	exchangeBase: string; // база обмена
	exchangeType: string; // тип справочника
	exchangeName: string; // наименование элемента справочника в базе обмена
	id: Ref; // ссылка на элемент справочника в базе приемнике
	idAnalytics: Ref; // ссылка на аналитику справочника
	addAnalytics: Ref; // дополнительная аналитика
	addType: Ref; // дополнительный тип
	notActive: number; // признак неактивности
}
///////////////////////////////////////////////////////////
export interface ISyncDocument {
	// элемент таблицы dbo.doc
	project: string; // проект
	exchangeCode: string; // код в базе обмена
	exchangeBase: string; // база обмена
	exchangeType: string; // тип документа
	id: Ref; // ссылка на документ в базе приемнике
	parent: Ref; // ссылка на родительский документ в базе приемнике
	exchangeStatus: number; // статус обмена документа
}
///////////////////////////////////////////////////////////
// Параматры коннекта с базой обмена
export const ExchangeSqlConfig: SQLConnectionConfig = {
	server: process.env.DB_HOST,
	authentication: {
		type: 'default',
		options: {
			userName: process.env.DB_USER,
			password: process.env.DB_PASSWORD,
		},
	},
	options: {
		trustServerCertificate: false,
		encrypt: false,
		database: process.env.DB_NAME,
		port: parseInt(process.env.DB_PORT as string, undefined),
		instanceName: process.env.DB_INSTANCE,
		requestTimeout: 20 * 60 * 1000 * 4 * 10,
	},
	pool: {
		min: 0,
		max: 1000,
		idleTimeoutMillis: 20 * 60 * 1000 * 4 * 10,
	},
	batch: {
		min: 0,
		max: 1000,
	},
};
///////////////////////////////////////////////////////////
const exchangeSQLAdmin = new SQLPool(ExchangeSqlConfig);
const esql = new SQLClient(exchangeSQLAdmin);
///////////////////////////////////////////////////////////
// Параметры коннекта с SQL базой
export async function GetSqlConfig(
	baseid: string,
): Promise<SQLConnectionConfig> {
	// чтение параметров подключения к базе SQL по ID
	const bp: any = await esql.oneOrNone(
		`
    select c.baseType as baseType, c.exchangeType as exchangeType,
      json_value(c.data, '$.db_host') as db_host,
      json_value(c.data, '$.db_instance') as db_instance,
      json_value(c.data, '$.db_port') as db_port,
      json_value(c.data, '$.db_name') as db_name,
      json_value(c.data, '$.db_user') as db_user,
      json_value(c.data, '$.db_password') as db_password
      from dbo.connections c
      where c.id = @p1 `,
		[baseid],
	);

	const SqlConfig: SQLConnectionConfig = {
		server: bp.db_host,
		authentication: {
			type: 'default',
			options: {
				userName: bp.db_user,
				password: bp.db_password,
			},
		},
		options: {
			trustServerCertificate: false,
			encrypt: false,
			database: bp.db_name,
			port: parseInt(bp.db_port as string, undefined),
			instanceName: bp.db_instance,
			requestTimeout:20 * 60 * 1000 * 4 * 10,
		},
		pool: {
			min: 0,
			max: 1000,
			idleTimeoutMillis: 20 * 60 * 1000 * 4 * 10,
		},
		batch: {
			min: 0,
			max: 100,
		},
	};
	return SqlConfig;
}
///////////////////////////////////////////////////////////
// Параметры коннекта с SQL базой
export async function GetMySqlConfig(
	baseid: string,
): Promise<any> {
	// чтение параметров подключения к базе MySQL по ID
	const bp: any = await esql.oneOrNone(
		`
    select c.baseType as baseType, c.exchangeType as exchangeType,
      json_value(c.data, '$.db_host') as db_host,
      json_value(c.data, '$.db_port') as db_port,
      json_value(c.data, '$.db_name') as db_name,
      json_value(c.data, '$.db_user') as db_user,
      json_value(c.data, '$.db_password') as db_password
      from dbo.connections c
      where c.id = @p1 `,
		[baseid],
	);

	return {
		connectionLimit: 100,
		host: bp.db_host,
		port: bp.db_port,
		user: bp.db_user,
		password: bp.db_password,
		database: bp.db_name,
		connectTimeout: 20 * 60 * 1000 * 4 * 10
	};
}
///////////////////////////////////////////////////////////
// получить ID элемента справочника в базе приемнике
export async function GetExchangeID(
	exchangeCode: string,
	exchangeBase: string,
	exchangeType: string,
	dsql:SQLClient
): Promise<Ref> {
	const ct: any = await dsql.oneOrNone(
		`
    SELECT id FROM documents where  exchangeCode = @p1 and exchangeBase = @p2`,
		[exchangeCode, exchangeBase],
	);
	// TODO: !!112!!1!1!11
	// TODO: 
	// TODO: 
	if (ct === null) return null;
	else return ct.id;
}
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// получить ID элемента справочника в базе приемнике
export async function GetExchangeCatalogID(
	project: string,
	exchangeCode: string,
	exchangeBase: string,
	exchangeType: string,
): Promise<Ref> {
	const ct: any = await esql.oneOrNone(
		`
    SELECT id FROM dbo.catalog where project = @p1 and exchangeCode = @p2 and exchangeBase = @p3 and exchangeType = @p4 `,
		[project, exchangeCode, exchangeBase, exchangeType],
	);
	if (ct === null) return null;
	else return ct.id;
}
///////////////////////////////////////////////////////////
// получить элемент сопоставления справочника
export async function GetExchangeCatalog(
	project: string,
	exchangeCode: string,
	exchangeBase: string,
	exchangeType: string,
): Promise<ISyncCatalog> {
	const ct = <ISyncCatalog>await esql.oneOrNone<ISyncCatalog>(
		`
    SELECT * FROM dbo.catalog where project = @p1 and exchangeCode =@p2 and exchangeBase = @p3 and exchangeType = @p4 `,
		[project, exchangeCode, exchangeBase, exchangeType],
	);
	return ct;
}
///////////////////////////////////////////////////////////
// получить ID документа в базе приемнике
export async function GetExchangeDocumentID(
	project: string,
	exchangeCode: string,
	exchangeBase: string,
	exchangeType: string,
): Promise<Ref> {
	const doc: any = await esql.oneOrNone(
		`
    SELECT id FROM dbo.doc where project = @p1 and exchangeCode =@p2 and exchangeBase =@p3 and exchangeType = @p4 `,
		[project, exchangeCode, exchangeBase, exchangeType],
	);
	if (!doc) return null;
	else return doc.id;
}
///////////////////////////////////////////////////////////
// получить элемент сопоставления документа
export async function GetExchangeDocument(
	project: string,
	exchangeCode: string,
	exchangeBase: string,
	exchangeType: string,
): Promise<ISyncDocument> {
	const doc = <ISyncDocument>await esql.oneOrNone<ISyncDocument>(
		`
    SELECT * FROM dbo.doc where project = @p1 and exchangeCode =@p2 and exchangeBase =@p3 and exchangeType = @p4 `,
		[project, exchangeCode, exchangeBase, exchangeType],
	);
	return doc;
}
///////////////////////////////////////////////////////////
export async function exchangeManyOrNone(sql: string, params: any[]) {
	return await esql.manyOrNone(sql, params);
}
export async function exchangeOneOrNone(sql: string, params: any[]) {
	return await esql.oneOrNone(sql, params);
}
///////////////////////////////////////////////////////////

const newSyncCatalog = (source: any, id: Ref): ISyncCatalog => {
	return {
		project: source.project,
		exchangeCode: source.id,
		exchangeBase: source.baseid,
		exchangeType: source.type,
		exchangeName: source.name,
		id: id,
		idAnalytics: null,
		addAnalytics: null,
		addType: null,
		notActive: 0,
	};
};
///////////////////////////////////////////////////////////
const newSyncDocument = (source: any, id: string): ISyncDocument => {
	return {
		project: source.project,
		exchangeCode: source.id,
		exchangeBase: source.baseid,
		exchangeType: source.type,
		id: id,
		parent: null,
		exchangeStatus: 0,
	};
};
///////////////////////////////////////////////////////////
// сохранить ссылку на элемент справочника из базы источника
export async function SetExchangeCatalogID(
	source: any,
	id: Ref,
): Promise<ISyncCatalog> {
	let ct: ISyncCatalog = await GetExchangeCatalog(
		source.project,
		source.id,
		source.baseid,
		source.type,
	);
	let response: ISyncCatalog = ct;
	if (ct === null) {
		// console.log('insert catalog link');
		ct = newSyncCatalog(source, id);
		const jsonDoc = JSON.stringify(ct);
		response = <ISyncCatalog>await esql.oneOrNone<ISyncCatalog>(
			`
      INSERT INTO dbo.catalog (
        [project], [exchangeCode], [exchangeBase], [exchangeType], [exchangeName],
        [id], [idAnalytics], [addAnalytics], [addType], [notActive])
      SELECT
        [project], [exchangeCode], [exchangeBase], [exchangeType], [exchangeName],
        [id], [idAnalytics], [addAnalytics], [addType], [notActive]
      FROM OPENJSON(@p1) WITH (
        [project] NVARCHAR(50),
        [exchangeCode] NVARCHAR(50),
        [exchangeBase] NVARCHAR(50),
        [exchangeType] NVARCHAR(50),
        [exchangeName] NVARCHAR(150),
        [id] UNIQUEIDENTIFIER,
        [idAnalytics] UNIQUEIDENTIFIER,
        [addAnalytics] NVARCHAR(50),
        [addType] NVARCHAR(50),
        [notActive] INT
      );
      SELECT * FROM dbo.catalog where project = @p2 and exchangeCode = @p3 and exchangeBase = @p4 and exchangeType = @p5 `,
			[jsonDoc, source.project, source.id, source.baseid, source.type],
		);
	} else {
		if (ct.id === id) {
			const jsonDoc = JSON.stringify(ct);
			response = <ISyncCatalog>await esql.oneOrNone<ISyncCatalog>(
				`
        UPDATE dbo.catalog
        SET
          exchangeName = i.exchangeName
        FROM (
          SELECT *
          FROM OPENJSON(@p1) WITH (
            [project] NVARCHAR(50),
            [exchangeCode] NVARCHAR(50),
            [exchangeBase] NVARCHAR(50),
            [exchangeType] NVARCHAR(50),
            [exchangeName] NVARCHAR(150),
            [id] UNIQUEIDENTIFIER,
            [idAnalytics] UNIQUEIDENTIFIER,
            [addAnalytics] NVARCHAR(50),
            [addType] NVARCHAR(50),
            [notActive] INT
          )
        ) i
        WHERE dbo.catalog.project = i.project and dbo.catalog.exchangeCode = i.exchangeCode
          and dbo.catalog.exchangeBase = i.exchangeBase and dbo.catalog.exchangeType = i.exchangeType;
        SELECT * FROM dbo.catalog where project = @p2 and exchangeCode = @p3 and exchangeBase = @p4 and exchangeType = @p5 `,
				[jsonDoc, source.project, source.id, source.baseid, source.type],
			);
		} else {
			// console.log('update catalog link old id=',ct.id,' new id=', id);
			ct.id = id;
			const jsonDoc = JSON.stringify(ct);
			response = <ISyncCatalog>await esql.oneOrNone<ISyncCatalog>(
				`
        UPDATE dbo.catalog
        SET
          exchangeName = i.exchangeName,
          id = i.id
        FROM (
          SELECT *
          FROM OPENJSON(@p1) WITH (
            [project] NVARCHAR(50),
            [exchangeCode] NVARCHAR(50),
            [exchangeBase] NVARCHAR(50),
            [exchangeType] NVARCHAR(50),
            [exchangeName] NVARCHAR(150),
            [id] UNIQUEIDENTIFIER,
            [idAnalytics] UNIQUEIDENTIFIER,
            [addAnalytics] NVARCHAR(50),
            [addType] NVARCHAR(50),
            [notActive] INT
          )
        ) i
        WHERE dbo.catalog.project = i.project and dbo.catalog.exchangeCode = i.exchangeCode
          and dbo.catalog.exchangeBase = i.exchangeBase and dbo.catalog.exchangeType = i.exchangeType;
        SELECT * FROM dbo.catalog where project = @p2 and exchangeCode =@p3 and exchangeBase =@p4 and exchangeType = @p5 `,
				[jsonDoc, source.project, source.id, source.baseid, source.type],
			);
		}
	}
	return response;
}
///////////////////////////////////////////////////////////
// сохранить ссылку на документ из базы источника
export async function SetExchangeDocumentID(
	source: any,
	id: string,
): Promise<ISyncDocument> {
	let doc: ISyncDocument = await GetExchangeDocument(
		source.project,
		source.id,
		source.baseid,
		source.type,
	);
	let response: ISyncDocument = doc;
	if (!doc) {
		doc = newSyncDocument(source, id);
		const jsonDoc = JSON.stringify(doc);
		response = <ISyncDocument>await esql.oneOrNone<ISyncDocument>(
			`
      INSERT INTO dbo.doc (
        [project], [exchangeCode], [exchangeBase], [exchangeType],
        [id], [parent], [exchangeStatus])
      SELECT
        [project], [exchangeCode], [exchangeBase], [exchangeType],
        [id], [parent], [exchangeStatus]
      FROM OPENJSON(@p1) WITH (
        [project] NVARCHAR(50),
        [exchangeCode] NVARCHAR(50),
        [exchangeBase] NVARCHAR(50),
        [exchangeType] NVARCHAR(50),
        [id] UNIQUEIDENTIFIER,
        [parent] UNIQUEIDENTIFIER,
        [exchangeStatus] INT
      );
      SELECT * FROM dbo.doc where project = @p2 and exchangeCode =@p3 and exchangeBase =@p4 and exchangeType = @p5 `,
			[jsonDoc, source.project, source.id, source.baseid, source.type],
		);
	}
	/* else {
    if (doc.id === id) return response;
    else {
      throw new Error(
        `Exists Document Link from ExchangeCode=${source.id} ExchangeBase=${source.baseid}. Project ${source.project}, type ${source.type}`
        );
    }
    }
  } */
	return response;
}
///////////////////////////////////////////////////////////
export async function saveSyncParams(SyncParams: ISyncParams) {
	const params = {
		id: SyncParams.syncid,
		syncType: 'Autosync',
		project: SyncParams.projectid,
		syncSource: SyncParams.sourceid,
		docid: SyncParams.docid,
		syncStart: SyncParams.startTime,
		syncEnd: null,
		periodBegin: SyncParams.periodBegin,
		periodEnd: SyncParams.periodEnd,
		execFlag: SyncParams.execFlag,
		params: SyncParams /* {
      autosync: SyncParams.autosync,
      forcedUpdate: SyncParams.forcedUpdate,
      logLevel: SyncParams.logLevel
    } */,
	};
	// syncType в зависимости от процедуры синхронизации
	switch (SyncParams.syncFunctionName) {
		case 'QueuePost':
			params.syncType = 'QueuePost';
			break;
		case 'AutosyncSMSQL':
			params.syncType = 'AutosyncSM';
			break;
		case 'QueueSyncSMSQL':
			params.syncType = 'QueuePost';
			break;
	}
	await esql.oneOrNone(
		`INSERT INTO dbo.syncList (id, syncType, project, syncSource, docid, syncStart, syncEnd, periodBegin, periodEnd, execFlag, params)
    select id, syncType, project, syncSource, docid, syncStart, syncEnd, periodBegin, periodEnd, execFlag, params
    from OPENJSON(@p1) WITH (
      [id] UNIQUEIDENTIFIER,
      [syncType] nvarchar(50),
      [project] nvarchar(50),
      [syncSource] nvarchar(50),
      [docid] nvarchar(50),
      [syncStart] datetime,
      [syncEnd] datetime,
      [periodBegin] datetime,
      [periodEnd] datetime,
      [execFlag] int,
      [params] NVARCHAR(max) N'$.params' AS JSON)
  `,
		[JSON.stringify(params)],
	);
}

export async function finishSync(SyncParams: ISyncParams) {
	const params = {
		id: SyncParams.syncid,
		syncEnd: SyncParams.finishTime,
	};
	await esql.oneOrNone(
		`
    UPDATE dbo.syncList SET syncEnd = i.syncEnd
    FROM (
      SELECT *
      FROM OPENJSON(@p1) WITH (
        [id] UNIQUEIDENTIFIER,
        [syncEnd] DATETIME)
    ) i
  WHERE dbo.syncList.id = i.id `,
		[JSON.stringify(params)],
	);
}

export async function saveLogProtocol(
	syncid: string,
	execCode: number,
	errorCount: number,
	syncStage: string,
	protocol: string,
) {
	await esql.oneOrNone(
		`INSERT INTO dbo.syncProtocol (syncid, execCode, errorCount, syncStage, protocol)
    select syncid, execCode, errorCount, syncStage, protocol
    from OPENJSON(@p1) WITH (
      [syncid] UNIQUEIDENTIFIER,
      [execCode] int,
      [errorCount] int,
      [syncStage] nvarchar(50),
      [protocol] nvarchar(max)
    )
  `,
		[
			JSON.stringify({
				syncid: syncid,
				execCode: execCode,
				errorCount: errorCount,
				syncStage: syncStage,
				protocol: protocol,
			}),
		],
	);
	console.log(`log: ${protocol}`);
}

export async function GetProject(id: string): Promise<IJettiProject> {
	const proj: any = await exchangeOneOrNone(
		`select * from dbo.projects where projectid = @p1`,
		[id],
	);
	if (!proj) throw new Error(`Project ${id} not found.`);
	return proj.data;
}

export async function getSyncParams(params: any): Promise<ISyncParams> {
	const prj: any = await GetProject(params.projectid);
	const source: any[] = prj.sources.filter((p) => p.id === params.sourceid);
	if (source.length !== 1)
		throw new Error(`Source "${params.sourceid}" not found`);
	const sbase: any = await exchangeOneOrNone(
		`select * from dbo.connections where id = @p1`,
		[params.sourceid],
	);
	if (!sbase)
		throw new Error(
			`Connection params of Source base "${params.sourceid}" not found`,
		);
	const result: ISyncParams = {
		docid: params.docid,
		projectid: params.projectid,
		sourceid: params.sourceid,
		autosync: params.autosync,
		periodBegin: params.periodBegin,
		periodEnd: params.periodEnd,
		exchangeID: params.exchangeID,
		execFlag: params.execFlag,
		objectList: [...params.objectList],
		forcedUpdate: params.forcedUpdate,
		logLevel: params.logLevel,
		flow: params.flow,
		info: params.info,
		syncFunctionName: params.syncFunctionName,
		syncid: uuidv1().toUpperCase(),
		project: prj,
		source: source[0],
		baseType: sbase.baseType,
		destination: prj.destination,
		firstDate: source[0].firstDate,
		lastSyncDate: new Date(2020, 5, 29, 8, 0, 0), // ! временно для примера - будет new Date()
		startTime: new Date(),
		finishTime: null,
	};
	if (result.autosync) {
		// параметры автосинхронизации
		if (result.exchangeID === '') {
			const asparams: any = await exchangeOneOrNone(
				`
        SELECT
          CASE
            when (@p1=32) then cast(cast(getdate() as date) as datetime)
            else cast(coalesce(max(sl.PeriodEnd), cast(dateadd(day, -(day(getdate())-1), getdate()) as date)) as datetime)
          end as DB,
          cast(cast(getdate() as DATE) as datetime) as DE,
          COALESCE(dateadd(DAY, -2, max(sl.syncStart)), cast(dateadd(day, -(day(getdate())-1), getdate()) as date)) as LastSyncDate
        FROM dbo.syncList sl
        where sl.syncType = 'Autosync' and sl.project = @p2 and sl.syncSource = @p3 and sl.ExecFlag=126 and not sl.syncEnd is null
          and cast(json_value(sl.params, '$.autosync') as bit) = 1`,
				[result.execFlag, result.projectid, result.sourceid],
			);
			if (asparams) {
				result.lastSyncDate = new Date(asparams.LastSyncDate);
				if (result.lastSyncDate < result.firstDate)
					result.lastSyncDate = result.firstDate;
				result.periodBegin = new Date(asparams.DB);
				if (result.periodBegin < result.firstDate)
					result.periodBegin = result.firstDate;
				result.periodEnd = new Date(asparams.DE);
			}
		} else result.autosync = false; // не может быть автосинхронизации по складу или подразделению
	}
	// console.log(result);
	return result;
}
