---
name: backend-patterns
description: Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js, Express, and Next.js API routes.
---

<!-- 本技能：后端开发模式。提供 Node/Express/Next.js 下的 API 设计、数据库与缓存、错误处理、鉴权、限流、队列、日志等最佳实践。 -->

# Backend Development Patterns

Backend architecture patterns and best practices for scalable server-side applications.

<!-- 后端架构模式与可扩展服务端应用的最佳实践。 -->

## API Design Patterns

<!-- 小节：API 设计模式。 -->

### RESTful API Structure

<!-- 子节：REST 风格 API 的 URL 与动词约定。 -->

```typescript
// ✅ Resource-based URLs
GET    /api/markets                 # List resources
GET    /api/markets/:id             # Get single resource
POST   /api/markets                 # Create resource
PUT    /api/markets/:id             # Replace resource
PATCH  /api/markets/:id             # Update resource
DELETE /api/markets/:id             # Delete resource

// ✅ Query parameters for filtering, sorting, pagination
GET /api/markets?status=active&sort=volume&limit=20&offset=0
```

<!-- 使用查询参数做过滤、排序、分页。 -->

### Repository Pattern

<!-- 子节：仓储模式——把数据访问抽象成接口，便于换实现与测试。 -->

```typescript
// Abstract data access logic
interface MarketRepository {
  findAll(filters?: MarketFilters): Promise<Market[]>
  findById(id: string): Promise<Market | null>
  create(data: CreateMarketDto): Promise<Market>
  update(id: string, data: UpdateMarketDto): Promise<Market>
  delete(id: string): Promise<void>
}

class SupabaseMarketRepository implements MarketRepository {
  async findAll(filters?: MarketFilters): Promise<Market[]> {
    let query = supabase.from('markets').select('*')

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.limit) {
      query = query.limit(filters.limit)
    }

    const { data, error } = await query

    if (error) throw new Error(error.message)
    return data
  }

  // Other methods...
}
```

<!-- SupabaseMarketRepository 实现 MarketRepository，封装 Supabase 查询。 -->

### Service Layer Pattern

<!-- 子节：服务层模式——业务逻辑与数据访问分离，服务调用仓储。 -->

```typescript
// Business logic separated from data access
class MarketService {
  constructor(private marketRepo: MarketRepository) {}

  async searchMarkets(query: string, limit: number = 10): Promise<Market[]> {
    // Business logic
    const embedding = await generateEmbedding(query)
    const results = await this.vectorSearch(embedding, limit)

    // Fetch full data
    const markets = await this.marketRepo.findByIds(results.map(r => r.id))

    // Sort by similarity
    return markets.sort((a, b) => {
      const scoreA = results.find(r => r.id === a.id)?.score || 0
      const scoreB = results.find(r => r.id === b.id)?.score || 0
      return scoreA - scoreB
    })
  }

  private async vectorSearch(embedding: number[], limit: number) {
    // Vector search implementation
  }
}
```

<!-- MarketService 依赖 MarketRepository，在 searchMarkets 里做向量检索再补全数据。 -->

### Middleware Pattern

<!-- 子节：中间件模式——在请求/响应管道中做鉴权、日志等，再交给业务 handler。 -->

```typescript
// Request/response processing pipeline
export function withAuth(handler: NextApiHandler): NextApiHandler {
  return async (req, res) => {
    const token = req.headers.authorization?.replace('Bearer ', '')

    if (!token) {
      return res.status(401).json({ error: 'Unauthorized' })
    }

    try {
      const user = await verifyToken(token)
      req.user = user
      return handler(req, res)
    } catch (error) {
      return res.status(401).json({ error: 'Invalid token' })
    }
  }
}

// Usage
export default withAuth(async (req, res) => {
  // Handler has access to req.user
})
```

<!-- withAuth 高阶函数包装 handler，验证 Bearer token 并注入 req.user。 -->

## Database Patterns

<!-- 小节：数据库相关模式。 -->

### Query Optimization

<!-- 子节：查询优化——只查需要的列、避免 select *。 -->

