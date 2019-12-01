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
    const sdbq = new MSSQL(this.user, TASKS_POOL);
    const companyList = await sdbq.manyOrNone<{ company: Ref, count: number }>(`
      SELECT company, COUNT(*) count
      FROM [dbo].[Documents]
      WHERE (1 = 1) AND
        posted = 0 and deleted = 0 and type LIKE 'Document.%' AND
        [ExchangeBase] IS NOT NULL AND
        company IS NOT NULL AND
        company IN (SELECT id FROM [dbo].[Documents] where type = 'Catalog.Company' AND parent = @p1)
      GROUP BY company
      HAVING COUNT(*) >0`, [this.company]);

    for (const row of companyList) {
      const companyObject = await lib.doc.byIdT<CatalogCompany>(row.company, sdbq);
      const companyDescription = companyObject && companyObject.description;
      const data = {
        job: { id: `sync`, description: `[IIKO exchange for  ${companyDescription}]` },
        user: null,
        company: row.company,
        companyName: companyDescription
      };
      const activeJobs = await JQueue.getActive();
      const jobs = activeJobs.filter(j => j.data.job.id === `sync` && j.data.company === row.company);
      // if (jobs.length) throw new Error(`job ${jobs[0].data.job.id} for ${companyDescription} is already running`);

      if (jobs.length === 0) await JQueue.add(data, { attempts: 0 });
    }
    return this;
  }
}
/* setTimeout(async () => {
console.log('start IIKO');
try {
  const process = new PostAfterEchangeServer();
  await process.Execute();
} catch (ex) { }
}, 1000 * 5);

setInterval(async () => {
  console.log('start IIKO');
  try {
    const process = new PostAfterEchangeServer();
    await process.Execute();
  } catch (ex) { }

}, 1000 * 600);
 */
