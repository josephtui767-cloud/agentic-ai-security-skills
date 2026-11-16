---
name: distributed-tracing-agents
description: >
  Reviews distributed tracing for agentic systems. Verifies dual identifier
  pattern — trace ID (from tracing system) plus an application-level
  correlation ID that survives asynchronous boundaries (SQS message
  attributes, EventBridge detail). Verifies risk-based sampling (100% for
  security-critical, statistical for routine) and Logs Insights queries for
  trace anomalies. Auto-invoked when reviewing agent observability or trace
  propagation.
tags: [agent-observability, tracing]
role: [ai-security-engineer]
phase: [build, operate]
frameworks: [NIST-SP-800-92, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Distributed Tracing for Agents

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Reviewing agent tracing configurations.
- Reviewing async boundaries (SQS, EventBridge, Step Functions).

## 2-6. TODO

## 7. References
- [AGENTSEC05-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec05-bp02.html)

---

*Stub — contributions welcome.*
