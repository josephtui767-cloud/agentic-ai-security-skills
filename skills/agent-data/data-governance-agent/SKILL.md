---
name: data-governance-agent
description: >
  Reviews data governance for agentic workloads. Verifies authorization
  systems align with data governance so agents evaluate access
  permissions unambiguously; data classification applies to agent-
  touched data; retention and disposition align with organizational
  policy. Auto-invoked when reviewing data governance for AI systems.
tags: [agent-data, governance]
role: [grc, ai-security-engineer]
phase: [design, operate, review]
frameworks: [ISO-IEC-42001-2023, NIST-AI-RMF-1.0, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-data-governance-config]"
---

# Agent Data Governance Review

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Data governance review for an agentic workload.
- Compliance preparation (ISO 42001, NIST AI RMF).

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 5.3
- ISO/IEC 42001:2023

---

*Stub — contributions welcome.*
