---
name: workflow-stage-checkpoint
description: >
  Reviews workflow stage checkpointing for long-running agent workflows.
  Verifies workflows decompose into stages with persisted outputs and
  explicit validation between them; checkpoint-based recovery resumes from
  the last known-good state; workflow steps are idempotent so replay does
  not duplicate side effects. Auto-invoked when reviewing long-running
  agent workflows.
tags: [agent-recovery, checkpoint, idempotency]
role: [ai-architect, ai-security-engineer]
phase: [design, build]
frameworks: [NIST-SP-800-34, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-workflow-config]"
---

# Workflow Stage Checkpointing

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Long-running agent workflows.
- Idempotency and recovery audit.

## 2-6. TODO

## 7. References
- [AGENTREL03-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentrel03.html)
- [AGENTREL07-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentrel07.html)

---

*Stub — contributions welcome.*
