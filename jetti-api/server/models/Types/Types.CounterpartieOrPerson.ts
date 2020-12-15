import { RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesCounterpartieOrPerson extends TypesBase {

  getTypes() {

    return RegisteredDocument()
      .filter(d =>
        d.type === 'Catalog.Counterpartie' ||
        d.type === 'Catalog.Person')
      .map(e => e.type);

  }
}
