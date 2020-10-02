import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.PromotionChannel',
  description: 'Канал рекламы',
  icon: 'fa fa-list',
  menu: 'Каналы рекламы',
})
export class CatalogPromotionChannel extends DocumentBase {

  @Props({ type: 'Catalog.PromotionChannel', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

}
