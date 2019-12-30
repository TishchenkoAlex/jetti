import { IFlatDocument } from './../../../../../../jetti-api/server/models/documents.factory';

export function viewModelToFlatDocument(viewModel: { [key: string]: any }): IFlatDocument {
  const newDoc: IFlatDocument = {
    id: viewModel.id || null,
    type: viewModel.type,
    date: viewModel.date || new Date(),
    code: viewModel.code,
    description: viewModel.description,
    posted: viewModel.posted,
    deleted: viewModel.deleted,
    parent: viewModel.parent && viewModel.parent['id'],
    isfolder: viewModel.isfolder,
    company: viewModel.company && viewModel.company['id'],
    user: viewModel.user && viewModel.user['id'],
    info: viewModel.info,
    timestamp: viewModel.timestamp || null,
  };

  const JETTI_DOC_PROP = Object.keys(newDoc);

  for (const property in viewModel) {
    if (!viewModel.hasOwnProperty(property)) { continue; }
    if (JETTI_DOC_PROP.indexOf(property) > -1) { continue; }
    if ((Array.isArray(viewModel[property]))) {
      const copy = JSON.parse(JSON.stringify(viewModel[property])) as any[];
      copy.forEach(element => {
        for (const p in element) {
          if (element.hasOwnProperty(p)) {
            let value = element[p];
            if (value && value.type &&
              ['string', 'number', 'boolean', 'datetime'].includes(value.type)) {
              value = null; element[p] = value; continue;
            }
            if (value && value.type && !value.value && ((value.id === '') || (value.id === null))) { value = null; }
            element[p] = !(value === undefined || value === null) ? value.id || value : value || null;
          }
        }
        delete element.index;
      });
      newDoc[property] = copy;
    } else {
      let value = viewModel[property];
      if (value && value['type'] &&
        ['string', 'number', 'boolean', 'datetime'].includes(value['type'])) {
        value['id'] = null; newDoc[property] = value; continue;
      }
      if (value && value['type'] && !value['value'] && ((value['id'] === '') || (value['id'] === null))) { value = null; }
      newDoc[property] = !(value === undefined || value === null) ? value['id'] || value : value || null;
    }
  }
  return newDoc;
}
