---
name: reviewer-cognitive-load
description: >
  Reviews reviewer workload management for agent approval workflows. Verifies
  priority queues (not FIFO), max-assignment caps per reviewer per window,
  rubber-stamp detection metrics (review time, approval rate, decision
  reversal rate), automatic escalation on backlog. Auto-invoked when
  reviewing HITL operations at scale.
tags: [agent-alignment, hitl, operations]
role: [ai-security-engineer, grc]
phase: [operate]
frameworks: [NIST-AI-RMF-1.0, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-review-workflow]"
---

# Reviewer Cognitive Load Review

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Agent approval workflows processing more than a handful of items per reviewer per day.
- Workflows where rubber-stamping is a realistic concern.

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

- [AGENTSEC07-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec07-bp01.html)

---

*Stub — contributions welcome.*
