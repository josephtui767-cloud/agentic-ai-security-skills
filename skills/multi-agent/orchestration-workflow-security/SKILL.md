---
name: orchestration-workflow-security
description: >
  Reviews multi-agent orchestration for security controls on the workflow
  layer: Step Functions IAM scoped per state machine; state machines as IaC
  (CFN/CDK) not console; input validation inside state machine; circuit
  breakers with quarantine paths; ALL-level execution logging; EventBridge
  alarms on circuit-breaker events. Auto-invoked when reviewing
  orchestration configurations.
tags: [multi-agent, workflow, orchestration]
role: [ai-security-engineer]
phase: [build, review]
frameworks: [OWASP-Agentic-AI, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-orchestration-config]"
---

# Multi-Agent Orchestration Workflow Security

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Step Functions orchestrating multi-agent workflows.
- Agent-delegated workflows (A2A).

## 2-6. TODO

## 7. References
- [AGENTSEC06-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec06-bp02.html)

---

*Stub — contributions welcome.*
