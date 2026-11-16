---
name: ai-architect
description: >
  Role bundle for an AI Architect designing agentic systems with security
  as a first-class concern. Orchestrates skills for scoping decisions,
  threat modeling, trust boundaries, orchestration security, HITL design,
  and model selection.
tags: [role-bundle, ai-architect]
role: [ai-architect]
phase: [design, review]
frameworks: [OWASP-Agentic-AI, MITRE-ATLAS, NIST-AI-RMF-1.0]
difficulty: advanced
time_estimate: "variable"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-architecture]"
---

# AI Architect

Role bundle for designing agentic systems with security as a first-class concern.

## Skills in order

1. `llm-scope-minimization` — use coded logic unless AI is needed.
2. `agent-scoping-review` — super-agent vs disparate-worker.
3. `trust-boundaries-agents` — trust zones + network/IAM/application enforcement.
4. `orchestration-workflow-security` — Step Functions / workflow controls.
5. `human-in-the-loop` — tiered approval design.
6. `model-system-card-review` — vet foundation models before approval.

## Deliverable

Architecture review document with threat model, trust-boundary diagram, and recommended skill assignments for downstream engineering teams.
