WITH TABLES AS (
  SELECT
    T.table_name,
    T.column_name

  FROM information_schema.columns T
  WHERE T.column_default LIKE '%id_seq%'
    AND T.table_schema = 'public'
    AND T.table_name NOT IN ('Event', '_Date', '_Number')
)

SELECT
  'INSERT INTO "Event" (keyname, keyvalue, action, details, personid) ' ||
  'SELECT ''' ||
  T.column_name ||
  ''', ' ||
  T.column_name ||
  ', ''created'', ''Record created by seeder'', ' ||
  P.personid ||
  ' FROM "' || T.table_name ||
  '";'

FROM TABLES T
  INNER JOIN "People" P ON 1=1
ORDER BY T.table_name ASC
;
