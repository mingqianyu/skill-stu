---
name: coding-standards
description: Universal coding standards, best practices, and patterns for TypeScript, JavaScript, React, and Node.js development.
---

<!-- 本技能：通用编码规范。适用于 TypeScript/JavaScript/React/Node.js 的可读性、简洁、DRY、类型与测试等。 -->

# Coding Standards & Best Practices

Universal coding standards applicable across all projects.

<!-- 适用于所有项目的通用编码标准。 -->

## Code Quality Principles

<!-- 小节：代码质量原则。 -->

### 1. Readability First

<!-- 可读性优先：代码被读多于写，命名清晰、自解释、格式一致。 -->
- Code is read more than written
- Clear variable and function names
- Self-documenting code preferred over comments
- Consistent formatting

### 2. KISS (Keep It Simple, Stupid)

<!-- 保持简单：能用最简单方案就用，避免过度设计、过早优化。 -->
- Simplest solution that works
- Avoid over-engineering
- No premature optimization
- Easy to understand > clever code

### 3. DRY (Don't Repeat Yourself)

<!-- 不重复：公共逻辑抽成函数/组件/工具，避免复制粘贴。 -->
- Extract common logic into functions
- Create reusable components
- Share utilities across modules
- Avoid copy-paste programming

### 4. YAGNI (You Aren't Gonna Need It)

<!-- 不需要就别做：不为臆想需求提前实现，需要时再加复杂度。 -->
- Don't build features before they're needed
- Avoid speculative generality
- Add complexity only when required
- Start simple, refactor when needed

## TypeScript/JavaScript Standards

<!-- 小节：TS/JS 规范。 -->

### Variable Naming

<!-- 变量命名：见名知意，布尔用 is/has 等前缀。 -->

```typescript
// ✅ GOOD: Descriptive names
const marketSearchQuery = 'election'
const isUserAuthenticated = true
const totalRevenue = 1000

// ❌ BAD: Unclear names
const q = 'election'
const flag = true
const x = 1000
```

<!-- 避免单字母、模糊命名。 -->

### Function Naming

<!-- 函数命名：动词+名词，如 fetchMarketData、calculateSimilarity、isValidEmail。 -->

```typescript
// ✅ GOOD: Verb-noun pattern
async function fetchMarketData(marketId: string) { }
function calculateSimilarity(a: number[], b: number[]) { }
function isValidEmail(email: string): boolean { }

// ❌ BAD: Unclear or noun-only
async function market(id: string) { }
function similarity(a, b) { }
function email(e) { }
```

<!-- 避免只用名词或含义不清。 -->

### Immutability Pattern (CRITICAL)

<!-- 不可变优先：用展开运算符生成新对象/数组，禁止直接改原对象/数组。 -->

```typescript
// ✅ ALWAYS use spread operator
const updatedUser = {
  ...user,
  name: 'New Name'
}

const updatedArray = [...items, newItem]

// ❌ NEVER mutate directly
user.name = 'New Name'  // BAD
items.push(newItem)     // BAD
```

<!-- 直接修改 user/items 会导致难以追踪的副作用。 -->

### Error Handling

<!-- 错误处理：检查 response.ok、抛错或包装、catch 里打日志再抛。 -->

```typescript
// ✅ GOOD: Comprehensive error handling
async function fetchData(url: string) {
  try {
    const response = await fetch(url)

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }

    return await response.json()
  } catch (error) {
    console.error('Fetch failed:', error)
    throw new Error('Failed to fetch data')
  }
}

// ❌ BAD: No error handling
async function fetchData(url) {
  const response = await fetch(url)
  return response.json()
}
```

<!-- 不处理 HTTP 错误和 JSON 解析错误会导致静默失败。 -->

### Async/Await Best Practices

<!-- 无依赖的异步用 Promise.all 并行，避免不必要串行。 -->

```typescript
// ✅ GOOD: Parallel execution when possible
const [users, markets, stats] = await Promise.all([
  fetchUsers(),
  fetchMarkets(),
  fetchStats()
])

// ❌ BAD: Sequential when unnecessary
const users = await fetchUsers()
const markets = await fetchMarkets()
const stats = await fetchStats()
```

<!-- 三个请求无依赖时可并行，缩短总耗时。 -->

### Type Safety

<!-- 类型安全：为接口、参数、返回值定义类型，避免 any。 -->

```typescript
// ✅ GOOD: Proper types
interface Market {
  id: string
  name: string
  status: 'active' | 'resolved' | 'closed'
  created_at: Date
}

function getMarket(id: string): Promise<Market> {
  // Implementation
}

// ❌ BAD: Using 'any'
function getMarket(id: any): Promise<any> {
  // Implementation
}
```

## React Best Practices

<!-- 小节：React 实践。 -->

### Component Structure