```typescript
// ✅ GOOD: Select only needed columns
const { data } = await supabase
  .from('markets')
  .select('id, name, status, volume')
  .eq('status', 'active')
  .order('volume', { ascending: false })
  .limit(10)

// ❌ BAD: Select everything
const { data } = await supabase
  .from('markets')
  .select('*')
```

<!-- 只选 id,name,status,volume 等需要的列，减少传输与解析。 -->

### N+1 Query Prevention

<!-- 子节：避免 N+1——先批量查关联数据再在内存里组装，不要循环里逐条查。 -->

```typescript
// ❌ BAD: N+1 query problem
const markets = await getMarkets()
for (const market of markets) {
  market.creator = await getUser(market.creator_id)  // N queries
}

// ✅ GOOD: Batch fetch
const markets = await getMarkets()
const creatorIds = markets.map(m => m.creator_id)
const creators = await getUsers(creatorIds)  // 1 query
const creatorMap = new Map(creators.map(c => [c.id, c]))

markets.forEach(market => {
  market.creator = creatorMap.get(market.creator_id)
})
```

<!-- 一次 getUsers(creatorIds) 后用 Map 做 O(1) 查找，避免 N 次查询。 -->

### Transaction Pattern

<!-- 子节：事务模式——多步写操作用 RPC 或事务保证原子性，失败时回滚。 -->

```typescript
async function createMarketWithPosition(
  marketData: CreateMarketDto,
  positionData: CreatePositionDto
) {
  // Use Supabase transaction
  const { data, error } = await supabase.rpc('create_market_with_position', {
    market_data: marketData,
    position_data: positionData
  })

  if (error) throw new Error('Transaction failed')
  return data
}

// SQL function in Supabase
CREATE OR REPLACE FUNCTION create_market_with_position(
  market_data jsonb,
  position_data jsonb
)
RETURNS jsonb
LANGUAGE plpgsql
AS $$
BEGIN
  -- Start transaction automatically
  INSERT INTO markets VALUES (market_data);
  INSERT INTO positions VALUES (position_data);
  RETURN jsonb_build_object('success', true);
EXCEPTION
  WHEN OTHERS THEN
    -- Rollback happens automatically
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;
```

<!-- 用 Supabase 的 RPC 调用 plpgsql 函数，在数据库内完成插入与异常回滚。 -->

## Caching Strategies

<!-- 小节：缓存策略。 -->

### Redis Caching Layer

<!-- 子节：用 Redis 做缓存层，先查缓存再查库，命中则写回缓存并设置 TTL。 -->

```typescript
class CachedMarketRepository implements MarketRepository {
  constructor(
    private baseRepo: MarketRepository,
    private redis: RedisClient
  ) {}

  async findById(id: string): Promise<Market | null> {
    // Check cache first
    const cached = await this.redis.get(`market:${id}`)

    if (cached) {
      return JSON.parse(cached)
    }

    // Cache miss - fetch from database
    const market = await this.baseRepo.findById(id)

    if (market) {
      // Cache for 5 minutes
      await this.redis.setex(`market:${id}`, 300, JSON.stringify(market))
    }

    return market
  }

  async invalidateCache(id: string): Promise<void> {
    await this.redis.del(`market:${id}`)
  }
}
```

<!-- CachedMarketRepository 装饰 baseRepo，读时先 redis 再 DB，写时可调用 invalidateCache。 -->

### Cache-Aside Pattern

<!-- 子节：Cache-Aside：先读缓存，未命中则读 DB 并回填缓存。 -->

```typescript
async function getMarketWithCache(id: string): Promise<Market> {
  const cacheKey = `market:${id}`

  // Try cache
  const cached = await redis.get(cacheKey)
  if (cached) return JSON.parse(cached)

  // Cache miss - fetch from DB
  const market = await db.markets.findUnique({ where: { id } })

  if (!market) throw new Error('Market not found')

  // Update cache
  await redis.setex(cacheKey, 300, JSON.stringify(market))

  return market
}
```

<!-- 逻辑：get → cache → 无则 DB → 写入 cache → 返回。 -->

## Error Handling Patterns

<!-- 小节：错误处理模式。 -->

### Centralized Error Handler

<!-- 子节：统一错误处理——区分 ApiError、Zod 校验错误与未知错误，返回对应 HTTP 状态与 JSON。 -->

