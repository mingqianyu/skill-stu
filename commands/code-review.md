# Code Review

<!-- 标题：代码审查。对应斜杠命令 /code-review。 -->

Comprehensive security and quality review of uncommitted changes:

<!-- 上面：对「未提交的变更」做全面的安全与质量审查（不审查已提交的历史）。 -->

1. Get changed files: git diff --name-only HEAD

   <!-- 第 1 步：用 git diff --name-only HEAD 得到当前相对 HEAD 改了哪些文件（只列文件名）。 -->

2. For each changed file, check for:

   <!-- 第 2 步：对每个被改动的文件，按下面三类逐项检查。 -->

**Security Issues (CRITICAL):**

<!-- 安全类问题，级别 CRITICAL：发现任一项都必须修，不能提交。 -->

- Hardcoded credentials, API keys, tokens

  <!-- 硬编码的凭证、API 密钥、token 等敏感信息。 -->

- SQL injection vulnerabilities

  <!-- SQL 注入：用拼接字符串拼 SQL 等。 -->

- XSS vulnerabilities

  <!-- 跨站脚本：未转义的用户输入输出到页面。 -->

- Missing input validation

  <!-- 缺少输入校验：用户/外部输入未校验就使用。 -->

- Insecure dependencies

  <!-- 不安全的依赖：有过期或有漏洞的包。 -->

- Path traversal risks

  <!-- 路径穿越：用户可控路径直接用于读文件等。 -->

**Code Quality (HIGH):**

<!-- 代码质量类，级别 HIGH：应尽量在提交前修。 -->

- Functions > 50 lines

  <!-- 单个函数超过 50 行。 -->

- Files > 800 lines

  <!-- 单文件超过 800 行。 -->

- Nesting depth > 4 levels

  <!-- 嵌套层级超过 4 层（if/for 等）。 -->

- Missing error handling

  <!-- 可能抛错的地方没有 try/catch 或等价处理。 -->

- console.log statements

  <!-- 遗留的 console.log。 -->

- TODO/FIXME comments

  <!-- 未跟进的 TODO/FIXME 注释。 -->

- Missing JSDoc for public APIs

  <!-- 对外暴露的 API 没有 JSDoc。 -->

**Best Practices (MEDIUM):**

<!-- 最佳实践类，级别 MEDIUM：建议改，不强制阻塞。 -->

- Mutation patterns (use immutable instead)

  <!-- 直接改可变对象，应改为不可变写法（如展开运算）。 -->

- Emoji usage in code/comments

  <!-- 在代码或注释里用 emoji。 -->

- Missing tests for new code

  <!-- 新增代码没有对应测试。 -->

- Accessibility issues (a11y)

  <!-- 可访问性问题：缺 ARIA、对比度等。 -->

3. Generate report with:

   <!-- 第 3 步：生成报告时，每条问题必须包含下面 4 项。 -->

   - Severity: CRITICAL, HIGH, MEDIUM, LOW

     <!-- 严重程度：四档之一。 -->

   - File location and line numbers

     <!-- 文件路径和行号，便于定位。 -->

   - Issue description

     <!-- 问题描述：具体是什么问题。 -->

   - Suggested fix

     <!-- 建议的修复方式或示例代码。 -->

4. Block commit if CRITICAL or HIGH issues found

   <!-- 第 4 步：若存在 CRITICAL 或 HIGH 问题，要阻止用户提交（明确提示必须修完再提交）。 -->

Never approve code with security vulnerabilities!

<!-- 最后一句：只要存在安全漏洞就绝不能批准/通过审查。 -->
