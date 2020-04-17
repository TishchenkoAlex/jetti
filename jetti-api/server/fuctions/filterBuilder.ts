import { FormListFilter, FilterInterval } from '../models/user.settings';

export interface IQueryFilter {
    tempTable: string;
    where: string;
}

export const filterBuilder = (filter: FormListFilter[]): IQueryFilter => {
    let where = ' (1 = 1) ';
    let tempTabe = '';

    const filterList = filter.filter(f => !(f.right === null || f.right === undefined));
    for (const f of filterList) {
        switch (f.center) {
            case '=':
            case '>=':
            case '<=':
            case '>':
            case '<':
                if (Array.isArray(f.right)) { // time interval
                    if (f.right[0])
                        where += ` AND "${f.left}" >= '${f.right[0]}'`;
                    if (f.right[1])
                        where += ` AND "${f.left}" <= '${f.right[1]}'`;
                    break;
                }
                if (typeof f.right === 'number') {
                    where += ` AND "${f.left}" ${f.center} '${f.right}'`;
                    break;
                }
                if (typeof f.right === 'boolean') {
                    where += ` AND "${f.left}" ${f.center} '${f.right}'`;
                    break;
                }
                if (typeof f.right === 'object') {
                    if (!f.right.id)
                        where += ` AND "${f.left}" IS NULL `;
                    else {
                        if (f.left === 'parent.id') {
                            where += ` AND "${f.left}" = '${f.right.id}'`;
                        } else {
                            if (tempTabe.indexOf(`[#${f.left}]`) < 0)
                                tempTabe += `SELECT id INTO [#${f.left}] FROM dbo.[Descendants]('${f.right.id}', '${f.right.type}');\n`;
                            where += ` AND "${f.left}" IN (SELECT id FROM [#${f.left}])`;
                        }
                    }
                    break;
                }
                if (typeof f.right === 'string')
                    f.right = f.right.toString().replace('\'', '\'\'');
                if (!f.right)
                    where += ` AND "${f.left}" IS NULL `;
                else
                    where += ` AND "${f.left}" ${f.center} N'${f.right}'`;
                break;
            case 'like':
                where += ` AND "${f.left}" LIKE N'%${(f.right['value'] || f.right).toString().replace('\'', '\'\'')}%' `;
                break;
            case 'beetwen':
                const interval = f.right as FilterInterval;
                if (interval.start)
                    where += ` AND "${f.left}" BEETWEN '${interval.start}' AND '${interval.end}' `;
                break;
            case 'in':
                where += ` AND "${f.left}" IN (${(f.right['value'] || f.right)}) `;
                break;
            case 'is null':
                where += ` AND "${f.left}" IS NULL `;
                break;
        }
    }
    return { where: where, tempTable: tempTabe };
};
