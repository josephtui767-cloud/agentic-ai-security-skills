---
name: runtime-threat-correlation
description: >
  Reviews runtime threat correlation for agentic systems. Verifies
  GuardDuty Extended Threat Detection for attack sequences (privilege
  discovery → API manipulation → persistence → exfiltration); monitoring
  sources (CloudTrail management events, VPC Flow Logs, DNS logs, S3 data
  events, Runtime Monitoring for agent compute); Security Hub CSPM
  aggregation; composite alarms combining evaluation-score degradation with
  GuardDuty findings. Auto-invoked when reviewing runtime detection.
tags: [agent-threat-detection, correlation]
role: [soc-analyst, ai-security-engineer]
phase: [operate]
frameworks: [MITRE-ATTACK-v16, MITRE-ATLAS, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-detection-config]"
---

# Runtime Threat Correlation for Agents

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Detection engineering for agentic workloads.
- SOC playbook development for AI-agent incidents.

## 2-6. TODO

## 7. References
- [AGENTSEC09-BP05](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec09-bp05.html)
- MITRE ATT&CK v16 + MITRE ATLAS

---

*Stub — contributions welcome.*
