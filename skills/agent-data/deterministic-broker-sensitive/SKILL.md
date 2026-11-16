---
name: deterministic-broker-sensitive
description: >
  Reviews whether a deterministic broker tool mediates agent access to
  high-sensitivity data systems. Broker inspects user prompts for
  malicious actions and governs high-risk data modifications via adaptive
  auth. Auto-invoked when reviewing agents that touch Tier-0 data stores.
tags: [agent-data, broker, sensitive]
role: [ai-architect, ai-security-engineer]
phase: [design, build]
frameworks: [OWASP-Agentic-AI, AWS-Agentic-AI-Prescriptive]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Deterministic Broker for Sensitive Systems

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Agents with access to high-sensitivity data systems.
- Architecture review for mutating operations against critical data.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 5.2

---

*Stub — contributions welcome.*
