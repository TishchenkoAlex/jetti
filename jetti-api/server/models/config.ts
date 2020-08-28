import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { CatalogSubcount } from './../models/Catalogs/Catalog.Subcount';
import { CatalogCatalogs } from './Catalogs/Catalog.Catalogs';
import { CatalogDocuments } from './Catalogs/Catalog.Documents';
import { CatalogObjects } from './Catalogs/Catalog.Objects';
import { DocumentBase, DocumentOptions, PropOptions, CopyTo } from './document';
import { createDocument, RegisteredDocumentStatic, RegisteredDocumentType, RegisteredDocumentDynamic } from './documents.factory';
import { AllDocTypes, AllTypes, ComplexTypes, DocTypes } from './documents.types';
import { createTypes, RegisteredTypes } from './Types/Types.factory';
import { CatalogForms } from './Catalogs/Catalog.Forms';
import { Global } from './global';

export interface IConfigSchema {
  type: AllDocTypes;
  description?: string;
  icon?: string;
  menu?: string;
  prefix?: string;
  QueryObject?: string;
  QueryList: string;
  dimensions?: { [x: string]: AllTypes }[];
  copyTo?: CopyTo[];
  Props: { [x: string]: PropOptions };
  Prop?: DocumentOptions;
  doc?: DocumentBase;
}

export function configSchema(): Map<AllDocTypes, IConfigSchema> {
  return Global.configSchema();
}

export function getConfigSchema() {
  return new Map(
      [...configSchemaStatic,
      ...ConfigSchemaFromRegisteredDocument(RegisteredDocumentDynamic())
      ]
          .map((i): [AllDocTypes, IConfigSchema] => [i.type, i]));
}

export function ConfigSchemaFromRegisteredDocument(RegisteredDocuments: RegisteredDocumentType[]): IConfigSchema[] {
  return [
    ...RegisteredDocuments.map(el => {
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
        // QueryObject: SQLGenegator.QueryObject(Props, el.type),
        QueryList: SQLGenegator.QueryList(Props, el.type),
        Props: Props,
        Prop: Prop,
        copyTo: Prop.copyTo,
        doc: doc
      });
      if (el.type === 'Catalog.Subcount') { result.QueryList = (doc as CatalogSubcount).QueryList(); }
      if (el.type === 'Catalog.Documents') { result.QueryList = (doc as CatalogDocuments).QueryList(); }
      if (el.type === 'Catalog.Catalogs') { result.QueryList = (doc as CatalogCatalogs).QueryList(); }
      if (el.type === 'Catalog.Objects') { result.QueryList = (doc as CatalogObjects).QueryList(); }
      if (el.type === 'Catalog.Forms') { result.QueryList = (doc as CatalogForms).QueryList(); }
      return result;
    })];
}

export const configSchemaStatic = [
  ...ConfigSchemaFromRegisteredDocument(RegisteredDocumentStatic)
  ,
  ...RegisteredTypes.map(el => {
    const doc = createTypes(el.type as ComplexTypes);
    const fakeDoc = new DocumentBase(); fakeDoc.type = el.type as any;
    return ({
      type: el.type as ComplexTypes,
      QueryList: doc.QueryList(),
      Props: fakeDoc.Props()
    });
  }),
];
