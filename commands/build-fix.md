# Build and Fix

<!-- 标题：构建与修复。对应斜杠命令 /build-fix。 -->

Incrementally fix TypeScript and build errors:

<!-- 上面一句：逐步、增量地修复 TypeScript 和构建错误（不要一次改很多处）。 -->

1. Run build: npm run build or pnpm build

   <!-- 第 1 步：先执行构建命令。用 npm 或 pnpm 根据项目习惯；目的是得到完整的报错列表。 -->

2. Parse error output:

   <!-- 第 2 步：解析构建命令的输出，把报错整理成结构化信息。 -->

   - Group by file

     <!-- 按文件分组：同一文件里的错误放在一起，便于按文件逐个修。 -->

   - Sort by severity

     <!-- 按严重程度排序：先修阻塞性的（如编译失败），再修警告。 -->

3. For each error:

   <!-- 第 3 步：对每一个错误按下面子步骤处理，且一次只处理一个错误。 -->

   - Show error context (5 lines before/after)

     <!-- 展示错误上下文：显示该错误所在位置前 5 行和后 5 行代码，方便理解报错位置。 -->

   - Explain the issue

     <!-- 用简短文字说明这个报错是什么问题（例如：类型不匹配、缺少导入等）。 -->

   - Propose fix

     <!-- 提出修复方案：说明打算怎么改、改哪一行。 -->

   - Apply fix

     <!-- 实际应用修复：改代码。 -->

   - Re-run build

     <!-- 再次运行构建，确认当前错误是否消失。 -->

   - Verify error resolved

     <!-- 确认该错误已解决，再处理下一个错误。 -->

4. Stop if:

   <!-- 第 4 步：遇到以下任一情况就停止，不要继续自动修。 -->

   - Fix introduces new errors

     <!-- 本次修复引入了新的报错（说明改法有问题，需要回滚或换方案）。 -->

   - Same error persists after 3 attempts

     <!-- 同一个错误尝试修了 3 次仍然存在（可能需人工介入或换思路）。 -->

   - User requests pause

     <!-- 用户明确要求暂停。 -->

5. Show summary:

   <!-- 第 5 步：全部处理完后（或中途停止时），给出汇总。 -->

   - Errors fixed

     <!-- 已修复的错误数量或列表。 -->

   - Errors remaining

     <!-- 仍未解决的错误。 -->

   - New errors introduced

     <!-- 修复过程中新引入的错误（若有）。 -->

Fix one error at a time for safety!

<!-- 最后一句：为了安全，一次只修一个错误；修完验证再修下一个，避免改乱。 -->
