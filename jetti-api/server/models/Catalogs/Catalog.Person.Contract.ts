import { JDocument, Props, Ref, DocumentBase } from '../document';

@JDocument({
  type: 'Catalog.Person.Contract',
  description: 'Договор с физ.лицом',
  icon: 'fa fa-list',
  menu: 'Договоры с физ.лицами',
  prefix: 'CONTR.P-'
})
export class CatalogPersonContract extends DocumentBase {

  @Props({ type: 'Catalog.Person.Contract', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Person', required: true, order: 1 })
  owner: Ref = null;

  @Props({ type: 'enum', value: ['OPEN', 'CLOSE', 'PENDING'], required: true })
  Status = 'OPEN';

  @Props({ type: 'date', required: true })
  StartDate: Ref = null;

  @Props({ type: 'date', required: false })
  EndDate: Ref = null;

}
