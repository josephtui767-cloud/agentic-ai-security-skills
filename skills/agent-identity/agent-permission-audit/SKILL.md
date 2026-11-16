---
name: agent-permission-audit
description: >
  Reviews permission audit cadence for agent identities. Agent permissions
  drift faster than human-user permissions as new tools, prompts, and
  orchestration patterns are added. Verifies risk-based cadence, automated
  + human-led analysis, real-time IAM-change detection, CloudTrail Lake for
  long-term correlation, Security Hub aggregation. Auto-invoked when
  reviewing IAM audit processes.
tags: [agent-identity, audit, iam]
role: [ai-security-engineer]
phase: [operate, review]
frameworks: [CIS-Controls-v8, NIST-SP-800-53-Rev5, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-iam-and-audit-config]"
---

# Agent Permission and Access Audit

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing permission audit cadence for agentic workloads.
- Reviewing IAM Access Analyzer / AWS Config setup for agents.
- Compliance audit preparation.

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

- [AGENTSEC03-BP04](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec03-bp04.html)

---

*Stub — contributions welcome.*
