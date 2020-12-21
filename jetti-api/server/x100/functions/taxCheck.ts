import { MSSQL } from './../../mssql';
import { lib } from '../../std.lib';
import { JETTI_POOL } from '../../sql.pool.jetti';
import { CatalogAttachment } from '../../models/Catalogs/Catalog.Attachment';
import { RegisterInfoTaxCheck } from '../../models/Registers/Info/TaxCheck';
import axios from 'axios';
import { Agent } from 'https';
import * as moment from 'moment';

export interface ITaxCheck {
    clientInn: string;
    inn: string;
    totalAmount: number;
    receiptId: string;
    operationTime: Date;
    URL?: string;
    operationId?: string;
}

export interface IUpdateOperationTaxCheckResponse {
    status: 'created' | 'updated' | 'exist' | 'error';
    operationId: string | null;
    info: string | null;
    counter?: null | number | undefined;
}

export const AttachmentType_taxCheck = '97B25D60-D171-11EA-8F9B-B93FB2CAD87D';
export const AttachmentType_apiHost = 'https://lknpd.nalog.ru/api/v1/receipt';

export async function findTaxCheckInRegisterInfo(taxCheck: ITaxCheck, tx: MSSQL): Promise<RegisterInfoTaxCheck | null> {
    const countTextTax = `
    USE sm
    SELECT COUNT(*) FROM [dbo].[Register.Info.TaxCheck]  where receiptId='' and inn=@p1
    `;

    const OperationCounterTax: any = await tx.oneOrNone<RegisterInfoTaxCheck>(countTextTax,
        [
            taxCheck.inn
        ]);
    const queryText = `
    SELECT *
    FROM [dbo].[Register.Info.TaxCheck]
    WHERE clientInn = @p1
        and inn = @p2
        and totalAmount = cast(@p3 as money)
        and [date] <= @p5
        and receiptId=''
        ${taxCheck.operationId ? 'and [document] = @p4' : ''}`;

    return await tx.oneOrNone<RegisterInfoTaxCheck>(queryText,
        [
            taxCheck.clientInn,
            taxCheck.inn,
            taxCheck.totalAmount.toString(),
            taxCheck.operationId,
            taxCheck.operationTime
        ]);
}

export async function findTaxCheckAttachmentsByOperationId(operId: string, tx: MSSQL): Promise<any[]> {
    const attach = await lib.util.getAttachmentsByOwner(operId, false, tx);
    return attach ? attach.filter(a => a.AttachmentType === AttachmentType_taxCheck) : [];
}

export async function saveTaxCheckAsAttachment(taxCheck: ITaxCheck, tx: MSSQL, attachmentId = ''): Promise<CatalogAttachment> {

    if (taxCheck.operationTime) taxCheck.operationTime = new Date(taxCheck.operationTime.toString());

    let attachment: CatalogAttachment;

    if (attachmentId) {
        attachment = await lib.doc.createDocServerById(attachmentId, tx) as CatalogAttachment;
    } else {
        if (taxCheck.operationId) {
            const attID = await findTaxCheckAttachmentsByOperationId(taxCheck.operationId, tx);
            if (attID.length) return saveTaxCheckAsAttachment(taxCheck, tx, attID[0].id);
        }
        attachment = await lib.doc.createDoc<CatalogAttachment>('Catalog.Attachment');
    }

    attachment.description = getTaxCheckDescription(taxCheck);
    attachment.Storage = getTaxCheckURL(taxCheck);
    attachment.AttachmentType = AttachmentType_taxCheck;
    attachment.owner = taxCheck.operationId as string;
    attachment.deleted = false;
    attachment.posted = true;

    const res = await lib.util.addAttachments([attachment], tx);
    return res[0];

}

export async function getTaxCheckFromURL(taxCheckURL: string): Promise<ITaxCheck> {

    // https://lknpd.nalog.ru/api/v1/receipt/598100160853/2001vsj3lh/json
    const host = taxCheckURL.replace('print', '');
    const instance = axios.create({ baseURL: host });
    const tcResp = await instance.get('json', { httpsAgent: new Agent({ rejectUnauthorized: false }) });
    if (tcResp.status !== 200) throw new Error(tcResp.statusText);
    return tcResp.data;
}

