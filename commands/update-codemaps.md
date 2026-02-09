# Update Codemaps

<!-- 标题：更新代码地图。对应 /update-codemaps，根据当前代码结构生成或更新架构文档。 -->

Analyze the codebase structure and update architecture documentation:

<!-- 上面：分析代码库结构，并据此更新架构类文档（codemap = 代码结构/依赖的“地图”）。 -->

1. Scan all source files for imports, exports, and dependencies

   <!-- 第 1 步：扫描所有源码文件，收集 import、export 以及模块间依赖关系。 -->

2. Generate token-lean codemaps in the following format:

   <!-- 第 2 步：生成“省 token”的 codemap 文件（精简、高层概览），按下面 4 个文件组织。 -->

   - codemaps/architecture.md - Overall architecture

     <!-- 整体架构：项目分层、主要模块、大块依赖关系。 -->

   - codemaps/backend.md - Backend structure

     <!-- 后端结构：API、服务、数据访问等后端模块。 -->

   - codemaps/frontend.md - Frontend structure

     <!-- 前端结构：页面、组件、路由等前端模块。 -->

   - codemaps/data.md - Data models and schemas

     <!-- 数据模型与 schema：实体、表结构、接口定义等。 -->

3. Calculate diff percentage from previous version

   <!-- 第 3 步：与上一版 codemap 对比，计算变更比例（如多少文件/段落发生变化）。 -->

4. If changes > 30%, request user approval before updating

   <!-- 第 4 步：若变更超过 30%，先请求用户确认再写入，避免大改被静默覆盖。 -->

5. Add freshness timestamp to each codemap

   <!-- 第 5 步：在每个 codemap 文件里加上“最后更新时间”，便于判断是否过期。 -->

6. Save reports to .reports/codemap-diff.txt

   <!-- 第 6 步：把本次变更摘要或 diff 保存到 .reports/codemap-diff.txt，便于审查。 -->

Use TypeScript/Node.js for analysis. Focus on high-level structure, not implementation details.

<!-- 最后一句：用 TypeScript/Node.js 做分析（如 AST、解析 import）；只关注高层结构，不展开实现细节。 -->
