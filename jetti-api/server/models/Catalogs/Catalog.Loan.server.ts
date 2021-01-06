import { IServerDocument } from '../documents.factory.server';
import { MSSQL } from '../../mssql';
import { CatalogLoan } from './Catalog.Loan';
import { lib } from '../../std.lib';
import { x100 } from '../../x100.lib';
import { CatalogCompany } from './Catalog.Company';


export class CatalogLoanServer extends CatalogLoan implements IServerDocument {

  beforeSave = async (tx: MSSQL): Promise<this> => {

    const departmentCompanyID = await x100.info.companyByDepartment(this.Department, new Date, tx);
    if (this.company === departmentCompanyID) return this;
    const company = await lib.doc.byIdT<CatalogCompany>(this.company, tx);
    const departmentCompany = await lib.doc.byIdT<CatalogCompany>(departmentCompanyID, tx);
    if (company && departmentCompany && company.currency !== departmentCompany.currency)
      throw new Error(`Валюта баланса организации подразделения договора не совпадает с валютой баланса организации договора`);

    return this;
  }

}
