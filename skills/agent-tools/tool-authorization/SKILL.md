---
name: tool-authorization
description: >
  Reviews tool authorization in agentic systems. Verifies external
  deterministic authorization (not prompt-level), identity propagation
  through the chain, OAuth claim-based policy evaluation, LOG_ONLY policy
  validation before enforce, semantic tool discovery to reduce overload,
  HITL on high-risk mutating operations. Auto-invoked when reviewing agent
  gateways, Cedar/policy-engine configs, or tool entitlement management.
tags: [agent-tools, authorization, oauth]
role: [ai-security-engineer]
phase: [build, review]
frameworks: [OWASP-Agentic-AI, OAuth-2.1, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-gateway-config]"
---

# Agent Tool Authorization Review

Aligned with OWASP Agentic AI ASI08 and AWS AGENTSEC02-BP01.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing agent gateway / MCP server configuration.
- Reviewing tool entitlement policies.
- Reviewing HITL gating for mutating tool calls.

## 2. What to Detect

TODO.

## 3. Rules

TODO.

## 4. Remediation

TODO.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- [AGENTSEC02-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec02-bp01.html)

---

*Stub — contributions welcome.*
