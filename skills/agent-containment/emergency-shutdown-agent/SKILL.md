---
name: emergency-shutdown-agent
description: >
  Reviews emergency shutdown procedures for agents. Verifies documented,
  rehearsed shutdown path that can disable functionality, roll back to a
  stable version, or move to safe mode when security threats are detected.
  Distinguishes immediate stop (deny-all policy, revoke credentials) from
  rollback (revert to prior agent version). Auto-invoked when reviewing
  incident response runbooks for agentic systems.
tags: [agent-containment, shutdown, kill-switch]
role: [ai-incident-responder]
phase: [respond]
frameworks: [NIST-SP-800-61r2, OWASP-Agentic-AI, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "15-30min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-ir-runbook]"
---

# Emergency Shutdown Procedures for Agents

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Incident response runbook review.
- Post-incident lessons-learned review.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 8.2

---

*Stub — contributions welcome.*
