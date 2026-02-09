<!--
  本文件：贡献指南（CONTRIBUTING）
  说明如何向本仓库提交代码或配置：你贡献的内容会进入 agents/、skills/、commands/ 等目录，
  被其他 Claude Code 用户安装使用。下文按「欢迎哪类贡献」「如何提交」「格式要求」「注意事项」组织。
-->

# Contributing to Everything Claude Code

Thanks for wanting to contribute. This repo is meant to be a community resource for Claude Code users.

<!-- 上面：感谢贡献；本仓库定位为面向 Claude Code 用户的社区资源，大家共享配置。 -->

## What We're Looking For

<!-- 本节：我们欢迎哪些类型的贡献。下面每一小节对应仓库里的一个目录，贡献时把文件放到对应目录即可。 -->

### Agents

<!--
  Agents（子代理）：在 Claude Code 里，主对话可以把任务「委托」给专门的子代理处理。
  每个 agent 是一个 .md 文件，用 frontmatter 声明名字、描述、可用工具、用的模型等；
  我们欢迎能「专注做好一类事」的新子代理。
-->
New agents that handle specific tasks well:
- Language-specific reviewers (Python, Go, Rust)
  <!-- 语言专属审查员：只审某一门语言的代码，如 Python/Go/Rust 的代码风格、最佳实践 -->
- Framework experts (Django, Rails, Laravel, Spring)
  <!-- 框架专家：熟悉某一框架（如 Django、Rails、Spring）的代理，能按该框架规范给建议 -->
- DevOps specialists (Kubernetes, Terraform, CI/CD)
  <!-- DevOps 类：懂 K8s、Terraform、CI/CD 的代理，协助基础设施与发布流程 -->
- Domain experts (ML pipelines, data engineering, mobile)
  <!-- 领域专家：如 ML 流水线、数据工程、移动端等垂直领域的代理 -->

### Skills

<!--
  Skills（技能）：不是「可调用的子代理」，而是「工作流说明 + 领域知识」的文档，
  通常放在 skills/ 下，可以是单个 .md 或一个带 SKILL.md 的目录。
  被命令或代理引用时，Claude 会按里面的步骤和规范执行。
-->
Workflow definitions and domain knowledge:
- Language best practices
  <!-- 某门语言的最佳实践（如命名、错误处理、模块划分） -->
- Framework patterns
  <!-- 某框架的常用模式（如 React Hooks、Django ORM 用法） -->
- Testing strategies
  <!-- 测试策略：单元测试、E2E、覆盖率要求等 -->
- Architecture guides
  <!-- 架构指南：分层、服务划分、接口设计等 -->
- Domain-specific knowledge
  <!-- 某一业务或技术领域的知识（如支付、合规、性能调优） -->

### Commands

<!--
  Commands（斜杠命令）：用户在输入框里输入 /xxx 触发的快捷指令，
  每个命令对应 commands/ 下的一个 .md 文件，里面写清楚「做什么、怎么用」。
-->
Slash commands that invoke useful workflows:
- Deployment commands
  <!-- 部署相关：如 /deploy、/release，一键执行或引导部署流程 -->
- Testing commands
  <!-- 测试相关：如 /tdd、/e2e、/test-coverage -->
- Documentation commands
  <!-- 文档相关：如自动生成/更新 README、API 文档 -->
- Code generation commands
  <!-- 代码生成：如按模板生成 CRUD、生成测试骨架 -->

### Hooks

<!--
  Hooks（钩子）：在 Claude Code 的某些「事件」发生时自动执行的逻辑，
  例如在「使用某工具之前/之后」「会话结束」时跑脚本。配置写在 hooks/hooks.json 里。
-->
Useful automations:
- Linting/formatting hooks
  <!-- 在编辑文件后自动跑 lint/格式化，或提醒未通过检查 -->
- Security checks
  <!-- 在敏感操作前做安全检查（如是否包含密钥、危险命令） -->
