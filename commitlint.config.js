/**
 * Commitlint 配置
 * 用于校验 Git 提交信息格式，保证提交历史清晰一致。
 * 规则：使用约定式类型（feat/fix/docs 等）、主题禁用某些大小写、标题最长 100 字符。
 */
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'chore', 'ci', 'build', 'revert'
    ]],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    'header-max-length': [2, 'always', 100]
  }
};
