---
name: agent-decommissioning
description: >
  Reviews agent decommissioning procedures: inactive-agent flagging, defined
  decommissioning lifecycle (deprecation notice → traffic drain → credential
  revocation → data retention disposition → infrastructure reclamation),
  dependency audit before retirement. Auto-invoked when reviewing agent
  lifecycle management.
tags: [agent-lifecycle, decommissioning]
role: [grc, ai-security-engineer]
phase: [operate]
frameworks: [ISO-IEC-42001-2023, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-or-fleet]"
---

# Agent Decommissioning Lifecycle

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Retiring an agent.
- Lifecycle audit.

## 2-6. TODO

## 7. References
- [AGENTSUS03-BP04](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsus03.html)

---

*Stub — contributions welcome.*
