<!-- 本文件：通用模式规则。约定 API 响应结构、自定义 Hooks（如防抖）、Repository 接口，以及做新功能时如何选型骨架项目。 -->

# Common Patterns

## API Response Format

<!-- 统一 API 响应格式：success、可选 data/error、可选 meta 分页信息。 -->
```typescript
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
```

## Custom Hooks Pattern

<!-- 示例：React 防抖 Hook，避免频繁更新。 -->
```typescript
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}
```

## Repository Pattern

<!-- 数据访问层接口：findAll/findById/create/update/delete，便于抽换实现与测试。 -->
```typescript
interface Repository<T> {
  findAll(filters?: Filters): Promise<T[]>
  findById(id: string): Promise<T | null>
  create(data: CreateDto): Promise<T>
  update(id: string, data: UpdateDto): Promise<T>
  delete(id: string): Promise<void>
}
```

## Skeleton Projects

<!-- 做新功能时：先找久经考验的骨架项目，用并行 agent 评估（安全、可扩展性、相关性、实现计划），克隆最合适者作为基础，在已有结构内迭代。 -->
When implementing new functionality:
1. Search for battle-tested skeleton projects
2. Use parallel agents to evaluate options:
   - Security assessment
   - Extensibility analysis
   - Relevance scoring
   - Implementation planning
3. Clone best match as foundation
4. Iterate within proven structure
