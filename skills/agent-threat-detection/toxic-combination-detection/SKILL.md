---
name: toxic-combination-detection
description: >
  Reviews detection of toxic control combinations in agentic deployments:
  overly permissive IAM combined with unrestricted network access, internet-
  facing agents with compromised auth, insecure tool permissions combined
  with mutating capability, etc. Each control is benign alone; combined
  they form an exploit path. Auto-invoked when reviewing CSPM / CNAPP
  insights for agentic systems.
tags: [agent-threat-detection, correlation, posture]
role: [ai-security-engineer, soc-analyst]
phase: [operate]
frameworks: [CIS-Controls-v8, NIST-SP-800-53-Rev5, AWS-Agentic-AI-Prescriptive]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-posture-data]"
---

# Toxic Combination Detection

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- CSPM / CNAPP insight review.
- Posture audit for agentic workloads.

## 2-6. TODO

## 7. References
- AWS Prescriptive Guidance BP 7.1

---

*Stub — contributions welcome.*
