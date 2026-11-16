---
name: automated-recovery-fallback
description: >
  Reviews automated recovery with fallback chains for agentic systems.
  Verifies agent failures trigger automated cutoffs, fallback chains, and
  recovery workflows that restore service within defined RTO. Each critical
  agent has an explicit, ordered fallback chain with documented quality
  trade-offs. Auto-invoked when reviewing recovery and resilience for
  agentic systems.
tags: [agent-recovery, recovery, fallback]
role: [ai-security-engineer, ai-incident-responder]
phase: [build, respond]
frameworks: [NIST-SP-800-61r2, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-recovery-config]"
---

# Automated Recovery with Fallback Chains

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Recovery workflow design review.
- Resilience audit for multi-agent systems.

## 2-6. TODO

## 7. References
- [AGENTREL04-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentrel04.html)
- [AGENTREL07-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentrel07.html)

---

*Stub — contributions welcome.*
