import { RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesExpenseOrBalanceOrIncome extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type.startsWith('Catalog.Expense') || d.type.startsWith('Catalog.Balance') || d.type.startsWith('Catalog.Income'))
      .map(e => e.type);
  }

}
