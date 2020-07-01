import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';

import { SQLPool } from '../sql/sql-pool';
import { ISyncParams, saveLogProtocol, exchangeManyOrNone, GetSqlConfig, GetExchangeCatalogID } from './iiko-to-jetti-connection';
import { DateToString, GetCatalog, InsertCatalog, UpdateCatalog, nullOrID, Ref, InsertDocument, GetDocument, UpdateDocument } from './iiko-to-jetti-utils';
import { dateReviverUTC } from '../fuctions/dateReviver';

///////////////////////////////////////////////////////////
const syncStage = 'Document.Order';
///////////////////////////////////////////////////////////
interface IiikoOrder {
  project: string;
  id: string;
  baseid: string;
  type: string;
  orderNum: string;
  date: Date;
}
///////////////////////////////////////////////////////////
const transformOrder = (syncParams: ISyncParams, source: any): IiikoOrder => {
  return {
    project: syncParams.project.id,
    id: source.orderId,
    baseid: syncParams.source.id,
    type: 'OrderDoc',
    orderNum: source.orderNum,
    date: source.date
  };
};
///////////////////////////////////////////////////////////
const newOrder = (): any => {
  return {
    id: uuidv1().toUpperCase(),
    type: 'Document.Operation',
    code: '',
    description: '',
    posted: 0,
    deleted: 0,
    doc: {
      Group: '',
      Operation: '',
      Amount: 0.0,
      currency: '',
      f1: '',
      f2: '',
      f3: '',
      Customer: '',
      Manager: '',
      NumCashShift: '',
      Department: '',
      Storehouse: '',
      PayCash: 0,
      PayCard: 0,
      PayAggregator: 0,
      PayKupon: 0,
      DeliveryType: '',
      OrderSource: '',
      RetailClient: '',
      BillTime: '',
      CloseTime: '',
      ItemsInventory: [],
      ItemsPay: []
    },
    parent: null,
    isfolder: false,
    company: '',
    user: null,
    info: null
  };
};
///////////////////////////////////////////////////////////
async function syncSalesSQL(syncParams: ISyncParams, iikoDoc: any, sourceSQL: SQLClient, destSQL: SQLClient): Promise<any> {
  // орбработка документов продаж по кассовой смене
  const startd: number = Date.now();
  if (syncParams.logLevel > 1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Session ${iikoDoc.id} ${iikoDoc.dateIncoming.toString()} #${iikoDoc.documentNumber}`);
  const Group = '5B7E85A4-BA99-11E7-BB80-DF3C32C3B9C9';
  let Operation = '58FA3C90-DEA7-11E9-8D32-67D574707955';

  const store: any = await GetCatalog(syncParams.project.id, iikoDoc.store, syncParams.source.id, 'Storehouse', destSQL); // склад
  const company: any = await destSQL.oneOrNone(`select cast(dbo.CompanyOnDate(@p1, @p2) as nvarchar(50)) as id;`,
    [iikoDoc.dateIncoming, store.doc.Department]); // организация
  const typeFranchise: any = await destSQL.oneOrNone(`select dbo.FranchiseOnDate(@p1, @p2) as tf `,
    [iikoDoc.dateIncoming, store.doc.Department]); // тип франшизы
  if (typeFranchise.tf === 'Classic franchise') Operation = '42C3BE10-1831-11EA-822C-15390275940A'; // другая операция по франшизе
  const customer: any = await destSQL.oneOrNone(`SELECT id FROM [dbo].[Catalog.Counterpartie.v] WITH (NOEXPAND) where [Department] = @p1 and [Client]='true' `, [store.doc.Department]); // розничный покупатель
  const company2: any = await destSQL.oneOrNone(`select cast(dbo.Company2OnDate(@p1, @p2) as nvarchar(50)) as id;`,
    [iikoDoc.dateIncoming, store.doc.Department]); // организация-2

  let docAcquiringTerminal2: Ref = null;
  let docBankAccount2: Ref = null;
  let docAcquier2: Ref = null;
  if (!company2 === null) {
    const params2: any = await destSQL.oneOrNone(`
      SELECT top 1 [id] as AcquiringTerminal2, [BankAccount] as BankAccount2, [Counterpartie] as Acquier2
      FROM [dbo].[Catalog.AcquiringTerminal.v] WITH (NOEXPAND)
      WHERE [Department] = @p1 and [company] = @p2
      order by [isDefault] desc, [code]`, [store.doc.Department, company2.id]); // параметры по организация2
    if (!params2 === null) {
      docAcquiringTerminal2 = params2.AcquiringTerminal2;
      docBankAccount2 = params2.BankAccount2;
      docAcquier2 = params2.Acquier2;
    }
    if (docAcquier2 === null) docAcquier2 = customer.id;
  }
  // заказы
  const Orders: any = await sourceSQL.manyOrNone(`
    select
      cast(i.orderId as nvarchar(50)) as [orderId],
      cast(p.orderNum as nvarchar(50)) as [orderNum],
      cast(p.cashier as nvarchar(50)) as [cashier],
      p.date as [date],
      p.openTime as [openTime],
      p.closeTime as [closeTime],
      cast(p.isDelivery as int) as [isDelivery],
      coalesce(cast(p.originName as nvarchar(50)), '') as [originName],
      coalesce(cast(p.orderType as nvarchar(50)), '') as [orderType]
    from
    ( SELECT DISTINCT ise.orderId
      from dbo.ItemSaleEvent ise
      where ise.session_id = @p1 and ise.deletedWithWriteoff=2 and ise.writeoffpaymenttype is null) as i
    left join dbo.OrderPaymentEvent p on p.[order] = i.orderId
    -- where i.orderId = '117C419C-34D3-40A4-A65A-02BC88F63E2B'
    `, [iikoDoc.id]);
  // позиции
  const pos: any = await sourceSQL.manyOrNone(`
    SELECT
      cast(ise.orderId as nvarchar(50)) as orderId,
      cast(ise.dishInfo as nvarchar(50)) as SKU,
      ise.openTime as openTime,
      ise.deliverTime as deliverTime,
      ise.printTime as printTime,
      ise.dishAmount as Qty,
      ise.dishPrice as Price,
      ise.dishSum as Amount,
      ise.discount as QtyAcc,
      ise.dishDiscountSum as QtyFact
    FROM dbo.ItemSaleEvent ise
    where ise.session_id = @p1
    and ise.deletedWithWriteoff=2 and ise.writeoffpaymenttype is null `, [iikoDoc.id]);
  // оплаты
  const cash: any = await sourceSQL.manyOrNone(`
    select
      z.ID1 as orderId,
      z.SKU as paymentType,
      z.SKU2 as isPrepay,
      cast(sum(z.sum) as numeric(19,9)) as Amount
    from (
      select
        cast(a.orderId as nvarchar(50)) as ID1,
        cast(a.paymentType as nvarchar(50)) as SKU,
        case when ((select COUNT(*) from dbo.AccountingTransaction a1 where a1.orderId=a.orderId and a1.session_id<>a.session_id and cast(a1.date as date)<>cast(a.date as date))=0) then '0' else '1' end as SKU2,
        a.sum as sum
      from dbo.AccountingTransaction a
      where a.session_id = @p1
      and not a.orderId is null
      and a.from_account = 'E1B8F656-2C58-244C-6921-5650DCA017EB') as z
    group by z.ID1, z.SKU, z.SKU2 `, [iikoDoc.id]);
  // удаленные заказы
  const delOrder: any = await sourceSQL.manyOrNone(`
    select DISTINCT
      cast(ise.orderId as nvarchar(50)) as orderId,
      ise.date as [date]
    from dbo.ItemSaleEvent ise
    where ise.session_id = @p1
      and not ise.orderId in (select DISTINCT i.orderId from dbo.ItemSaleEvent i where i.session_id = ise.session_id
        and i.deletedWithWriteoff=2 and i.writeoffpaymenttype is null) `, [iikoDoc.id]);
  // доставка
  const delivery: any = await sourceSQL.manyOrNone(`
    select
      cast(i.orderId as nvarchar(50)) as orderId,
      cast(p.orderNum as nvarchar(50)) as orderNum,
      cast(p.orderType as nvarchar(50)) as orderType,
      d.billTime as billTime,
      d.closeTime as closeTime,
      cast(p.isDelivery as int) as isDelivery,
      cast(d.customerId as nvarchar(50)) as customerId,
      cast(d.sourceKey as nvarchar(50)) as sourceKey
    from
      (SELECT DISTINCT ise.orderId
      from dbo.ItemSaleEvent ise
      where ise.session_id = @p1
      and ise.deletedWithWriteoff=2 and ise.writeoffpaymenttype is null) as i
    left join dbo.OrderPaymentEvent p on p.[order] = i.orderId
    left join dbo.Delivery d on d.orderId = i.orderId `, [iikoDoc.id]);
  // кассы
  const CashRegister: any = await destSQL.oneOrNone(`SELECT top 1 d.id FROM [dbo].[Catalog.CashRegister.v] d WITH (NOEXPAND)
    where d.[Department] = @p1 and d.[currency] = @p2 and cast(d.[isAccounting] as bit) = 1 and d.[company] = @p3 ORDER by d.deleted`,
    [store.doc.Department, syncParams.source.currency, company.id]);
  let CashRegister2: any = await destSQL.oneOrNone(`SELECT top 1 d.id FROM [dbo].[Catalog.CashRegister.v] d WITH (NOEXPAND)
    where d.[Department] = @p1 and d.[currency] = @p2 and cast(d.[isAccounting] as bit) = 0 and d.[company] = @p3 ORDER by d.deleted`,
    [store.doc.Department, syncParams.source.currency, company.id]);
  if (syncParams.source.id === 'Poland') CashRegister2 = CashRegister;
  // экв. терминал
  const AcquiringTerminal: any = await destSQL.oneOrNone(`SELECT top 1 d.[id], d.[BankAccount], d.[Counterpartie] as Acquier
    FROM [dbo].[Catalog.AcquiringTerminal.v] d WITH (NOEXPAND)
    where d.[Department] = @p1 and d.[company] = @p2  order by d.[isDefault] desc, d.[code]`, [store.doc.Department, company.id]);
  let docAcquier: Ref = null;
  let docBankAccount: Ref = null;
  let docAcquiringTerminal: Ref = null;
  if (!(AcquiringTerminal === null)) {
    docAcquiringTerminal = nullOrID(AcquiringTerminal);
    docBankAccount = AcquiringTerminal.BankAccount;
    docAcquier = AcquiringTerminal.Acquier;
  }
  if (docAcquier === null) docAcquier = nullOrID(customer);
  //
  // обработка заказов
  //
  let icnt = 0; let ucnt = 0; let dcnt = 0;
  for (const ord of Orders) {
    const iikoOrder: IiikoOrder = transformOrder(syncParams, ord);
    let posz = pos.filter(p => p.orderId === ord.orderId);
    // сопоставление по SKU
    posz = await exchangeManyOrNone(`
      SELECT
        (SELECT top 1 [id] FROM dbo.catalog c where [project]=@p1 and [exchangeCode]=p.[SKU] and [exchangeBase]=@p2 and [exchangeType] = 'Product') as [SKU],
        p.[Qty],
        p.[Price],
        p.[Amount] as [AmountFull],
        p.[QtyAcc] as [Discount],
        p.[QtyFact] as [AmountDiscount],
        p.[openTime] as [TimeStart],
        p.[deliverTime] as [TimeFeed],
        p.[printTime] as [TimePrint]
      FROM OPENJSON(@p3) WITH (
        [SKU] UNIQUEIDENTIFIER,
        [openTime] DATETIME,
        [deliverTime] DATETIME,
        [printTime] DATETIME,
        [Qty] money,
        [Price] money,
        [Amount] money,
        [QtyAcc] money,
        [QtyFact] money) as p
    `, [syncParams.project.id, syncParams.source.id, JSON.stringify(posz)]);
    // исключим из продаж модификаторы по нулевой цене
    posz = await destSQL.manyOrNone(`
      SELECT
        p.[SKU],
        p.[Qty],
        p.[Price],
        p.[AmountFull],
        p.[Discount],
        p.[AmountDiscount],
        p.[TimeStart],
        p.[TimeFeed],
        p.[TimePrint]
      FROM OPENJSON(@p1) WITH (
        [SKU] UNIQUEIDENTIFIER,
        [TimeStart] DATETIME,
        [TimeFeed] DATETIME,
        [TimePrint] DATETIME,
        [Qty] money,
        [Price] money,
        [AmountFull] money,
        [Discount] money,
        [AmountDiscount] money) as p
      LEFT JOIN [dbo].[Catalog.Product.v] c on c.[id]=p.[SKU] --WITH (NOEXPAND)
      left join [dbo].[Catalog.ProductKind.v] k on k.[id]=c.[ProductKind]
      where not c.[id] is null
      and (k.[code]<>N'MODIFIER' or (k.[code]=N'MODIFIER' and abs(p.[AmountFull])>=0.005))
    `, [JSON.stringify(posz)]);
    const nposz = posz.filter(p => p.Qty < 0);
    if (nposz.length > 0) {
      // есть позиции с отрицательным количеством - сворачиваем
      posz = await destSQL.manyOrNone(`
        SELECT
          p.[SKU],
          sum(p.[Qty]) as [Qty],
          max(p.[Price]) as [Price],
          sum(p.[AmountFull]) as [AmountFull],
          max(p.[Discount]) as [Discount],
          sum(p.[AmountDiscount]) as [AmountDiscount],
          min(p.[TimeStart]) as [TimeStart],
          min(p.[TimeFeed]) as [TimeFeed],
          min(p.[TimePrint]) as [TimePrint]
        FROM OPENJSON(@p1) WITH (
          [SKU] UNIQUEIDENTIFIER,
          [TimeStart] DATETIME,
          [TimeFeed] DATETIME,
          [TimePrint] DATETIME,
          [Qty] money,
          [Price] money,
          [AmountFull] money,
          [Discount] money,
          [AmountDiscount] money) as p
        group by p.[SKU]
      `, [JSON.stringify(posz)]);
      console.log(posz);
    }
    let deletedz = 0;
    if (posz.length === 0) deletedz = 1;
    // оплаты
    let cashz = cash.filter(p => p.orderId === ord.orderId);
    // пишем документ по времени в 13:00
    const datez: Date = ord.date;
    datez.setUTCHours(13); datez.setMinutes(0); datez.setSeconds(0);
    const codez = syncParams.source.code + '-' + ord.orderNum;
    const descriptionz: any = await destSQL.oneOrNone(`
      SELECT N'Operation ('+d.description+N') #'+@p1+N', '+convert(nvarchar(30), @p2, 127) as dsc FROM [dbo].[Catalog.Operation.v] d WITH (NOEXPAND) where d.[id] = @p3 `,
      [codez, datez.toJSON(), Operation]);
    const managerz: any = await GetCatalog(syncParams.project.id, ord.cashier, syncParams.source.id, 'Manager', destSQL); // кассир
    // обработка дополнительных параметров PaymentTypeAdd
    const tabPayAdd: any = []; // !!! let
    // !!! пока убрал !!!
    /*
    if (syncParams.source.id=='Poland' && ord.orderType != '') {
      tabPayAdd = await exchangeManyOrNone(`select cm.ExchangeCode, cm.addAnalytics, cast(cm.id as nvarchar(50)) as id from dbo.Catalog cm
        where cm.ExchangeBase = @p1 and cm.ExchangeType='PaymentTypeAdd' and coalesce(cm.addType,'')=@p2
      `,[syncParams.source.id, ord.orderType]);

    } else if (syncParams.source.id=='Russia' && ord.originName != '') {
      tabPayAdd = await exchangeManyOrNone(`select cm.ExchangeCode, cm.addAnalytics, cast(cm.id as nvarchar(50)) as id from dbo.Catalog cm
        where cm.ExchangeBase = @p1 and cm.ExchangeType='PaymentTypeAdd' and coalesce(cm.addType,'')=@p2
        `,[syncParams.source.id, ord.orderType]);
    }
    console.log(JSON.stringify(tabPayAdd)); */
    // оплаты по заказу
    cashz = await exchangeManyOrNone(`
      SELECT
        case when(COALESCE(p.[isPrepay],'0')='1') then N'PREPAY' WHEN(a.[addAnalytics] is NULL) then c.addAnalytics else a.[addAnalytics] end as TypePay,
        case WHEN(a.[addAnalytics] is NULL and (c.addAnalytics like 'CASH%')) then @p1
             WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'BANK' or c.addAnalytics = 'ONLINE')) then @p2
             WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'BANK2')) then @p3
             WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] like 'CASH%')) then @p1
             WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] = 'BANK' or a.[addAnalytics] = 'ONLINE')) then @p2
             WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] = 'BANK2')) then @p3
             ELSE cast(a.[id] as nvarchar(50))
        end as Client,
        p.[Amount] as AmountPay,
        case WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'BANK' or c.addAnalytics = 'ONLINE')) then @p4
             WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'BANK2')) then @p5
             WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] = 'BANK' or a.[addAnalytics] = 'ONLINE')) then @p4
             WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] = 'BANK2')) then @p5
             ELSE null
        end as BankAccount,
        case  WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'CASH')) then @p6
            WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'CASH2' or c.addAnalytics = 'AGGR2')) then @p7
            WHEN(not a.[addAnalytics] is NULL and (a.addAnalytics = 'CASH')) then @p6
            WHEN(not a.[addAnalytics] is NULL and (a.addAnalytics = 'CASH2' or a.addAnalytics = 'AGGR2')) then @p7
              ELSE null
        end as CashRegister,
        case  WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'BANK' or c.addAnalytics = 'ONLINE')) then @p8
            WHEN(a.[addAnalytics] is NULL and (c.addAnalytics = 'BANK2')) then @p9
            WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] = 'BANK' or a.[addAnalytics] = 'ONLINE')) then @p8
            WHEN(not a.[addAnalytics] is NULL and (a.[addAnalytics] = 'BANK2')) then @p9
              ELSE null
        end as AcquiringTerminal
      FROM OPENJSON(@p10) WITH (
        [paymentType] UNIQUEIDENTIFIER,
        [isPrepay] nvarchar(1),
        [Amount] money) as p
      left join dbo.[catalog] c on c.exchangeCode=p.[paymentType] and c.exchangeBase='Russia' and c.exchangeType='PaymentType'
      left join OPENJSON(@p11) WITH (
        [ExchangeCode] UNIQUEIDENTIFIER,
        [addAnalytics] NVARCHAR(50),
        [id] UNIQUEIDENTIFIER) as a on a.[ExchangeCode]=p.paymentType
    `, [customer.id, docAcquier, docAcquier2, docBankAccount, docBankAccount2, nullOrID(CashRegister), nullOrID(CashRegister2),
      docAcquiringTerminal, docAcquiringTerminal2, JSON.stringify(cashz), JSON.stringify(tabPayAdd)]);
    // итоговые суммы оплат
    const Amount: any = await destSQL.oneOrNone(`
      select
        sum(COALESCE(i.PayCash,0)) as PayCash,
        sum(COALESCE(i.PayCard,0)) as PayCard,
        sum(COALESCE(i.PayAggregator,0)) as PayAggregator,
        sum(COALESCE(i.PayKupon,0)) as PayKupon,
        sum(COALESCE(i.Amount,0)) as Amount
      from
      (SELECT
        CASE when (p.[TypePay] like 'CASH%') then p.[AmountPay] else 0 end as PayCash,
        CASE when (p.[TypePay] like 'BANK%' or p.[TypePay]='ONLINE') then p.[AmountPay] else 0 end as PayCard,
        CASE when (p.[TypePay] like 'AGGR%') then p.[AmountPay] else 0 end as PayAggregator,
        CASE when (p.[TypePay] = 'KUP') then p.[AmountPay] else 0 end as PayKupon,
        p.[AmountPay] as Amount
      FROM OPENJSON(@p1) WITH (
        [TypePay] nvarchar(50),
        [Client] nvarchar(50),
        [AmountPay] MONEY,
        [BankAccount] nvarchar(50),
        [CashRegister] nvarchar(50),
        [AcquiringTerminal] nvarchar(50)) as p) as i`, [JSON.stringify(cashz)]);
    // доставка
    let docDeliveryType: Ref = null;
    let docbillTime: Ref = null;
    let docCloseTime: Ref = null;
    let docRetailClient: Ref = null;
    let docOrderSource: Ref = null;
    let isDelivery = 0;
    let deliveryz: any = delivery.filter(p => p.orderId === ord.orderId);
    if (deliveryz.length > 0) {
      deliveryz = await exchangeManyOrNone(`
        select top 1 coalesce(cm.addAnalytics,'') as DeliveryType, d.[billTime] as billTime, d.[closeTime] as CloseTime,
          d.[customerId] as RetailClient, d.[sourceKey] as OrderSource, d.[isDelivery] as isDelivery
        FROM OPENJSON(@p1) WITH (
          [orderId] uniqueidentifier,
          [orderNum] nvarchar(50),
          [orderType] nvarchar(50),
          [billTime] datetime,
          [closeTime] datetime,
          [isDelivery] money,
          [customerId] nvarchar(50),
          [sourceKey] nvarchar(50)) as d
        left join dbo.[Catalog] cm on cm.ExchangeCode=d.orderType and cm.ExchangeBase='Russia' and cm.ExchangeType='OrderType'
      `, [JSON.stringify(deliveryz)]);
      docDeliveryType = deliveryz[0].DeliveryType;
      docbillTime = deliveryz[0].billTime;
      docCloseTime = deliveryz[0].CloseTime;
      docRetailClient = deliveryz[0].RetailClient;
      docOrderSource = deliveryz[0].OrderSource;
      isDelivery = deliveryz[0].isDelivery;
    }
    if (Amount.PayAggregator > 0 && isDelivery === 0) docDeliveryType = 'EXTERNAL';
    if (docDeliveryType === null) docDeliveryType = 'RESTAURANT';
    // заполняем документ
    let isNewDoc: Boolean = false;
    let NoSqlDocument: any = await GetDocument(iikoOrder.project, iikoOrder.id, iikoOrder.baseid, iikoOrder.type, destSQL);
    if (!NoSqlDocument) {
      isNewDoc = true;
      if (syncParams.logLevel > 2) {
        await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Order ${ord.orderId} #${ord.orderNum} insert`);
      }
      NoSqlDocument = newOrder();
      icnt++;
    } else {
      if (syncParams.logLevel > 2) {
        await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Order ${ord.orderId} #${ord.orderNum} update`);
      }
      ucnt++;
    }
    NoSqlDocument.type = 'Document.Operation';
    NoSqlDocument.date = datez;
    NoSqlDocument.code = codez;
    NoSqlDocument.description = descriptionz.dsc;
    NoSqlDocument.posted = 0;
    NoSqlDocument.deleted = deletedz;
    NoSqlDocument.doc.Group = Group;
    NoSqlDocument.doc.Operation = Operation;
    NoSqlDocument.doc.Amount = Amount.Amount;
    NoSqlDocument.doc.currency = syncParams.source.currency;
    NoSqlDocument.doc.f1 = customer.id;
    NoSqlDocument.doc.f2 = managerz.id;
    NoSqlDocument.doc.f3 = store.doc.Department;
    NoSqlDocument.doc.Customer = customer.id;
    NoSqlDocument.doc.Manager = managerz.id;
    NoSqlDocument.doc.NumCashShift = iikoDoc.documentNumber;
    NoSqlDocument.doc.Department = store.doc.Department;
    NoSqlDocument.doc.Storehouse = store.id;
    NoSqlDocument.doc.PayCash = Amount.PayCash;
    NoSqlDocument.doc.PayCard = Amount.PayCard;
    NoSqlDocument.doc.PayAggregator = Amount.PayAggregator;
    NoSqlDocument.doc.PayKupon = Amount.PayKupon;
    NoSqlDocument.doc.DeliveryType = docDeliveryType;
    NoSqlDocument.doc.OrderSource = docOrderSource;
    NoSqlDocument.doc.RetailClient = docRetailClient;
    NoSqlDocument.doc.BillTime = docbillTime;
    NoSqlDocument.doc.CloseTime = docCloseTime;
    NoSqlDocument.doc.ItemsInventory = posz;
    NoSqlDocument.doc.ItemsPay = cashz;
    NoSqlDocument.parent = null;
    NoSqlDocument.isfolder = false;
    NoSqlDocument.company = company.id;
    NoSqlDocument.user = null;
    NoSqlDocument.info = null;
    // JSON.stringify(posz) JSON.stringify(cashz)
    // console.log(NoSqlDocument);
    const jsonDoc = JSON.stringify(NoSqlDocument);
    if (isNewDoc) await InsertDocument(jsonDoc, NoSqlDocument.id, iikoOrder, destSQL);
    else await UpdateDocument(jsonDoc, NoSqlDocument.id, destSQL);
    // !!! if (@setQueue=1) insert into [sm].exc.QueuePost (id, company, flow)
    // !!! select @docid, @Company, @defFlow; -- очерерь проведения документов
  }
  // обработка удаленных заказов
  for (const delord of delOrder) {
    const NoSqlDocument: any = await GetDocument(syncParams.project.id, delord.orderId, syncParams.source.id, 'OrderDoc', destSQL);
    if (NoSqlDocument) {
      if (!NoSqlDocument.deleted) {
        console.log('нужно удалить', NoSqlDocument.deleted);
        dcnt++;
      }
    }
  }
  // протокол
  const endd: number = Date.now();
  if (syncParams.logLevel > 1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage,
    `Session #${iikoDoc.documentNumber} orders: insert ${icnt}, update ${ucnt}, delete ${dcnt}. Processing time ${(endd - startd) / 1000} s.`);
}

export async function ImportSalesToJetti(syncParams: ISyncParams, docList: any[] = []) {
  await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Start sync Sales Documents`);
  if (syncParams.baseType === 'sql') await ImportSalesSQLToJetti(syncParams, docList);
}

export async function ImportSalesSQLToJetti(syncParams: ISyncParams, docList: any[] = []) {

  const ssqlcfg = await GetSqlConfig(syncParams.source.id);
  const ssql = new SQLClient(new SQLPool(ssqlcfg));
  const dsql = new SQLClient(new SQLPool(await GetSqlConfig(syncParams.destination)));

  let i = 0;
  // условия к выборке
  let sw = '';
  if (docList.length === 0) {
    // выборка по интервалу дат
    sw = ` where ( cast(pr.dateIncoming as DATE) between '${DateToString(syncParams.periodBegin)}' and '${DateToString(syncParams.periodEnd)}' `;
    if (syncParams.execFlag === 126 && syncParams.autosync) {
      sw += ` or (cast(pr.dateIncoming as DATE) >= '${DateToString(syncParams.firstDate)}' and cast(pr.dateIncoming as DATE) < '${DateToString(syncParams.periodBegin)}' and pr.dateModified >= '${DateToString(syncParams.lastSyncDate)}' )) `;
    } else sw += ') ';
    if (syncParams.exchangeID === null) {
      if (syncParams.source.exchangeStores.length > 0) {
        // ограничение по списку складов
        sw += ` and pr.defaultStore in (`;
        i = 0;
        for (const store of syncParams.source.exchangeStores) {
          i++;
          if (i === 1) sw += `'${store}'`;
          else sw += `, '${store}'`;
        }
        sw += ') ';
      }
    } else {
      sw += ` and pr.defaultStore = '${syncParams.exchangeID}' `;
    }
  } else {
    // выборка по списку документов
    i = 0;
    for (const d of docList) {
      i++;
      if (i === 1) sw = ` where pr.sessionid in ('${d}'`;
      else sw += `, '${d}'`;
    }
    sw += ') ';
  }

  const sql = `
    SELECT DISTINCT
      cast(pr.sessionid as varchar(38)) as id,
      cast(pr.comment as nvarchar(255)) as comment,
      cast(pr.conception as nvarchar(50)) as conception,
      pr.dateIncoming,
      cast((select top 1 u.session_number from UserActionEvent u where u.dtype='CSE' and u.session_id=pr.sessionId) as nvarchar(19)) as documentNumber,
      pr.status,
      cast(pr.defaultStore as nvarchar(50)) as store,
      cast(pr.accountTo as nvarchar(50)) as account,
      cast(pr.revision as nvarchar(50)) as revision,
      pr.dateModified,
      cast(pr.userModified as nvarchar(50)) as userModified
    FROM dbo.salesdocument pr
    ${sw}
      and pr.status=1
      and not pr.sessionid is null
      order by pr.dateIncoming `;
  // console.log(sql);
  i = 0;
  let batch: any[] = [];
  const response = await ssql.manyOrNoneStream(sql, [],
    async (row: ColumnValue[], req: Request) => {
      i++;
      const rawDoc: any = {};
      row.forEach(col => rawDoc[col.metadata.colName] = col.value);
      batch.push(rawDoc);
      if (batch.length === ssqlcfg.batch.max) {
        req.pause();
        if (syncParams.logLevel > 1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `inserting to batch ${i} Sales docs`);
        for (const doc of batch) await syncSalesSQL(syncParams, doc, ssql, dsql);
        batch = [];
        req.resume();
      }
    },
    async (rowCount: number, more: boolean) => {
      if (rowCount && !more && batch.length > 0) {
        if (syncParams.logLevel > 1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `inserting tail ${batch.length} Sales docs`);
        for (const doc of batch) await syncSalesSQL(syncParams, doc, ssql, dsql);
      }
      await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Finish sync Sales Docs`);

    }
  );


}

