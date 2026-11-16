---
name: memory-input-validation
description: >
  Reviews every write path into agent memory for validation: user inputs,
  tool outputs, inter-agent messages, memory consolidation. Teams typically
  validate the user API and leave the other three paths open. Auto-invoked
  when reviewing memory write handlers, create_event / insert / put flows,
  or the consolidation pipeline.
tags: [agent-memory, validation, review, write-path]
role: [ai-security-engineer]
phase: [build, review]
frameworks: [OWASP-LLM01-2025, OWASP-Agentic-AI, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Agent Memory Write-Path Validation

Reviews validation coverage across all memory write paths. Aligned with AWS Well-Architected Agentic AI Lens AGENTSEC01-BP02.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing agent memory APIs.
- Reviewing RAG ingestion pipelines.
- Reviewing inter-agent handoff → memory write patterns.
- Reviewing long-term memory consolidation.

## 2. What to Detect

TODO: Signals including create_event calls with raw tool output, memory consolidation that bypasses the same validators user input goes through, no quarantine queue for ambiguous writes.

## 3. Rules

TODO.

## 4. Remediation

TODO: Three-layer validation (syntactic JSON Schema, semantic Guardrails, contextual check); quarantine queue for ambiguous inputs; WAF at API-fronted memory writes.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- [AGENTSEC01-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec01-bp02.html)

---

*Stub — contributions welcome.*
