import { RegisteredDocumentsTypes as RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';
export class TypesUserOrGroup extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(d => ['Catalog.User', 'Catalog.UsersGroup'].includes(d));
  }
}
