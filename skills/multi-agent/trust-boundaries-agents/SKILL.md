---
name: trust-boundaries-agents
description: >
  Reviews trust boundaries between agents. Verifies trust zone tiers
  (public / internal operational / privileged), network segmentation via
  VPC/SG + Transit Gateway route tables, application-layer identity
  verification via A2A agent cards or API Gateway Lambda authorizers,
  resource-based IAM policies, Cedar trust-level conditions at tool
  gateway, PrivateLink for cross-zone traffic, AWS Config custom rules for
  trust-zone drift. Auto-invoked during multi-agent architecture review.
tags: [multi-agent, zero-trust, boundaries]
role: [ai-architect, ai-security-engineer]
phase: [design, build]
frameworks: [NIST-SP-800-207, OWASP-Agentic-AI, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-architecture]"
---

# Trust Boundaries Between Agents

## 1. When to Use
If a target is provided via arguments, focus the review on: $ARGUMENTS
- Multi-agent architectures.
- A2A protocol deployments.
- Cross-zone agent communication.

## 2-6. TODO

## 7. References
- [AGENTSEC06-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec06-bp03.html)
- NIST SP 800-207 Zero Trust Architecture

---

*Stub — contributions welcome.*
