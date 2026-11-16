---
name: edge-protection-ai
description: >
  Reviews edge protection tuned for AI workloads. Verifies WAF with managed
  rule groups for common web threats; rate limiting against reasoning-loop
  abuse and token-drain DoS; adaptive rules for AI-specific patterns.
  Auto-invoked when reviewing public-facing agent endpoints.
tags: [agent-infrastructure, waf, rate-limit]
role: [ai-security-engineer, cloud-security-engineer]
phase: [build, operate]
frameworks: [OWASP-Top-10-2021, OWASP-API-Security-2023, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-edge-config]"
---

# Edge Protection for AI Workloads

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Public-facing agent API review.
- Reviewing cost/DoS protection for token-driven workloads.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 6.4

---

*Stub — contributions welcome.*
