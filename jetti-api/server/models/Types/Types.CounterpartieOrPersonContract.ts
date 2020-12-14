import { RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCounterpartieOrPersonContract extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type === 'Catalog.Contract' || d.type === 'Catalog.Person.Contract')
      .map(e => e.type);
  }
}