- Validation hooks
  <!-- 校验：如提交前检查 commit message、分支名、文件命名 -->
- Notification hooks
  <!-- 通知类：如任务完成时发消息、写日志 -->

### Rules

<!--
  Rules（规则）：放在 rules/ 下的 .md，是「始终要遵守」的约定，
  会作为系统级提示注入到 Claude，例如：不许写死密钥、必须写测试、提交格式等。
-->
Always-follow guidelines:
- Security rules
  <!-- 安全规则：禁止硬编码密钥、依赖版本要求、权限最小化等 -->
- Code style rules
  <!-- 代码风格：命名、文件大小、不可变性等（如本仓库的 coding-style.md） -->
- Testing requirements
  <!-- 测试要求：如 TDD、覆盖率下限、必须跑的检查 -->
- Naming conventions
  <!-- 命名约定：变量/文件/分支/提交信息的命名规范 -->

### MCP Configurations

<!--
  MCP（Model Context Protocol）配置：让 Claude Code 连接外部服务（GitHub、数据库、云厂商等）。
  mcp-configs/ 里放的是这些服务器的配置模板，用户复制到自己的 ~/.claude 后填入密钥使用。
-->
New or improved MCP server configs:
- Database integrations
  <!-- 数据库类 MCP：如 Postgres、Supabase、ClickHouse 等 -->
- Cloud provider MCPs
  <!-- 云厂商：如 AWS、Vercel、Railway 的 MCP -->
- Monitoring tools
  <!-- 监控类：与监控、日志、告警系统对接 -->
- Communication tools
  <!-- 通讯类：如 Slack、邮件、通知推送 -->

---

## How to Contribute

<!-- 本节：从 Fork 到提 PR 的完整步骤，按顺序做即可。 -->

### 1. Fork the repo

<!-- 先在 GitHub 上 Fork 本仓库，然后克隆你自己账号下的仓库到本地。下面 YOUR_USERNAME 换成你的 GitHub 用户名。 -->
```bash
git clone https://github.com/YOUR_USERNAME/everything-claude-code.git
cd everything-claude-code
```

### 2. Create a branch

<!-- 为新功能单独开一个分支，便于审查和合并。分支名要有意义，如 add-python-reviewer 表示「新增 Python 审查员代理」。 -->
```bash
git checkout -b add-python-reviewer
```

### 3. Add your contribution

<!-- 把新建或修改的文件放到对应目录，这样插件/文档结构才能正确识别。 -->
Place files in the appropriate directory:
- `agents/` for new agents
  <!-- 新子代理的 .md 放在 agents/ -->
- `skills/` for skills (can be single .md or directory)
  <!-- 技能可以是单个 .md，或一个目录（内含 SKILL.md 等） -->
- `commands/` for slash commands
  <!-- 斜杠命令的 .md 放在 commands/ -->
- `rules/` for rule files
  <!-- 规则文件放在 rules/，用户会复制到 ~/.claude/rules/ -->
- `hooks/` for hook configurations
  <!-- 钩子配置写在 hooks/hooks.json，或新增条目合并进该文件 -->
- `mcp-configs/` for MCP server configs
  <!-- MCP 服务器配置放在 mcp-configs/，如 mcp-servers.json -->

### 4. Follow the format

<!-- 下面给出各类文件的推荐格式，方便 Claude Code 和本仓库的校验脚本正确解析。 -->

**Agents** should have frontmatter:

<!-- 子代理文件开头用 YAML frontmatter 声明：name（唯一标识）、description（一句话说明）、tools（允许使用的工具列表）、model（如 sonnet/opus）。正文写具体指令。 -->
```markdown
---
name: agent-name
description: What it does
tools: Read, Grep, Glob, Bash
model: sonnet
---

Instructions here...
```

**Skills** should be clear and actionable:

<!-- 技能文档建议包含：何时用、怎么执行、示例。这样被命令或代理引用时，Claude 知道在什么场景下按什么步骤做。 -->
```markdown
# Skill Name

## When to Use

...

## How It Works

...

## Examples

...
```

