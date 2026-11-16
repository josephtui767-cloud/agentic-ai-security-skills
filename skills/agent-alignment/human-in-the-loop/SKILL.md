---
name: human-in-the-loop
description: >
  Reviews human-in-the-loop design for agentic systems. Verifies deterministic
  risk classifier (not LLM-based), tiered approval (autonomous / single /
  multi-reviewer), approval mechanism matched to execution environment
  (Step Functions, Bedrock Agents user confirmation, ROC, async tasks),
  bounded persistent trust grants (never wildcard), S3-stored decision
  context with presigned URLs, timeout + escalation on every approval
  mechanism, logged reviewer identity. Auto-invoked when reviewing agent
  approval workflows.
tags: [agent-alignment, hitl, design]
role: [ai-architect, ai-security-engineer]
phase: [design, build, review]
frameworks: [OWASP-Agentic-AI, NIST-AI-RMF-1.0, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Human-in-the-Loop Design for Agents

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Agents with mutating tool access or real-world side effects.
- Approval workflows for high-risk operations.
- Review of persistent trust grant mechanisms.

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

- [AGENTSEC04-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec04-bp02.html)

---

*Stub — contributions welcome.*
