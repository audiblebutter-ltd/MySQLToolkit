-- Full replica status (run on the replica)

-- MySQL 8.0.22+

SHOW REPLICA STATUS\G


-- MySQL < 8.0.22

-- SHOW SLAVE STATUS\G


-- Replication-related system variables

SHOW VARIABLES LIKE 'gtid_mode';
SHOW VARIABLES LIKE 'enforce_gtid_consistency';
SHOW VARIABLES LIKE 'relay_log%';
SHOW VARIABLES LIKE 'replica_parallel%';


-- GTID position comparison (run on source and replica, compare output)

SELECT @@global.gtid_executed AS gtid_executed;


-- Replica applier thread status (performance_schema, MySQL 8.0+)

SELECT
    channel_name,
    service_state,
    last_error_number,
    last_error_message,
    last_error_timestamp
FROM performance_schema.replication_applier_status_by_worker
ORDER BY channel_name, last_error_timestamp DESC;