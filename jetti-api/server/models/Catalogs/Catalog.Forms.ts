import { buildSubcountQueryList } from '../../fuctions/SQLGenerator.MSSQL';
import { DocumentBase, DocumentOptions, JDocument, Props, Ref } from '../document';
import { RegisteredForms } from '../Forms/form.factory';

@JDocument({
  type: 'Catalog.Forms',
  description: 'Form types',
  icon: '',
  menu: 'Form types',
})
export class CatalogForms extends DocumentBase {
  @Props({ type: 'Catalog.Forms', hiddenInList: true, order: -1 })
  parent: Ref = null;


  QueryList() {
    const list: { type: string, description: string }[] = [];
    RegisteredForms.forEach(el => {
      const f = new el();
      list.push({ type: f.type, description: (<DocumentOptions>f.Prop()).description });
    });
    return buildSubcountQueryList(list);
  }

}
