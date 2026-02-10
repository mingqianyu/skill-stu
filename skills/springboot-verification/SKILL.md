---
name: springboot-verification
description: Verification loop for Spring Boot projects: build, static analysis, tests with coverage, security scans, and diff review before release or PR.
---

<!-- 本技能：Spring Boot 验证闭环。PR/大改/部署前：构建、静态分析、测试与覆盖率、安全扫描。 -->

# Spring Boot Verification Loop

Run before PRs, after major changes, and pre-deploy.

<!-- 在提 PR、大改或部署前运行。 -->

## Phase 1: Build

<!-- 阶段 1：mvn clean verify 或 gradle assemble，失败则停。 -->

```bash
mvn -T 4 clean verify -DskipTests
# or
./gradlew clean assemble -x test
```

If build fails, stop and fix.

## Phase 2: Static Analysis

<!-- 阶段 2：spotbugs、pmd、checkstyle。 -->

Maven (common plugins):
```bash
mvn -T 4 spotbugs:check pmd:check checkstyle:check
```

Gradle (if configured):
```bash
./gradlew checkstyleMain pmdMain spotbugsMain
```

## Phase 3: Tests + Coverage

<!-- 阶段 3：test、jacoco 报告，确保 80%+。 -->

```bash
mvn -T 4 test
mvn jacoco:report   # verify 80%+ coverage
# or
./gradlew test jacocoTestReport
```

Report:
- Total tests, passed/failed
- Coverage % (lines/branches)

## Phase 4: Security Scan

<!-- 阶段 4：OWASP dependency-check、git secrets。 -->

```bash
# Dependency CVEs
mvn org.owasp:dependency-check-maven:check
# or
./gradlew dependencyCheckAnalyze

# Secrets (git)
git secrets --scan  # if configured
```

## Phase 5: Lint/Format (optional gate)

```bash
mvn spotless:apply   # if using Spotless plugin
./gradlew spotlessApply
```

## Phase 6: Diff Review

```bash
git diff --stat
git diff
```

Checklist:
- No debugging logs left (`System.out`, `log.debug` without guards)
- Meaningful errors and HTTP statuses
- Transactions and validation present where needed
- Config changes documented

## Output Template

```
VERIFICATION REPORT
===================
Build:     [PASS/FAIL]
Static:    [PASS/FAIL] (spotbugs/pmd/checkstyle)
Tests:     [PASS/FAIL] (X/Y passed, Z% coverage)
Security:  [PASS/FAIL] (CVE findings: N)
Diff:      [X files changed]

Overall:   [READY / NOT READY]

Issues to Fix:
1. ...
2. ...
```

## Continuous Mode

- Re-run phases on significant changes or every 30–60 minutes in long sessions
- Keep a short loop: `mvn -T 4 test` + spotbugs for quick feedback

**Remember**: Fast feedback beats late surprises. Keep the gate strict—treat warnings as defects in production systems.
