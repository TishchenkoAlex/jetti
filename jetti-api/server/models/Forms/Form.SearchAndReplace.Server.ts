import { IServerForm } from './form.factory.server';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { Ref } from '../document';
import { FormSearchAndReplace } from './Form.SearchAndReplace';
import { TASKS_POOL } from '../../sql.pool.tasks';

export default class FormSearchAndReplaceServer extends FormSearchAndReplace implements IServerForm {

  async Execute() {
    return this;
  }

  async getExchangeData(id: string, tx: MSSQL): Promise<{ ExchangeCode: string, ExchangeBase: string } | null> {

    const sdbq = new MSSQL(TASKS_POOL, this.user);
    const query = `select ExchangeCode, ExchangeBase from dbo.[Documents] where id = @p1`;
    return await sdbq.oneOrNone<{ ExchangeCode: string, ExchangeBase: string } | null>(query, [id]);

  }
  // tslint:disable
  async Search() {



    if (!this.OldValue) throw new Error('Searched value is not defined');
    const sdbq = new MSSQL(TASKS_POOL, this.user);
    await this.FillExchangeData(sdbq);

    this.NewValueExchangeBase
    const query = `
      select  COUNT(id) Records
      ,type Type
      ,'Documents.doc' Source
      from Documents
      where contains(doc, @p1)
      GROUP BY type
    UNION
      select COUNT(id) Records
      ,type
      ,'Documents.company' source
      from Documents 
      where company = @p1
      GROUP BY type
      UNION 
    
      select COUNT(id) Records
      ,type
      
      ,'Accumulation.data' source
      from Accumulation 
      where contains(data, @p1)
      GROUP BY type
    
      UNION
    
      select COUNT(id) Records
      ,type
      
      ,'Accumulation.company' source
      from Accumulation 
      where company = @p1
      GROUP BY type
    
      UNION
    
      select COUNT(id) Records
      ,type
      
      ,'Accumulation.document' source
      from Accumulation 
      where document = @p1
      GROUP BY type
    
    UNION
    
      select COUNT(id) Records
      ,type
      
      ,'Register.Info.data' source
      from [Register.Info]
      where contains(data, @p1)
      GROUP BY type
    
    UNION
    
      select COUNT(id) Records
      ,type
      
      ,'Register.Info.company' source
      from [Register.Info]
      where company = @p1
      GROUP BY type
    
    UNION
    
      select COUNT(id) Records
      ,type
      ,'Register.Info.document' source
      from [Register.Info]
      where document = @p1
      GROUP BY type `;

    const searchRes = await sdbq.manyOrNone<{ Records: number, Type: string, Source: string }>(query, [this.OldValue]);
    this.SearchResult = [];
    for (const row of searchRes) {
      this.SearchResult.push({
        Records: row.Records,
        Type: row.Type,
        Source: row.Source
      });
    }

    return this;
  }

  async FillExchangeData(tx: MSSQL) {

    this.OldValueExchangeBase = '';
    this.OldValueExchangeCode = '';
    this.NewValueExchangeBase = '';
    this.NewValueExchangeCode = '';
    if (this.NewValue) {
      const ExchangeData = await this.getExchangeData(this.NewValue, tx);
      if (ExchangeData) {
        this.NewValueExchangeBase = ExchangeData.ExchangeBase;
        this.NewValueExchangeCode = ExchangeData.ExchangeCode;
      }
    }
    if (this.OldValue) {
      const ExchangeData = await this.getExchangeData(this.OldValue, tx);
      if (ExchangeData) {
        this.OldValueExchangeBase = ExchangeData.ExchangeBase;
        this.OldValueExchangeCode = ExchangeData.ExchangeCode;
      }
    }
  }

  async Replace() {
    const sdbq = new MSSQL(TASKS_POOL, this.user);
    this.user.isAdmin = true;
    await sdbq.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        this.ReplaceInTx(tx);
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    })
  }

  async ReplaceInTx(tx: MSSQL) {

    if (!this.OldValue) throw new Error('Old value is not defined');
    if (!this.NewValue) throw new Error('New value is not defined');
    if (this.NewValue === this.OldValue) throw new Error('Bad params: The new value cannot be equal to the old value');

    const NewValue = await lib.doc.byId(this.NewValue, tx);
    const OldValue = await lib.doc.byId(this.OldValue, tx);
    if (NewValue!.type !== OldValue!.type) throw new Error(`Bad params: The new value type ${NewValue!.type} mast be same type ${OldValue!.type} as old value`);

    let query = `
        declare @isCompany int = (SELECT COUNT(*) FROM Documents WHERE id = @p2 AND type = N'Catalog.Company')
        update documents set doc = REPLACE(doc, @p1, @p2), timestamp = getdate()
        where id in (select id from documents where contains(doc, @p1));
        RAISERROR('REPLACE DOC', 0 ,1) WITH NOWAIT;
        DROP TABLE IF EXISTS #Exchange;
        select ExchangeBase, ExchangeCode into #Exchange from Documents where id = @p1;
        RAISERROR('#Exchange', 0 ,1) WITH NOWAIT;
        IF (select ExchangeBase from #Exchange) <> ''
        BEGIN
            if ((select top 1 coalesce(d.ExchangeCode,'') from Documents d where d.id=@p2)='' or @p3=1)
            begin
                update documents set
                    ExchangeBase = (select ExchangeBase from #Exchange),
                    ExchangeCode = (select ExchangeCode from #Exchange)
                where id = @p2;
                RAISERROR('set ExchangeBase', 0 ,1) WITH NOWAIT;
                update documents set
                    ExchangeBase = null,
                    ExchangeCode = null
                where id = @p1;
                RAISERROR('clear ExchangeBase', 0 ,1) WITH NOWAIT;
            end
        END
        update CatalogMatching  set id = @p2 where id = @p1;
        RAISERROR('id', 0 ,1) WITH NOWAIT;
        if @isCompany > 0 update documents set company = @p2 where company = @p1;
        RAISERROR('company', 0 ,1) WITH NOWAIT;
        update documents set parent = @p2 where parent = @p1;
        RAISERROR('parent', 0 ,1) WITH NOWAIT;
        update documents set [user] = @p2 where [user] = @p1;
        RAISERROR('[user]', 0 ,1) WITH NOWAIT;
        update documents set deleted = 1, timestamp = getdate() where id = @p1 and deleted <> 1;
        RAISERROR('deleted', 0 ,1) WITH NOWAIT;
        update Accumulation set data = REPLACE(data, @p1, @p2)
        where id in (select id from Accumulation where contains(data, @p1));
        RAISERROR('REPLACE Accumulation', 0 ,1) WITH NOWAIT;
        if @isCompany > 0 update Accumulation set company = @p2 where company = @p1;
        RAISERROR('company', 0 ,1) WITH NOWAIT;
        update [Register.Info] set data = REPLACE(data, @p1, @p2)
        where id in (select id from [Register.Info] where contains(data, @p1));
        RAISERROR('REPLACE [Register.Info]', 0 ,1) WITH NOWAIT;
        if @isCompany > 0 update [Register.Info] set company = @p2 where company = @p1;
        RAISERROR('company', 0 ,1) WITH NOWAIT;`;

    await tx.none(query, [this.OldValue, this.NewValue, this.ReplaceExchangeCode]);
    return this;
  }
}
