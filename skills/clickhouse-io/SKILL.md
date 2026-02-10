---
name: clickhouse-io
description: ClickHouse database patterns, query optimization, analytics, and data engineering best practices for high-performance analytical workloads.
---

<!-- 本技能：ClickHouse 分析模式。面向 OLAP 的列存数据库，适用于大批量分析查询、实时聚合与数据管道。 -->

# ClickHouse Analytics Patterns

ClickHouse-specific patterns for high-performance analytics and data engineering.

<!-- ClickHouse 相关的高性能分析与数据工程模式。 -->

## Overview

ClickHouse is a column-oriented database management system (DBMS) for online analytical processing (OLAP). It's optimized for fast analytical queries on large datasets.

<!-- 概述：ClickHouse 是列式 OLAP 数据库，针对大表分析查询优化。 -->

**Key Features:**
- Column-oriented storage

  <!-- 列式存储：按列压缩与读取，分析查询只扫需要的列。 -->

- Data compression

  <!-- 数据压缩：列存便于高压缩比。 -->

- Parallel query execution

  <!-- 并行查询执行。 -->

- Distributed queries

  <!-- 分布式查询。 -->

- Real-time analytics

  <!-- 实时分析能力。 -->

## Table Design Patterns

<!-- 小节：表设计模式。 -->

### MergeTree Engine (Most Common)

<!-- 子节：最常用的 MergeTree 引擎，按分区与 ORDER BY 组织数据。 -->

```sql
CREATE TABLE markets_analytics (
    date Date,
    market_id String,
    market_name String,
    volume UInt64,
    trades UInt32,
    unique_traders UInt32,
    avg_trade_size Float64,
    created_at DateTime
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(date)
ORDER BY (date, market_id)
SETTINGS index_granularity = 8192;
```

<!-- 按 toYYYYMM(date) 分区，按 (date, market_id) 排序，便于按时间与市场过滤。 -->

### ReplacingMergeTree (Deduplication)

<!-- 子节：去重表引擎，同一 ORDER BY 键保留一条（如多源数据合并时去重）。 -->

```sql
-- For data that may have duplicates (e.g., from multiple sources)
CREATE TABLE user_events (
    event_id String,
    user_id String,
    event_type String,
    timestamp DateTime,
    properties String
) ENGINE = ReplacingMergeTree()
PARTITION BY toYYYYMM(timestamp)
ORDER BY (user_id, event_id, timestamp)
PRIMARY KEY (user_id, event_id);
```

<!-- 多源写入可能重复时，用 ReplacingMergeTree 在后台合并去重。 -->

### AggregatingMergeTree (Pre-aggregation)

<!-- 子节：预聚合表引擎，存 AggregateFunction 状态，查询时用 *Merge 得到最终聚合值。 -->

```sql
-- For maintaining aggregated metrics
CREATE TABLE market_stats_hourly (
    hour DateTime,
    market_id String,
    total_volume AggregateFunction(sum, UInt64),
    total_trades AggregateFunction(count, UInt32),
    unique_users AggregateFunction(uniq, String)
) ENGINE = AggregatingMergeTree()
PARTITION BY toYYYYMM(hour)
ORDER BY (hour, market_id);

-- Query aggregated data
SELECT
    hour,
    market_id,
    sumMerge(total_volume) AS volume,
    countMerge(total_trades) AS trades,
    uniqMerge(unique_users) AS users
FROM market_stats_hourly
WHERE hour >= toStartOfHour(now() - INTERVAL 24 HOUR)
GROUP BY hour, market_id
ORDER BY hour DESC;
```

<!-- sumMerge/countMerge/uniqMerge 用于从 AggregateFunction 列得到标量。 -->

## Query Optimization Patterns

<!-- 小节：查询优化模式。 -->

### Efficient Filtering

<!-- 子节：高效过滤——先按索引列（如 date、market_id）过滤，再按其他条件。 -->

