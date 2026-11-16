# Security Policy

## Prompt Injection Hardening

Every skill in this repository is reviewed against **OWASP LLM01:2025 (Prompt Injection)** before `injection-hardened: true` is set in its frontmatter.

Review criteria:

- Skill body does not instruct agents to treat external, retrieved, or tool-output content as authoritative commands.
- Skill body does not contain hidden or obfuscated instructions (zero-width characters, bidirectional overrides, HTML comments with directives, encoded blocks).
- Skill body does not instruct agents to bypass or weaken security controls globally.
- Skill body does not instruct agents to exfiltrate repository content, secrets, or user data.
- Skill body uses precise security language rather than vague instructions like "make sure it's secure".
- Skill content is scoped: the skill clearly states what it applies to and what is out of scope.

The `coding-agent-steering-security` skill in this repository provides the full ruleset for authoring and scanning AI coding agent instruction files, and is used as part of CI for this repository itself.

## Reporting a Vulnerability

Please do **not** open a public GitHub issue for security vulnerabilities in these skills.

Instead, report privately via GitHub Security Advisories on this repository, or email the maintainers listed in `MAINTAINERS.md` (if present).

Include:

- The skill file(s) affected
- The attack scenario (direct injection, indirect injection via retrieved content, misleading framework citation, etc.)
- A reproducible example if possible
- Suggested remediation

We aim to acknowledge within 5 business days and resolve critical issues within 30 days.

## Responsible Disclosure

Please do not publish details of a vulnerability until we have had reasonable time to investigate and release a fix. We will credit reporters in release notes unless anonymity is requested.

## Scope

In scope:

- Prompt injection in skill content
- Framework reference accuracy (invented control IDs, misleading citations)
- Skills that could instruct an agent to bypass security controls
- Logic errors in detection patterns that produce dangerous false negatives

Out of scope:

- Issues in the agent runtimes themselves (Claude Code, Kiro, Cursor, etc.) — report to those vendors
- Issues in AWS services or other third-party tools referenced as implementation examples
- False positives in detection patterns that do not have security impact
