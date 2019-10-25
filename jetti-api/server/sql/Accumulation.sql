ALTER TRIGGER [dbo].[Accumulation.DELETE] ON [dbo].[Accumulation]
AFTER DELETE AS 
BEGIN 

DELETE FROM dbo."Register.Accumulation.AccountablePersons" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.AP" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.AR" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Balance" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Bank" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Cash" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Cash.Transit" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Inventory" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Loan" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.PL" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Sales" WHERE document IN (SELECT document from deleted);
DELETE FROM dbo."Register.Accumulation.Depreciation" WHERE document IN (SELECT document from deleted);

END;