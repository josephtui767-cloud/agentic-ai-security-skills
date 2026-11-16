---
name: mcp-server-security
description: >
  Reviews MCP (Model Context Protocol) server implementations and
  integrations for security: OAuth 2.1 inbound auth, scoped outbound
  authentication per target type, tool schema validation, allowlist
  enforcement via MCP Registry, per-session isolation, heightened review
  for remote MCP servers over the public internet. Auto-invoked when
  reviewing MCP server code, MCP client integrations, or mcp.json
  configurations.
tags: [agent-tools, mcp, protocol]
role: [ai-security-engineer]
phase: [build, operate, review]
frameworks: [MCP-Spec, OAuth-2.1, OWASP-Agentic-AI]
difficulty: intermediate
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-mcp-server-or-config]"
---

# MCP Server Security Review

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

- Reviewing MCP server implementations.
- Reviewing MCP client / agent configurations that include `mcp.json`.
- Reviewing remote MCP servers accessed over the public internet.
- Reviewing MCP server onboarding processes.

## 2. What to Detect

TODO: Signals including missing OAuth 2.1 inbound auth, overly broad outbound creds, no schema validation on exposed tools, no allowlist of approved servers, lack of session isolation, remote MCP servers without heightened review.

## 3. Rules

TODO.

## 4. Remediation

TODO.

## 5. Verification

TODO.

## 6. Gotchas

TODO.

## 7. References

- [Model Context Protocol](https://modelcontextprotocol.io/specification)
- OAuth 2.1
- OWASP Agentic AI

---

*Stub — contributions welcome.*
