---
name: behavioural-baselines
description: >
  Reviews agent behavioural baselines: per-agent-type metrics (API call rate,
  data access volume, decision frequency, error rate), CloudWatch dynamic
  anomaly detection, evaluation-score drift as early warning, correlation
  with GuardDuty findings in Security Hub. Auto-invoked when reviewing
  agent monitoring or anomaly detection.
tags: [agent-observability, baseline, anomaly]
role: [ai-security-engineer, soc-analyst]
phase: [operate]
frameworks: [MITRE-ATLAS, OWASP-LLM09-2025, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-monitoring-config]"
---

# Agent Behavioural Baselines

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Reviewing agent monitoring and alerting.
- Reviewing anomaly detection configuration.

## 2-6. TODO

## 7. References
- [AGENTSEC07-BP04](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec07-bp04.html)

---

*Stub — contributions welcome.*
