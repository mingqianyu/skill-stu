# Eval Command

<!-- 标题：评估命令。对应 /eval，用于“评估驱动开发”：定义、执行、报告功能/回归评估，验证是否达标（如 pass@k）。 -->

Manage eval-driven development workflow.

<!-- 上面：管理“以评估驱动”的开发流程（先定义要验证什么，再跑评估、看报告）。 -->

## Usage

`/eval [define|check|report|list] [feature-name]`

<!-- 用法：第一个参数为动作 define/check/report/list；define/check/report 时第二个参数为功能名 feature-name。 -->

## Define Evals

<!-- 小节：定义评估。为某个功能新建一份评估定义文件。 -->

`/eval define feature-name`

<!-- 示例：/eval define feature-auth 会为 feature-auth 创建评估定义。 -->

Create a new eval definition:

<!-- 下面 2 步：创建新评估定义。 -->

1. Create `.claude/evals/feature-name.md` with template:

   <!-- 第 1 步：在 .claude/evals/ 下创建 feature-name.md，内容用下面模板。 -->

```markdown
## EVAL: feature-name
Created: $(date)

### Capability Evals
- [ ] [Description of capability 1]
- [ ] [Description of capability 2]

### Regression Evals
- [ ] [Existing behavior 1 still works]
- [ ] [Existing behavior 2 still works]

### Success Criteria
- pass@3 > 90% for capability evals
- pass^3 = 100% for regression evals
```

   <!-- 模板说明：EVAL 标题与创建时间；Capability Evals 为“能力评估”（新功能是否具备某能力）；Regression Evals 为“回归评估”（原有行为是否仍成立）；Success Criteria 为通过标准：能力评估 pass@3 超 90%，回归评估 pass^3 为 100%。 -->

2. Prompt user to fill in specific criteria

   <!-- 第 2 步：提示用户把方括号里的占位改成具体描述（如具体能力、具体行为）。 -->

## Check Evals

<!-- 小节：执行评估。按定义跑一遍评估并记录结果。 -->

`/eval check feature-name`

Run evals for a feature:

1. Read eval definition from `.claude/evals/feature-name.md`

   <!-- 第 1 步：从 .claude/evals/feature-name.md 读出该功能的评估定义。 -->

2. For each capability eval:

   <!-- 第 2 步：对每条“能力评估”做下面事。 -->

   - Attempt to verify criterion

     <!-- 尝试验证这条标准（如跑代码、检查输出）。 -->

   - Record PASS/FAIL

     <!-- 记录通过或失败。 -->

   - Log attempt in `.claude/evals/feature-name.log`

     <!-- 把本次尝试写入 feature-name.log，便于追溯。 -->

3. For each regression eval:

   <!-- 第 3 步：对每条“回归评估”。 -->

   - Run relevant tests

     <!-- 跑相关测试（如对应单测、集成测）。 -->

   - Compare against baseline

     <!-- 与基线对比（如之前通过的输出）。 -->

   - Record PASS/FAIL

     <!-- 记录通过或失败。 -->

4. Report current status:

   <!-- 第 4 步：用下面格式输出当前状态。 -->

```
EVAL CHECK: feature-name
========================
Capability: X/Y passing
Regression: X/Y passing
Status: IN PROGRESS / READY
```

   <!-- 上面：能力评估 X/Y 通过，回归评估 X/Y 通过；状态为进行中或就绪。 -->

## Report Evals

<!-- 小节：生成评估报告。产出完整报告与建议。 -->

`/eval report feature-name`

Generate comprehensive eval report:

<!-- 报告需包含下面几块。 -->

```
EVAL REPORT: feature-name
=========================
Generated: $(date)

CAPABILITY EVALS
----------------
[eval-1]: PASS (pass@1)
[eval-2]: PASS (pass@2) - required retry
[eval-3]: FAIL - see notes

REGRESSION EVALS
----------------
[test-1]: PASS
[test-2]: PASS
[test-3]: PASS

METRICS
-------
Capability pass@1: 67%
Capability pass@3: 100%
Regression pass^3: 100%

NOTES
-----
[Any issues, edge cases, or observations]

RECOMMENDATION
--------------
[SHIP / NEEDS WORK / BLOCKED]
```

<!-- 说明：每条能力/回归评估的 PASS/FAIL 及 pass@k；汇总指标；备注；最终建议为 SHIP（可发布）/ NEEDS WORK（需再修）/ BLOCKED（阻塞）。 -->

## List Evals

<!-- 小节：列出所有评估定义。 -->

`/eval list`

Show all eval definitions:

<!-- 列出 .claude/evals/ 下所有评估及其当前通过情况。 -->

```
EVAL DEFINITIONS
================
feature-auth      [3/5 passing] IN PROGRESS
feature-search    [5/5 passing] READY
feature-export    [0/4 passing] NOT STARTED
```

<!-- 格式：名称、已通过条数/总条数、状态（进行中/就绪/未开始）。 -->

## Arguments

$ARGUMENTS:

<!-- 参数说明：$ARGUMENTS 表示用户传入会填在这里。 -->

- `define <name>` - Create new eval definition

  <!-- 创建名为 name 的评估定义。 -->

- `check <name>` - Run and check evals

  <!-- 执行并检查该名称的评估。 -->

- `report <name>` - Generate full report

  <!-- 生成该名称的完整报告。 -->

- `list` - Show all evals

  <!-- 列出所有评估定义。 -->

- `clean` - Remove old eval logs (keeps last 10 runs)

  <!-- 清理旧日志，只保留最近 10 次运行记录。 -->
