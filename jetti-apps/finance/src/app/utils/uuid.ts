// tslint:disable: no-bitwise
export class Utils {

  static decimalToHex(num: number): string {
    let hex: string = num.toString(16);
    while (hex.length < 2) hex = '0' + hex;
    return hex;
  }
    static createNewGuid(): string {

    const cryptoObj: Crypto = window.crypto; // for IE 11
    if (cryptoObj && cryptoObj.getRandomValues) {
      const buffer: Uint8Array = new Uint8Array(16);
      cryptoObj.getRandomValues(buffer);
      buffer[6] |= 0x40;
      buffer[6] &= 0x4f;
      buffer[8] |= 0x80;
      buffer[8] &= 0xbf;

      return Utils.decimalToHex(buffer[0]) + Utils.decimalToHex(buffer[1])
        + Utils.decimalToHex(buffer[2]) + Utils.decimalToHex(buffer[3])
        + '-' + Utils.decimalToHex(buffer[4]) + Utils.decimalToHex(buffer[5])
        + '-' + Utils.decimalToHex(buffer[6]) + Utils.decimalToHex(buffer[7])
        + '-' + Utils.decimalToHex(buffer[8]) + Utils.decimalToHex(buffer[9])
        + '-' + Utils.decimalToHex(buffer[10]) + Utils.decimalToHex(buffer[11])
        + Utils.decimalToHex(buffer[12]) + Utils.decimalToHex(buffer[13])
        + Utils.decimalToHex(buffer[14]) + Utils.decimalToHex(buffer[15]);
    } else {
      const guidHolder = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
      const hex = '0123456789abcdef';
      let r = 0;
      let guidResponse = '';
      for (let i = 0; i < 36; i++) {
        if (guidHolder[i] !== '-' && guidHolder[i] !== '4') {
          r = Math.random()  * 16 | 0;
        }
        if (guidHolder[i] === 'x') {
          guidResponse += hex[r];
        } else if (guidHolder[i] === 'y') {
          r &= 0x3;
          r |= 0x8;
          guidResponse += hex[r];
        } else {
          guidResponse += guidHolder[i];
        }
      }
      return guidResponse;
    }
  }
}

