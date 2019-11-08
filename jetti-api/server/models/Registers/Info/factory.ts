import { RegisterInfoDepreciation } from './Depreciation';
import { RegisterInfoExchangeRates } from './ExchangeRates';
import { RegisterInfoPriceList } from './PriceList';
import { RegisterInfo } from './RegisterInfo';
import { RegisterInfoRLS } from './RLS';
import { RegisterInfoSettings } from './Settings';

export type RegisterInfoTypes =
    'Register.Info.PriceList' |
    'Register.Info.ExchangeRates' |
    'Register.Info.Settings' |
    'Register.Info.Depreciation' |
    'Register.Info.RLS';

export type RegistersInfo =
    RegisterInfoPriceList |
    RegisterInfoExchangeRates |
    RegisterInfoDepreciation |
    RegisterInfoSettings |
    RegisterInfoRLS;

export interface IRegisteredRegisterInfo {
    type: RegisterInfoTypes;
    Class: typeof RegisterInfo;
}

const RegisteredRegisterInfo: IRegisteredRegisterInfo[] = [
    { type: 'Register.Info.PriceList', Class: RegisterInfoPriceList },
    { type: 'Register.Info.ExchangeRates', Class: RegisterInfoExchangeRates },
    { type: 'Register.Info.Settings', Class: RegisterInfoSettings },
    { type: 'Register.Info.Depreciation', Class: RegisterInfoDepreciation },
    { type: 'Register.Info.RLS', Class: RegisterInfoRLS },
];

export function createRegisterInfo<T extends RegisterInfo>(init: Partial<T>): T {
    const doc = RegisteredRegisterInfo.find(el => el.type === init.type);
    if (doc) return (new doc.Class(init) as T);
    else throw new Error(`createRegisterInfo: can't create type! ${init.type} is not registered`);
}

export function RegisterRegisterInfo(Register: IRegisteredRegisterInfo) {
    RegisteredRegisterInfo.push(Register);
}

export function GetRegisterInfo() {
    return RegisteredRegisterInfo;
}
