---
name: multi-reviewer-consensus
description: >
  Reviews multi-reviewer consensus workflows for critical agent operations.
  Verifies parallel blind review (reviewers don't see each other's decisions),
  consensus logic (unanimous for two, majority with escalation for three+),
  cross-team reviewer selection, split-decision escalation, logged reviewer
  identity. Auto-invoked when reviewing high-risk agent approval workflows.
tags: [agent-alignment, hitl, four-eyes]
role: [ai-security-engineer, grc]
phase: [build, operate]
frameworks: [NIST-AI-RMF-1.0, ISO-IEC-42001-2023, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-approval-workflow]"
---

# Multi-Reviewer Consensus for Critical Operations

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Critical mutating operations (deletions, financial transactions, external comms).
- Operations where a single approver is a single point of failure.

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

- [AGENTSEC07-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec07-bp03.html)

---

*Stub — contributions welcome.*
