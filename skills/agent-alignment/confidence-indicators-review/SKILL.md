---
name: confidence-indicators-review
description: >
  Reviews whether human reviewers see calibrated context when approving
  agent operations. Distinguishes evaluator pattern (reviewer judges agent
  recommendation) from gate pattern (reviewer decides policy). Verifies
  contextual grounding scores with plain-language explanation, historical
  similarity lookup, evaluation trends, and dashboards for systemic
  patterns. Auto-invoked when reviewing agent approval UIs or notification
  payloads.
tags: [agent-alignment, hitl, confidence]
role: [ai-security-engineer]
phase: [build, operate]
frameworks: [OWASP-LLM09-2025, NIST-AI-RMF-1.0, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-approval-ui-or-workflow]"
---

# Confidence Indicators for Human Review

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Reviewing approval UI / notification payloads.
- Reviewing scoring / confidence surfacing in HITL workflows.

## 2-6. TODO

## 7. References
- [AGENTSEC07-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec07-bp02.html)

---

*Stub — contributions welcome.*
