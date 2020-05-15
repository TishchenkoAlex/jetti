import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: 'numeric' })
export class NumericPipe implements PipeTransform {
  transform(str: string, precision: number = 2) {
    return stringToNumber(str, precision);
  }
}
export function stringToNumberString(str: any, precision: number = 2): string {
  if (!str) return '';
  const digitGroups = ('' + str).replace('.', ',').split(',');
  const res = parseFloat(digitGroups.length === 1
    ? digitGroups[0].replace(/[^0-9,]*/g, '') :
    `${digitGroups[0].replace(/[^0-9,]*/g, '')}.${digitGroups[1].slice(0, precision).replace(/[^0-9,]*/g, '')}`);
  if (Number.isNaN(res)) return '';
  const numbRes = ('' + res).replace('.', ',');
  return `${numbRes}${digitGroups.length > 1 && !numbRes.includes(',') ? ',' : ''}`;
}

export function stringToNumber(str: any, precision: number = 2): number {
  if (!str ) return 0;
  const digitGroups = ('' + str).replace(',', '.').split('.');
  const res = parseFloat(digitGroups.length === 1
    ? digitGroups[0].replace(/[^0-9.]*/g, '') :
    `${digitGroups[0].replace(/[^0-9.]*/g, '')}.${digitGroups[1].slice(0, precision).replace(/[^0-9.]*/g, '')}`);
  if (Number.isNaN(res)) return 0;
  const numbRes = '' + res;
  return parseFloat(`${numbRes}${digitGroups.length > 1 && !numbRes.includes('.') ? '.' : ''}`);
}
