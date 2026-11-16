---
name: dlp-agent-flows
description: >
  Reviews DLP extension to agent output flows. Verifies agent-produced
  content passes through DLP across all outbound channels; DLP policies
  tuned for AI-produced text; detection trends monitored for exfiltration
  signals. Auto-invoked when reviewing data-protection coverage for
  agentic workloads.
tags: [agent-data, dlp, exfiltration]
role: [ai-security-engineer, grc]
phase: [build, operate]
frameworks: [NIST-SP-800-53-Rev5, OWASP-LLM02-2025, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-dlp-config]"
---

# DLP for Agent Flows

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- DLP review for agent-produced content.
- Exfiltration-detection coverage audit.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 5.4

---

*Stub — contributions welcome.*
