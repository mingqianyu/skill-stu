---
description: Enforce test-driven development workflow. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage.
---

<!-- frontmatter：description 概括本命令——强制 TDD 流程、先测试后实现、80%+ 覆盖率。 -->

# TDD Command

<!-- 标题：TDD 命令。对应 /tdd。 -->

This command invokes the **tdd-guide** agent to enforce test-driven development methodology.

<!-- 上面：本命令会调用 tdd-guide 子代理，由它来执行并监督“测试驱动开发”的流程。 -->

## What This Command Does

<!-- 小节：本命令做哪几件事。 -->

1. **Scaffold Interfaces** - Define types/interfaces first

   <!-- 先搭接口：把要实现的函数/组件的输入输出类型、接口定义好，再写测试。 -->

2. **Generate Tests First** - Write failing tests (RED)

   <!-- 先写测试：写出会“失败”的测试（因为实现还不存在），即 RED 阶段。 -->

3. **Implement Minimal Code** - Write just enough to pass (GREEN)

   <!-- 最小实现：只写能让测试通过的最少代码，即 GREEN 阶段。 -->

4. **Refactor** - Improve code while keeping tests green (REFACTOR)

   <!-- 重构：在测试保持通过的前提下改进结构、命名、性能等，即 REFACTOR 阶段。 -->

5. **Verify Coverage** - Ensure 80%+ test coverage

   <!-- 验证覆盖率：跑覆盖率，确保达到 80% 以上，不足则补测。 -->

## When to Use

<!-- 小节：何时使用 /tdd。 -->

Use `/tdd` when:

- Implementing new features

  <!-- 在做新功能时，用 TDD 保证可测试、可回归。 -->

- Adding new functions/components

  <!-- 在加新函数或新组件时。 -->

- Fixing bugs (write test that reproduces bug first)

  <!-- 修 bug 时：先写一个“能复现该 bug”的失败测试，再修到通过。 -->

- Refactoring existing code

  <!-- 重构已有代码时：先有测试再改，避免改坏。 -->

- Building critical business logic

  <!-- 写关键业务逻辑时：必须测试覆盖。 -->

## How It Works

<!-- 小节：具体怎么执行。tdd-guide 子代理会按下面 7 步做。 -->

The tdd-guide agent will:

1. **Define interfaces** for inputs/outputs

   <!-- 定义输入输出的类型/接口（函数签名、数据结构）。 -->