```typescript
class ApiError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public isOperational = true
  ) {
    super(message)
    Object.setPrototypeOf(this, ApiError.prototype)
  }
}

export function errorHandler(error: unknown, req: Request): Response {
  if (error instanceof ApiError) {
    return NextResponse.json({
      success: false,
      error: error.message
    }, { status: error.statusCode })
  }

  if (error instanceof z.ZodError) {
    return NextResponse.json({
      success: false,
      error: 'Validation failed',
      details: error.errors
    }, { status: 400 })
  }

  // Log unexpected errors
  console.error('Unexpected error:', error)

  return NextResponse.json({
    success: false,
    error: 'Internal server error'
  }, { status: 500 })
}

// Usage
export async function GET(request: Request) {
  try {
    const data = await fetchData()
    return NextResponse.json({ success: true, data })
  } catch (error) {
    return errorHandler(error, request)
  }
}
```

<!-- errorHandler 根据错误类型返回 4xx/5xx 与统一结构的 JSON。 -->

### Retry with Exponential Backoff

<!-- 子节：带指数退避的重试——失败后按 1s、2s、4s 延迟再试，避免雪崩。 -->

```typescript
async function fetchWithRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 3
): Promise<T> {
  let lastError: Error

  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn()
    } catch (error) {
      lastError = error as Error

      if (i < maxRetries - 1) {
        // Exponential backoff: 1s, 2s, 4s
        const delay = Math.pow(2, i) * 1000
        await new Promise(resolve => setTimeout(resolve, delay))
      }
    }
  }

  throw lastError!
}

// Usage
const data = await fetchWithRetry(() => fetchFromAPI())
```

<!-- fetchWithRetry 在 maxRetries 次内重试，间隔指数增长。 -->

## Authentication & Authorization

<!-- 小节：认证与授权。 -->

### JWT Token Validation

<!-- 子节：JWT 校验——verifyToken 解析并验证签名，requireAuth 从 Header 取 token 并校验。 -->

```typescript
import jwt from 'jsonwebtoken'

interface JWTPayload {
  userId: string
  email: string
  role: 'admin' | 'user'
}

export function verifyToken(token: string): JWTPayload {
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload
    return payload
  } catch (error) {
    throw new ApiError(401, 'Invalid token')
  }
}

export async function requireAuth(request: Request) {
  const token = request.headers.get('authorization')?.replace('Bearer ', '')

  if (!token) {
    throw new ApiError(401, 'Missing authorization token')
  }

  return verifyToken(token)
}

// Usage in API route
export async function GET(request: Request) {
  const user = await requireAuth(request)

  const data = await getDataForUser(user.userId)

  return NextResponse.json({ success: true, data })
}
```

<!-- GET 里先 requireAuth 得到 user，再按 user.userId 取数据。 -->

### Role-Based Access Control

<!-- 子节：基于角色的访问控制——角色与权限映射，requirePermission 高阶函数校验权限后再执行 handler。 -->

```typescript
type Permission = 'read' | 'write' | 'delete' | 'admin'

interface User {
  id: string
  role: 'admin' | 'moderator' | 'user'
}

const rolePermissions: Record<User['role'], Permission[]> = {
  admin: ['read', 'write', 'delete', 'admin'],
  moderator: ['read', 'write', 'delete'],
  user: ['read', 'write']
}

export function hasPermission(user: User, permission: Permission): boolean {
  return rolePermissions[user.role].includes(permission)
}

export function requirePermission(permission: Permission) {
  return (handler: (request: Request, user: User) => Promise<Response>) => {
    return async (request: Request) => {
      const user = await requireAuth(request)

      if (!hasPermission(user, permission)) {
        throw new ApiError(403, 'Insufficient permissions')
      }

      return handler(request, user)
    }
  }
}

// Usage - HOF wraps the handler
export const DELETE = requirePermission('delete')(
  async (request: Request, user: User) => {
    // Handler receives authenticated user with verified permission
    return new Response('Deleted', { status: 200 })
  }
)
```

<!-- requirePermission('delete') 返回包装函数，内部检查 hasPermission 再调用业务 handler。 -->

## Rate Limiting

<!-- 小节：限流。 -->

### Simple In-Memory Rate Limiter

