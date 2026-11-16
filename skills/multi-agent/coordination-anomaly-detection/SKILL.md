---
name: coordination-anomaly-detection
description: >
  Reviews multi-agent coordination anomaly detection. Verifies coordination
  metrics (inter-agent message rate, workflow frequency, agent-pair
  latency and error rate, topology changes), CloudWatch anomaly detection
  with baselines, AgentCore Evaluations as early-warning layer, GuardDuty
  correlation with coordination logs, scheduled Logs Insights queries.
  Auto-invoked when reviewing multi-agent detection coverage.
tags: [multi-agent, anomaly, detection]
role: [ai-security-engineer, soc-analyst]
phase: [operate]
frameworks: [MITRE-ATLAS, OWASP-Agentic-AI, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-detection-config]"
---

# Multi-Agent Coordination Anomaly Detection

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Multi-agent systems in production.
- Detection coverage review for agentic workloads.

## 2-6. TODO

## 7. References
- [AGENTSEC06-BP04](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec06-bp04.html)

---

*Stub — contributions welcome.*
