---
name: automated-prompt-testing
description: >
  Reviews automated prompt testing suites in CI/CD. Verifies the suite
  covers role confusion, context manipulation, privilege escalation, multi-
  turn conversation attacks, context poisoning, cross-agent prompt
  propagation, and that baseline detection rates / false-positive
  thresholds are tracked over time. Auto-invoked when reviewing CI pipelines
  for agentic applications.
tags: [agent-testing, prompt-injection, ci]
role: [ai-security-engineer, ai-red-teamer]
phase: [build, review]
frameworks: [OWASP-LLM01-2025, MITRE-ATLAS, AWS-Agentic-AI-Prescriptive]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-ci-config-or-test-suite]"
---

# Automated Prompt Testing Suite

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- CI/CD pipeline review.
- Pre-release security gate review.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 4.1
- promptfoo, fmeval, SecEval (as example tools, not mandates)

---

*Stub — contributions welcome.*
