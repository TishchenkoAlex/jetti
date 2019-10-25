import { DocumentOptions } from '../document';
import { createDocument, RegisteredDocument } from '../documents.factory';
import { AllTypes } from '../documents.types';
import { buildTypesQueryList } from './../../fuctions/SQLGenerator.MSSQL';
import { TypesBase } from './TypesBase';

export class TypesSubcount extends TypesBase {

  QueryList() {
    const select = RegisteredDocument
      .map(el => ({ type: el.type as AllTypes, description: (<DocumentOptions>(createDocument(el.type).Prop())).description }));

    select.push({type: 'number', description: 'number'});
    select.push({type: 'date', description: 'date'});
    select.push({type: 'datetime', description: 'datetime'});
    select.push({type: 'string', description: 'string'});
    select.push({type: 'boolean', description: 'boolean'});
    select.push({type: 'table', description: 'table'});

    return buildTypesQueryList(select);
  }

}

