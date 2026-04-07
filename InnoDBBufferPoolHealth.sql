-- Buffer pool utilization and dirty pages

SELECT
    variable_name,
    variable_value
FROM performance_schema.global_status
WHERE variable_name IN (
    'Innodb_buffer_pool_pages_total',
    'Innodb_buffer_pool_pages_data',
    'Innodb_buffer_pool_pages_free',
    'Innodb_buffer_pool_pages_dirty',
    'Innodb_buffer_pool_pages_flushed',
    'Innodb_buffer_pool_read_requests',
    'Innodb_buffer_pool_reads',
    'Innodb_buffer_pool_wait_free',
    'Innodb_buffer_pool_write_requests'
)
ORDER BY variable_name;


-- Buffer pool hit rate

SELECT
    ROUND(
        (1 - (
            (SELECT CAST(variable_value AS UNSIGNED)
               FROM performance_schema.global_status
              WHERE variable_name = 'Innodb_buffer_pool_reads') /
            NULLIF(
                (SELECT CAST(variable_value AS UNSIGNED)
                   FROM performance_schema.global_status
                  WHERE variable_name = 'Innodb_buffer_pool_read_requests'),
            0)
        )) * 100, 2
    ) AS hit_rate_pct;
-- Configured buffer pool size
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'innodb_buffer_pool_instances';