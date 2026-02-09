<!-- 本文件：测试要求。最低 80% 覆盖率、单元/集成/E2E 三类都要、强制 TDD 流程、测试失败时的排查与可用 agent。 -->

# Testing Requirements

## Minimum Test Coverage: 80%

<!-- 三类测试均需要：单元（函数/工具/组件）、集成（API/数据库）、E2E（关键用户流程，用 Playwright）。 -->
Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows (Playwright)

## Test-Driven Development

<!-- 强制流程：先写失败测试（RED）→ 最小实现让测试通过（GREEN）→ 重构（IMPROVE）→ 确认覆盖率 ≥80%。 -->
MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Troubleshooting Test Failures

<!-- 测试失败时：用 tdd-guide、检查隔离与 mock、优先改实现而非改测试（除非测试本身写错）。 -->
1. Use **tdd-guide** agent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

## Agent Support

<!-- tdd-guide：新功能时主动用，强制先写测试；e2e-runner：Playwright E2E 专项。 -->
- **tdd-guide** - Use PROACTIVELY for new features, enforces write-tests-first
- **e2e-runner** - Playwright E2E testing specialist
