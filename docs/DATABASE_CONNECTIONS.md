# Database Connection Configuration

## Overview

Fizzy uses multiple database connections for different purposes:
- **Primary**: Web requests and main application data
- **Queue**: SolidQueue background job workers
- **Cable**: Action Cable WebSocket connections
- **Cache**: Solid Cache storage

## Connection Pool Sizing

### Queue Database Pool

The queue database connection pool is set to **5 connections per process** by default:
- 3 threads per SolidQueue worker process
- 2 additional connections as buffer
- Configurable via `SOLID_QUEUE_POOL_SIZE` environment variable

**Calculation:**
- If you have 8 CPU cores and `JOB_CONCURRENCY` is not set, you'll have 8 SolidQueue processes
- Each process: 5 connections × 8 processes = 40 total queue connections
- This is much better than the previous 20 × 8 = 160 connections

### Primary Database Pool

The primary database pool is set to **5 connections per process** by default:
- Handles web requests from users
- Each Puma worker process has its own pool
- With 8 CPU cores: 5 × 8 = 40 connections (vs previous 50 × 8 = 400)
- Configurable via `DB_POOL_SIZE` environment variable
- Formula: threads per worker (1) + buffer (4) = 5 per process

## MySQL max_connections Configuration

To prevent "Too many connections" errors, ensure your MySQL server has sufficient `max_connections`:

**Recommended minimum:**
```sql
SET GLOBAL max_connections = 500;
```

**For production with multiple processes:**
```sql
SET GLOBAL max_connections = 1000;
```

**To check current connections:**
```sql
SHOW VARIABLES LIKE 'max_connections';
SHOW STATUS LIKE 'Threads_connected';
```

**To see current connection usage:**
```sql
SHOW PROCESSLIST;
```

## Railway/Cloud Provider Configuration

**Railway MySQL Connection Limits:**
- Starter plans: ~100-150 max_connections
- Pro plans: ~200-500 max_connections
- Enterprise: Custom limits

**Connection Calculation for Railway:**
With default configuration (8 workers, 1 thread each, 5 pool size):
- Primary: 8 × 5 = 40 connections
- Cable: 8 × 5 = 40 connections
- Cache: 8 × 5 = 40 connections
- Queue: 8 × 5 = 40 connections
- **Total: ~160 connections** (well within Railway's limits)

If you're using Railway or another cloud provider:
1. Check your MySQL plan's connection limits
2. Calculate total connections needed: `(workers × pool_size) × number_of_databases`
3. Reduce `DB_POOL_SIZE` if needed (minimum: 2-3)
4. Reduce `WEB_CONCURRENCY` if you have many workers
5. Upgrade your plan if you need more connections

## Troubleshooting

### "Too many connections" errors

1. **Check current connection usage:**
   ```sql
   SHOW STATUS LIKE 'Threads_connected';
   ```

2. **Reduce worker processes:**
   ```bash
   JOB_CONCURRENCY=4  # Instead of default CPU count
   ```

3. **Reduce pool sizes:**
   ```bash
   SOLID_QUEUE_POOL_SIZE=3  # Minimum: threads (3) + 0 buffer
   ```

4. **Increase MySQL max_connections** (if you have control)

### Connection pool exhaustion during shutdown

The `solid_queue_graceful_shutdown.rb` initializer handles this by:
- Catching connection errors during process deregistration
- Logging warnings instead of crashing
- Allowing the supervisor to clean up stale processes

## Environment Variables

- `DB_POOL_SIZE`: Primary/Cable/Cache database pool size per process (default: 5)
- `SOLID_QUEUE_POOL_SIZE`: Queue database pool size per process (default: 5)
- `JOB_CONCURRENCY`: Number of SolidQueue worker processes (default: CPU count)
- `WEB_CONCURRENCY`: Number of Puma worker processes (default: CPU count)

## Quick Fix for "Too many connections" on Railway

If you're hitting connection limits on Railway:

1. **Reduce pool size:**
   ```bash
   DB_POOL_SIZE=3
   SOLID_QUEUE_POOL_SIZE=3
   ```

2. **Reduce worker count:**
   ```bash
   WEB_CONCURRENCY=4  # Instead of default CPU count
   JOB_CONCURRENCY=4
   ```

3. **Check your current usage:**
   Connect to your Railway MySQL and run:
   ```sql
   SHOW STATUS LIKE 'Threads_connected';
   SHOW VARIABLES LIKE 'max_connections';
   ```

4. **Upgrade your Railway plan** if you need more connections
