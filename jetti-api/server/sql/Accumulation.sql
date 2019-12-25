USE [sm]
GO
/****** Object:  Trigger [dbo].[Accumulation.DELETE]    Script Date: 12/25/2019 12:48:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[Accumulation.DELETE] ON [dbo].[Accumulation]
AFTER DELETE AS 
BEGIN 
	IF (ROWCOUNT_BIG() = 0) RETURN;
	DELETE FROM dbo."Register.Accumulation.AccountablePersons" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.AccountablePersons');
	DELETE FROM dbo."Register.Accumulation.AP" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.AP');
	DELETE FROM dbo."Register.Accumulation.AR"  WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.AR');
	DELETE FROM dbo."Register.Accumulation.Balance" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Balance');
	DELETE FROM dbo."Register.Accumulation.Bank" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Bank');
	DELETE FROM dbo."Register.Accumulation.Cash" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Cash');
	DELETE FROM dbo."Register.Accumulation.Cash.Transit" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Cash.Transit');
	DELETE FROM dbo."Register.Accumulation.Inventory" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Inventory');
	DELETE FROM dbo."Register.Accumulation.Loan" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Loan');
	DELETE FROM dbo."Register.Accumulation.PL" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.PL');
	DELETE FROM dbo."Register.Accumulation.Sales" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Sales');
	DELETE FROM dbo."Register.Accumulation.Depreciation" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.Depreciation');
	DELETE FROM dbo."Register.Accumulation.BudgetItemTurnover" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.BudgetItemTurnover');
	DELETE FROM dbo."Register.Accumulation.CashToPay" WHERE id IN (SELECT id from deleted where [type] = 'Register.Accumulation.CashToPay');
END;