<!-- 组件结构：函数组件 + 明确 Props 类型，默认值解构。 -->

```typescript
// ✅ GOOD: Functional component with types
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

export function Button({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}

// ❌ BAD: No types, unclear structure
export function Button(props) {
  return <button onClick={props.onClick}>{props.children}</button>
}
```

<!-- 避免无类型、无结构的 props。 -->

### Custom Hooks

<!-- 自定义 Hook：封装可复用逻辑，如 useDebounce。 -->

```typescript
// ✅ GOOD: Reusable custom hook
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value)
    }, delay)

    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}

// Usage
const debouncedQuery = useDebounce(searchQuery, 500)
```

<!-- 使用方只需传入值和延迟。 -->

### State Management

<!-- 状态更新：依赖前值的用函数式 setState(prev => ...)，避免闭包陈旧值。 -->

```typescript
// ✅ GOOD: Proper state updates
const [count, setCount] = useState(0)

// Functional update for state based on previous state
setCount(prev => prev + 1)

// ❌ BAD: Direct state reference
setCount(count + 1)  // Can be stale in async scenarios
```

<!-- 异步或批量更新时 count 可能不是最新。 -->

### Conditional Rendering

<!-- 条件渲染：用 && 链式展示加载/错误/数据，避免深层三元。 -->

```typescript
// ✅ GOOD: Clear conditional rendering
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}

// ❌ BAD: Ternary hell
{isLoading ? <Spinner /> : error ? <ErrorMessage error={error} /> : data ? <DataDisplay data={data} /> : null}
```

<!-- 多重三元可读性差，易出错。 -->

## API Design Standards

<!-- 小节：API 设计规范。 -->

### REST API Conventions

<!-- REST 约定：资源 URL + 动词语义，过滤用查询参数。 -->

```
GET    /api/markets              # List all markets
GET    /api/markets/:id          # Get specific market
POST   /api/markets              # Create new market
PUT    /api/markets/:id          # Update market (full)
PATCH  /api/markets/:id          # Update market (partial)
DELETE /api/markets/:id          # Delete market

# Query parameters for filtering
GET /api/markets?status=active&limit=10&offset=0
```

### Response Format

<!-- 统一响应结构：success、data/error、可选 meta 分页。 -->

```typescript
// ✅ GOOD: Consistent response structure
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}

// Success response
return NextResponse.json({
  success: true,
  data: markets,
  meta: { total: 100, page: 1, limit: 10 }
})

// Error response
return NextResponse.json({
  success: false,
  error: 'Invalid request'
}, { status: 400 })
```

### Input Validation

<!-- 用 Zod 等 schema 校验请求体，校验失败返回 400 与 details。 -->

```typescript
import { z } from 'zod'

// ✅ GOOD: Schema validation
const CreateMarketSchema = z.object({
  name: z.string().min(1).max(200),
  description: z.string().min(1).max(2000),
  endDate: z.string().datetime(),
  categories: z.array(z.string()).min(1)
})

export async function POST(request: Request) {
  const body = await request.json()

  try {
    const validated = CreateMarketSchema.parse(body)
    // Proceed with validated data
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json({
        success: false,
        error: 'Validation failed',
        details: error.errors
      }, { status: 400 })
    }
  }
}
```

## File Organization

<!-- 小节：文件组织。 -->

### Project Structure

<!-- 推荐目录：app/api、components、hooks、lib、types、styles 等。 -->

```
src/
├── app/                    # Next.js App Router
│   ├── api/               # API routes
│   ├── markets/           # Market pages
│   └── (auth)/           # Auth pages (route groups)
├── components/            # React components
│   ├── ui/               # Generic UI components
│   ├── forms/            # Form components
│   └── layouts/          # Layout components
├── hooks/                # Custom React hooks
├── lib/                  # Utilities and configs
│   ├── api/             # API clients
│   ├── utils/           # Helper functions
│   └── constants/       # Constants
├── types/                # TypeScript types
└── styles/              # Global styles
```

### File Naming

<!-- 组件 PascalCase，hook 用 use 前缀，工具/类型 camelCase。 -->

```
components/Button.tsx          # PascalCase for components
hooks/useAuth.ts              # camelCase with 'use' prefix
lib/formatDate.ts             # camelCase for utilities
types/market.types.ts         # camelCase with .types suffix
```

## Comments & Documentation

<!-- 小节：注释与文档。 -->

### When to Comment

<!-- 注释解释“为什么”而不是“做了什么”；避免废话注释。 -->

```typescript
// ✅ GOOD: Explain WHY, not WHAT
// Use exponential backoff to avoid overwhelming the API during outages
const delay = Math.min(1000 * Math.pow(2, retryCount), 30000)

// Deliberately using mutation here for performance with large arrays
items.push(newItem)

// ❌ BAD: Stating the obvious
// Increment counter by 1
count++

// Set name to user's name
name = user.name
```

