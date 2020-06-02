import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Person',
  description: 'Физлицо',
  icon: 'fa fa-list',
  menu: 'Физлица',
  prefix: 'PERS-',
  relations: [
    { name: 'BankAccount', type: 'Catalog.Person.BankAccount', field: 'owner' },
    { name: 'Employee', type: 'Catalog.Employee', field: 'Person' },
    { name: 'Loan', type: 'Catalog.Loan', field: 'owner' }
  ],
  dimensions: [
    { Department: 'Catalog.Department' },
    { JobTitle: 'Catalog.JobTitle' }
  ]
})
export class CatalogPerson extends DocumentBase {

  @Props({ type: 'Catalog.Person', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', value: ['MALE', 'FEMALE', 'SELF'] })
  Gender = null;

  @Props({ type: 'string' })
  FirstName: Ref = null;

  @Props({ type: 'string' })
  LastName: Ref = null;

  @Props({ type: 'string' })
  MiddleName: Ref = null;

  @Props({ type: 'string' })
  Code1: Ref = null;

  @Props({ type: 'string' })
  Code2: Ref = null;

  @Props({ type: 'string' })
  Address: Ref = null;

  @Props({ type: 'string' })
  Phone: Ref = null;

  @Props({ type: 'string' })
  Email: Ref = null;

  @Props({ type: 'date' })
  EmploymentDate = null;

  @Props({ type: 'Catalog.Department' })
  Department: Ref = null;

  @Props({ type: 'Catalog.JobTitle' })
  JobTitle: Ref = null;

  @Props({ type: 'string' })
  Profile: Ref = null;

  @Props({ type: 'Catalog.PersonIdentity' })
  DocumentType: Ref = null;

  @Props({ type: 'string' })
  DocumentCode = '';

  @Props({ type: 'string' })
  DocumentNumber = '';

  @Props({ type: 'date' })
  DocumentDate = null;

  @Props({ type: 'string' })
  DocumentAuthority = '';

  @Props({ type: 'string', isAdditional: true })
  AccountAD = '';

  @Props({ type: 'boolean', hiddenInList: false, isAdditional: true })
  Fired = false;

}
