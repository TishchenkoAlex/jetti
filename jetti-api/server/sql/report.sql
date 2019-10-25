WITH vars as (SELECT
  '2017-03-01' as SDate,
  DATEADD(DAY, 1, '2017-06-30') as EDate,
  'Customer' as Dimension,
  'Catalog.Counterpartie' AS DimensionType,
  'AR' as Measure,
  'Register.Accumulation.AR' as Register)
SELECT
    fin."Id" AS "Id",
    "Dimension".description as "Dimension",
    SUM(BeginBalance) "Begin",
    SUM(Income) "In",
    SUM(Expense) "Out",
    (coalesce(SUM(Income), 0)-coalesce(SUM(Expense), 0)+coalesce(SUM(BeginBalance), 0)) "End"
FROM (
  SELECT
      JSON_VALUE(r.data, '$."Customer"') AS "Id",
      SUM(CAST(JSON_VALUE(r.data, '$.AR') AS money) * CASE WHEN r.kind = 1 THEN 1 ELSE NULL END) as Income,
      SUM(CAST(JSON_VALUE(r.data, '$.AR') AS MONEY) * CASE WHEN r.kind = 1 THEN NULL ELSE 1 END) as Expense,
      NULL as BeginBalance
  FROM "Accumulation" r
  WHERE
      r.type = (SELECT Register FROM vars) 
      AND r.date >= (SELECT SDate FROM vars) AND r.date < (SELECT EDate FROM vars)
  GROUP BY JSON_VALUE(r.data, '$."Customer"')
  UNION ALL
  SELECT
	  JSON_VALUE(r.data, '$."Customer"'),
      NULL,
      NULL,
      SUM(CAST(JSON_VALUE(r.data, '$.AR') AS money) * CASE WHEN r.kind = 1 THEN 1 ELSE -1 END)
  FROM "Accumulation" r
  WHERE
      r.type = (SELECT Register FROM vars)
      AND r.date < (SELECT SDate FROM vars)
  GROUP BY JSON_VALUE(r.data, '$."Customer"')) fin
LEFT JOIN "Documents" "Dimension" ON "Dimension".id = fin."Id" AND "Dimension".type = (SELECT DimensionType FROM vars)
GROUP BY fin."Id", "Dimension".description;