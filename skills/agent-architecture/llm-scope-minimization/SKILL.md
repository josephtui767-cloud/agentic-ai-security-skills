---
name: llm-scope-minimization
description: >
  Reviews agent architecture for LLM-use minimization — use coded logic
  wherever deterministic code can do the job, reserve LLM invocation for
  tasks that genuinely need reasoning. Treats the LLM like an untrusted
  user inside the agent. Auto-invoked during agent architecture reviews,
  design phase threat modeling, or when evaluating prompt-injection blast
  radius.
tags: [agent-architecture, design, review, minimization]
role: [ai-architect, ai-security-engineer]
phase: [design, review]
frameworks: [OWASP-Agentic-AI, OWASP-LLM01-2025, AWS-Agentic-AI-Prescriptive]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase-or-design-doc]"
---

# LLM Scope Minimization Review

Reviews agent architecture for minimization of LLM involvement. Aligned with the AWS Prescriptive Guidance **System Design BP 1.1** ("Use deterministic execution logic unless AI is needed") and **OWASP LLM01:2025** (reduces prompt-injection blast radius).

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing a new agent design** before implementation begins.
- **Reviewing an existing agent** that has grown in scope and now invokes the LLM for many sub-tasks.
- **Threat modeling an agent** to assess the blast radius of a successful prompt injection.
- **Cost optimization** that doubles as security hardening — fewer LLM calls = narrower attack surface.

## 2. What to Detect

TODO: Patterns for identifying LLM calls that could be replaced with deterministic code. Signals include:
- LLM used for validation (`"is this a valid email?"` → regex)
- LLM used for format normalization (dates, casing)
- LLM used for routing between tools (switch statement on classified intent)
- LLM used for arithmetic (calculator)
- LLM used for data retrieval that could be a direct query
- Perceive/reason/act layers all delegated to the LLM rather than only the reason layer.

## 3. Rules

TODO: Hard constraints. For example:
- Validation MUST use deterministic logic, not LLM evaluation.
- Tool selection MUST use an allowlist, not free-form LLM selection, unless the use case genuinely requires open-ended reasoning.
- Arithmetic, date/time, and type normalization MUST use language primitives.

## 4. Remediation

TODO: Before / after examples. See the AWS Prescriptive Guidance System Design BP 1.1 diagram showing the perceive/reason/act pattern where only the reason layer invokes the LLM.

## 5. Verification

TODO: Falsifiable test. Pass = agent architecture document or code shows LLM invocations are scoped to tasks that genuinely require reasoning, with all other logic implemented deterministically.

## 6. Gotchas

TODO: False positives (e.g. creative tasks where LLM reasoning is the point) and precision traps.

## 7. References

- AWS Prescriptive Guidance — [Security best practices for agentic AI systems, BP 1.1](https://docs.aws.amazon.com/prescriptive-guidance/latest/agentic-ai-security/best-practices-system-design.html)
- OWASP LLM Top 10 — [LLM01:2025 Prompt Injection](https://genai.owasp.org/llmrisk/llm01-prompt-injection/)
- OWASP Agentic AI Threats and Mitigations

---

*Stub — contributions welcome. See CONTRIBUTING.md.*