2. **Write tests that will FAIL** (because code doesn't exist yet)

   <!-- 写会失败的测试（此时实现还不存在，所以测试应失败）。 -->

3. **Run tests** and verify they fail for the right reason

   <!-- 跑测试，确认失败原因是“未实现”而不是测试写错。 -->

4. **Write minimal implementation** to make tests pass

   <!-- 写最小实现，让测试通过。 -->

5. **Run tests** and verify they pass

   <!-- 再跑测试，确认通过。 -->

6. **Refactor** code while keeping tests green

   <!-- 重构代码，过程中测试始终保持通过。 -->

7. **Check coverage** and add more tests if below 80%

   <!-- 检查覆盖率，若低于 80% 则补充测试。 -->

## TDD Cycle

<!-- 小节：TDD 循环。四个阶段循环进行。 -->

```
RED → GREEN → REFACTOR → REPEAT

RED:      Write a failing test
GREEN:    Write minimal code to pass
REFACTOR: Improve code, keep tests passing
REPEAT:   Next feature/scenario
```

<!-- 上面：RED 写失败测试 → GREEN 写最少代码通过 → REFACTOR 改进且保持绿 → REPEAT 下一个需求/场景。 -->

## Example Usage

```
User: /tdd I need a function to calculate market liquidity score

Agent (tdd-guide):
# TDD Session: Market Liquidity Score Calculator

## Step 1: Define Interface (SCAFFOLD)

```typescript
// lib/liquidity.ts
export interface MarketData {
  totalVolume: number
  bidAskSpread: number
  activeTraders: number
  lastTradeTime: Date
}

export function calculateLiquidityScore(market: MarketData): number {
  // TODO: Implementation
  throw new Error('Not implemented')
}
```

## Step 2: Write Failing Test (RED)

```typescript
// lib/liquidity.test.ts
import { calculateLiquidityScore } from './liquidity'

describe('calculateLiquidityScore', () => {
  it('should return high score for liquid market', () => {
    const market = {
      totalVolume: 100000,
      bidAskSpread: 0.01,
      activeTraders: 500,
      lastTradeTime: new Date()
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBeGreaterThan(80)
    expect(score).toBeLessThanOrEqual(100)
  })

  it('should return low score for illiquid market', () => {
    const market = {
      totalVolume: 100,
      bidAskSpread: 0.5,
      activeTraders: 2,
      lastTradeTime: new Date(Date.now() - 86400000) // 1 day ago
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBeLessThan(30)
    expect(score).toBeGreaterThanOrEqual(0)
  })

  it('should handle edge case: zero volume', () => {
    const market = {
      totalVolume: 0,
      bidAskSpread: 0,
      activeTraders: 0,
      lastTradeTime: new Date()
    }

    const score = calculateLiquidityScore(market)

    expect(score).toBe(0)
  })
})
```

## Step 3: Run Tests - Verify FAIL

```bash
npm test lib/liquidity.test.ts

FAIL lib/liquidity.test.ts
  ✕ should return high score for liquid market (2 ms)
    Error: Not implemented

1 test failed, 0 passed
```

✅ Tests fail as expected. Ready to implement.

## Step 4: Implement Minimal Code (GREEN)

```typescript
// lib/liquidity.ts
export function calculateLiquidityScore(market: MarketData): number {
  // Handle zero volume edge case
  if (market.totalVolume === 0) {
    return 0
  }

  // Calculate component scores (0-100 scale)
  const volumeScore = Math.min(market.totalVolume / 1000, 100)
  const spreadScore = Math.max(100 - (market.bidAskSpread * 1000), 0)
  const traderScore = Math.min(market.activeTraders / 10, 100)

  // Recent activity bonus
  const hoursSinceLastTrade = (Date.now() - market.lastTradeTime.getTime()) / (1000 * 60 * 60)
  const recencyScore = Math.max(100 - (hoursSinceLastTrade * 10), 0)

  // Weighted average
  const score = (
    volumeScore * 0.4 +
    spreadScore * 0.3 +
    traderScore * 0.2 +
    recencyScore * 0.1
  )

  return Math.min(Math.max(score, 0), 100) // Clamp to 0-100
}
```

## Step 5: Run Tests - Verify PASS

```bash
npm test lib/liquidity.test.ts

PASS lib/liquidity.test.ts
  ✓ should return high score for liquid market (3 ms)
  ✓ should return low score for illiquid market (2 ms)
  ✓ should handle edge case: zero volume (1 ms)

3 tests passed
```

✅ All tests passing!

## Step 6: Refactor (IMPROVE)

```typescript
// lib/liquidity.ts - Refactored with constants and better readability
const WEIGHTS = {
  VOLUME: 0.4,
  SPREAD: 0.3,
  TRADERS: 0.2,
  RECENCY: 0.1,
} as const

const SCALE_FACTORS = {
  VOLUME: 1000,
  SPREAD: 1000,
  TRADERS: 10,
  RECENCY_PENALTY: 10,
} as const

function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max)
}

export function calculateLiquidityScore(market: MarketData): number {
  if (market.totalVolume === 0) return 0

  const volumeScore = Math.min(market.totalVolume / SCALE_FACTORS.VOLUME, 100)
  const spreadScore = clamp(100 - (market.bidAskSpread * SCALE_FACTORS.SPREAD), 0, 100)
  const traderScore = Math.min(market.activeTraders / SCALE_FACTORS.TRADERS, 100)

  const hoursSinceLastTrade = (Date.now() - market.lastTradeTime.getTime()) / (1000 * 60 * 60)
  const recencyScore = clamp(100 - (hoursSinceLastTrade * SCALE_FACTORS.RECENCY_PENALTY), 0, 100)

  const weightedScore =
    volumeScore * WEIGHTS.VOLUME +
    spreadScore * WEIGHTS.SPREAD +
    traderScore * WEIGHTS.TRADERS +
    recencyScore * WEIGHTS.RECENCY

  return clamp(weightedScore, 0, 100)
}
```

## Step 7: Verify Tests Still Pass

```bash
npm test lib/liquidity.test.ts

PASS lib/liquidity.test.ts
  ✓ should return high score for liquid market (3 ms)
  ✓ should return low score for illiquid market (2 ms)
  ✓ should handle edge case: zero volume (1 ms)

3 tests passed
```

✅ Refactoring complete, tests still passing!

## Step 8: Check Coverage

```bash
npm test -- --coverage lib/liquidity.test.ts

File           | % Stmts | % Branch | % Funcs | % Lines
---------------|---------|----------|---------|--------
liquidity.ts   |   100   |   100    |   100   |   100

Coverage: 100% ✅ (Target: 80%)
```

✅ TDD session complete!
```

## TDD Best Practices

**DO:**
- ✅ Write the test FIRST, before any implementation
- ✅ Run tests and verify they FAIL before implementing
- ✅ Write minimal code to make tests pass
- ✅ Refactor only after tests are green
- ✅ Add edge cases and error scenarios
- ✅ Aim for 80%+ coverage (100% for critical code)

**DON'T:**
- ❌ Write implementation before tests
- ❌ Skip running tests after each change
- ❌ Write too much code at once
- ❌ Ignore failing tests
- ❌ Test implementation details (test behavior)
- ❌ Mock everything (prefer integration tests)

## Test Types to Include

**Unit Tests** (Function-level):
- Happy path scenarios
- Edge cases (empty, null, max values)
- Error conditions
- Boundary values

**Integration Tests** (Component-level):
- API endpoints
- Database operations
- External service calls
- React components with hooks

**E2E Tests** (use `/e2e` command):
- Critical user flows
- Multi-step processes
- Full stack integration

## Coverage Requirements

- **80% minimum** for all code
- **100% required** for:
  - Financial calculations
  - Authentication logic
  - Security-critical code
  - Core business logic

## Important Notes

**MANDATORY**: Tests must be written BEFORE implementation. The TDD cycle is:

1. **RED** - Write failing test
2. **GREEN** - Implement to pass
3. **REFACTOR** - Improve code

Never skip the RED phase. Never write code before tests.

## Integration with Other Commands

- Use `/plan` first to understand what to build
- Use `/tdd` to implement with tests
- Use `/build-and-fix` if build errors occur
- Use `/code-review` to review implementation
- Use `/test-coverage` to verify coverage

## Related Agents

This command invokes the `tdd-guide` agent located at:
`~/.claude/agents/tdd-guide.md`

And can reference the `tdd-workflow` skill at:
`~/.claude/skills/tdd-workflow/`
