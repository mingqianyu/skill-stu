# Test Coverage

<!-- 标题：测试覆盖率。对应 /test-coverage，分析覆盖率并补写缺失的测试，使整体达到 80%+。 -->

Analyze test coverage and generate missing tests:

<!-- 上面：分析当前覆盖率，找出缺口，并生成缺失的测试。 -->

1. Run tests with coverage: npm test --coverage or pnpm test --coverage

   <!-- 第 1 步：先跑带覆盖率收集的测试（npm 或 pnpm 根据项目），生成覆盖率报告。 -->

2. Analyze coverage report (coverage/coverage-summary.json)

   <!-- 第 2 步：解析覆盖率报告，通常用 coverage/coverage-summary.json 或项目配置的路径。 -->

3. Identify files below 80% coverage threshold

   <!-- 第 3 步：找出覆盖率低于 80% 的文件，作为优先补测对象。 -->

4. For each under-covered file:

   <!-- 第 4 步：对每个未达标文件做下面几件事。 -->

   - Analyze untested code paths

     <!-- 分析哪些分支、哪些函数、哪些行还没被测试覆盖。 -->

   - Generate unit tests for functions

     <!-- 为未覆盖的函数生成单元测试。 -->

   - Generate integration tests for APIs

     <!-- 为 API 层生成集成测试（如有需要）。 -->

   - Generate E2E tests for critical flows

     <!-- 对关键用户流程生成 E2E 测试（按需）。 -->

5. Verify new tests pass

   <!-- 第 5 步：跑一遍新写的测试，确认全部通过。 -->

6. Show before/after coverage metrics

   <!-- 第 6 步：展示补测前后的覆盖率对比（如文件级、整体百分比）。 -->

7. Ensure project reaches 80%+ overall coverage

   <!-- 第 7 步：确保项目整体覆盖率达到 80% 以上（若仍不足可继续针对未达标文件补测）。 -->

Focus on:

<!-- 补测时优先覆盖下面几类场景。 -->

- Happy path scenarios

  <!-- 正常路径：主要业务流程、常见入参。 -->

- Error handling

  <!-- 错误处理：抛错、返回错误码、异常分支。 -->

- Edge cases (null, undefined, empty)

  <!-- 边界：null、undefined、空数组/空字符串等。 -->

- Boundary conditions

  <!-- 边界条件：数值上下界、空输入、最大长度等。 -->
