-- Active lock waits: who is waiting on whom

SELECT
    r.trx_id                                                        AS waiting_trx_id,
    r.trx_mysql_thread_id                                           AS waiting_thread,
    LEFT(r.trx_query, 200)                                          AS waiting_query,
    b.trx_id                                                        AS blocking_trx_id,
    b.trx_mysql_thread_id                                           AS blocking_thread,
    LEFT(b.trx_query, 200)                                          AS blocking_query,
    b.trx_started                                                   AS blocking_started,
    TIMESTAMPDIFF(SECOND, b.trx_started, NOW())                     AS blocking_seconds
FROM information_schema.innodb_lock_waits w
JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id
JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id
ORDER BY blocking_seconds DESC;


-- All open transactions (with or without active waits)

SELECT
    trx_id,
    trx_mysql_thread_id                                             AS thread_id,
    trx_started,
    TIMESTAMPDIFF(SECOND, trx_started, NOW())                       AS open_seconds,
    trx_rows_locked                                                 AS rows_locked,
    trx_rows_modified                                               AS rows_modified,
    trx_state,
    LEFT(trx_query, 200)                                            AS current_query
FROM information_schema.innodb_trx
ORDER BY open_seconds DESC;