```sql
-- ✅ GOOD: Use indexed columns first
SELECT *
FROM markets_analytics
WHERE date >= '2025-01-01'
  AND market_id = 'market-123'
  AND volume > 1000
ORDER BY date DESC
LIMIT 100;

-- ❌ BAD: Filter on non-indexed columns first
SELECT *
FROM markets_analytics
WHERE volume > 1000
  AND market_name LIKE '%election%'
  AND date >= '2025-01-01';
```

<!-- 先按分区/ORDER BY 列过滤能剪枝，非索引列或 LIKE 放前面会拖慢查询。 -->

### Aggregations

<!-- 子节：聚合——多用 ClickHouse 内置聚合函数（如 uniq、quantile），避免不必要的外层计算。 -->

```sql
-- ✅ GOOD: Use ClickHouse-specific aggregation functions
SELECT
    toStartOfDay(created_at) AS day,
    market_id,
    sum(volume) AS total_volume,
    count() AS total_trades,
    uniq(trader_id) AS unique_traders,
    avg(trade_size) AS avg_size
FROM trades
WHERE created_at >= today() - INTERVAL 7 DAY
GROUP BY day, market_id
ORDER BY day DESC, total_volume DESC;

-- ✅ Use quantile for percentiles (more efficient than percentile)
SELECT
    quantile(0.50)(trade_size) AS median,
    quantile(0.95)(trade_size) AS p95,
    quantile(0.99)(trade_size) AS p99
FROM trades
WHERE created_at >= now() - INTERVAL 1 HOUR;
```

<!-- quantile 比 percentile 等更高效，适合延迟/大小等分位数。 -->

### Window Functions

<!-- 子节：窗口函数——如按 market_id 分区、按 date 排序的累计和。 -->

```sql
-- Calculate running totals
SELECT
    date,
    market_id,
    volume,
    sum(volume) OVER (
        PARTITION BY market_id
        ORDER BY date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_volume
FROM markets_analytics
WHERE date >= today() - INTERVAL 30 DAY
ORDER BY market_id, date;
```

<!-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 表示从分区首行到当前行的累计。 -->

## Data Insertion Patterns

<!-- 小节：数据写入模式。 -->

### Bulk Insert (Recommended)

<!-- 子节：推荐批量插入，一次 VALUES 多行，避免逐行 INSERT。 -->

```typescript
import { ClickHouse } from 'clickhouse'

const clickhouse = new ClickHouse({
  url: process.env.CLICKHOUSE_URL,
  port: 8123,
  basicAuth: {
    username: process.env.CLICKHOUSE_USER,
    password: process.env.CLICKHOUSE_PASSWORD
  }
})

// ✅ Batch insert (efficient)
async function bulkInsertTrades(trades: Trade[]) {
  const values = trades.map(trade => `(
    '${trade.id}',
    '${trade.market_id}',
    '${trade.user_id}',
    ${trade.amount},
    '${trade.timestamp.toISOString()}'
  )`).join(',')

  await clickhouse.query(`
    INSERT INTO trades (id, market_id, user_id, amount, timestamp)
    VALUES ${values}
  `).toPromise()
}

// ❌ Individual inserts (slow)
async function insertTrade(trade: Trade) {
  // Don't do this in a loop!
  await clickhouse.query(`
    INSERT INTO trades VALUES ('${trade.id}', ...)
  `).toPromise()
}
```

<!-- 循环里单条 INSERT 会非常慢，应攒批后一次写入。 -->

### Streaming Insert

<!-- 子节：流式写入——用 insert().stream() 持续写批次，适合实时接入。 -->

```typescript
// For continuous data ingestion
import { createWriteStream } from 'fs'
import { pipeline } from 'stream/promises'

async function streamInserts() {
  const stream = clickhouse.insert('trades').stream()

  for await (const batch of dataSource) {
    stream.write(batch)
  }

  await stream.end()
}
```

<!-- 从数据源逐批写入 ClickHouse stream，写完后 end。 -->

## Materialized Views

<!-- 小节：物化视图。 -->

### Real-time Aggregations

<!-- 子节：用物化视图实时聚合——从 trades 等表 SELECT 聚合写入目标表，查询时直接读目标表。 -->

