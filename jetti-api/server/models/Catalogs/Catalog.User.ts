import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.User',
  description: 'Пользователь',
  icon: 'fa fa-list',
  menu: 'Пользователи',
  prefix: 'USR-',
  hierarchy: 'folders',
  relations: [
    { name: 'Responsible persons', type: 'Register.Info.CompanyResponsiblePersons', field: '[User].id' },
    { name: 'Loan owner', type: 'Register.Info.LoanOwner', field: '[User].id' },
  ],
})
export class CatalogUser extends DocumentBase {

  @Props({ type: 'Catalog.User', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'string', order: 1, required: true, style: { width: '250px' }, isUnique: true })
  code = '';

  @Props({ type: 'boolean' })
  isAdmin = false;

  @Props({ type: 'boolean' })
  isDisabled = false;

  @Props({ type: 'Catalog.Person' })
  Person: Ref = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

}
