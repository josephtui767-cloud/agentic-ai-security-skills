---
name: ai-incident-responder
description: >
  Role bundle for an AI Incident Responder handling containment, forensics,
  and recovery for agentic incidents. Orchestrates skills for behavioural
  anomaly containment, emergency shutdown, forensic preservation, runtime
  threat correlation, AI business continuity, and automated recovery.
tags: [role-bundle, ai-incident-responder]
role: [ai-incident-responder]
phase: [respond, recover]
frameworks: [NIST-SP-800-61r2, NIST-SP-800-86, MITRE-ATLAS]
difficulty: advanced
time_estimate: "variable"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-incident-id]"
---

# AI Incident Responder

Role bundle for containment, forensics, and recovery.

## Skills in order

1. `behavioural-anomaly-containment` — automated containment of rogue agents.
2. `emergency-shutdown-agent` — immediate stop or safe-mode rollback.
3. `forensic-preservation-agent` — snapshot memory, sessions, tool calls.
4. `runtime-threat-correlation` — correlate agent anomalies with CSPM/GuardDuty findings.
5. `ai-business-continuity` — maintain essential operations during outage.
6. `automated-recovery-fallback` — restore within RTO.

## Deliverable

Incident report with containment timeline, forensic findings, root cause, and lessons-learned feedback into guardrails and detection rules.
