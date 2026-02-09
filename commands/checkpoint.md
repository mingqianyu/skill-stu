# Checkpoint Command

<!-- 标题：检查点命令。对应 /checkpoint，用于在工作流里“打点”或对比当前与历史状态。 -->

Create or verify a checkpoint in your workflow.

<!-- 上面：在 workflow 里创建检查点，或根据某个检查点做验证（对比）。 -->

## Usage

<!-- 小节：用法。 -->

`/checkpoint [create|verify|list] [name]`

<!-- 命令格式：第一个参数为动作 create/verify/list，create 和 verify 时可跟检查点名称 name。 -->

## Create Checkpoint

<!-- 小节：创建检查点。即“保存当前进度”并记到日志里。 -->

When creating a checkpoint:

<!-- 当执行“创建检查点”时，按下面 4 步做。 -->

1. Run `/verify quick` to ensure current state is clean

   <!-- 第 1 步：先跑一次快速验证 /verify quick，确保当前状态是干净的（构建、测试等通过）。 -->

2. Create a git stash or commit with checkpoint name

   <!-- 第 2 步：用检查点名字创建一个 git stash 或一次 commit，把当前改动“钉住”。 -->

3. Log checkpoint to `.claude/checkpoints.log`:

   <!-- 第 3 步：把这次检查点记录追加到 .claude/checkpoints.log，方便之后 verify 时读取。 -->

```bash
echo "$(date +%Y-%m-%d-%H:%M) | $CHECKPOINT_NAME | $(git rev-parse --short HEAD)" >> .claude/checkpoints.log
```

   <!-- 上面命令：写入“时间 | 检查点名称 | 当前 git 短 SHA”到日志文件。 -->

4. Report checkpoint created

   <!-- 第 4 步：向用户报告“检查点已创建”及名称、时间等。 -->

## Verify Checkpoint

<!-- 小节：验证检查点。即“和某个历史检查点对比，看当前改了什么、测试/覆盖率变化”。 -->

When verifying against a checkpoint:

<!-- 当执行“验证（对比）某检查点”时，按下面做。 -->

1. Read checkpoint from log

   <!-- 第 1 步：从 .claude/checkpoints.log 里读出该名称对应的记录（时间、git SHA）。 -->

2. Compare current state to checkpoint:

   <!-- 第 2 步：把当前状态和检查点当时的状态做对比，列出下面几项。 -->

   - Files added since checkpoint

     <!-- 自该检查点以来新增了哪些文件。 -->

   - Files modified since checkpoint

     <!-- 自该检查点以来修改了哪些文件。 -->

   - Test pass rate now vs then

     <!-- 当前测试通过率 vs 当时（或当时是否有跑测试）。 -->

   - Coverage now vs then

     <!-- 当前覆盖率 vs 当时。 -->

3. Report:

   <!-- 第 3 步：用下面格式输出对比报告。 -->

```
CHECKPOINT COMPARISON: $NAME
============================
Files changed: X
Tests: +Y passed / -Z failed
Coverage: +X% / -Y%
Build: [PASS/FAIL]
```

   <!-- 上面：检查点名称、文件变更数、测试增减、覆盖率增减、构建是否通过。 -->

## List Checkpoints

<!-- 小节：列出所有检查点。 -->

Show all checkpoints with:

<!-- 列出时每条检查点要显示： -->

- Name

  <!-- 检查点名称。 -->

- Timestamp

  <!-- 创建时间。 -->

- Git SHA

  <!-- 当时的 git 提交短 SHA。 -->

- Status (current, behind, ahead)

  <!-- 状态：相对当前分支是 current（当前）/ behind（落后）/ ahead（超前）。 -->

## Workflow

<!-- 小节：典型工作流。示意在什么阶段打点、什么时候验证。 -->

Typical checkpoint flow:

<!-- 典型的检查点使用流程如下。 -->

```
[Start] --> /checkpoint create "feature-start"
   |
[Implement] --> /checkpoint create "core-done"
   |
[Test] --> /checkpoint verify "core-done"
   |
[Refactor] --> /checkpoint create "refactor-done"
   |
[PR] --> /checkpoint verify "feature-start"
```

<!-- 上面：开始功能时打点 feature-start → 实现完核心打点 core-done → 测试阶段验证 core-done → 重构完打点 refactor-done → 提 PR 前验证 feature-start（和起点对比）。 -->

## Arguments

<!-- 小节：参数说明。$ARGUMENTS 表示用户传入的参数会填在这里。 -->

$ARGUMENTS:

- `create <name>` - Create named checkpoint

  <!-- 创建名为 name 的检查点。 -->

- `verify <name>` - Verify against named checkpoint

  <!-- 与名为 name 的检查点做对比验证。 -->

- `list` - Show all checkpoints

  <!-- 列出所有已保存的检查点。 -->

- `clear` - Remove old checkpoints (keeps last 5)

  <!-- 清理旧检查点，只保留最近 5 个。 -->
