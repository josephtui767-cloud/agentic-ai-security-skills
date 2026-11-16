---
name: agentic-vuln-scanning-sdlc
description: >
  Reviews vulnerability scanning coverage across the agentic AI SDLC:
  design-document security review, PR-level analysis for agent-specific
  issues (insecure tool invocations, insufficient permission scoping,
  authorization chains), runtime scanning tuned for agent behavior,
  AI-generated code treated as its own vulnerability class (hallucinated
  APIs, insecure defaults, outdated libs), multi-stage verification to
  reduce false positives. Auto-invoked when reviewing SDLC scanning setup.
tags: [agent-testing, vuln-scan, sdlc]
role: [mlops-security, ai-security-engineer]
phase: [design, build, operate]
frameworks: [NIST-SP-800-218A, CWE-Top-25, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-sdlc-config]"
---

# Agentic Vulnerability Scanning Across the SDLC

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Reviewing SDLC scanning coverage for agentic workloads.
- Evaluating AI-generated code scanning.

## 2-6. TODO

## 7. References
- [AGENTSEC09-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec09-bp01.html)
- NIST SP 800-218A

---

*Stub — contributions welcome.*
