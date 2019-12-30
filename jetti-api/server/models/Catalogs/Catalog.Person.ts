import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Person',
  description: 'Физлицо',
  icon: 'fa fa-list',
  menu: 'Физлица',
  prefix: 'PERS-'
})
export class CatalogPerson extends DocumentBase {

  @Props({ type: 'Catalog.Person', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string' })
  Code1: Ref = null;

  @Props({ type: 'string' })
  Code2: Ref = null;

  @Props({ type: 'string' })
  Address: Ref = null;

  @Props({ type: 'string' })
  Phone: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.JobTitle' })
  JobTitle: Ref = null;

  @Props({ type: 'string' })
  Profile: Ref = null;

}