### JSDoc for Public APIs

<!-- 对外 API 用 JSDoc：描述、@param、@returns、@throws、@example。 -->

```typescript
/**
 * Searches markets using semantic similarity.
 *
 * @param query - Natural language search query
 * @param limit - Maximum number of results (default: 10)
 * @returns Array of markets sorted by similarity score
 * @throws {Error} If OpenAI API fails or Redis unavailable
 *
 * @example
 * ```typescript
 * const results = await searchMarkets('election', 5)
 * console.log(results[0].name) // "Trump vs Biden"
 * ```
 */
export async function searchMarkets(
  query: string,
  limit: number = 10
): Promise<Market[]> {
  // Implementation
}
```

## Performance Best Practices

<!-- 小节：性能实践。 -->

### Memoization

<!-- 用 useMemo 缓存重计算、useCallback 缓存回调，避免多余渲染。 -->

```typescript
import { useMemo, useCallback } from 'react'

// ✅ GOOD: Memoize expensive computations
const sortedMarkets = useMemo(() => {
  return markets.sort((a, b) => b.volume - a.volume)
}, [markets])

// ✅ GOOD: Memoize callbacks
const handleSearch = useCallback((query: string) => {
  setSearchQuery(query)
}, [])
```

### Lazy Loading

<!-- 重组件用 lazy + Suspense 按需加载，fallback 显示加载态。 -->

```typescript
import { lazy, Suspense } from 'react'

// ✅ GOOD: Lazy load heavy components
const HeavyChart = lazy(() => import('./HeavyChart'))

export function Dashboard() {
  return (
    <Suspense fallback={<Spinner />}>
      <HeavyChart />
    </Suspense>
  )
}
```

### Database Queries

```typescript
// ✅ GOOD: Select only needed columns
const { data } = await supabase
  .from('markets')
  .select('id, name, status')
  .limit(10)

// ❌ BAD: Select everything
const { data } = await supabase
  .from('markets')
  .select('*')
```

<!-- 只 select 需要的列，减少 IO 与序列化。 -->

## Testing Standards

<!-- 小节：测试规范。 -->

### Test Structure (AAA Pattern)

<!-- 测试结构：Arrange 准备、Act 执行、Assert 断言。 -->

```typescript
test('calculates similarity correctly', () => {
  // Arrange
  const vector1 = [1, 0, 0]
  const vector2 = [0, 1, 0]

  // Act
  const similarity = calculateCosineSimilarity(vector1, vector2)

  // Assert
  expect(similarity).toBe(0)
})
```

### Test Naming

```typescript
// ✅ GOOD: Descriptive test names
test('returns empty array when no markets match query', () => { })
test('throws error when OpenAI API key is missing', () => { })
test('falls back to substring search when Redis unavailable', () => { })

// ❌ BAD: Vague test names
test('works', () => { })
test('test search', () => { })
```

<!-- 测试名应描述场景与预期。 -->

## Code Smell Detection

Watch for these anti-patterns:

<!-- 注意以下反模式。 -->

### 1. Long Functions

<!-- 过长函数：拆成多个小函数，单一职责。 -->
```typescript
// ❌ BAD: Function > 50 lines
function processMarketData() {
  // 100 lines of code
}

// ✅ GOOD: Split into smaller functions
function processMarketData() {
  const validated = validateData()
  const transformed = transformData(validated)
  return saveData(transformed)
}
```

### 2. Deep Nesting

<!-- 深层嵌套：用早退（early return）扁平化，避免 5 层以上 if。 -->

```typescript
// ❌ BAD: 5+ levels of nesting
if (user) {
  if (user.isAdmin) {
    if (market) {
      if (market.isActive) {
        if (hasPermission) {
          // Do something
        }
      }
    }
  }
}

// ✅ GOOD: Early returns
if (!user) return
if (!user.isAdmin) return
if (!market) return
if (!market.isActive) return
if (!hasPermission) return

// Do something
```

### 3. Magic Numbers

<!-- 魔法数字：提取为命名常量，如 MAX_RETRIES、DEBOUNCE_DELAY_MS。 -->
```typescript
// ❌ BAD: Unexplained numbers
if (retryCount > 3) { }
setTimeout(callback, 500)

// ✅ GOOD: Named constants
const MAX_RETRIES = 3
const DEBOUNCE_DELAY_MS = 500

if (retryCount > MAX_RETRIES) { }
setTimeout(callback, DEBOUNCE_DELAY_MS)
```

**Remember**: Code quality is not negotiable. Clear, maintainable code enables rapid development and confident refactoring.

<!-- 记住：代码质量不可妥协；清晰可维护的代码才能快速迭代、放心重构。 -->
