import { RegisteredDocumentsTypes as RegisteredDocumentsTypes } from '../documents.factory';
import { TypesBase } from './TypesBase';
export class TypesUserOrGroup extends TypesBase {

  getTypes() {
    return RegisteredDocumentsTypes(type => ['Catalog.User', 'Catalog.UsersGroup'].includes(type));
  }
}
