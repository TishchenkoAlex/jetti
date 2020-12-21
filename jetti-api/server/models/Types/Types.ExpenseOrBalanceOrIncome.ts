import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesExpenseOrBalanceOrIncome extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.Expense', 'Catalog.Balance', 'Catalog.Income'].includes(type));
  }

}
