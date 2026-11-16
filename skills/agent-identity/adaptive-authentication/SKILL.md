---
name: adaptive-authentication
description: >
  Reviews adaptive / risk-based authentication for high-risk agent
  operations: step-up auth or user-approval chains when the agent orchestrates
  a high-risk mutation. Auto-invoked when reviewing authentication flows for
  agents that perform mass export, modification, or deletion of critical data.
tags: [agent-identity, authentication, step-up]
role: [ai-security-engineer, identity-engineer]
phase: [design, build]
frameworks: [NIST-SP-800-63B, OWASP-ASVS-4.0.3, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-auth-flow]"
---

# Adaptive Authentication for Agent Operations

Aligned with AWS Prescriptive Guidance BP 2.3, NIST SP 800-63B, OWASP ASVS.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing agents that perform mass export / mutation / deletion.
- Reviewing authentication flows for mutating agent operations.

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

- AWS Prescriptive Guidance BP 2.3
- NIST SP 800-63B
- OWASP ASVS 4.0.3

---

*Stub — contributions welcome.*
