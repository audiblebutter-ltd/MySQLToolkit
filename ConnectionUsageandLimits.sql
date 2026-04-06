-- 1. Current connections vs the limit

SELECT
    @@max_connections AS max_connections,
    (SELECT VARIABLE_VALUE FROM performance_schema.global_status
     WHERE VARIABLE_NAME = 'Threads_connected')             AS current_connections,
    (SELECT VARIABLE_VALUE FROM performance_schema.global_status
     WHERE VARIABLE_NAME = 'Max_used_connections') AS peak_connections,
    ROUND(
        (SELECT VARIABLE_VALUE FROM performance_schema.global_status
         WHERE VARIABLE_NAME = 'Threads_connected')
        / @@max_connections * 100, 1
    ) AS pct_used;


-- 2. Active connections — who is doing work right now

SELECT

    user,
    host,
    db,
    command,
    time    AS seconds_in_state,
    state,
    info    AS current_query

FROM information_schema.PROCESSLIST
WHERE command != 'Sleep'
ORDER BY time DESC;


-- 3. Connection count by user and host

SELECT
    user,
    host,
    db,
    command,
    COUNT(*) AS connection_count
FROM information_schema.PROCESSLIST
GROUP BY user, host, db, command
ORDER BY connection_count DESC;


-- 4. Sleeping connection accumulation

SELECT

    user,
    host,
    COUNT(*)             AS sleeping_connections,
    MAX(time)            AS longest_sleep_seconds,
    ROUND(AVG(time), 1)  AS avg_sleep_seconds

FROM information_schema.PROCESSLIST
WHERE command = 'Sleep'
GROUP BY user, host
ORDER BY sleeping_connections DESC;


-- 5. Key timeout and limit variables

SHOW VARIABLES WHERE Variable_name IN (
    'max_connections',
    'wait_timeout',
    'interactive_timeout',
    'thread_cache_size',
    'max_user_connections'
);