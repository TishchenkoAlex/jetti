import { MSSQL } from '../../mssql';
import { ServerDocument } from '../ServerDocument';
import { CatalogOperation } from './Catalog.Operation';

export class CatalogOperationServer extends CatalogOperation implements ServerDocument {

  async onCreate(tx: MSSQL) {
    this.script = `/*

// Account
Registers.Account.push({
    debit: { account: lib.account.byCode('50.01'), subcounts: [$.CashRegister, lib.doc.byCode('Catalog.CashFlow', 'IN.CUSTOMER', tx)] },
    kredit: { account: lib.account.byCode('62.01'), subcounts: [$.Customer] },
    sum: AmountInBalance
});

// Balance
Registers.Accumulation.push({
    kind: false,
    type: "Register.Accumulation.Balance",
    data: {
        Department: $.Department,
        Balance: lib.doc.byCode('Catalog.Balance', 'AR', tx),
        Analytics: $.Customer,
        Amount: AmountInBalance
    }
});

Registers.Accumulation.push({
    kind: true,
    type: "Register.Accumulation.Balance",
    data: {
        Department: $.Department,
        Balance: lib.doc.byCode('Catalog.Balance', 'CASH', tx),
        Analytics: $.CashRegister,
        Amount: AmountInBalance
    }
});

// PL
Registers.Accumulation.push({
    kind: true,
    type: "Register.Accumulation.PL",
    data: {
        Department: $.Department,
        PL: $.Expense,
        Analytics: $.Analytics,
        Amount: $.Amount,
    }
});

// Register.Accumulation.AR
Registers.Accumulation.push({
    kind: false,
    type: 'Register.Accumulation.AR',
    data: {
        AO: $.Invoice,
        Department: $.Department,
        Customer: $.Customer,
        AR: $.Amount,
        PayDay: doc.date,
        currency: $.currency,
        AmountInBalance
    }
});

// Register.Accumulation.AP
Registers.Accumulation.push({
    kind: false,
    type: 'Register.Accumulation.AP',
    data: {
        AO: $.Invoice,
        Department: $.Department,
        Customer: $.Customer,
        Amount: $.Amount,
        PayDay: doc.date,
        currency: $.currency,
        AmountInBalance
    }
});

// Register.Accumulation.Cash
Registers.Accumulation.push({
    kind: true,
    type: "Register.Accumulation.Cash",
    data: {
        Department: $.Department,
        CashRegister: $.CashRegister,
        CashFlow: $.CashFlow,
        Amount: $.Amount,
        AmountInBalance
    }
});

// Register.Accumulation.Bank
Registers.Accumulation.push({
    kind: true,
    type: "Register.Accumulation.Bank",
    data: {
        Department: $.Department,
        BankAccount: $.BankAccount,
        CashFlow: $.CashFlow,
        Amount: $.Amount,
        AmountInBalance
    }
});

// Cash Transit
Registers.Accumulation.push({
    kind: false,
    type: "Register.Accumulation.Cash.Transit",
    data: {
        Department: null,
        CashFlow: $.CashFlow,
        Sender: $.Sender,
        Recipient: $.Recipient,
        Amount: $.Amount,
        currency: $.currency,
        AmountInBalance
    }
});

// AccountablePersons
Registers.Accumulation.push({
    kind: false,
    type: "Register.Accumulation.AccountablePersons",
    data: {
        Department: $.Department,
        CashFlow: CashFlowRef,
        Employee: $.Employee,
        Amount: $.Amount / exchangeRate,
        currency: $.currency,
        AmountInBalance
    }
});

// LOAN
Registers.Accumulation.push({
    kind: false,
    type: "Register.Accumulation.Loan",
    data: {
        Department: $.Department,
        Loan: $.Loan,
        CashFlow: lib.doc.byCode('Catalog.CashFlow', 'IN.LOAN', tx),
        Counterpartie: $.Counterpartie,
        Amount: $.Amount,
        AmountInBalance
    }
});

// GOODS
// const avgSumma = lib.register.avgCost(doc.date, { company: doc.company, SKU: row.SKU, Storehouse: $.Storehouse }, tx) * row.Qty;
Registers.Accumulation.push({
  kind: true,
  type: "Register.Accumulation.Sales",
  data: {
      AO: $.id,
      Department: $.Department,
      Customer: $.Customer,
      Product: $.Product,
      Manager: $.Manager,
      Storehouse: $.Storehouse,
      Qty: $.Qty,
      Amount: $.Amount,
      Cost: avgSumma,
      Discount: 0,
      Tax: $.Tax,
      currency: $.currency
  }
});

Registers.Accumulation.push({
    kind: false,
    type: "Register.Accumulation.Inventory",
    data: {
        Storehouse: $.Storehouse,
        Expense: $.Expense,
        SKU: row.SKU,
        Cost: avgSumma,
        Qty: row.Qty
    }
});

*/`;
    return this;
  }
}
