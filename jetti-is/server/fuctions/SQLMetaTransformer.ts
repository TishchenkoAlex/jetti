/**@description {  трансформирует данные из metadata SQL в представление белого человека }
 * @format {
 * {
 *  value: '15B37D9D-4443-4EC8-A0E2-CCAED341BA00',
 *  metadata: {
 *    userType: 0,
 *    flags: 33,
 *    type: {
 *     id: 231,
 *      type: 'NVARCHAR',
 *      name: 'NVarChar',
 *     maximumLength: 4000,
 *     declaration: [Function: declaration],
 *     resolveLength: [Function: resolveLength],
 *     generateTypeInfo: [Function: generateTypeInfo],
 *     generateParameterData: [GeneratorFunction: generateParameterData],
 *     validate: [Function: validate]
 *   },
 *     lcid: 1049,
 *     flags: 208,
 *     version: 0,
 *     sortId: 0,
 *     codepage: 'CP1251'
 *   },
 *   precision: undefined,
 *   scale: undefined,
 *   udtInfo: undefined,
 *   dataLength: 100,
 *   schema: undefined,
 *   colName: 'userModified',
 *   tableName: undefined
 * }
 *}
 * @example {
 * const p:IMySQL = SQLMetaTransformer(anyArray)
 * console.log(p)
 * }
 * @return {Object} Массив свойств которые извлечены из MetaData и value
 */

interface IsqlCollect {
	value: any;
	colName: string;
	typeDate: any;
}
interface IsqlCollectionArray {
	[index: number]: IsqlCollect;
}
export const SQLMetaTransformerArray = (...SQLMetaData): any => {
	let resolveObjMetaDataCollection: any = {};
	const resolveArray: any = [];
	for (const OneCollum of SQLMetaData[0]) {
		if (OneCollum.metadata) {
			if (OneCollum.metadata.colName) {
				if (
					typeof resolveObjMetaDataCollection[OneCollum.metadata.colName] !==
					'undefined'
				) {
					resolveArray.push(resolveObjMetaDataCollection);
					resolveObjMetaDataCollection = {};
				} else {
					resolveObjMetaDataCollection[OneCollum.metadata.colName] =
						OneCollum.value;
				}
			}
		}
	}
	return resolveArray;
};
