---
name: ai-red-teamer
description: >
  Role bundle for an AI Red Teamer conducting offensive assessment of
  agentic systems. Orchestrates skills for scheduled red-team programs,
  context-aware pen testing, indirect prompt injection defense (used as
  offense), automated prompt testing, and scoped sandboxing.
tags: [role-bundle, ai-red-teamer]
role: [ai-red-teamer]
phase: [operate, review]
frameworks: [OWASP-Agentic-Top-10-2026, OWASP-LLM-Top-10-2025, MITRE-ATLAS]
difficulty: advanced
time_estimate: "variable"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-engagement-scope]"
---

# AI Red Teamer

Role bundle for offensive assessment of agentic systems.

## Skills in order

1. `agentic-red-team` — scheduled red team program structure.
2. `context-aware-pentest` — adaptive attacker-agent methodology.
3. `indirect-prompt-injection-defense` — review (and pentest) indirect injection surfaces.
4. `automated-prompt-testing` — CI-integrated adversarial suite.
5. `scoped-pentest-sandbox` — safe environment setup before engagement.

## Deliverable

Engagement report with scenario library, CVSS-scored findings, chained exploit paths, and purple-team feedback for defenders.
