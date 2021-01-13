import { RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesExpenseOrIncome extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.Expense', 'Catalog.Income'].includes(type));
  }

}
