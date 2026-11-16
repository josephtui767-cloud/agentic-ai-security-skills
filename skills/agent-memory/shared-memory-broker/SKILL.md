---
name: shared-memory-broker
description: >
  Reviews multi-agent systems for a deterministic broker/proxy mediating all
  shared-memory access. Treats shared memory as partially trusted and
  enforces content integrity, policy, and grounding checks at a single point.
  Auto-invoked when reviewing multi-agent architectures with shared memory
  (shared KBs, conversation histories, coordination state).
tags: [agent-memory, broker, multi-agent]
role: [ai-architect, ai-security-engineer]
phase: [design, build, review]
frameworks: [OWASP-Agentic-AI, AWS-Agentic-AI-Prescriptive]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-multi-agent-codebase]"
---

# Shared Memory Broker Review

Reviews shared-memory architectures for a deterministic broker. Aligned with AWS Prescriptive Guidance BP 1.3.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Multi-agent systems with shared knowledge bases.
- Coordination memory between cooperating agents.
- Shared conversation history across agent handoffs.

## 2. What to Detect

TODO.

## 3. Rules

TODO.

## 4. Remediation

TODO: Single deterministic broker tool as the only path to shared memory; filters, validation, policy enforcement at the broker.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- AWS Prescriptive Guidance BP 1.3

---

*Stub — contributions welcome.*
