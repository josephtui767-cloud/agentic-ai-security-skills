---
name: hallucination-propagation
description: >
  Reviews agents for controls that keep a single hallucination from cascading
  through memory and multi-agent workflows: contextual grounding thresholds,
  LLM-as-judge for high-stakes outputs, grounding checks before memory
  writes, confidence tagging on memory entries, EventBridge-style broadcast
  flagging potentially corrupted context. Auto-invoked when reviewing RAG,
  memory consolidation, or multi-agent reasoning chains.
tags: [agent-memory, hallucination, grounding]
role: [ai-security-engineer, ml-engineer]
phase: [build, operate]
frameworks: [OWASP-LLM09-2025, NIST-AI-RMF-1.0, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Hallucination Propagation Detection

Reviews for hallucination-propagation controls. Aligned with OWASP LLM09:2025, NIST AI RMF, AWS AGENTSEC01-BP03.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- RAG + persistent memory agents.
- Multi-agent workflows where agents consume each other's outputs.
- Safety-critical domains (medical, legal, financial).

## 2. What to Detect

TODO.

## 3. Rules

TODO.

## 4. Remediation

TODO.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- OWASP LLM Top 10 — LLM09:2025
- [AGENTSEC01-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec01-bp03.html)

---

*Stub — contributions welcome.*
