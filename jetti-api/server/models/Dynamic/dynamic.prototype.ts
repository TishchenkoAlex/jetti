import { DocumentBase, JDocument, Props, Ref } from '../document';
import { JRegisterInfo, RegisterInfo } from '../Registers/Info/RegisterInfo';
@JDocument({
  type: 'Catalog.Dynamic',
  description: 'Прототип динамического справочника',
  icon: 'fa fa-list',
  menu: 'Прототип динамического справочника',
  prefix: 'ref-',
  hierarchy: 'folders'
})
export class CatalogDynamic extends DocumentBase {

  @Props({ type: 'Catalog.Dynamic', hiddenInList: true, order: -1 })
  parent: Ref = null;

}

@JRegisterInfo({
  type: 'Register.Info.Dynamic',
  description: 'Прототип регистра сведений',
})
export class RegisterInfoDynamic extends RegisterInfo {

  constructor(init: Partial<RegisterInfoDynamic>) {
    super(init);
    Object.assign(this, init);
  }
}

