import { RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesExpenseOrIncome extends TypesBase {

  getTypes() {
    const types = ['Catalog.Expense', 'Catalog.Income'];
    return RegisteredDocument()
      .filter(d => types.includes(d.type))
      .map(e => e.type);
  }

}
