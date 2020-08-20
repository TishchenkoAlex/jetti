import { DocumentOptions } from '../document';
import { RegisteredDocument, createDocument } from '../documents.factory';
import { buildTypesQueryList } from '../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesUserOrGroup extends TypesBase {

  getTypes() {
    return RegisteredDocument()
      .filter(d => d.type === 'Catalog.User' || d.type === 'Catalog.UsersGroup')
      .map(e => e.type);
  }
}
