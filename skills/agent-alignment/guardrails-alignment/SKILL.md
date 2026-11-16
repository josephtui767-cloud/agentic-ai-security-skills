---
name: guardrails-alignment
description: >
  Reviews guardrail and alignment controls for agentic systems. Verifies
  tiered guardrail configurations per use case, per-filter strength
  calibration, guardrails applied to internal paths (inter-agent messages,
  memory writes), version-controlled rollback, CloudWatch intervention
  metrics broken down by input/output, continuous evaluation for goal
  attainment drift. Auto-invoked when reviewing Bedrock Guardrails configs,
  content moderation, or alignment controls.
tags: [agent-alignment, guardrails, review]
role: [ai-security-engineer, ml-engineer]
phase: [build, operate, review]
frameworks: [OWASP-LLM01-2025, OWASP-Agentic-AI, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-guardrails-config]"
---

# Guardrails and Alignment Controls Review

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing Bedrock Guardrails / NeMo Guardrails / custom content moderation.
- Reviewing agent-specific guardrail overlays.
- Reviewing goal-attainment evaluation.

## 2. What to Detect

TODO.

## 3. Rules

TODO.

## 4. Remediation

TODO.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- [AGENTSEC04-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec04-bp01.html)

---

*Stub — contributions welcome.*
