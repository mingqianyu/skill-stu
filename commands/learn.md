# /learn - Extract Reusable Patterns

<!-- 标题：从会话中提取可复用模式。对应 /learn，把当前对话里值得复用的做法写成技能文件，存到 ~/.claude/skills/learned/。 -->

Analyze the current session and extract any patterns worth saving as skills.

<!-- 上面：分析当前这场会话，把“值得以后复用”的模式提取出来，保存成 skill 文件。 -->

## Trigger

<!-- 小节：何时运行。 -->

Run `/learn` at any point during a session when you've solved a non-trivial problem.

<!-- 在会话中，当你刚解决完一个“非 trivial”的问题后，随时可以跑 /learn 做一次提取。 -->

## What to Extract

<!-- 小节：提取什么。下面四类都值得写成技能。 -->

Look for:

1. **Error Resolution Patterns**

   <!-- 第 1 类：错误解决模式。即“遇到某类错 → 根因是什么 → 怎么修”的可复用套路。 -->

   - What error occurred?

     <!-- 当时报的是什么错（信息、堆栈）。 -->

   - What was the root cause?

     <!-- 根本原因（配置、版本、用法等）。 -->

   - What fixed it?

     <!-- 具体做了哪一步修好的。 -->

   - Is this reusable for similar errors?

     <!-- 类似错误以后是否能用同一招（可复用才值得提取）。 -->

2. **Debugging Techniques**

   <!-- 第 2 类：调试技巧。不 obvious 的排查步骤、工具组合、诊断套路。 -->

   - Non-obvious debugging steps

     <!-- 不那么显而易见的调试步骤（如先看哪条日志、先查哪个配置）。 -->

   - Tool combinations that worked

     <!-- 哪些工具组合有效（如 grep + 某命令）。 -->

   - Diagnostic patterns

     <!-- 可复用的诊断模式（如“先复现再缩小范围”）。 -->

3. **Workarounds**

   <!-- 第 3 类：变通方案。库的坑、API 限制、某版本特有的修法。 -->

   - Library quirks

     <!-- 某个库的奇怪行为及应对方式。 -->

   - API limitations

     <!-- API 的限制及绕过方式。 -->

   - Version-specific fixes

     <!-- 针对特定版本的修复（如某版本必须加某配置）。 -->

4. **Project-Specific Patterns**

   <!-- 第 4 类：项目特有模式。本次会话里发现的代码库约定、架构选择、集成方式。 -->

   - Codebase conventions discovered

     <!-- 发现的代码风格、目录约定等。 -->

   - Architecture decisions made

     <!-- 本次做的架构决策及理由。 -->

   - Integration patterns

     <!-- 与外部服务/模块的集成方式。 -->

## Output Format

<!-- 小节：输出格式。每个模式单独一个 .md 文件，按下面结构写。 -->

Create a skill file at `~/.claude/skills/learned/[pattern-name].md`:

<!-- 文件路径：用户目录下 .claude/skills/learned/，文件名用模式名（如 error-x-y-fix.md）。 -->

```markdown
# [Descriptive Pattern Name]

**Extracted:** [Date]
**Context:** [Brief description of when this applies]

## Problem
[What problem this solves - be specific]

## Solution
[The pattern/technique/workaround]

## Example
[Code example if applicable]

## When to Use
[Trigger conditions - what should activate this skill]
```

<!-- 模板：标题；提取日期与适用场景；问题描述；解决方案；示例代码（如有）；何时启用该技能。 -->

## Process

<!-- 小节：执行流程。按下面 5 步做。 -->

1. Review the session for extractable patterns

   <!-- 第 1 步：通读当前会话，找出可提取的模式（对照上面四类）。 -->

2. Identify the most valuable/reusable insight

   <!-- 第 2 步：挑出最有价值、最可复用的一条（优先一条写透，不要一次写很多条）。 -->

3. Draft the skill file

   <!-- 第 3 步：按上面模板起草技能文件内容。 -->

4. Ask user to confirm before saving

   <!-- 第 4 步：把草稿给用户确认，再保存，不要静默写入。 -->

5. Save to `~/.claude/skills/learned/`

   <!-- 第 5 步：确认后保存到 learned/ 目录。 -->

## Notes

<!-- 小节：注意点。 -->

- Don't extract trivial fixes (typos, simple syntax errors)

  <!-- 不要提取 trivial 的修法（如改拼写、简单语法错误），不值得占一条技能。 -->

- Don't extract one-time issues (specific API outages, etc.)

  <!-- 不要提取一次性问题（如某次 API 宕机），无法复用的不写。 -->

- Focus on patterns that will save time in future sessions

  <!-- 只写“以后会话能省时间”的模式。 -->

- Keep skills focused - one pattern per skill

  <!-- 一个技能文件只讲一个模式，保持聚焦。 -->
