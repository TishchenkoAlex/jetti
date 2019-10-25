import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { CatalogSubcount } from './../models/Catalogs/Catalog.Subcount';
import { CatalogCatalogs } from './Catalogs/Catalog.Catalogs';
import { CatalogDocuments } from './Catalogs/Catalog.Documents';
import { DocumentBase, DocumentOptions, PropOptions } from './document';
import { createDocument, RegisteredDocument } from './documents.factory';
import { AllDocTypes, AllTypes, ComplexTypes, DocTypes } from './documents.types';
import { createTypes, RegisteredTypes } from './Types/Types.factory';

export interface IConfigSchema {
  type: AllDocTypes;
  description?: string;
  icon?: string;
  menu?: string;
  prefix?: string;
  QueryObject?: string;
  QueryList: string;
  dimensions?: { [x: string]: AllTypes }[];
  copyTo?: DocTypes[];
  Props: { [x: string]: PropOptions };
  Prop?: DocumentOptions;
  doc?: DocumentBase;
}

export const configSchema = new Map([
  ...RegisteredDocument.map(el => {
    const doc = createDocument(el.type);
    const Prop = doc.Prop() as DocumentOptions;
    const Props = doc.Props();
    const result: IConfigSchema = ({
      type: el.type,
      description: Prop.description,
      icon: Prop.icon,
      menu: Prop.menu,
      prefix: Prop.prefix,
      dimensions: Prop.dimensions,
      QueryObject: SQLGenegator.QueryObject(Props, el.type),
      QueryList: SQLGenegator.QueryList(Props, el.type),
      Props: Props,
      Prop: Prop,
      copyTo: Prop.copyTo,
      doc: doc
    });
    if (el.type === 'Catalog.Subcount') { result.QueryList = (doc as CatalogSubcount).QueryList(); }
    if (el.type === 'Catalog.Documents') { result.QueryList = (doc as CatalogDocuments).QueryList(); }
    if (el.type === 'Catalog.Catalogs') { result.QueryList = (doc as CatalogCatalogs).QueryList(); }
    return result;
  }),
  ...RegisteredTypes.map(el => {
    const doc = createTypes(el.type as ComplexTypes);
    const fakeDoc = new DocumentBase(); fakeDoc.type = el.type as any;
    return ({
      type: el.type as ComplexTypes,
      QueryList: doc.QueryList(),
      Props: fakeDoc.Props()
    });
  }),
].map((i): [AllDocTypes, IConfigSchema] => [i.type, i]));
