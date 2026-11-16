---
name: fine-tune-data-pipelines
description: >
  Reviews fine-tuning data pipelines for lineage, bias, quality, and
  poisoning defenses. Verifies pipeline delivers data without human read
  access, applies data purification filters, and the risk of including
  sensitive data in training is explicitly assessed. Auto-invoked when
  reviewing model customization or training pipelines.
tags: [agent-data, pipeline, poisoning]
role: [ml-engineer, ai-security-engineer]
phase: [build, operate]
frameworks: [NIST-AI-RMF-1.0, OWASP-LLM04-2025, AWS-Agentic-AI-Prescriptive]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-pipeline-config]"
---

# Fine-Tune Data Pipeline Review

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Model fine-tuning pipeline review.
- Training data governance audit.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 5.1

---

*Stub — contributions welcome.*
