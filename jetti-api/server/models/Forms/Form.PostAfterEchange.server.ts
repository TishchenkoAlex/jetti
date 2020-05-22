import { x100 } from './../../x100.lib';
import { JQueue, processId } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { PostAfterEchange } from './Form.PostAfterEchange';
import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { Ref } from '../document';

export default class PostAfterEchangeServer extends PostAfterEchange implements IServerForm {

  async AddDescendantsCompany(tx: MSSQL) {
    if (!this.company) throw new Error(`Empty company!`);
    if (this.EndDate) this.EndDate.setHours(23, 59, 59, 999);
    this.user.isAdmin = true;
    const descedants = await lib.doc.Descendants(this.company, new MSSQL(TASKS_POOL, this.user));
    if (!descedants) return;
    const query = `SELECT distinct company
    FROM dbo.[Register.Accumulation.Inventory]
    WHERE (1 = 1) ${this.StartDate ? ' AND date between @p2 AND @p3 ' : ``}
    AND company IN (${descedants.map(el => '\'' + el.id + '\'').join(',')})`;
    const companyItems = await x100.util.x100DataDB().manyOrNone<{ company: string }>(query, [this.company, this.StartDate, this.EndDate]);
    this.Companys = [...new Set([...this.Companys.map(e => e.company), ...companyItems.map(e => e.company)])]
      .map(e => ({ company: e }));
  }

  async Execute() {
    this.user.isAdmin = true;
    if (this.EndDate) this.EndDate.setHours(23, 59, 59, 999);
    const procId = processId();
    const sdbq = new MSSQL(TASKS_POOL, this.user);
    let query = `
      SELECT company, COUNT(*) count
      FROM [dbo].[Documents]
      WHERE (1 = 1) ${this.StartDate ? ' AND date between @p2 AND @p3 ' : ``}
        ${this.Operation ? ` AND JSON_VALUE(doc, '$.Operation') = @p4 ` : ``}
        ${this.rePost ? `` : ` AND posted = 0 `} AND deleted = 0 and type LIKE 'Document.%' AND
        -- [ExchangeBase] IS NOT NULL AND
        company IS NOT NULL AND
        company IN (SELECT id FROM dbo.[Descendants](@p1, ''))
      GROUP BY company
      HAVING COUNT(*) >0
      ORDER BY 2 DESC`;
    if (this.Companys.length)
      query = query.replace(`SELECT id FROM dbo.[Descendants](@p1, '')`
        , `${this.Companys.map(el => '\'' + el.company + '\'').join(',')}`);

    const companyList = await sdbq.manyOrNone<{ company: Ref, count: number }>(query,
      [this.company, this.StartDate, this.EndDate, this.Operation]);

    for (const row of companyList) {
      const companyObject = await lib.doc.byIdT<CatalogCompany>(row.company, sdbq);
      const companyDescription = companyObject && companyObject.description;
      const data = {
        job: { id: `sync`, description: `[IIKO exchange for  ${companyDescription}]` },
        user: this.user,
        company: row.company,
        companyName: companyDescription,
        StartDate: this.StartDate,
        EndDate: this.EndDate,
        rePost: this.rePost,
        Operation: this.Operation,
        processId: procId
      };
      const activeJobs = await JQueue.getActive();
      const jobs = activeJobs.filter(j => j.data.job.id === `sync` && j.data.company === row.company);
      if (jobs.length === 0) await JQueue.add(data, { attempts: 3, priority: 100 });
    }
    return this;
  }
}
