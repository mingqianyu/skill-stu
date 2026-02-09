<!-- 本文件：编辑 plugin.json 时的注意事项摘要，避免因未公开的校验规则导致安装失败。详细约束见 PLUGIN_SCHEMA_NOTES.md。 -->

### Plugin Manifest Gotchas

<!-- 若你打算修改 .claude-plugin/plugin.json，请注意：Claude 插件校验器有多条「未在公开文档写明但会强制执行」的规则，违反会导致安装失败并出现含糊错误（如 agents: Invalid input）。典型约束：组件字段必须是数组、agents 必须写具体文件路径不能写目录、必须提供 version。 -->

If you plan to edit `.claude-plugin/plugin.json`, be aware that the Claude plugin validator enforces several **undocumented but strict constraints** that can cause installs to fail with vague errors (for example, `agents: Invalid input`). In particular, component fields must be arrays, `agents` must use explicit file paths rather than directories, and a `version` field is required for reliable validation and installation.

These constraints are not obvious from public examples and have caused repeated installation failures in the past. They are documented in detail in `.claude-plugin/PLUGIN_SCHEMA_NOTES.md`, which should be reviewed before making any changes to the plugin manifest.
