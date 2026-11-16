---
name: agent-scoping-review
description: >
  Reviews agent architecture for the super-agent vs disparate-worker scoping
  decision. Disparate workers contain compromise and simplify threat modeling;
  super-agents simplify entitlements but widen blast radius. Auto-invoked
  during agent architecture reviews and threat modeling for multi-capability
  agents.
tags: [agent-architecture, design, scoping, review]
role: [ai-architect, ai-security-engineer]
phase: [design, review]
frameworks: [OWASP-Agentic-AI, MITRE-ATLAS, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-architecture]"
---

# Agent Scoping and Boundary Review

Reviews the scoping choice between super-agent (one agent with many tools) and disparate-worker (many narrow agents). Aligned with AWS Prescriptive Guidance System Design BP 1.2 and OWASP Agentic AI.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing a new multi-capability agent design.**
- **Reviewing an agent whose tool count has grown** past 8-10 tools.
- **Threat modeling blast radius** of a successful compromise.
- **Architectural tradeoff review** for performance vs security.

## 2. What to Detect

TODO: Signals for inappropriate super-agent patterns (e.g. one agent with write access to multiple data domains, orchestrator agent making every decision through the LLM).

## 3. Rules

TODO: Hard constraints. Candidates:
- An agent MUST NOT have write access to more than one data classification level without explicit sign-off.
- High-risk mutating tools MUST sit behind a dedicated worker agent, not a general orchestrator.

## 4. Remediation

TODO: Decomposition pattern — orchestrator with narrow worker agents.

## 5. Verification

TODO: Falsifiable test.

## 6. Gotchas

TODO.

## 7. References

- AWS Prescriptive Guidance — [BP 1.2](https://docs.aws.amazon.com/prescriptive-guidance/latest/agentic-ai-security/best-practices-system-design.html)
- OWASP Agentic AI
- MITRE ATLAS

---

*Stub — contributions welcome.*
