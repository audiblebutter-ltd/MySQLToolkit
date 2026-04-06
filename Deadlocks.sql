-- 1. Most recent deadlock — full detail from InnoDB

--    Scroll to the LATEST DETECTED DEADLOCK section

SHOW ENGINE INNODB STATUS\G

-- 2. Total deadlock count since server startup

SELECT
    VARIABLE_VALUE AS deadlocks_since_startup
FROM performance_schema.global_status
WHERE VARIABLE_NAME = 'Innodb_deadlocks';


-- 3. Current lock waits (MySQL 8.0+)

SELECT

    dl.OBJECT_SCHEMA,
    dl.OBJECT_NAME,
    dl.LOCK_TYPE,
    dl.LOCK_MODE,
    dl.LOCK_STATUS,
    dl.LOCK_DATA,
    t.PROCESSLIST_ID,
    t.PROCESSLIST_USER,
    t.PROCESSLIST_HOST,
    t.PROCESSLIST_DB,
    t.PROCESSLIST_TIME,
    t.PROCESSLIST_INFO
FROM performance_schema.data_locks dl
JOIN performance_schema.threads t
    ON dl.THREAD_ID = t.THREAD_ID
WHERE dl.LOCK_STATUS = 'WAITING'
ORDER BY t.PROCESSLIST_TIME DESC;


-- 4. Lock wait relationships — who is blocking who (MySQL 8.0+)

SELECT

    r.REQUESTING_ENGINE_TRANSACTION_ID  AS waiting_trx,
    r.BLOCKING_ENGINE_TRANSACTION_ID    AS blocking_trx,
    dl_wait.OBJECT_SCHEMA               AS schema_name,
    dl_wait.OBJECT_NAME                 AS table_name,
    dl_wait.LOCK_TYPE                   AS lock_type,
    dl_wait.LOCK_MODE                   AS lock_mode,
    tw.PROCESSLIST_INFO                 AS waiting_query,
    tb.PROCESSLIST_INFO                 AS blocking_query,
    tb.PROCESSLIST_TIME                 AS blocking_seconds
FROM performance_schema.data_lock_waits r
JOIN performance_schema.data_locks dl_wait
    ON r.REQUESTING_ENGINE_LOCK_ID = dl_wait.ENGINE_LOCK_ID
JOIN performance_schema.threads tw
    ON r.REQUESTING_THREAD_ID = tw.THREAD_ID
JOIN performance_schema.threads tb
    ON r.BLOCKING_THREAD_ID = tb.THREAD_ID
ORDER BY blocking_seconds DESC;


-- 5. All active InnoDB transactions

SELECT
    trx_id,
    trx_state,
    trx_started,
    trx_wait_started,
    TIMESTAMPDIFF(SECOND, trx_wait_started, NOW()) AS wait_seconds,
    trx_rows_locked,
    trx_rows_modified,
    trx_query
FROM information_schema.INNODB_TRX
ORDER BY trx_wait_started ASC;