import { FormListFilter, FilterInterval } from '../models/user.settings';

export interface IQueryFilter {
  tempTable: string;
  where: string;
}

export const filterBuilder = (filter: FormListFilter[],
  excludesTypes = ['Catalog.Operation.Group', 'Catalog.User', 'Catalog.Operation']): IQueryFilter => {

  let where = ' (1 = 1) '; let tempTable = '';
  const filterList = filter
    .filter(f => !(f.right === null || f.right === undefined))
    .map(f => ({ ...f, leftQ: `\"${f.left}\"` }));

  for (const f of filterList) {
    switch (f.center) {
      case '=': case '>=': case '<=': case '>': case '<': case '<>':
        if (Array.isArray(f.right)) { // time interval
          if (f.right[0]) where += ` AND ${f.leftQ} >= '${f.right[0]}'`;
          if (f.right[1]) where += ` AND ${f.leftQ} <= '${f.right[1]}'`;
          break;
        }
        if (typeof f.right === 'string') f.right = f.right.toString().replace('\'', '\'\'');
        if (typeof f.right === 'number') { where += ` AND ${f.leftQ} ${f.center} '${f.right}'`; break; }
        if (typeof f.right === 'boolean') { where += ` AND ${f.leftQ} ${f.center} '${f.right}'`; break; }
        if (f.right instanceof Date) { where += ` AND ${f.leftQ} ${f.center} '${f.right.toJSON()}'`; break; }
        if (typeof f.right === 'object') {
          if (!f.right.id) where += ` AND ${f.leftQ} IS NULL `;
          else if (f.left === 'parent.id') where += ` AND ${f.leftQ} = '${f.right.id}'`;
          else if (excludesTypes.includes(f.right.type)) where += ` AND ${f.leftQ} = '${f.right.id}'`;
          else if (tempTable.indexOf(`[#${f.left}]`) < 0) {
            tempTable += `SELECT id INTO [#${f.left}] FROM dbo.[Descendants]('${f.right.id}', '${f.right.type}');\n`;
            where += ` AND ${f.leftQ} IN (SELECT id FROM [#${f.left}])`;
          }
          break;
        }
        if (!f.right) where += ` AND ${f.leftQ} IS NULL `; else where += ` AND ${f.leftQ} ${f.center} N'${f.right}'`;
        break;
      case 'like':
        where += ` AND ${f.leftQ} LIKE N'%${(f.right['value'] || f.right).toString().replace('\'', '\'\'')}%' `;
        break;
      case 'not like':
        where += ` AND ${f.leftQ} NOT LIKE N'%${(f.right['value'] || f.right).toString().replace('\'', '\'\'')}%' `;
        break;
      case 'beetwen':
        const interval = f.right as FilterInterval;
        if (interval.start) where += ` AND ${f.leftQ} BEETWEN '${interval.start}' AND '${interval.end}' `;
        break;
      case 'in':
        where += ` AND ${f.leftQ} IN (${(f.right['value'] || f.right)}) `;
        break;
      case 'not in':
        where += ` AND ${f.leftQ} NOT IN (${(f.right['value'] || f.right)}) `;
        break;
      case 'is null':
        where += ` AND ${f.leftQ} IS NULL `;
      case 'is not null':
        where += ` AND ${f.leftQ} IS NOT NULL `;
        break;
    }
  }
  return { where: where, tempTable: tempTable };
};
