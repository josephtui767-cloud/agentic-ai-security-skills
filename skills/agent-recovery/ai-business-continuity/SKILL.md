---
name: ai-business-continuity
description: >
  Reviews business continuity plans for AI workloads. Verifies safe fallback
  systems and trained staff to maintain essential operations when agents
  are offline; defined RTO / RPO for agent-dependent business processes.
  Human operators must retain enough skill to work without the agent.
  Auto-invoked when reviewing business continuity for AI-dependent
  processes.
tags: [agent-recovery, bcp, resilience]
role: [grc, ai-incident-responder]
phase: [design, operate, respond]
frameworks: [NIST-SP-800-34, ISO-22301, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "60-120min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-bcp-doc]"
---

# AI Business Continuity Plan

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- BCP review for AI-dependent processes.
- DR audit for agentic workloads.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 8.3
- NIST SP 800-34
- ISO 22301

---

*Stub — contributions welcome.*
