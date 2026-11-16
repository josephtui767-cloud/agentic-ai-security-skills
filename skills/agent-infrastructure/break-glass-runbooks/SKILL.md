---
name: break-glass-runbooks
description: >
  Reviews break-glass runbooks for agentic systems: stored OUTSIDE the agent
  infrastructure they're meant to work around, maintained with current
  contact lists and up-to-date procedures, regularly exercised. Operators
  must retain enough knowledge to work without the agent. Auto-invoked
  when reviewing incident response readiness for agentic workloads.
tags: [agent-infrastructure, break-glass, runbook]
role: [ai-incident-responder]
phase: [operate, respond]
frameworks: [NIST-SP-800-61r2, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-runbook-repo]"
---

# Break-Glass Runbooks for Agentic Systems

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Incident response readiness review.
- Post-incident lessons-learned.

## 2-6. TODO

## 7. References
- [AGENTOPS07-BP04](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentops07.html)

---

*Stub — contributions welcome.*
