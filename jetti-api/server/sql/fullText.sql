DROP FULLTEXT INDEX ON [dbo].[Register.Info];
CREATE FULLTEXT INDEX ON [dbo].[Register.Info](data) KEY INDEX [Info_id_uindex] ON [jsonInfo];

DROP FULLTEXT INDEX ON [dbo].[Documents];
CREATE FULLTEXT INDEX ON [dbo].[Documents](doc) KEY INDEX [Documents_id_pk] ON [jsonDocuments];

DROP FULLTEXT INDEX ON [dbo].[Accumulation];
CREATE FULLTEXT INDEX ON  [dbo].[Accumulation](data) KEY INDEX [Accumulation_id_uindex] ON [jsonAccumulation];