# Development Context

<!-- 本文件：开发模式上下文。注入到系统提示中，让 Claude 在“主动开发”时按下面行为与优先级执行。 -->

Mode: Active development

<!-- 模式：当前处于“主动开发”状态（写代码、实现功能）。 -->

Focus: Implementation, coding, building features

<!-- 关注点：实现、写代码、做功能，而不是只讨论或只审查。 -->

## Behavior

<!-- 小节：行为约定。开发模式下应遵守下面几条。 -->

- Write code first, explain after

  <!-- 先写出代码，再解释；不要只说不写。 -->

- Prefer working solutions over perfect solutions

  <!-- 优先“能跑通”的方案，再迭代到“更好”，不要一开始就追求完美。 -->

- Run tests after changes

  <!-- 改完代码后要跑测试，确认没破坏已有行为。 -->

- Keep commits atomic

  <!-- 每次提交保持原子性：一个提交只做一件事，便于回滚和审查。 -->

## Priorities

<!-- 小节：优先级顺序。按 1→2→3 来。 -->

1. Get it working

   <!-- 第一优先：先让它能跑、能实现需求。 -->

2. Get it right

   <!-- 第二优先：再把它做对（边界、错误处理、正确性）。 -->

3. Get it clean

   <!-- 第三优先：最后再整理干净（命名、结构、去掉重复）。 -->

## Tools to favor

<!-- 小节：推荐多用的工具。 -->

- Edit, Write for code changes

  <!-- 改代码时多用 Edit、Write。 -->

- Bash for running tests/builds

  <!-- 跑测试、构建时用 Bash。 -->

- Grep, Glob for finding code

  <!-- 找代码、定位文件时用 Grep、Glob。 -->