**Commands** should explain what they do:

<!-- 命令文件也建议有 frontmatter 的 description，正文写清楚命令用途和详细说明。 -->
```markdown
---
description: Brief description of command
---

# Command Name

Detailed instructions...
```

**Hooks** should include descriptions:

<!-- 每条钩子配置建议带 description，说明在什么条件下触发、做什么，便于维护。 -->
```json
{
  "matcher": "...",
  "hooks": [...],
  "description": "What this hook does"
}
```

### 5. Test your contribution

<!-- 提交前在本地用 Claude Code 实际跑一遍：安装你的 agents/commands/hooks 等，确认能正常触发、无报错，再提 PR。 -->
Make sure your config works with Claude Code before submitting.

### 6. Submit a PR

<!-- 提交到你的分支后，在 GitHub 上从该分支向上游仓库发起 Pull Request。 -->
```bash
git add .
git commit -m "Add Python code reviewer agent"
git push origin add-python-reviewer
```

<!-- 提交信息建议用约定式格式，如 feat: / fix: / docs: ，见仓库根目录 commitlint.config.js。 -->

Then open a PR with:
- What you added
  <!-- PR 描述里写清楚：你加了哪些文件、哪些功能 -->
- Why it's useful
  <!-- 说明为什么对社区有用（解决什么问题、适用什么场景） -->
- How you tested it
  <!-- 说明你是怎么在 Claude Code 里验证的，便于维护者复现 -->

---

## Guidelines

<!-- 贡献时建议遵守的「要做」和「不要做」，保证仓库质量、安全、可维护。 -->

### Do

- Keep configs focused and modular
  <!-- 每个配置只做一件事，能单独启用/禁用，便于他人按需选用 -->
- Include clear descriptions
  <!-- 名称、description、注释写清楚，方便别人理解用途和用法 -->
- Test before submitting
  <!-- 提交前在 Claude Code 里实际跑过，避免合并后别人装上有问题 -->
- Follow existing patterns
  <!-- 参考本仓库里同类文件的结构和写法，保持风格一致 -->
- Document any dependencies
  <!-- 若依赖特定环境、版本、外部服务，在文件或 README 里说明 -->

### Don't

- Include sensitive data (API keys, tokens, paths)
  <!-- 不要提交真实 API 密钥、token、本机路径；用占位符如 YOUR_KEY_HERE，在文档里说明用户需自行替换 -->
- Add overly complex or niche configs
  <!-- 避免过于复杂或只适合极少数场景的配置，优先通用、可复用的内容 -->
- Submit untested configs
  <!-- 未在 Claude Code 里验证过的配置不要直接提 PR，避免主分支被破坏 -->
- Create duplicate functionality
  <!-- 若已有类似 agent/command/skill，优先扩展现有文件或先讨论再新增 -->
- Add configs that require specific paid services without alternatives
  <!-- 若必须依赖某付费服务，请同时提供替代方案说明或免费替代，方便更多人使用 -->

---

## File Naming

<!-- 文件名约定：小写、连字符、见名知意，并与 agent/skill 名称一致，便于查找和脚本校验。 -->
- Use lowercase with hyphens: `python-reviewer.md`
  <!-- 小写 + 连字符，例如 python-reviewer.md -->
- Be descriptive: `tdd-workflow.md` not `workflow.md`
  <!-- 文件名要能体现内容，用 tdd-workflow.md 而不是笼统的 workflow.md -->
- Match the agent/skill name to the filename
  <!-- frontmatter 里的 name 或技能标题，建议与文件名一致或高度对应 -->

---

## Questions?

<!-- 有疑问可以开 GitHub issue，或到 X（推特）联系维护者。 -->
Open an issue or reach out on X: [@affaanmustafa](https://x.com/affaanmustafa)

---

Thanks for contributing. Let's build a great resource together.
