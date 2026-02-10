---
description: Restate requirements, assess risks, and create step-by-step implementation plan. WAIT for user CONFIRM before touching any code.
---

<!-- frontmatter：先重述需求、评估风险、出分步计划；必须等用户确认后才动代码。 -->

# Plan Command

<!-- 标题：计划命令。对应 /plan。 -->

This command invokes the **planner** agent to create a comprehensive implementation plan before writing any code.

<!-- 上面：本命令会调用 planner 子代理，在写任何代码之前先产出一份完整的实施计划。 -->

## What This Command Does

<!-- 小节：本命令做哪几件事。 -->

1. **Restate Requirements** - Clarify what needs to be built

   <!-- 重述需求：用清晰的语言说明“要做出什么”，消除歧义。 -->

2. **Identify Risks** - Surface potential issues and blockers

   <!-- 识别风险：把可能的问题和阻塞点列出来。 -->

3. **Create Step Plan** - Break down implementation into phases

   <!-- 创建步骤计划：把实现拆成若干阶段、每阶段具体步骤。 -->

4. **Wait for Confirmation** - MUST receive user approval before proceeding

   <!-- 等待确认：必须收到用户明确同意后才可以动手写代码，不能自动开改。 -->

## When to Use

<!-- 小节：何时使用 /plan。 -->

Use `/plan` when:

- Starting a new feature

  <!-- 开始做新功能时，先规划再实现。 -->

- Making significant architectural changes

  <!-- 要做较大架构调整时。 -->

- Working on complex refactoring

  <!-- 做复杂重构时，先出计划再动刀。 -->

- Multiple files/components will be affected

  <!-- 会动到多个文件或组件时，先理清顺序和依赖。 -->

- Requirements are unclear or ambiguous

  <!-- 需求不清晰或有歧义时，先通过计划把需求澄清。 -->

## How It Works

<!-- 小节：planner 子代理具体会怎么做。 -->

The planner agent will:

1. **Analyze the request** and restate requirements in clear terms

   <!-- 分析用户请求，用清晰语句重述需求。 -->

2. **Break down into phases** with specific, actionable steps

   <!-- 拆成若干阶段，每阶段有可执行的具体步骤。 -->

3. **Identify dependencies** between components

   <!-- 标出组件/步骤之间的依赖关系。 -->

4. **Assess risks** and potential blockers

   <!-- 评估风险与潜在阻塞点。 -->

5. **Estimate complexity** (High/Medium/Low)

   <!-- 估算复杂度（高/中/低）。 -->

6. **Present the plan** and WAIT for your explicit confirmation

   <!-- 给出计划全文，并等待你明确确认，未经确认不写代码。 -->

## Example Usage

```
User: /plan I need to add real-time notifications when markets resolve

Agent (planner):
# Implementation Plan: Real-Time Market Resolution Notifications

## Requirements Restatement
- Send notifications to users when markets they're watching resolve
- Support multiple notification channels (in-app, email, webhook)
- Ensure notifications are delivered reliably
- Include market outcome and user's position result

## Implementation Phases

### Phase 1: Database Schema
- Add notifications table with columns: id, user_id, market_id, type, status, created_at
- Add user_notification_preferences table for channel preferences
- Create indexes on user_id and market_id for performance

### Phase 2: Notification Service
- Create notification service in lib/notifications.ts
- Implement notification queue using BullMQ/Redis
- Add retry logic for failed deliveries
- Create notification templates

### Phase 3: Integration Points
- Hook into market resolution logic (when status changes to "resolved")
- Query all users with positions in market
- Enqueue notifications for each user

### Phase 4: Frontend Components
- Create NotificationBell component in header
- Add NotificationList modal
- Implement real-time updates via Supabase subscriptions
- Add notification preferences page

## Dependencies
- Redis (for queue)
- Email service (SendGrid/Resend)
- Supabase real-time subscriptions

## Risks
- HIGH: Email deliverability (SPF/DKIM required)
- MEDIUM: Performance with 1000+ users per market
- MEDIUM: Notification spam if markets resolve frequently
- LOW: Real-time subscription overhead

## Estimated Complexity: MEDIUM
- Backend: 4-6 hours
- Frontend: 3-4 hours
- Testing: 2-3 hours
- Total: 9-13 hours

**WAITING FOR CONFIRMATION**: Proceed with this plan? (yes/no/modify)
```

## Important Notes

**CRITICAL**: The planner agent will **NOT** write any code until you explicitly confirm the plan with "yes" or "proceed" or similar affirmative response.

If you want changes, respond with:
- "modify: [your changes]"
- "different approach: [alternative]"
- "skip phase 2 and do phase 3 first"

## Integration with Other Commands

After planning:
- Use `/tdd` to implement with test-driven development
- Use `/build-and-fix` if build errors occur
- Use `/code-review` to review completed implementation

## Related Agents

This command invokes the `planner` agent located at:
`~/.claude/agents/planner.md`
