USE [sm]
GO
/****** Object:  UserDefinedFunction [dbo].[ExchangeRate]    Script Date: 27.10.2020 20:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[ExchangeRate] 
(
	@date DATETIME, @company uniqueidentifier, @currency uniqueidentifier
)
RETURNS FLOAT
AS
	BEGIN
	DECLARE @RESULT FLOAT = 1;

	SELECT TOP 1 @RESULT = CAST([Rate] AS FLOAT) / CASE WHEN [Mutiplicity] > 0 THEN [Mutiplicity] ELSE 1 END
    FROM [Register.Info.ExchangeRates] WITH (NOEXPAND)
    WHERE
      date <= @date
      AND company = @company
      AND currency = @currency
    ORDER BY date DESC;

	
	RETURN ISNULL(@RESULT, 1);
END
