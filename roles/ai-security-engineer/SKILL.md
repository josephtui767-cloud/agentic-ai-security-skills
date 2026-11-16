---
name: ai-security-engineer
description: >
  Role bundle for an AI Security Engineer building security into agentic
  AI products and infrastructure. Orchestrates skills in the right order
  for the engagement: tool parameter validation, memory isolation, agent
  identity separation, output filtering, least privilege, decision
  artifact logging.
tags: [role-bundle, ai-security-engineer]
role: [ai-security-engineer]
phase: [design, build, operate, review]
frameworks: [OWASP-Agentic-AI, OWASP-LLM-Top-10-2025, NIST-AI-RMF-1.0]
difficulty: advanced
time_estimate: "variable"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-system]"
---

# AI Security Engineer

Role bundle for building security into agentic AI products.

## When to Use

Invoke this bundle for a full security-engineering review of an agentic AI system.

## Skills in order

1. `tool-parameter-validation` — validate what the LLM emits to tools.
2. `memory-isolation` — partition memory; integrity on read; scoped IAM.
3. `agent-identity-separation` — distinct agent identity; user context as claims.
4. `output-filtering-sensitive` — PII/credential filter on every outbound path.
5. `least-privilege-dynamic` — short-lived creds, permission boundaries, IAM conditions.
6. `decision-artifact-logging` — tamper-evident logging in a Log Archive account.

## Deliverable

Normalized JSON findings per [`docs/normalized-json-output.md`](../../docs/normalized-json-output.md) aggregated across skills, with severity-ranked remediation plan.
