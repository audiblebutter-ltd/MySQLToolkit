-- Large tables with no non-primary indexes

SELECT

    t.table_schema,

    t.table_name,

    t.table_rows,

    ROUND((t.data_length + t.index_length) / 1024 / 1024, 2) AS total_mb,

    COUNT(s.index_name)                                        AS secondary_index_count

FROM information_schema.tables t

LEFT JOIN information_schema.statistics s

    ON  t.table_schema = s.table_schema

    AND t.table_name   = s.table_name

    AND s.index_name  != 'PRIMARY'

WHERE t.table_schema NOT IN ('information_schema','mysql','performance_schema','sys')

  AND t.table_type = 'BASE TABLE'

GROUP BY

    t.table_schema,

    t.table_name,

    t.table_rows,

    t.data_length,

    t.index_length

HAVING secondary_index_count = 0

   AND t.table_rows > 1000

ORDER BY t.table_rows DESC;


-- Index usage statistics (requires performance_schema)

SELECT

    object_schema                        AS db,
    object_name                          AS table_name,
    index_name,
    count_read                           AS reads,
    count_write                          AS writes,
    count_fetch                          AS fetches,
    count_insert                         AS inserts,
    count_update                         AS updates,
    count_delete                         AS deletes

FROM performance_schema.table_io_waits_summary_by_index_usage
WHERE object_schema NOT IN ('mysql','information_schema','performance_schema','sys')
  AND index_name IS NOT NULL
  AND index_name != 'PRIMARY'
ORDER BY count_read ASC, object_schema, object_name;