import { RegisterInfoTaxCheck } from './TaxCheck';
import { RegisterInfoDynamic } from './../../Dynamic/dynamic.prototype';
import { RegisterInfoShareEmission } from './ShareEmission';
import { RegisterInfoCompanyPrice } from './CompanyPrice';
import { RegisterInfoRoyaltySales } from './RoyaltySales';
import { RegisterInfoDepartmentStatus } from './DepartmentStatus';
import { RegisterInfoHoliday } from './Holiday';
import { RegisterInfoCompanyResponsiblePersons } from './CompanyResponsiblePersons';
import { RegisterInfoRLSPeriod } from './RLS.Period';
import { RegisterInfoDepreciation } from './Depreciation';
import { RegisterInfoExchangeRates } from './ExchangeRates';
import { RegisterInfoPriceList } from './PriceList';
import { RegisterInfo } from './RegisterInfo';
import { RegisterInfoRLS } from './RLS';
import { RegisterInfoSettings } from './Settings';
import { RegisterInfoBudgetItemRule } from './BudgetItemRule';
import { DepartmentCompanyHistory } from './DepartmentCompanyHistory';
import { RegisterInfoCounterpartiePriceList } from './CounterpartiePriceList';
import { RegisterInfoSettlementsReconciliation } from './SettlementsReconciliation';
import { RegisterInfoProductSpecificationByDepartment } from './ProductSpecificationByDepartment';
import { RegisterInfoIntercompanyHistory } from './IntercompanyHistory';
import { RegisterInfoIncomeDocumentRegistry } from './IncomeDocumentRegistry';
import { RegisterInfoLoanOwner } from './LoanOwner';
import { RegisterInfoEmployeeHistory } from './EmployeeHistory';
import { RegisterInfoExchangeRatesNational } from './ExchangeRates.National';
import { RegisterInfoProductModifier } from './ProductModifier';
import { RegisterInfoSelfEmployed } from './SelfEmployed';
import { RegisterInfoStaffingTableHistory } from './StaffingTableHistory';
import { RegisterInfoEmploymentType } from './EmploymentType';
import { RegisterInfoIntl } from './Intl';

export type RegisterInfoTypes =
    'Register.Info.Dynamic' |
    'Register.Info.Holiday' |
    'Register.Info.PriceList' |
    'Register.Info.SelfEmployed' |
    'Register.Info.SettlementsReconciliation' |
    'Register.Info.ExchangeRates' |
    'Register.Info.ExchangeRates.National' |
    'Register.Info.Settings' |
    'Register.Info.ProductSpecificationByDepartment' |
    'Register.Info.Depreciation' |
    'Register.Info.RLS' |
    'Register.Info.Intl' |
    'Register.Info.RLS.Period' |
    'Register.Info.BudgetItemRule' |
    'Register.Info.DepartmentCompanyHistory' |
    'Register.Info.DepartmentStatus' |
    'Register.Info.CompanyResponsiblePersons' |
    'Register.Info.IntercompanyHistory' |
    'Register.Info.RoyaltySales' |
    'Register.Info.IncomeDocumentRegistry' |
    'Register.Info.CompanyPrice' |
    'Register.Info.ShareEmission' |
    'Register.Info.LoanOwner' |
    'Register.Info.ProductModifier' |
    'Register.Info.EmployeeHistory' |
    'Register.Info.EmploymentType' |
    'Register.Info.StaffingTableHistory' |
    'Register.Info.TaxCheck' |
    'Register.Info.CounterpartiePriceList';

export type RegistersInfo =
    RegisterInfoDynamic |
    RegisterInfoHoliday |
    RegisterInfoPriceList |
    RegisterInfoDepartmentStatus |
    RegisterInfoRoyaltySales |
    RegisterInfoSettlementsReconciliation |
    RegisterInfoCompanyResponsiblePersons |
    RegisterInfoExchangeRates |
    RegisterInfoExchangeRatesNational |
    RegisterInfoDepreciation |
    RegisterInfoSettings |
    RegisterInfoIntl |
    RegisterInfoSelfEmployed |
    RegisterInfoProductSpecificationByDepartment |
    RegisterInfoIntercompanyHistory |
    RegisterInfoIncomeDocumentRegistry |
    RegisterInfoCompanyPrice |
    RegisterInfoShareEmission |
    RegisterInfoLoanOwner |
    RegisterInfoProductModifier |
    RegisterInfoEmployeeHistory |
    RegisterInfoEmploymentType |
    RegisterInfoStaffingTableHistory |
    RegisterInfoTaxCheck |
    RegisterInfoRLS;

export interface IRegisteredRegisterInfo {
    type: RegisterInfoTypes;
    Class: typeof RegisterInfo;
}

const RegisteredRegisterInfo: IRegisteredRegisterInfo[] = [
    { type: 'Register.Info.Dynamic', Class: RegisterInfoDynamic },
    { type: 'Register.Info.Holiday', Class: RegisterInfoHoliday },
    { type: 'Register.Info.PriceList', Class: RegisterInfoPriceList },
    { type: 'Register.Info.SelfEmployed', Class: RegisterInfoSelfEmployed },
    { type: 'Register.Info.ProductModifier', Class: RegisterInfoProductModifier },
    { type: 'Register.Info.SettlementsReconciliation', Class: RegisterInfoSettlementsReconciliation },
    { type: 'Register.Info.ExchangeRates', Class: RegisterInfoExchangeRates },
    { type: 'Register.Info.ExchangeRates.National', Class: RegisterInfoExchangeRatesNational },
    { type: 'Register.Info.ProductSpecificationByDepartment', Class: RegisterInfoProductSpecificationByDepartment },
    { type: 'Register.Info.Settings', Class: RegisterInfoSettings },
    { type: 'Register.Info.Depreciation', Class: RegisterInfoDepreciation },
    { type: 'Register.Info.RLS.Period', Class: RegisterInfoRLSPeriod },
    { type: 'Register.Info.RLS', Class: RegisterInfoRLS },
    { type: 'Register.Info.BudgetItemRule', Class: RegisterInfoBudgetItemRule },
    { type: 'Register.Info.IntercompanyHistory', Class: RegisterInfoIntercompanyHistory },
    { type: 'Register.Info.DepartmentCompanyHistory', Class: DepartmentCompanyHistory },
    { type: 'Register.Info.DepartmentStatus', Class: RegisterInfoDepartmentStatus },
    { type: 'Register.Info.CounterpartiePriceList', Class: RegisterInfoCounterpartiePriceList },
    { type: 'Register.Info.CompanyResponsiblePersons', Class: RegisterInfoCompanyResponsiblePersons },
    { type: 'Register.Info.IncomeDocumentRegistry', Class: RegisterInfoIncomeDocumentRegistry },
    { type: 'Register.Info.CompanyPrice', Class: RegisterInfoCompanyPrice },
    { type: 'Register.Info.ShareEmission', Class: RegisterInfoShareEmission },
    { type: 'Register.Info.LoanOwner', Class: RegisterInfoLoanOwner },
    { type: 'Register.Info.Intl', Class: RegisterInfoIntl },
    { type: 'Register.Info.RoyaltySales', Class: RegisterInfoRoyaltySales },
    { type: 'Register.Info.EmployeeHistory', Class: RegisterInfoEmployeeHistory },
    { type: 'Register.Info.EmploymentType', Class: RegisterInfoEmploymentType },
    { type: 'Register.Info.StaffingTableHistory', Class: RegisterInfoStaffingTableHistory },
    { type: 'Register.Info.TaxCheck', Class: RegisterInfoTaxCheck },
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
