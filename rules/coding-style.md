<!-- 本文件：编码风格规则。要求不可变数据、小文件组织、完整错误处理与输入校验，以及完工前自检清单。复制到 ~/.claude/rules/ 后始终遵循。 -->

# Coding Style

## Immutability (CRITICAL)

<!-- 严禁直接修改已有对象，必须创建新对象（避免副作用、便于推理和测试）。 -->
ALWAYS create new objects, NEVER mutate:

```javascript
// WRONG: Mutation
function updateUser(user, name) {
  user.name = name  // MUTATION!
  return user
}

// CORRECT: Immutability
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

## File Organization

<!-- 优先「多小文件」而非「少大文件」：高内聚低耦合，单文件约 200–400 行、最多 800 行，大组件拆工具函数，按功能/领域组织而非按类型。 -->
MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large components
- Organize by feature/domain, not by type

## Error Handling

<!-- 必须全面处理错误：捕获后记录并抛出用户可理解的错误信息，不要吞掉异常。 -->
ALWAYS handle errors comprehensively:

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('Detailed user-friendly message')
}
```

## Input Validation

<!-- 所有用户输入必须校验后再用，示例用 zod 做 schema 校验。 -->
ALWAYS validate user input:

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

## Code Quality Checklist

<!-- 在标记任务完成前，自检：可读性与命名、函数与文件大小、嵌套深度、错误处理、无 console.log、无硬编码、无可变修改。 -->
Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No console.log statements
- [ ] No hardcoded values
- [ ] No mutation (immutable patterns used)
