INSERT INTO distributed_table_shard_key_not_equal_partition_key (id, value, created_at)
SELECT
    number + 1,
    concat('Value', number),
    toDateTime(rand() % (toUnixTimestamp('2025-03-31') - toUnixTimestamp('2025-01-01')) + toUnixTimestamp('2025-01-01'))
FROM numbers(1000000)

INSERT INTO distributed_table_shard_key_equal_partition_key (id, value, created_at)
SELECT
    number + 1,
    concat('Value', number),
    toDateTime(rand() % (toUnixTimestamp('2025-03-31') - toUnixTimestamp('2025-01-01')) + toUnixTimestamp('2025-01-01'))
FROM numbers(1000000)

CREATE table ascending_table (
    id UInt32,
    created_at DateTime
) ENGINE = MergeTree()
PRIMARY KEY (id, created_at)
PARTITION BY (id, created_at)

INSERT INTO table (id, created_at)                                                      
SELECT
    number + 1,
    toDateTime(toUnixTimestamp('2025-01-01') + (1000000 * number))
FROM numbers(100)

SELECT * from ascending_table at2 order by id

CREATE TABLE distributed_table_month ON CLUSTER cluster_2S_1R (
   id UInt32,
   created_at DateTime
) ENGINE = Distributed(cluster_2S_1R, default, ascending_table, toMonth(created_at))