export async function updateOperationTaxCheck(taxCheck: ITaxCheck): Promise<IUpdateOperationTaxCheckResponse> {
    const countTextTax = `
    USE sm
    SELECT COUNT(*) FROM [dbo].[Register.Info.TaxCheck]  where receiptId='' and inn=@p1`;

    if (taxCheck.operationTime && typeof taxCheck.operationTime === 'string')
        taxCheck.operationTime = new Date(taxCheck.operationTime);

    const tx = new MSSQL(JETTI_POOL);
    const result: IUpdateOperationTaxCheckResponse = { status: 'created', operationId: null, info: null };
    const tc = await findTaxCheckInRegisterInfo(taxCheck, tx);


    const OperationCounterTax: any = await tx.oneOrNone<RegisterInfoTaxCheck>(countTextTax,
        [
            taxCheck.inn
        ]);
    let counter;
    const counterValue = OperationCounterTax[''];
    const computedValue = counterValue - 1;

    if (computedValue <= 0) {
        counter = 'У вас нет задолжностей по чекам.';
    } else {
        counter = `Количество не отправленных чеков: ${computedValue}`;
    }
    if (!tc) {
        result.status = 'error';
        result.info =
            `Не найден документ операции по реквизитам: ИНН плательщика ${taxCheck.inn}, ИНН получателя ${taxCheck.clientInn} на сумму ${taxCheck.totalAmount} ранне ${moment(taxCheck.operationTime).locale('ru').format('LLL')}!`;
        return result;
    }

    result.operationId = tc.document;
    if (tc.receiptId) {
        if (tc.receiptId !== taxCheck.receiptId) {
            result.status = 'updated';
            result.info = `Привязан к ${await lib.util.getObjectPropertyById(tc.document as string, 'description', tx)}' вместо чека №${tc.receiptId}`;
            result.counter = counter;
        } else if (tc.totalAmount === taxCheck.totalAmount) {
            result.status = 'exist';
            result.info = `Запись существует. Чек отражен документом ${await lib.util.getObjectPropertyById(tc.document as string, 'description', tx)}`;
            result.counter = counter;
            return result;
        }
    }

    const doc = await lib.doc.createDocServerById(tc.document as string, tx);
    if (!doc) {
        result.status = 'error';
        result.info = `Отсутстует документ с ID ${tc.document}`;

        return result;
    }

    doc['receiptId'] = taxCheck.receiptId;
    doc['operationTime'] = taxCheck.operationTime;
    taxCheck.operationId = doc.id;

    try {
        if (result.status === 'updated' || result.status === 'created') {
            await saveTaxCheckAsAttachment(taxCheck, tx);
        }
        await lib.doc.updateDoc(doc, tx);
        await lib.doc.unPostById(doc.id, tx);
        await lib.doc.postById(doc.id, tx);
    } catch (error) {
        result.status = 'error';
        result.info = `Ошибка при проведении документа ${doc.description}: \n ${error.message || ''}`;
        return result;
    }

    result.info = `Чек отражен документом ${await lib.util.getObjectPropertyById(tc.document as string, 'description', tx)}`;
    result.counter = counter;
    return result;

}

function getTaxCheckDescription(taxCheck: ITaxCheck): string {
    return `Чек ${taxCheck.receiptId} (${taxCheck.inn} => ${taxCheck.clientInn}) от ${lib.util.formatDate(taxCheck.operationTime)} на сумму ${taxCheck.totalAmount}`;
}

function getTaxCheckURL(taxCheck: ITaxCheck, urlType = 'print' || 'json'): string {
    if (taxCheck.URL) return taxCheck.URL;
    return `${AttachmentType_apiHost}/${taxCheck.inn}/${taxCheck.receiptId}/${urlType}`;
}
