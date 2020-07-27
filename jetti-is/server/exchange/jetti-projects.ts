// описание параметров проектов
import { config as dotenv } from 'dotenv';

import { Ref } from './iiko-to-jetti-utils';
import { exchangeOneOrNone } from './iiko-to-jetti-connection';

dotenv();
// интерфейс базы источника данных
export interface IExchangeSource {
	id: string; // id базы
	code: string; // префикс для кодов документов/справочников
	firstDate: Date; // дата с которой ведется учет
	company: string; // корневая(родительская) компания
	currency: string; // валюта
	TransitStorehouse: string; // транзитный склад
	CounterpartieFolder: Ref; // папка для контрагентов в базе приемнике
	ProductFolder: Ref; // папка для номенклатуры в базе приемнике
	exchangeStores: string[]; // список складов для синхронизации (если пустой массив - все имеющиеся)
	exchangeDeparments: string[]; // список подразделений для синхронизации (если пустой массив - все имеющиеся)
}

// интерфейс проекта
export interface IJettiProject {
	id: string; // id проекта
	destination: string; // база приемник проекта
	sources: IExchangeSource[]; // список баз источников для проекта
	baseURL: string; // URL сервисов проекта
	queuePostURL: string; // сервис проведения
	loginURL: string; // авторизация
	authParams: {
		// параметры авторизации
		email?: string; // e-mail
		password?: string; // пароль
	};
}

