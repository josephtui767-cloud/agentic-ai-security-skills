---
name: account-isolation-pattern
description: >
  Reviews account and workload isolation for agentic systems. Verifies
  separation of fine-tuning data from runtime environments, dedicated
  security account, separate agent-operational and log-archive accounts;
  SCPs enforce boundaries; cross-account policies lock down audit trail.
  Auto-invoked when reviewing cloud account structure for AI workloads.
tags: [agent-infrastructure, isolation, account]
role: [cloud-security-engineer, ai-security-engineer]
phase: [design, build]
frameworks: [NIST-SP-800-53-Rev5, CIS-Controls-v8, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-account-structure]"
---

# Account and Workload Isolation Pattern

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Multi-account design review.
- Reviewing SRA alignment.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 6.1

---

*Stub — contributions welcome.*