```sql
-- Create materialized view for hourly stats
CREATE MATERIALIZED VIEW market_stats_hourly_mv
TO market_stats_hourly
AS SELECT
    toStartOfHour(timestamp) AS hour,
    market_id,
    sumState(amount) AS total_volume,
    countState() AS total_trades,
    uniqState(user_id) AS unique_users
FROM trades
GROUP BY hour, market_id;

-- Query the materialized view
SELECT
    hour,
    market_id,
    sumMerge(total_volume) AS volume,
    countMerge(total_trades) AS trades,
    uniqMerge(unique_users) AS users
FROM market_stats_hourly
WHERE hour >= now() - INTERVAL 24 HOUR
GROUP BY hour, market_id;
```

<!-- *State 存中间状态，写入目标表；查询时 *Merge 合并。 -->

## Performance Monitoring

<!-- 小节：性能监控。 -->

### Query Performance

<!-- 子节：从 system.query_log 查慢查询、读行数、内存等。 -->

```sql
-- Check slow queries
SELECT
    query_id,
    user,
    query,
    query_duration_ms,
    read_rows,
    read_bytes,
    memory_usage
FROM system.query_log
WHERE type = 'QueryFinish'
  AND query_duration_ms > 1000
  AND event_time >= now() - INTERVAL 1 HOUR
ORDER BY query_duration_ms DESC
LIMIT 10;
```

<!-- type = 'QueryFinish' 且 query_duration_ms > 1000 筛选慢查询。 -->

### Table Statistics

<!-- 子节：从 system.parts 看表大小、行数、最后修改时间。 -->

```sql
-- Check table sizes
SELECT
    database,
    table,
    formatReadableSize(sum(bytes)) AS size,
    sum(rows) AS rows,
    max(modification_time) AS latest_modification
FROM system.parts
WHERE active
GROUP BY database, table
ORDER BY sum(bytes) DESC;
```

<!-- active 分区部分，按库表汇总 bytes/rows。 -->

## Common Analytics Queries

<!-- 小节：常见分析查询示例。 -->

### Time Series Analysis

<!-- 子节：时间序列——日活、留存等，按 toDate 分组与 dateDiff。 -->

```sql
-- Daily active users
SELECT
    toDate(timestamp) AS date,
    uniq(user_id) AS daily_active_users
FROM events
WHERE timestamp >= today() - INTERVAL 30 DAY
GROUP BY date
ORDER BY date;

-- Retention analysis
SELECT
    signup_date,
    countIf(days_since_signup = 0) AS day_0,
    countIf(days_since_signup = 1) AS day_1,
    countIf(days_since_signup = 7) AS day_7,
    countIf(days_since_signup = 30) AS day_30
FROM (
    SELECT
        user_id,
        min(toDate(timestamp)) AS signup_date,
        toDate(timestamp) AS activity_date,
        dateDiff('day', signup_date, activity_date) AS days_since_signup
    FROM events
    GROUP BY user_id, activity_date
)
GROUP BY signup_date
ORDER BY signup_date DESC;
```

<!-- 留存：按 signup_date 与 days_since_signup 统计各日留存人数。 -->

### Funnel Analysis

<!-- 子节：漏斗分析——各步骤人数与步骤间转化率。 -->

```sql
-- Conversion funnel
SELECT
    countIf(step = 'viewed_market') AS viewed,
    countIf(step = 'clicked_trade') AS clicked,
    countIf(step = 'completed_trade') AS completed,
    round(clicked / viewed * 100, 2) AS view_to_click_rate,
    round(completed / clicked * 100, 2) AS click_to_completion_rate
FROM (
    SELECT
        user_id,
        session_id,
        event_type AS step
    FROM events
    WHERE event_date = today()
)
GROUP BY session_id;
```

<!-- 按 session 统计 viewed/clicked/completed 及转化率。 -->

### Cohort Analysis

<!-- 子节： cohort 分析——按注册月份与活跃月份统计留存。 -->

