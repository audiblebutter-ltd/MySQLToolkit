-- 1. Is binary logging enabled?
SHOW VARIABLES LIKE 'log_bin';
SHOW VARIABLES LIKE 'binlog_format';
SHOW VARIABLES LIKE 'expire_logs_days';
SHOW VARIABLES LIKE 'binlog_expire_logs_seconds';


-- 2. Current binary log file and write position

SHOW MASTER STATUS;


-- 3. All binary log files on disk with sizes

SHOW BINARY LOGS;


-- 4. Full health check — settings in one row

SELECT

    @@log_bin                            AS binary_logging_enabled,
    @@binlog_format                      AS binlog_format,
    @@server_id                          AS server_id,
    @@binlog_expire_logs_seconds         AS expire_seconds,
    @@binlog_expire_logs_seconds / 86400 AS expire_days,
    @@max_binlog_size / 1024 / 1024      AS max_binlog_size_mb;