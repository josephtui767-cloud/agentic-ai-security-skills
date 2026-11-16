---
name: prompt-as-code
description: >
  Reviews prompt-lifecycle management: prompts versioned in Git under same
  repo as the application; YAML/JSON externalised from code; peer review on
  pull requests; metadata tracked (model version, temperature, eval results);
  separate governance for PoC vs production phases; staged rollout; tested
  automated rollback. Auto-invoked when reviewing how prompts are managed
  across the application lifecycle.
tags: [agent-lifecycle, prompts, ci]
role: [mlops-security, ai-security-engineer]
phase: [build]
frameworks: [NIST-SP-800-218A, SLSA-v1.0, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-repo]"
---

# Prompts as Code Lifecycle

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Prompt management process review.
- Audit preparation.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 2.2
- NIST SP 800-218A

---

*Stub — contributions welcome.*
