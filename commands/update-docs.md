# Update Documentation

<!-- 标题：更新文档。对应 /update-docs，从“单一事实来源”同步生成或更新项目文档。 -->

Sync documentation from source-of-truth:

<!-- 上面：以代码和配置为“事实来源”，把文档同步成与之一致（不凭空编文档）。 -->

1. Read package.json scripts section

   <!-- 第 1 步：读取 package.json 的 scripts 段。 -->

   - Generate scripts reference table

     <!-- 根据 scripts 生成“脚本参考表”（命令 + 用途）。 -->

   - Include descriptions from comments

     <!-- 若 scripts 旁有注释说明，一并摘到文档里。 -->

2. Read .env.example

   <!-- 第 2 步：读取 .env.example。 -->

   - Extract all environment variables

     <!-- 提取所有环境变量名。 -->

   - Document purpose and format

     <!-- 为每个变量写清用途和取值格式（可结合注释或约定）。 -->

3. Generate docs/CONTRIB.md with:

   <!-- 第 3 步：生成或更新 docs/CONTRIB.md（贡献/开发指南），包含下面 4 块。 -->

   - Development workflow

     <!-- 开发流程：如何拉分支、跑环境、提 PR 等。 -->

   - Available scripts

     <!-- 可用脚本：上面生成的脚本表或链接。 -->

   - Environment setup

     <!-- 环境准备：依赖安装、.env 配置等。 -->

   - Testing procedures

     <!-- 测试流程：如何跑单测、集成测、E2E。 -->

4. Generate docs/RUNBOOK.md with:

   <!-- 第 4 步：生成或更新 docs/RUNBOOK.md（运维手册），包含下面 4 块。 -->

   - Deployment procedures

     <!-- 部署步骤：如何构建、发布、回滚。 -->

   - Monitoring and alerts

     <!-- 监控与告警：看哪些指标、告警怎么处理。 -->

   - Common issues and fixes

     <!-- 常见问题与处理：故障排查、已知坑。 -->

   - Rollback procedures

     <!-- 回滚步骤：出问题如何回滚。 -->

5. Identify obsolete documentation:

   <!-- 第 5 步：找出可能过期的文档。 -->

   - Find docs not modified in 90+ days

     <!-- 找出超过 90 天未修改的文档。 -->

   - List for manual review

     <!-- 列出清单供人工判断是否仍适用或需更新。 -->

6. Show diff summary

   <!-- 第 6 步：输出本次文档变更的摘要（哪些文件被更新、新增）。 -->

Single source of truth: package.json and .env.example

<!-- 最后一句：本命令以 package.json 和 .env.example 为“单一事实来源”，不依赖文档里已过期的描述。 -->
