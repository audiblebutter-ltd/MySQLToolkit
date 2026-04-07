-- Active queries (excludes idle Sleep connections)

SELECT
    id,
    user,
    host,
    db,
    command,
    time AS seconds,
    state,
    info        AS query
FROM information_schema.processlist
WHERE command != 'Sleep'
ORDER BY time DESC;

-- Thread and connection counts

SHOW STATUS LIKE 'Threads_%';
SHOW STATUS LIKE 'Max_used_connections';
SHOW VARIABLES LIKE 'max_connections';