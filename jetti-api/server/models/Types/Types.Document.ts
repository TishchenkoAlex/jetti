import { RegisteredDocument } from '../documents.factory';
import { TypesBase } from './TypesBase';

export class TypesDocument extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type.startsWith('Document.'))
      .map(e => e.type);
  }
}
