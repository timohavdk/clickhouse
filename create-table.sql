/** Создание локальной бд на каждом из шардов */ 

/** Ключ шардирования соответствует ключу партиционирования */
CREATE TABLE shard_key_equal_partition_key (
    id UInt32,
    value String,
    created_at DateTime
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(created_at)
ORDER BY (id, created_at);


CREATE TABLE distributed_table_shard_key_equal_partition_key ON CLUSTER cluster_2S_1R (
   id UInt32,
   value String,
   created_at DateTime
) ENGINE = Distributed(cluster_2S_1R, default, shard_key_equal_partition_key, intHash32(toYYYYMM(created_at)) % 3)

/** Ключ шардирования не соответствует ключу партиционирования */
CREATE TABLE shard_key_not_equal_partition_key (
    id UInt32,
    value String,
    created_at DateTime
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(created_at)
ORDER BY (id, created_at);

CREATE TABLE distributed_table_shard_key_not_equal_partition_key (
    id UInt32,
    value String,
    created_at DateTime
) ENGINE = Distributed('cluster_2S_1R', 'default', 'shard_key_not_equal_partition_key', rand());

INSERT INTO distributed_table VALUES 
(1, 'Value1', '2025-01-01 12:00:00'),
(2, 'Value2', '2025-02-01 12:00:00'),
(3, 'Value3', '2025-03-01 12:00:00');