```sql
-- User cohorts by signup month
SELECT
    toStartOfMonth(signup_date) AS cohort,
    toStartOfMonth(activity_date) AS month,
    dateDiff('month', cohort, month) AS months_since_signup,
    count(DISTINCT user_id) AS active_users
FROM (
    SELECT
        user_id,
        min(toDate(timestamp)) OVER (PARTITION BY user_id) AS signup_date,
        toDate(timestamp) AS activity_date
    FROM events
)
GROUP BY cohort, month, months_since_signup
ORDER BY cohort, months_since_signup;
```

<!-- 按 cohort 与 months_since_signup 看每批用户在各月的活跃人数。 -->

## Data Pipeline Patterns

<!-- 小节：数据管道模式。 -->

### ETL Pattern

<!-- 子节：ETL——从 Postgres 等抽取，转换后批量写入 ClickHouse，可定时执行。 -->

```typescript
// Extract, Transform, Load
async function etlPipeline() {
  // 1. Extract from source
  const rawData = await extractFromPostgres()

  // 2. Transform
  const transformed = rawData.map(row => ({
    date: new Date(row.created_at).toISOString().split('T')[0],
    market_id: row.market_slug,
    volume: parseFloat(row.total_volume),
    trades: parseInt(row.trade_count)
  }))

  // 3. Load to ClickHouse
  await bulkInsertToClickHouse(transformed)
}

// Run periodically
setInterval(etlPipeline, 60 * 60 * 1000)  // Every hour
```

<!-- 每小时跑一次 ETL，保持分析库与业务库同步。 -->

### Change Data Capture (CDC)

<!-- 子节：变更数据捕获——监听 Postgres NOTIFY，将变更同步写入 ClickHouse。 -->

```typescript
// Listen to PostgreSQL changes and sync to ClickHouse
import { Client } from 'pg'

const pgClient = new Client({ connectionString: process.env.DATABASE_URL })

pgClient.query('LISTEN market_updates')

pgClient.on('notification', async (msg) => {
  const update = JSON.parse(msg.payload)

  await clickhouse.insert('market_updates', [
    {
      market_id: update.id,
      event_type: update.operation,  // INSERT, UPDATE, DELETE
      timestamp: new Date(),
      data: JSON.stringify(update.new_data)
    }
  ])
})
```

<!-- 收到通知后解析 payload，将 INSERT/UPDATE/DELETE 记录写入 ClickHouse。 -->

## Best Practices

<!-- 小节：最佳实践摘要。 -->

### 1. Partitioning Strategy

<!-- 分区策略：通常按时间（月/日），避免过多分区，分区键用 DATE。 -->
- Partition by time (usually month or day)
- Avoid too many partitions (performance impact)
- Use DATE type for partition key

### 2. Ordering Key

<!-- 排序键：最常过滤的列放前面，考虑基数与压缩。 -->
- Put most frequently filtered columns first
- Consider cardinality (high cardinality first)
- Order impacts compression

### 3. Data Types

<!-- 数据类型：用最小够用类型，重复字符串用 LowCardinality，分类用 Enum。 -->
- Use smallest appropriate type (UInt32 vs UInt64)
- Use LowCardinality for repeated strings
- Use Enum for categorical data

### 4. Avoid

<!-- 避免：SELECT *、滥用 FINAL、过多 JOIN、小批量频繁插入；改为指定列、先合并再查、反范式、批量写。 -->

- SELECT * (specify columns)
- FINAL (merge data before query instead)
- Too many JOINs (denormalize for analytics)
- Small frequent inserts (batch instead)

### 5. Monitoring

<!-- 监控：查询性能、磁盘、merge、慢查询日志。 -->
- Track query performance
- Monitor disk usage
- Check merge operations
- Review slow query log

**Remember**: ClickHouse excels at analytical workloads. Design tables for your query patterns, batch inserts, and leverage materialized views for real-time aggregations.

<!-- 记住：ClickHouse 擅长分析负载；表结构按查询模式设计、批量写入、用物化视图做实时聚合。 -->
