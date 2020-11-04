USE [sm]
GO
/****** Object:  UserDefinedFunction [dbo].[Distribution.Salary.Person.FIFO.Function]    Script Date: 03.11.2020 10:29:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[Distribution.Salary.Person.FIFO.Function](@EndDate date, @Currency uniqueidentifier, @Person uniqueidentifier, @Amount money, @CompanyParent uniqueidentifier, @DocId uniqueidentifier)

RETURNS @result TABLE ([MaxDate] date, [Company] uniqueidentifier, [Currency] uniqueidentifier, [Department] uniqueidentifier, [Person] uniqueidentifier, [Amount] money)

AS
BEGIN
	DECLARE @ResultFIFO AS table ([MaxDate] date, [Company] uniqueidentifier, [Currency] uniqueidentifier, [Department] uniqueidentifier, [Person] uniqueidentifier, [Amount] money, [Processed] bit);
	DECLARE @SortBC AS table ([MaxDate] date, [Company] uniqueidentifier, [Currency] uniqueidentifier, [Department] uniqueidentifier, [Person] uniqueidentifier, [Amount] money, [Processed] bit);

	INSERT INTO @SortBC
	SELECT max(RegSalary.[date]) as MaxDate
		  ,RegSalary.company as Company
		  ,RegSalary.[currency] as Currency
		  ,COALESCE(RegSalary.[Department], '00000000-0000-0000-0000-000000000000') as Department
		  ,RegSalary.[Person] as Person
		  ,SUM(RegSalary.[Amount]) as Amount
		  ,Cast(0 as bit) as Processed
	  FROM [dbo].[Register.Accumulation.Salary] RegSalary
	  where 1=1
		and RegSalary.[Person] = @Person
		and RegSalary.[currency] = @Currency
		and RegSalary.[date] <= @EndDate
		and RegSalary.company in (SELECT id FROM [dbo].Descendants(@CompanyParent, ''))
		and RegSalary.document <> @DocId
	GROUP BY RegSalary.company
		  ,RegSalary.[currency]
		  ,COALESCE(RegSalary.[Department], '00000000-0000-0000-0000-000000000000')
		  ,RegSalary.[Person]
	HAVING SUM(RegSalary.[Amount]) <> 0
	--Order by 1

	WHILE @Amount >= COALESCE((SELECT TOP 1 Amount FROM @SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0) AND COALESCE((SELECT TOP 1 Amount FROM @SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0) <> 0
	BEGIN	 
		INSERT INTO @ResultFIFO
		SELECT TOP 1 sTmp.* FROM @SortBC as sTmp where Processed = 0 ORDER BY MaxDate, Amount, Department, Company

		SET @Amount = @Amount - COALESCE((SELECT TOP 1 Amount FROM @SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0);
		UPDATE @SortBC SET Processed = 1 WHERE MaxDate = (SELECT TOP 1 MaxDate FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Department = (SELECT TOP 1 Department FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Company = (SELECT TOP 1 Company FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC);

	   IF @Amount > 0 AND @Amount <= COALESCE((SELECT TOP 1 Amount FROM @SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0)
		BREAK;
	 END

	INSERT INTO @ResultFIFO
	SELECT TOP 1 sTmp.MaxDate, sTmp.Company, sTmp.Currency, sTmp.Department, sTmp.Person, (SELECT @Amount) as Amount, sTmp.Processed FROM @SortBC as sTmp where Processed = 0 ORDER BY MaxDate, Amount, Department, Company
	SET @Amount = @Amount - COALESCE((SELECT TOP 1 Amount FROM @SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0);
	UPDATE @SortBC SET Processed = 1 WHERE MaxDate = (SELECT TOP 1 MaxDate FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Department = (SELECT TOP 1 Department FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Company = (SELECT TOP 1 Company FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC);

	IF @Amount > 0 
	BEGIN
		INSERT INTO @ResultFIFO
		SELECT TOP 1 sTmp.MaxDate, sTmp.Company, sTmp.Currency, sTmp.Department, sTmp.Person, (SELECT @Amount) as Amount, sTmp.Processed FROM @SortBC as sTmp where Processed = 1 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC
	END 
	--SET @Amount = 0

	IF (SELECT COUNT(*) FROM @ResultFIFO) > 0
		BEGIN
			INSERT INTO @result
			SELECT Res.[MaxDate]
				,Res.[Company]
				,Res.[Currency]
				,IIF(Res.[Department] <> '00000000-0000-0000-0000-000000000000', Res.[Department], null) as [Department]
				,Res.[Person]
				,SUM(Res.[Amount]) as Amount
			FROM @ResultFIFO as Res
			GROUP BY Res.[MaxDate]
				,Res.[Company]
				,Res.[Currency]
				,IIF(Res.[Department] <> '00000000-0000-0000-0000-000000000000', Res.[Department], null)
				,Res.[Person]
		END
	ELSE
		BEGIN
			INSERT INTO @result
			SELECT @EndDate as [MaxDate]
				,(SELECT TOP 1 [company] FROM [Register.Info.DepartmentCompanyHistory] WITH (NOEXPAND) WHERE [date] <= @EndDate AND [Department] = (SELECT [Department] FROM [dbo].[Catalog.Person.v] with (noexpand) WHERE [id] = @Person) ORDER BY [date] DESC) as [Company]
				,@Currency as [Currency]
				,(SELECT [Department] FROM [dbo].[Catalog.Person.v] with (noexpand) WHERE [id] = @Person) as [Department]
				,@Person as [Person]
				,@Amount as Amount
		END
	RETURN;
END
