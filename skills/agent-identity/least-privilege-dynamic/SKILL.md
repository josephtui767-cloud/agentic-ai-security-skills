---
name: least-privilege-dynamic
description: >
  Reviews agent IAM for least-privilege and dynamic boundaries: short-lived
  STS sessions, session policies, permission boundaries, contextual IAM
  conditions (region, resource tag, time, source VPC), JIT access for
  elevated operations, organization-level SCPs. Auto-invoked when reviewing
  agent IAM roles, policies, or AWS Organizations guardrails.
tags: [agent-identity, iam, least-privilege]
role: [ai-security-engineer]
phase: [build, operate]
frameworks: [CIS-Controls-v8, NIST-SP-800-53-Rev5, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-iam-config]"
---

# Agent Least Privilege and Dynamic Boundaries

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing agent IAM roles and policies.
- Reviewing short-lived credential issuance.
- Reviewing organization-level SCPs.

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

- [AGENTSEC03-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec03-bp03.html)
- CIS Controls v8
- NIST SP 800-53 AC-6

---

*Stub — contributions welcome.*
