---
name: input-obfuscation-stripping
description: >
  Reviews input pipelines for stripping of hidden content before model
  invocation: zero-width Unicode (U+200B/C/D), bidirectional overrides
  (U+202A-U+202E), HTML comments with directives, Base64/encoded blocks
  the agent might be instructed to decode. Auto-invoked when reviewing
  input preprocessing in agent pipelines.
tags: [agent-io, unicode, obfuscation]
role: [ai-security-engineer]
phase: [build]
frameworks: [OWASP-LLM01-2025, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "20-40min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-input-preprocessor]"
---

# Input Obfuscation and Unicode Stripping

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Input preprocessing code.
- Post-incident where obfuscated injection was observed.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 4.4
- Unicode UAX #31, UAX #39 (security considerations)

---

*Stub — contributions welcome.*
