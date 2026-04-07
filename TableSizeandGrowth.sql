-- Top tables by total size
SELECT
    table_schema                                                        AS db,
    table_name,
    table_rows,
    ROUND(data_length  / 1024 / 1024, 2)                               AS data_mb,
    ROUND(index_length / 1024 / 1024, 2)                               AS index_mb,
    ROUND((data_length + index_length) / 1024 / 1024, 2)               AS total_mb,
    ROUND(data_free    / 1024 / 1024, 2)                               AS reclaimable_mb,
    ROUND(index_length / NULLIF(data_length, 0) * 100, 1)              AS index_to_data_pct
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema','mysql','performance_schema','sys')
  AND table_type = 'BASE TABLE'
ORDER BY (data_length + index_length) DESC
LIMIT 30;


-- Schema-level rollup

SELECT
    table_schema                                                        AS db,
    COUNT(*)                                                            AS table_count,
    ROUND(SUM(data_length)  / 1024 / 1024, 2)                          AS data_mb,
    ROUND(SUM(index_length) / 1024 / 1024, 2)                          AS index_mb,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2)            AS total_mb,
    ROUND(SUM(data_free)    / 1024 / 1024, 2)                          AS reclaimable_mb
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema','mysql','performance_schema','sys')
GROUP BY table_schema
ORDER BY total_mb DESC;