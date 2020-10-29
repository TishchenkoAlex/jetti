USE [sm]
GO
/****** Object:  StoredProcedure [dbo].[Distribution.Salary.Person.FIFO]    Script Date: 28.10.2020 21:24:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Distribution.Salary.Person.FIFO]
	@EndDate date,
	@Currency uniqueidentifier,
	@Person uniqueidentifier,
	@Amount money
AS
BEGIN
	DECLARE @ResultFIFO AS table ([MaxDate] date, [Company] uniqueidentifier, [Currency] uniqueidentifier, [Department] uniqueidentifier, [Person] uniqueidentifier, [Amount] money, [Processed] bit);
	DROP TABLE IF EXISTS #SortBC;

	SELECT max(RegSalary.[date]) as MaxDate
		  ,RegSalary.company as Company
		  ,RegSalary.[currency] as Currency
		  ,RegSalary.[Department] as Department
		  ,RegSalary.[Person] as Person
		  ,SUM(RegSalary.[Amount]) as Amount
		  ,Cast(0 as bit) as Processed
	INTO #SortBC
	  FROM [dbo].[Register.Accumulation.Salary] RegSalary
	  where 1=1
		and RegSalary.[Person] = @Person
		and RegSalary.[currency] = @Currency
		and RegSalary.[date] <= @EndDate
	GROUP BY RegSalary.company
		  ,RegSalary.[currency]
		  ,RegSalary.[Department]
		  ,RegSalary.[Person]
	HAVING SUM(RegSalary.[Amount]) != 0
	--Order by 1

	WHILE @Amount >= COALESCE((SELECT TOP 1 Amount FROM #SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0) AND COALESCE((SELECT TOP 1 Amount FROM #SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0) <> 0
	BEGIN	 
		INSERT INTO @ResultFIFO
		SELECT TOP 1 sTmp.* FROM #SortBC as sTmp where Processed = 0 ORDER BY MaxDate, Amount, Department, Company

		SET @Amount = @Amount - COALESCE((SELECT TOP 1 Amount FROM #SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0);
		UPDATE #SortBC SET Processed = 1 WHERE MaxDate = (SELECT TOP 1 MaxDate FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Department = (SELECT TOP 1 Department FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Company = (SELECT TOP 1 Company FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC);

	   IF @Amount > 0 AND @Amount <= COALESCE((SELECT TOP 1 Amount FROM #SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0)
		BREAK;
	 END

	INSERT INTO @ResultFIFO
	SELECT TOP 1 sTmp.MaxDate, sTmp.Company, sTmp.Currency, sTmp.Department, sTmp.Person, (SELECT @Amount) as Amount, sTmp.Processed FROM #SortBC as sTmp where Processed = 0 ORDER BY MaxDate, Amount, Department, Company
	SET @Amount = @Amount - COALESCE((SELECT TOP 1 Amount FROM #SortBC where Processed = 0 ORDER BY MaxDate, Amount, Department, Company), 0);
	UPDATE #SortBC SET Processed = 1 WHERE MaxDate = (SELECT TOP 1 MaxDate FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Department = (SELECT TOP 1 Department FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC) AND Company = (SELECT TOP 1 Company FROM @ResultFIFO WHERE Processed = 0 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC);

	IF @Amount > 0 
	BEGIN
		INSERT INTO @ResultFIFO
		SELECT TOP 1 sTmp.MaxDate, sTmp.Company, sTmp.Currency, sTmp.Department, sTmp.Person, (SELECT @Amount) as Amount, sTmp.Processed FROM #SortBC as sTmp where Processed = 1 ORDER BY MaxDate DESC, Amount DESC, Department DESC, Company DESC
	END 
	SET @Amount = 0

	SELECT Res.[MaxDate]
		,Res.[Company]
		,Res.[Currency]
		,Res.[Department]
		,Res.[Person]
		,SUM(Res.[Amount]) as Amount
	FROM @ResultFIFO as Res
	GROUP BY Res.[MaxDate]
		,Res.[Company]
		,Res.[Currency]
		,Res.[Department]
		,Res.[Person]
END
