---
name: forensic-preservation-agent
description: >
  Reviews forensic preservation procedures for agent incidents. Verifies
  snapshot of agent memory, active sessions, pending operations, recent
  tool invocations to isolated storage BEFORE containment actions destroy
  evidence. Aligned with RFC 3227 evidence-collection order of volatility
  and NIST SP 800-86. Auto-invoked when reviewing forensic playbooks for
  agentic incidents.
tags: [agent-containment, forensics]
role: [ai-incident-responder, forensics-analyst]
phase: [respond]
frameworks: [NIST-SP-800-86, RFC-3227, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-ir-runbook]"
---

# Forensic Preservation for Agent Incidents

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Forensic runbook review.
- Post-incident forensic capability audit.

## 2-6. TODO

## 7. References
- NIST SP 800-86
- RFC 3227

---

*Stub — contributions welcome.*
