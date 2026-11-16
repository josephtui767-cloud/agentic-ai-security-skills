---
name: multi-layer-input-validation
description: >
  Reviews input validation across every agent input surface: direct user
  messages, tool outputs, inter-agent messages, retrieved external content,
  memory reads. Verifies no input reaches the agent's reasoning without a
  validation control appropriate to its risk profile. The umbrella skill
  that calls into memory-input-validation, tool-parameter-validation,
  indirect-prompt-injection-defense, and input-obfuscation-stripping.
tags: [agent-io, validation, input]
role: [ai-security-engineer, appsec-engineer]
phase: [build, review]
frameworks: [OWASP-LLM01-2025, CWE-Top-25, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Multi-Layer Input Validation for Agents

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Architectural review of all input surfaces.
- Pre-prod compliance check.

## 2-6. TODO

## 7. References
- [AGENTSEC08-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec08-bp01.html)

---

*Stub — contributions welcome.*
