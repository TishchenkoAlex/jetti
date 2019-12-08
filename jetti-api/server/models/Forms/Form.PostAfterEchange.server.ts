import { JQueue } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { PostAfterEchange } from './Form.PostAfterEchange';
import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { Ref } from '../document';

export default class PostAfterEchangeServer extends PostAfterEchange implements IServerForm {
  async Execute() {
    if (this.EndDate) this.EndDate.setHours(23, 59, 59, 999);
    const sdbq = new MSSQL(this.user, TASKS_POOL);
    const query = `
      SELECT company, COUNT(*) count
      FROM [dbo].[Documents]
      WHERE (1 = 1) ${this.StartDate ? ' AND date between @p2 AND @p3 ' : ``}
        ${this.Operation ? ` AND JSON_VALUE(doc, '$.Operation') = @p4 ` : ``}
        ${this.rePost ? `` : ` AND posted = 0 `} AND deleted = 0 and type LIKE 'Document.%' AND
        [ExchangeBase] IS NOT NULL AND
        company IS NOT NULL AND
        ( company IN (SELECT id FROM [dbo].[Documents] where type = 'Catalog.Company' AND parent = @p1) OR company = @p1)
      GROUP BY company
      HAVING COUNT(*) >0
      ORDER BY 2 DESC`;
    const companyList = await sdbq.manyOrNone<{ company: Ref, count: number }>(query, 
      [this.company, this.StartDate, this.EndDate, this.Operation]);

    for (const row of companyList) {
      const companyObject = await lib.doc.byIdT<CatalogCompany>(row.company, sdbq);
      const companyDescription = companyObject && companyObject.description;
      const data = {
        job: { id: `sync`, description: `[IIKO exchange for  ${companyDescription}]` },
        user: null,
        company: row.company,
        companyName: companyDescription,
        StartDate: this.StartDate,
        EndDate: this.EndDate,
        rePost: this.rePost,
        Operation: this.Operation
      };
      const activeJobs = await JQueue.getActive();
      const jobs = activeJobs.filter(j => j.data.job.id === `sync` && j.data.company === row.company);
      if (jobs.length === 0) await JQueue.add(data, { attempts: 3 });
    }
    return this;
  }
}
