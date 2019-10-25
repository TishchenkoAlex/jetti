export interface ITypes {
  QueryList(): string;
}

export class TypesBase implements ITypes {
  QueryList(): string {
    throw new Error('Method not implemented.');
  }
}
