# Refactor Clean

<!-- 标题：重构与清理。对应斜杠命令 /refactor-clean。 -->

Safely identify and remove dead code with test verification:

<!-- 上面：在「有测试验证」的前提下，安全地识别并移除死代码（未使用的代码、导出、依赖）。 -->

1. Run dead code analysis tools:

   <!-- 第 1 步：运行下面几种死代码分析工具，收集可能可删的项。 -->

   - knip: Find unused exports and files

     <!-- knip：找出未被引用的导出和整文件未使用的文件。 -->

   - depcheck: Find unused dependencies

     <!-- depcheck：找出 package.json 里声明但代码里没用的依赖。 -->

   - ts-prune: Find unused TypeScript exports

     <!-- ts-prune：找出 TypeScript 里未被使用的导出。 -->

2. Generate comprehensive report in .reports/dead-code-analysis.md

   <!-- 第 2 步：把分析结果写成完整报告，保存到 .reports/dead-code-analysis.md，便于人工确认。 -->

3. Categorize findings by severity:

   <!-- 第 3 步：按「删除风险」把结果分成三档，只对低风险的做自动删除建议。 -->

   - SAFE: Test files, unused utilities

     <!-- SAFE（安全可删）：例如仅测试用的文件、明确未使用的工具函数。 -->

   - CAUTION: API routes, components

     <!-- CAUTION（需谨慎）：例如 API 路由、组件，可能被动态引用，要人工确认。 -->

   - DANGER: Config files, main entry points

     <!-- DANGER（危险）：例如配置文件、入口文件，很可能被间接依赖，不要自动删。 -->

4. Propose safe deletions only

   <!-- 第 4 步：只提议 SAFE 档的删除；CAUTION/DANGER 仅列出供人工决定。 -->

5. Before each deletion:

   <!-- 第 5 步：每执行一次实际删除前，必须按下面顺序做，任一步失败就回滚。 -->

   - Run full test suite

     <!-- 先跑完整测试套件，确认当前全部通过。 -->

   - Verify tests pass

     <!-- 确认测试确实通过。 -->

   - Apply change

     <!-- 再应用本次删除（只删一处或一个文件）。 -->

   - Re-run tests

     <!-- 删除后再跑一遍全量测试。 -->

   - Rollback if tests fail

     <!-- 若删除后测试失败，立即回滚这次删除。 -->

6. Show summary of cleaned items

   <!-- 第 6 步：全部完成后，列出本次清理了哪些文件/导出/依赖的汇总。 -->

Never delete code without running tests first!

<!-- 最后一句：绝不能在不先跑测试的情况下删代码；先测、再删、再测，失败就回滚。 -->
