import { buildSubcountQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { DocumentBase, JDocument, Props, Ref } from './../document';
import { allTypes } from '../Types/Types.factory';

@JDocument({
  type: 'Catalog.Subcount',
  description: 'Субконко',
  icon: '',
  menu: 'Субконто',
})
export class CatalogSubcount extends DocumentBase {
  @Props({ type: 'Catalog.Subcount', hiddenInList: true, order: -1 })
  parent: Ref = null;

  QueryList = () => buildSubcountQueryList(allTypes());

}
