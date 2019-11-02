// tslint:disable:max-line-length
import * as Queue from 'bull';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { DocumentBase, Ref } from '../document';
import { RegisterAccumulationInventory } from '../Registers/Accumulation/Inventory';

export default async function (job: Queue.Job) {
  await job.progress(0);
  const params = job.data;
  const tx: MSSQL = job.data.tx;
  const doc = params.doc as DocumentBase;
  const oldInventory = params.Inventory[0] as RegisterAccumulationInventory[];
  const newInventory = params.Inventory[1] as RegisterAccumulationInventory[];
  const Inventory = [
    ...oldInventory.map(el => ({ date: el.date, batch: el.batch, company: el.company, SKU: el.SKU, Storehouse: el.Storehouse })),
    ...newInventory.map(el => ({ date: el.date, batch: el.batch, company: doc.company, SKU: el.SKU, Storehouse: el.Storehouse })),
  ];

  const query = `
    DECLARE @movementsTable TABLE (
      [date] DATE,
      [company] UNIQUEIDENTIFIER,
      [batch] UNIQUEIDENTIFIER,
      [Storehouse] UNIQUEIDENTIFIER,
      [SKU] UNIQUEIDENTIFIER
    );

    INSERT INTO @movementsTable
      SELECT *
      FROM OPENJSON(@p2) WITH (
        [date] DATE,
        [company] UNIQUEIDENTIFIER,
        [batch] UNIQUEIDENTIFIER,
        [Storehouse] UNIQUEIDENTIFIER,
        [SKU] UNIQUEIDENTIFIER
      );

    SELECT DISTINCT document from "Register.Accumulation.Inventory"
    WHERE (1=1)
      AND [Qty.Out] <> 0
        AND date >= (SELECT MIN([date]) FROM @movementsTable)
        AND company IN (SELECT [company] FROM @movementsTable)
        AND Storehouse IN (SELECT Storehouse FROM @movementsTable)
        AND SKU IN (SELECT SKU FROM @movementsTable)
        AND batch IN (SELECT batch FROM @movementsTable)
        AND document <> @p1`;
  const list = await tx.manyOrNone<{ document: Ref }>(query, [doc.id, JSON.stringify(Inventory)]);

  const TaskList: any[] = [];
  const count = list.length; let offset = 0;
  job.data.job['total'] = list.length;
  await job.update(job.data);
  while (offset < count) {
    let i = 0;
    for (i = 0; i < 5; i++) {
      if (!list[i + offset]) break;
      const q = lib.doc.postById(list[i + offset].document, tx);
      TaskList.push(q);
    }
    offset = offset + i;
    await Promise.all(TaskList);
    TaskList.length = 0;
    await job.progress(Math.round(offset / count * 100));
  }
  await job.progress(100);
}
