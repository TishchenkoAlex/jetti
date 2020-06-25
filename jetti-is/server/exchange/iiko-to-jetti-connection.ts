import { SQLClient } from '../sql/sql-client';
import { SQLPool } from '../sql/sql-pool';
import { ColumnValue, Request } from 'tedious';
import { config as dotenv } from 'dotenv';
import { SQLConnectionConfig } from '../sql/interfaces';
import { Ref } from './iiko-to-jetti-utils';
import { IJettiProject, IExchangeSource } from './jetti-projects';

dotenv();

export interface ISyncParams {
  // параметры синхронизации
  project: IJettiProject,   // проект
  source: IExchangeSource,  // база источник
  baseType: string,         // тип базы источника: sql - mssql, pg - postgree
  destination: string,      // ид база приемник
  periodBegin: Date,        // дата с которой синхронизируются данные
  periodEnd: Date,          // дата по которую синхронизируются данные
  startDate: Date,          // начальная дата, с которой для базы источника ведется синхронизация
  lastSyncDate: Date,       // дата последней автосинхронизации
  autosync: boolean,        // автосинхронизация данных
  forcedUpdate: boolean,    // принудитеольное обновление данных (если false - обновляются только новые и у которых не совпадает версия данных)
  logLevel: number,         // уровень логирования: 0-ошибки, 1-общая информация, 2-детальная информация,
  startTime: Date,          // время старта
  finishTime: Date | null   // время завершение
}
export interface ISyncCatalog {
  // элемент таблицы dbo.catalog
  project: string,          // проект
  exchangeCode: string,     // код в базе обмена
  exchangeBase: string,     // база обмена
  exchangeType: string,     // тип справочника
  exchangeName: string,     // наименование элемента справочника в базе обмена
  id: Ref,                  // ссылка на элемент справочника в базе приемнике
  idAnalytics: Ref,         // ссылка на аналитику справочника
  addAnalytics: Ref,     // дополнительная аналитика
  addType: Ref,          // дополнительный тип
  notActive: number         // признак неактивности 
}
///////////////////////////////////////////////////////////
// Параматры коннекта с базой обмена
export const ExchangeSqlConfig: SQLConnectionConfig = {
  server: process.env.E_DB_HOST,
  authentication: {
    type: 'default',
    options: {
      userName: process.env.E_DB_USER,
      password: process.env.E_DB_PASSWORD
    }
  },
  options: {
    trustServerCertificate: false,
    encrypt: false,
    database: process.env.E_DB_NAME,
    port: parseInt(process.env.E_DB_PORT as string, undefined),
    instanceName: process.env.E_DB_INSTANCE,
    requestTimeout: 2 * 60 * 1000
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  },
  batch: {
    min: 0,
    max: 1000,
  }
};
const exchangeSQLAdmin = new SQLPool(ExchangeSqlConfig);
///////////////////////////////////////////////////////////
// Параметры коннекта с SQL базой
export async function GetSqlConfig(baseid: string): Promise<SQLConnectionConfig> {
  // чтение параметров подключения к базе SQL по ID
  const esql = new SQLClient(exchangeSQLAdmin);
  const bp: any = await esql.oneOrNone(`
    select c.baseType as baseType, c.exchangeType as exchangeType, 
      json_value(c.data, '$.db_host') as db_host,
      json_value(c.data, '$.db_instance') as db_instance,
      json_value(c.data, '$.db_port') as db_port,
      json_value(c.data, '$.db_name') as db_name,
      json_value(c.data, '$.db_user') as db_user,
      json_value(c.data, '$.db_password') as db_password
      from dbo.connections c
      where c.id = @p1 `, [baseid]); 
  const SqlConfig: SQLConnectionConfig = {
    server: bp.db_host,
    authentication: {
      type: 'default',
      options: {
        userName: bp.db_user,
        password: bp.db_password
      }
    },
    options: {
      trustServerCertificate: false,
      encrypt: false,
      database: bp.db_name,
      port: parseInt(bp.db_port as string, undefined),
      instanceName: bp.db_instance,
      requestTimeout: 2 * 60 * 1000
    },
    pool: {
      min: 0,
      max: 1000,
      idleTimeoutMillis: 20 * 60 * 1000
    },
    batch: {
      min: 0,
      max: 100,
    }
  }
  return SqlConfig;
};
///////////////////////////////////////////////////////////
// получить ID элемента справочника в базе приемнике
export async function GetExchangeCatalogID(project: string, exchangeCode: string, exchangeBase: string, exchangeType: string): Promise<Ref> {
  const esql = new SQLClient(exchangeSQLAdmin);
  const ct: any = await esql.oneOrNone(`SELECT id FROM dbo.catalog where project = @p1 and exchangeCode =@p2 and exchangeBase =@p3 and exchangeType = @p4 `, 
    [project, exchangeCode, exchangeBase, exchangeType]); 
  if (ct === null) return null
    else return ct.id;
}
///////////////////////////////////////////////////////////
// получить элемент сопоставления справочника
export async function GetExchangeCatalog(project: string, exchangeCode: string, exchangeBase: string, exchangeType: string): Promise<ISyncCatalog> {
  const esql = new SQLClient(exchangeSQLAdmin);
  const ct = <ISyncCatalog> await esql.oneOrNone<ISyncCatalog>(`SELECT * FROM dbo.catalog where project = @p1 and exchangeCode =@p2 and exchangeBase =@p3 and exchangeType = @p4 `, 
    [project, exchangeCode, exchangeBase, exchangeType]); 
  return ct;
}
///////////////////////////////////////////////////////////
const newSyncCatalog = (source: any, id: string): ISyncCatalog => {
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
    notActive: 0
  }
}
///////////////////////////////////////////////////////////
// сохранить ссылку на элемент справочника из базы источника
export async function SetExchangeCatalogID(source: any, id: string): Promise<ISyncCatalog> {
  const esql = new SQLClient(exchangeSQLAdmin);
  let ct: ISyncCatalog = await GetExchangeCatalog(source.project, source.id, source.baseid, source.type);
  let response: ISyncCatalog = ct;
  if (ct === null) {
    // console.log('insert catalog link');
    ct = newSyncCatalog(source, id);
    const jsonDoc = JSON.stringify(ct);
    response = <ISyncCatalog> await esql.oneOrNone<ISyncCatalog>(`
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
      SELECT * FROM dbo.catalog where project = @p2 and exchangeCode =@p3 and exchangeBase =@p4 and exchangeType = @p5 `, 
    [jsonDoc, source.project, source.id, source.baseid, source.type]); 
  }
  else {
    if (ct.id === id) {
      const jsonDoc = JSON.stringify(ct);
      response = <ISyncCatalog> await esql.oneOrNone<ISyncCatalog>(`
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
        SELECT * FROM dbo.catalog where project = @p2 and exchangeCode =@p3 and exchangeBase =@p4 and exchangeType = @p5 `, 
      [jsonDoc, source.project, source.id, source.baseid, source.type]); 
    }
    else {
      // console.log('update catalog link old id=',ct.id,' new id=', id);
      ct.id = id;
      const jsonDoc = JSON.stringify(ct);
      response = <ISyncCatalog> await esql.oneOrNone<ISyncCatalog>(`
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
      [jsonDoc, source.project, source.id, source.baseid, source.type]); 
    }
  }
  return response;
}
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

  