<!-- 子节：简单内存限流——按 identifier（如 IP）在滑动窗口内计数，超限返回 429。 -->

```typescript
class RateLimiter {
  private requests = new Map<string, number[]>()

  async checkLimit(
    identifier: string,
    maxRequests: number,
    windowMs: number
  ): Promise<boolean> {
    const now = Date.now()
    const requests = this.requests.get(identifier) || []

    // Remove old requests outside window
    const recentRequests = requests.filter(time => now - time < windowMs)

    if (recentRequests.length >= maxRequests) {
      return false  // Rate limit exceeded
    }

    // Add current request
    recentRequests.push(now)
    this.requests.set(identifier, recentRequests)

    return true
  }
}

const limiter = new RateLimiter()

export async function GET(request: Request) {
  const ip = request.headers.get('x-forwarded-for') || 'unknown'

  const allowed = await limiter.checkLimit(ip, 100, 60000)  // 100 req/min

  if (!allowed) {
    return NextResponse.json({
      error: 'Rate limit exceeded'
    }, { status: 429 })
  }

  // Continue with request
}
```

<!-- checkLimit(ip, 100, 60000) 表示每 IP 每分钟最多 100 次。 -->

## Background Jobs & Queues

<!-- 小节：后台任务与队列。 -->

### Simple Queue Pattern

<!-- 子节：简单队列——add 入队并触发 process，process 循环取 job 执行，失败只打日志。 -->

```typescript
class JobQueue<T> {
  private queue: T[] = []
  private processing = false

  async add(job: T): Promise<void> {
    this.queue.push(job)

    if (!this.processing) {
      this.process()
    }
  }

  private async process(): Promise<void> {
    this.processing = true

    while (this.queue.length > 0) {
      const job = this.queue.shift()!

      try {
        await this.execute(job)
      } catch (error) {
        console.error('Job failed:', error)
      }
    }

    this.processing = false
  }

  private async execute(job: T): Promise<void> {
    // Job execution logic
  }
}

// Usage for indexing markets
interface IndexJob {
  marketId: string
}

const indexQueue = new JobQueue<IndexJob>()

export async function POST(request: Request) {
  const { marketId } = await request.json()

  // Add to queue instead of blocking
  await indexQueue.add({ marketId })

  return NextResponse.json({ success: true, message: 'Job queued' })
}
```

<!-- POST 只负责把任务入队并立即返回，不阻塞请求。 -->

## Logging & Monitoring

<!-- 小节：日志与监控。 -->

### Structured Logging

<!-- 子节：结构化日志——JSON 输出，带 timestamp、level、message 和上下文，便于采集与检索。 -->

```typescript
interface LogContext {
  userId?: string
  requestId?: string
  method?: string
  path?: string
  [key: string]: unknown
}

class Logger {
  log(level: 'info' | 'warn' | 'error', message: string, context?: LogContext) {
    const entry = {
      timestamp: new Date().toISOString(),
      level,
      message,
      ...context
    }

    console.log(JSON.stringify(entry))
  }

  info(message: string, context?: LogContext) {
    this.log('info', message, context)
  }

  warn(message: string, context?: LogContext) {
    this.log('warn', message, context)
  }

  error(message: string, error: Error, context?: LogContext) {
    this.log('error', message, {
      ...context,
      error: error.message,
      stack: error.stack
    })
  }
}

const logger = new Logger()

// Usage
export async function GET(request: Request) {
  const requestId = crypto.randomUUID()

  logger.info('Fetching markets', {
    requestId,
    method: 'GET',
    path: '/api/markets'
  })

  try {
    const markets = await fetchMarkets()
    return NextResponse.json({ success: true, data: markets })
  } catch (error) {
    logger.error('Failed to fetch markets', error as Error, { requestId })
    return NextResponse.json({ error: 'Internal error' }, { status: 500 })
  }
}
```

<!-- 使用 requestId、method、path 等上下文，错误时记录 error 与 stack。 -->

**Remember**: Backend patterns enable scalable, maintainable server-side applications. Choose patterns that fit your complexity level.

<!-- 记住：后端模式用于可扩展、可维护的服务端应用，按项目复杂度选用合适模式。 -->
