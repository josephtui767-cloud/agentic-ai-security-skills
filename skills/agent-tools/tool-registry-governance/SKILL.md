---
name: tool-registry-governance
description: >
  Reviews tool registries for runtime enforcement: version-controlled
  approved-tool catalog with security review date, data classification,
  required permissions; default-deny posture at the gateway; AWS Config
  drift detection; automated deprecation workflow. Auto-invoked when
  reviewing tool catalogs, MCP registries, or tool-approval processes.
tags: [agent-tools, registry, governance, slsa]
role: [ai-security-engineer, mlops-security]
phase: [build, operate]
frameworks: [SLSA-v1.0, OWASP-Agentic-AI, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-tool-registry]"
---

# Agent Tool Registry Governance

Aligned with AWS AGENTSEC02-BP03 and SLSA v1.0.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing MCP server registry / catalog.
- Reviewing agent gateway target configurations.
- Reviewing the tool onboarding process.

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

- [AGENTSEC02-BP03](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec02-bp03.html)
- [MCP Registry open standard](https://github.com/modelcontextprotocol/registry)

---

*Stub — contributions welcome.*
