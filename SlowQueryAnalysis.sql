-- Verify performance_schema is enabled

SHOW VARIABLES LIKE 'performance_schema';

-- Slow query log configuration (for reference)

SHOW VARIABLES LIKE 'slow_query_log%';
SHOW VARIABLES LIKE 'long_query_time';
SHOW VARIABLES LIKE 'log_queries_not_using_indexes';

-- Top queries by total cumulative time

SELECT
    schema_name                                                         AS db,
    digest_text                                                         AS query_pattern,
    count_star                                                          AS executions,
    ROUND(avg_timer_wait   / 1000000000000, 4)                         AS avg_sec,
    ROUND(max_timer_wait   / 1000000000000, 4)                         AS max_sec,
    ROUND(sum_timer_wait   / 1000000000000, 4)                         AS total_sec,
    ROUND(sum_rows_examined / NULLIF(count_star, 0))                   AS avg_rows_examined,
    ROUND(sum_rows_sent     / NULLIF(count_star, 0))                   AS avg_rows_returned,
    ROUND(sum_no_index_used / NULLIF(count_star, 0) * 100, 1)         AS pct_no_index,
    DATE_FORMAT(first_seen, '%Y-%m-%d %H:%i')                          AS first_seen,
    DATE_FORMAT(last_seen,  '%Y-%m-%d %H:%i')                          AS last_seen
FROM performance_schema.events_statements_summary_by_digest
WHERE digest_text IS NOT NULL
  AND schema_name NOT IN ('mysql','information_schema','performance_schema','sys')
ORDER BY sum_timer_wait DESC
LIMIT 25;