---
name: agent-cicd-quality-gates
description: >
  Reviews CI/CD quality gates specific to agentic systems: behavioural
  evaluation gates (not just unit tests), staged rollout with automatic
  rollback on regression, integration with AgentCore Evaluations or
  equivalent, change-review gates proportional to risk. Auto-invoked when
  reviewing CI/CD pipelines for agentic workloads.
tags: [agent-lifecycle, cicd, quality]
role: [mlops-security]
phase: [build]
frameworks: [SLSA-v1.0, OWASP-CICD-Top-10, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-cicd-config]"
---

# Agent CI/CD Quality Gates

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- CI/CD review for agentic deployments.
- Pre-release quality gate audit.

## 2-6. TODO

## 7. References
- [AGENTOPS03-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentops03.html)
- OWASP CI/CD Top 10

---

*Stub — contributions welcome.*
