---
name: continuous-security-validation
description: >
  Reviews CI/CD-integrated continuous security validation for agentic
  systems. Verifies triggers on agentic-specific changes (prompt change,
  tool registry change, permission scope change, orchestration pattern
  update); auto-generated code fixes with findings; regression testing
  after fixes; MTTD / MTTR / fix-effectiveness tracked. Auto-invoked when
  reviewing CI/CD security integration.
tags: [agent-testing, ci, automation]
role: [mlops-security, ai-security-engineer]
phase: [build, operate]
frameworks: [NIST-SP-800-218A, SLSA-v1.0, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-ci-config]"
---

# Continuous Security Validation for Agentic Systems

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- CI/CD pipeline review for agentic workloads.
- Security validation coverage audit.

## 2-6. TODO

## 7. References
- [AGENTSEC09-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec09-bp03.html)
- NIST SP 800-218A

---

*Stub — contributions welcome.*
