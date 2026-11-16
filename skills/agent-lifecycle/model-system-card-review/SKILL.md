---
name: model-system-card-review
description: >
  Reviews foundation-model system cards before onboarding a model to an
  approved-LLM list. Verifies documented safeguards, known limitations,
  adversarial-safety results, cyber-evaluation results are reviewed and
  risk-assessed for the target use case. Auto-invoked when a new model is
  proposed for use.
tags: [agent-lifecycle, model, review]
role: [grc, ai-security-engineer]
phase: [design, review]
frameworks: [NIST-AI-RMF-1.0, ISO-IEC-42001-2023, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-model-card]"
---

# Model System Card Review

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- New model onboarding.
- Periodic review of existing approved models.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 3.1

---

*Stub — contributions welcome.*
