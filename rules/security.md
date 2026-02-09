<!-- 本文件：安全规则。提交前必检项、密钥管理（禁止硬编码）、发现安全问题时的响应流程。 -->

# Security Guidelines

## Mandatory Security Checks

<!-- 每次提交前必须确认：无硬编码密钥、输入校验、防 SQL 注入/XSS/CSRF、鉴权、限流、错误信息不泄露敏感数据。 -->
Before ANY commit:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection enabled
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data

## Secret Management

<!-- 禁止在代码里写死密钥；一律用环境变量，并在使用前检查是否已配置。 -->
```typescript
// NEVER: Hardcoded secrets
const apiKey = "sk-proj-xxxxx"

// ALWAYS: Environment variables
const apiKey = process.env.OPENAI_API_KEY

if (!apiKey) {
  throw new Error('OPENAI_API_KEY not configured')
}
```

## Security Response Protocol

<!-- 一旦发现安全问题：立即停止、用 security-reviewer 分析、先修 CRITICAL、轮换已暴露密钥、全库排查同类问题。 -->
If security issue found:
1. STOP immediately
2. Use **security-reviewer** agent
3. Fix CRITICAL issues before continuing
4. Rotate any exposed secrets
5. Review entire codebase for similar issues
