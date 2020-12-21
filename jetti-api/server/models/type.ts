export class Type {

    public static isOperation(type: string) {
        return !!(type && type.startsWith('Operation.'));
    }

    public static isDocument(type: string) {
        return !!(type && (type.startsWith('Document.') || this.isOperation(type)));
    }

    public static isCatalog(type: string) {
        return !!(type && type.startsWith('Catalog.'));
    }

    public static isType(type: string) {
        return !!(type && type.startsWith('Types.'));
    }

    public static isJournal(type: string) {
        return !!(type && type.startsWith('Journal.'));
    }

    public static isForm(type: string) {
        return !!(type && type.startsWith('Form.'));
    }

    // stored types
    public static isRefType(type: string) {
        return this.isDocument(type) || this.isCatalog(type);
    }

}
