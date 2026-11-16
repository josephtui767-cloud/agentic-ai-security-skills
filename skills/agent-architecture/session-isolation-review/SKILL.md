---
name: session-isolation-review
description: >
  Reviews agent session management for isolation between users: unique
  cryptographically secure session IDs, session-scoped storage, timeouts,
  resource cleanup, and partitioned memory/context per session. Auto-invoked
  when reviewing session handling in agentic applications.
tags: [agent-architecture, session, isolation, review]
role: [ai-security-engineer]
phase: [build, review]
frameworks: [OWASP-Session-Management, OWASP-LLM02-2025, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Agent Session Isolation Review

Reviews session management for cross-user isolation. Aligned with OWASP Session Management Cheat Sheet, OWASP LLM02:2025, and AWS Prescriptive Guidance BP 1.4.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing any agent serving multiple users.
- Reviewing session middleware or auth handoff.
- After reports of "cross-user data leakage" symptoms.

## 2. What to Detect

TODO: Signals including shared session IDs, missing timeouts, predictable IDs, session-scoped data bleeding into globals.

## 3. Rules

TODO.

## 4. Remediation

TODO.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- AWS Prescriptive Guidance BP 1.4

---

*Stub — contributions welcome.*
