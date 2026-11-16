---
name: mlops-security
description: >
  Role bundle for MLOps Security — securing the AI development lifecycle.
  Orchestrates skills for prompt-as-code, CI/CD quality gates, fine-tune
  data pipelines, continuous security validation, SDLC-wide vuln scanning,
  and coding-agent steering file hygiene.
tags: [role-bundle, mlops-security]
role: [mlops-security]
phase: [build, operate]
frameworks: [NIST-SP-800-218A, SLSA-v1.0, OWASP-CICD-Top-10]
difficulty: advanced
time_estimate: "variable"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-mlops-pipeline]"
---

# MLOps Security

Role bundle for securing the AI development lifecycle.

## Skills in order

1. `prompt-as-code` — prompts versioned in Git with peer review.
2. `agent-cicd-quality-gates` — behavioural eval gates, staged rollout, rollback.
3. `fine-tune-data-pipelines` — lineage, bias, poisoning defenses.
4. `continuous-security-validation` — on-demand validation on agentic changes.
5. `agentic-vuln-scanning-sdlc` — design + PR + runtime scanning.
6. `coding-agent-steering-security` — scan steering files committed to the repo.

## Deliverable

Hardened MLOps pipeline with documented security gates and continuous validation hooks.
