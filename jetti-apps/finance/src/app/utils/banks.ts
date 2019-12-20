

export class BankStatementUnloader {

  static getBankStatementAsString(docsID: string[]): string[] {
    const idString = docsID.map(el => "'" + el + "'").join(',');
    let fields = [
      { key: 'ВерсияФормата', value: '1.02' },
      { key: 'Кодировка', value: 'Windows' },
      { key: 'Отправитель', value: '1С:ERP Управление предприятием 2' },
      { key: 'Получатель', value: '' },
      { key: 'ДатаСоздания', value: this.getDateTime(new Date()).date},
      { key: 'ВремяСоздания', value: this.getDateTime(new Date()).time},
      { key: 'ДатаНачала', value: '' },
      { key: 'ДатаКонца', value: '' },
      { key: 'РасчСчет', value: '' },
      { key: 'Документ', value: 'Платежное поручение' }
    ]

    return fields.map(el => `${el.key}=${el.value}`);

    // return '1CClientBankExchange\n' + fields.map(el => `${el.key}=${el.value}`).join('\n');
  }
  //18.12.2019
  //15:32:59
  private static getDateTime(someDate: Date):{date:string, time: string} {
    return {
      date: `${someDate.getDate()}.${someDate.getMonth()}.${someDate.getFullYear()}`,
      time: `${someDate.getHours()}:${someDate.getMinutes()}:${someDate.getSeconds()}`
    }
  }

}