/*
export interface IExchangeBase  extends IExchangeSource{
    db_type?: string,
    db_exchange_type?: string,
    db_host?: string,
    db_instance?: string,
    db_port?: number,
    db_name?: string,
    db_user?: string,
    db_password?: string
}
*/
//////////////////////////////////////////////////////////////////////////
// ! ВРЕМЕННО: тестовые параметры
// база источника Russia проекта SMV
export const RussiaSourceSMV: IExchangeSource = {
	id: 'Russia',
	code: 'RU',
	firstDate: new Date('2020-07-01'),
	company: 'E5850830-02D2-11EA-A524-E592E08C23A5',
	currency: 'A4867005-66B8-4A8A-9105-3F25BB081936',
	TransitStorehouse: '7642EDF0-CB88-11EA-A616-C7FB62AF187B',
	CounterpartieFolder: '42E29350-AF24-11EA-B93F-AD0D181CA7FB',
	ProductFolder: '149A6390-B16F-11EA-AF55-1D3B6811F490',
	exchangeStores: [
		'F3FE986C-B007-427B-B7E4-69A1CE96D807',
		'22925F3E-7597-4362-BD3C-FFEB20913B7B',
		'B72A88A5-E93A-4959-B2DC-287B798CA171',
		'7ECAB182-7C77-4827-AD7F-8BB1DB40D8E6',
		'048D8729-EAF7-499D-BD3F-AAC1DA034980',
		'0C8194C5-063D-4A55-9FC1-D7579A47DD92',
		'F5288B74-B51C-42A0-A54A-08096BF4544C',
		'6AA733F2-3584-47DE-B056-15BEBE9D7EEA',
		'A7CB5B72-D6D8-4221-80BF-2BED6FEF1799',
		'99BDDECA-2E52-4650-90A6-637CC6647A5F',
		'F572B5FB-8CD0-46B9-8277-384C9E88EF15',
		'C02BE998-06AE-4650-93B4-52D40276A09B',
		'E30FF6BB-F174-4257-9F8F-B6C30B59B6EC',
		'05593A7D-3E3B-45C9-8DA1-C9D73E08F167',
		'55563A7A-3CBB-4575-82A9-BE3DC99365CD',
		'B284BDF9-5401-4810-AEB1-641D77575DA0',
		'68733584-928C-441B-A53A-0FCEEE36B5F9',
		'BF386572-843F-48A5-8A65-DF9C416C5B39',
		'81568FE3-4EFF-4098-BE87-343F72AED5D1',
		'07D68A3C-A776-41EB-B474-BE7258E86505',
		'764535CD-7DB7-4981-B497-B0BFC9F41607',
		'75021289-73C5-46B5-BA50-BC8DEDEBEA70',
		'C6DFE472-1C9D-4C02-B2BD-1788D8BB8C6D',
	],
	exchangeDeparments: [
		'483C6FF6-3937-47DD-A0EA-A18790850719',
		'6D9CE7C4-33E7-4663-B71E-119B98A6B85E',
		'AA3FC867-05A9-4053-9B9A-F26E854673D1',
		'E392AC91-20C4-4C2E-A3ED-E924A90BD74D',
		'A195102C-D618-4A0F-B1DD-42ABAD2F5AB3',
		'CD7BF285-F5A9-4249-94BA-3571CE5B37BA',
		'32B54A32-E3BC-4A92-86A4-FE6CE5B8DF8B',
		'A1C7CF6E-73DF-4E83-B7DB-0BB052B20F62',
		'54A2C69B-A2BB-4B56-90F5-CF2A65071715',
		'5565BA3E-642A-4618-82C5-8AD6A9FCA7D6',
		'0A427F3B-64AF-4386-BDAE-C4CF6CFBEF6E',
		'045D3D22-2D1C-4CDC-B3FF-569E2474ABB7',
		'4679B857-E3BD-4955-ACCB-57513B8496E3',
		'826AEF22-7448-4E65-8E41-131D6405729E',
		'9737403D-DFAF-428E-AC23-59698CB87AC0',
		'0138FF8B-7653-4B5C-9C7F-32B4AEE31D91',
		'311534EB-48F4-4B9B-87FC-F47CEF801362',
		'10E8681B-466C-4283-883C-C673B01CBE86',
		'C523B1C7-53CE-4155-B306-036B120B9BC2',
		'71E6D250-B2C3-4106-9056-CBC9181D4E59',
		'5D9006EB-CB07-4E32-98AD-8440A8BE650D',
		'6096BAF5-CDC0-4170-91C1-5128F057DA9A',
		'BBB0A9C4-8348-447F-8346-0332FCE1EA0A',
	],
};
// проект SMV
export const SMVProject: IJettiProject = {
	id: 'SMV',
	destination: 'SMV',
	sources: [RussiaSourceSMV],
	baseURL: 'https://smv.jetti-app.com',
	queuePostURL: 'api/post',
	loginURL: 'exchange/login',
	authParams: {
		email: process.env.EXCHANGE_LOGIN,
		password: process.env.EXCHANGE_ACCESS_KEY,
	},
};
// тестовые параметры для баз источников проекта SM
export const RussiaSourceSM: IExchangeSource = {
	id: 'Russia',
	code: 'RU',
	firstDate: new Date('2020-01-01'),
	company: 'E5850830-02D2-11EA-A524-E592E08C23A5',
	currency: 'A4867005-66B8-4A8A-9105-3F25BB081936',
	TransitStorehouse: 'A6630630-105A-11EA-A121-47B7906BBE72',
	CounterpartieFolder: '18C511F0-0E12-11EA-8C8B-DF1D52F7A823',
	ProductFolder: '4862FFC0-0E0E-11EA-8C8B-DF1D52F7A823',
	exchangeStores: [],
	exchangeDeparments: [],
};
export const UkraineSourceSM: IExchangeSource = {
	id: 'Ukraine',
	code: 'UA',
	firstDate: new Date('2020-01-01'),
	company: 'FE302460-0489-11EA-941F-EBDB19162587',
	currency: 'B559C270-42E6-11E8-9F62-93768160FCE2',
	TransitStorehouse: '99012980-105B-11EA-A121-47B7906BBE72',
	CounterpartieFolder: '6C157420-1043-11EA-918B-29E0703B7EE8',
	ProductFolder: 'FD813CD0-1068-11EA-A121-47B7906BBE72',
	exchangeStores: [],
	exchangeDeparments: [],
};
export const KazakhstanSourceSM: IExchangeSource = {
	id: 'Kazakhstan',
	code: 'KZ',
	firstDate: new Date('2020-01-01'),
	company: '9C226AA0-FAFA-11E9-B75B-A35013C043AE',
	currency: 'EACEB4C0-EF78-11E9-B31D-AFFC64AED744',
	TransitStorehouse: '5A861070-062A-11EA-93E1-4FADE32DFB41',
	CounterpartieFolder: '75D010A0-0603-11EA-93E1-4FADE32DFB41',
	ProductFolder: '49B971A0-0603-11EA-93E1-4FADE32DFB41',
	exchangeStores: [],
	exchangeDeparments: [],
};

// тестовые прараметры для проекта SM
export const SMProject: IJettiProject = {
	id: 'SM',
	destination: 'SM',
	sources: [RussiaSourceSM, UkraineSourceSM, KazakhstanSourceSM],
	baseURL: 'https://sm.jetti-app.com',
	queuePostURL: 'api/post',
	loginURL: 'exchange/login',
	authParams: {
		email: process.env.EXCHANGE_LOGIN,
		password: process.env.EXCHANGE_ACCESS_KEY,
	},
};
async function UpdateProject(p: any) {
	await exchangeOneOrNone(
		`
	UPDATE dbo.projects
    SET [data] = i.[data]
    FROM (
    SELECT [projectid], [data]
    FROM OPENJSON(@p1) WITH (
        [projectid] NVARCHAR(50),
        [data] NVARCHAR(max) N'$.data' AS JSON)
    ) i
    WHERE dbo.projects.[projectid] = i.[projectid]`,
		[JSON.stringify(p)],
	);
}
export async function SaveProjectParams() {
	let pr = {
		projectid: SMProject.id,
		data: SMProject,
	};
	await UpdateProject(pr);
	pr = {
		projectid: SMVProject.id,
		data: SMVProject,
	};
	await UpdateProject(pr);
	console.log('project data updated.');
}
