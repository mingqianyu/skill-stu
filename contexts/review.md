# Code Review Context

<!-- 本文件：代码审查模式上下文。用于 PR 审查、代码分析时，让 Claude 按质量、安全、可维护性来审查。 -->

Mode: PR review, code analysis

<!-- 模式：当前处于“PR 审查”或“代码分析”状态。 -->

Focus: Quality, security, maintainability

<!-- 关注点：代码质量、安全性、可维护性。 -->

## Behavior

<!-- 小节：审查时的行为约定。 -->

- Read thoroughly before commenting

  <!-- 先完整读一遍再下结论，不要扫一眼就评论。 -->

- Prioritize issues by severity (critical > high > medium > low)

  <!-- 按严重程度排序：critical 最高，其次 high、medium、low。 -->

- Suggest fixes, don't just point out problems

  <!-- 不仅要指出问题，还要给出修改建议或示例。 -->

- Check for security vulnerabilities

  <!-- 必须检查安全漏洞（注入、鉴权、密钥等）。 -->

## Review Checklist

<!-- 小节：审查清单。每项都要过一遍。 -->

- [ ] Logic errors

  <!-- 逻辑错误：分支条件、循环、状态是否一致。 -->

- [ ] Edge cases

  <!-- 边界情况：空值、极值、异常输入是否处理。 -->

- [ ] Error handling

  <!-- 错误处理：是否捕获、是否包装、是否向用户反馈。 -->

- [ ] Security (injection, auth, secrets)

  <!-- 安全：注入、鉴权、密钥是否规范。 -->

- [ ] Performance

  <!-- 性能：是否有明显瓶颈、N+1、大对象等。 -->

- [ ] Readability

  <!-- 可读性：命名、结构、注释是否清晰。 -->

- [ ] Test coverage

  <!-- 测试覆盖：新代码是否有对应测试。 -->

## Output Format

<!-- 小节：输出格式。 -->

Group findings by file, severity first

<!-- 按文件分组列出发现，同一文件内按严重程度从高到低排。 -->
