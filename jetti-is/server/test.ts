// Test exchange modules...	
import {	
	AutosyncIIkoToJetty,	
	AutosyncSMSQL,	
} from './exchange/iiko-to-jetti-autosync';	
import { exchangeOneOrNone } from './exchange/iiko-to-jetti-connection';	

import { QueuePost } from './exchange/queue-post';	
import { SaveProjectParams } from './exchange/jetti-projects';	
import { AutosyncSmartToJetty } from './exchange/smart-to-jetti-autosync';	

// Параметры, передаваемые в процедуры синхронизации	
//   docid: string;             // id документа синхронизации	
//   projectid: string;         // id проекта cинхронизации	
//   sourceid: string;          // id базы источника	
//   autosync: boolean;         // автосинхронизация данных/ ручная синхронизация	
// (только указанные типы документов, только за указанный период)	
//   periodBegin: Date;         // дата с которой синхронизируются данные	
//   periodEnd: Date;           // дата по которую синхронизируются данные	
//   exchangeID: Ref;           // загрузка по ID (один склад/подразделение) - если нужно все = пустое значение	
//   execFlag: number;          // флаг обработки автосинхронизации (код документа для загрузки)	
//   forcedUpdate: boolean;     // принудитеольное обновление данных	
// (если false - обновляются только новые и у которых не совпадает версия данных)	
//   logLevel: number;          // уровень логирования: 0-ошибки, 1-общая информация, 2-детальная информация,	
//   syncFunctionName?: string; // имя функции синхронизации	
// Дополнительные параметры. добавляются уже внутри процедуры синхронизации	
//   syncid: string;            // id синхронизации (newid)	
//   project: IJettiProject;    // проект cинхронизации	
//   source: IExchangeSource;   // база источник	
//   baseType: string;          // тип базы источника: sql - mssql, pg - postgree	
//   destination: string;       // ид базы приемника	
//   firstDate: Date;           // начальная дата, с которой для базы источника ведется синхронизация	
//   lastSyncDate: Date;        // дата последней автосинхронизации	
//   startTime: Date;           // время старта задачи	
//   finishTime: Date | null;   // время завершения задачи	

/*	
// ! Тест автосинхронизации SMV	
const params = {	
	docid: 'D035ECB0-BA01-11EA-A123-0157C63EEA3C',	
	projectid: 'SMV',	
	sourceid: 'Russia',	
	autosync: true,	
	periodBegin: new Date('2020-07-02'), // ImportPurchaseRetToJetti date period 2019-03-26	
	periodEnd: new Date('2020-07-02'),	
	exchangeID: 'B72A88A5-E93A-4959-B2DC-287B798CA171', // '', //	
	execFlag: 128,	
	objectList: [],	
	forcedUpdate: true,	
	logLevel: 2,	
	flow: 0,	
	syncFunctionName: 'AutosincIkoToJetty',	
	info: 'Test Autosync',	
};	
AutosyncIIkoToJetty(params).catch((error) => {	
	console.log(error);	
});	
*/	
/*	
// ! Тест SQL-автосинхронизации SM	
const params = {	
	docid: 'D035ECB0-BA01-11EA-A123-0157C63EEA3C',	
	projectid: 'SM',	
	sourceid: 'Russia',	
	autosync: false,	
	periodBegin: new Date('2020-07-01'),	
	periodEnd: new Date('2020-07-01'),	
	exchangeID: 'B72A88A5-E93A-4959-B2DC-287B798CA171',	
	execFlag: 0,	
	objectList: [],	
	forcedUpdate: true,	
	logLevel: 2,	
	flow: 18,	
	syncFunctionName: 'AutosyncSMSQL',	
	info: 'Test SQL-Autosync'	
};	
AutosyncSMSQL(params).catch((error) => { console.log(error); });	
*/	
/*	
// ! Тест очереди проведения документов	
const params = {	
  docid: '60CC3860-BC55-11EA-87BF-B532C3269DCB',	
  projectid: 'SM',	
  sourceid: 'Russia',	
  autosync: true,	
  periodBegin: new Date('2020-07-06'),	
  periodEnd: new Date('2020-07-06'),	
  exchangeID: '',	
  execFlag: 1000,  // кол-во документов в блоке	
  objectList: [],	
  forcedUpdate: true,	
  logLevel: 2,	
  flow: 0,	
  syncFunctionName: 'QueuePost',	
  info: 'Test Queue Post Documents'	
};	
QueuePost(params).catch((error) => { console.log(error); });	
*/	

// QueuePost(params).catch((error) => { console.log(error); });	

/*	
SaveProjectParams().catch((error) => {	
	console.log(error);	
}); // ! обровить данные проектов в базе	
*/	

// ! Тест MySQL	
const params = {	
	docid: 'D035ECB0-BA01-11EA-A123-0157C63EEA3C',	
	projectid: 'SM',	
	sourceid: 'Smartass',	
	autosync: false,	
	periodBegin: new Date('2020-07-01'), // ImportPurchaseRetToJetti date period 2019-03-26	
	periodEnd: new Date('2020-07-01'),	
	exchangeID: null,	
	execFlag: 0,	
	objectList: [],	
	forcedUpdate: true,	
	logLevel: 2,	
	flow: 0,	
	syncFunctionName: 'AutosincSmartToJetty',	
	info: 'Test Autosync',	
};	
AutosyncSmartToJetty(params).catch((error) => {	
	console.log(error);	
});	

/*	
const mysql = require('mysql');	
const connection = mysql.createConnection({	
	host: '172.18.100.163',	
	port: '3306',	
	user: 'smartass',	
	password: '5mdnrUcZduOHaDRb',	
	database: 'smartass'	
});	
connection.connect();	
// SELECT 1 + 1 AS solution, 2 + 2 as f	
connection.query(`	
	select  id, email, name, first_name, last_name, phone, create_datetime, update_datetime	
	from smartass.pe2_user	
	limit 20 `, function (error, results, fields) {	
	if (error) throw error;	
	// console.log('The solution is: ', results[0].solution);	
	for (const row in results) {	
		console.log(results[row]);	
	}	
});	
connection.end();	
*/