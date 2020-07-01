// Test exchange modules...
import { AutosincIkoToJetty } from './exchange/iiko-to-jetti-autosync';

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

const params = {
      docid: 'D035ECB0-BA01-11EA-A123-0157C63EEA3C',
      projectid: 'SMV',
      sourceid: 'Russia',
      autosync: false,
      periodBegin: new Date(2020, 5, 1),
      periodEnd: new Date(2020, 5, 2),
      exchangeID: 'B72A88A5-E93A-4959-B2DC-287B798CA171',
      execFlag: 32,
      forcedUpdate: true,
      logLevel: 2,
      syncFunctionName: 'AutosincIkoToJetty'
};

AutosincIkoToJetty(params).catch((error) => { console.log(error); });

