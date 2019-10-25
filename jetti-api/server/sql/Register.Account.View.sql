CREATE VIEW "Register.Account.View" AS
SELECT
  r.date date,
  r.sum  sum,

  r.document "document.id", document.description "document.value", document.code "document.code", document.type "document.type",
  company.description "company.value", company.id "company.id", company.code "company.code", company.type "company.type",

  dt.code "debit.account", dt.description "debit.description", r.dt_qty "debit.qty", dt_cur.description "debit.currency", dt_sum "debit.sum",
  dt_subcount1.id "debit.subcount1.id", dt_subcount1.type "debit.subcount1.type",dt_subcount1.description "debit.subcount1.value", dt_subcount1.type "debit.subcount1.code",
  dt_subcount2.id "debit.subcount2.id", dt_subcount2.type "debit.subcount2.type",dt_subcount2.description "debit.subcount2.value", dt_subcount2.type "debit.subcount2.code",
  dt_subcount3.id "debit.subcount3.id", dt_subcount3.type "debit.subcount3.type",dt_subcount3.description "debit.subcount3.value", dt_subcount3.type "debit.subcount3.code",
  dt_subcount4.id "debit.subcount4.id", dt_subcount4.type "debit.subcount4.type",dt_subcount4.description "debit.subcount4.value", dt_subcount4.type "debit.subcount4.code",

  kt.code "kredit.account", dt.description "kredit.description", r.kt_qty "kredit.qty", kt_cur.description "kredit.currency", kt_sum "kredit.sum",
  kt_subcount1.id "kredit.subcount1.id", kt_subcount1.type "kredit.subcount1.type",kt_subcount1.description "kredit.subcount1.value", kt_subcount1.type "kredit.subcount1.code",
  kt_subcount2.id "kredit.subcount2.id", kt_subcount2.type "kredit.subcount2.type",kt_subcount2.description "kredit.subcount2.value", kt_subcount2.type "kredit.subcount2.code",
  kt_subcount3.id "kredit.subcount3.id", kt_subcount3.type "kredit.subcount3.type",kt_subcount3.description "kredit.subcount3.value", kt_subcount3.type "kredit.subcount3.code",
  kt_subcount4.id "kredit.subcount4.id", kt_subcount4.type "kredit.subcount4.type",kt_subcount4.description "kredit.subcount4.value", kt_subcount4.type "kredit.subcount4.code"

FROM "Register.Account" r
  LEFT JOIN "Documents" document ON document.id = r.document
  LEFT JOIN "Documents" dt ON dt.code = r.dt and dt.type = 'Catalog.Account'
  LEFT JOIN "Documents" kt ON kt.code = r.kt and dt.type = 'Catalog.Account'
  LEFT JOIN "Documents" dt_subcount1 ON dt_subcount1.id= r.dt_subcount1
  LEFT JOIN "Documents" dt_subcount2 ON dt_subcount2.id = r.dt_subcount2
  LEFT JOIN "Documents" dt_subcount3 ON dt_subcount3.id = r.dt_subcount3
  LEFT JOIN "Documents" dt_subcount4 ON dt_subcount4.id = r.dt_subcount4
  LEFT JOIN "Documents" kt_subcount1 ON kt_subcount1.id = r.kt_subcount1
  LEFT JOIN "Documents" kt_subcount2 ON kt_subcount2.id = r.kt_subcount2
  LEFT JOIN "Documents" kt_subcount3 ON kt_subcount3.id = r.kt_subcount3
  LEFT JOIN "Documents" kt_subcount4 ON kt_subcount4.id = r.kt_subcount4
  LEFT JOIN "Documents" dt_cur ON dt_cur.id = r.dt_cur
  LEFT JOIN "Documents" kt_cur ON kt_cur.id = r.kt_cur
  LEFT JOIN "Documents" company ON company.id = r.company

