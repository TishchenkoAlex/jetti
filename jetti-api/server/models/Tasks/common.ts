export interface IQueueRow {
    type: string;
    status: number;
    doc?: string;
    exchangeCode?: string;
    exchangeBase?: string;
    date?: Date;
    id?: string;
}
