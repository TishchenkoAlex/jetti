ALTER trigger [dbo].[Catalogs -> Documents.Operation]
	on [dbo].[Documents]
	after update
as 
begin
	if (rowcount_big() = 0) return;

	set nocount on;

	declare @id uniqueidentifier, @description nvarchar(150);
	declare @rows table (id UNIQUEIDENTIFIER, description nvarchar(150));

	insert into @rows select id, description from inserted where type like 'Catalog.%';

	while exists (select * from @rows)
	begin
		select top 1 @id = id, @description = description from @rows order by id asc;
		
		update [documents.operation] set [parent.value] = @description where [parent.id] = @id and [parent.value] <> @description;
		update [documents.operation] set [f1.value] = @description where [f1.id] = @id and [f1.value] <> @description;
		update [documents.operation] set [f2.value] = @description where [f2.id] = @id and [f2.value] <> @description;
		update [documents.operation] set [f3.value] = @description where [f3.id] = @id and [f3.value] <> @description;

		update [documents.operation] set [company.value] = @description where [company.id] = @id and [company.value] <> @description;
		update [documents.operation] set [currency.value] = @description where [currency.id] = @id and [currency.value] <> @description;
		update [documents.operation] set [user.value] = @description where [user.id] = @id and [user.value] <> @description;
		update [documents.operation] set [group.value] = @description where [group.id] = @id and [group.value] <> @description;
		update [documents.operation] set [operation.value] = @description where [operation.id] = @id and [operation.value] <> @description;

		delete from @rows where id = @id;
	end
end