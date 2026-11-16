---
name: guardrail-metrics-detection
description: >
  Reviews guardrail intervention metrics as a detection signal. Verifies
  CloudWatch metrics like InvocationsIntervened are tracked by
  GuardrailPolicyType, that trending increases (e.g. in
  SensitiveInformationPolicy blocks) fire alarms, and that the signal
  routes into the incident pipeline. Auto-invoked when reviewing
  observability for guardrail-protected agents.
tags: [agent-threat-detection, guardrails, metrics]
role: [soc-analyst, ai-security-engineer]
phase: [operate]
frameworks: [OWASP-LLM09-2025, MITRE-ATLAS, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-metric-config]"
---

# Guardrail Metrics as Detection Signal

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Detection engineering review for guardrail-protected agents.
- SOC alert design for AI workloads.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 4.3

---

*Stub — contributions welcome.*
