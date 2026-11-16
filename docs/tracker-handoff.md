# Tracker Handoff Output

When tracker handoff is requested, skills map normalized findings to tracker-ready work items. The output validates against [`schemas/tracker-handoff.schema.json`](../schemas/tracker-handoff.schema.json) and is tracker-system-agnostic — it does not perform live integration with any tracker.

## Shape

```json
{
  "items": [
    {
      "title": "Shared memory namespace used as default across users",
      "severity": "high",
      "description": "The agent uses a single shared namespace for all user sessions, allowing one affected session to read or overwrite context belonging to other users. See src/agent/memory.py:42.",
      "evidence": [
        "src/agent/memory.py:42 — memory = SharedMemory(namespace='global')",
        "12 call sites use the shared namespace without session scoping"
      ],
      "framework_refs": [
        "OWASP-Agentic-Top-10-2026:LLM03",
        "AWS-Agentic-AI-Lens:AGENTSEC01-BP01"
      ],
      "remediation": "Partition memory by actorId and sessionId using a hierarchical namespace template. Add IAM policies restricting the agent role to its authorized namespace prefixes.",
      "owner_suggestion": "platform-agents-team",
      "sla_target": {
        "severity": "high",
        "resolution_within_days": 14
      },
      "labels": ["ai-security", "agentic", "memory", "high"],
      "finding_id": "MEM-001"
    }
  ]
}
```

## Field conventions

| Field | Convention |
|-------|------------|
| `title` | ≤ 120 chars. Imperative or declarative. No "Fix" / "Issue:" prefixes. |
| `severity` | Mirrors normalized finding severity. |
| `description` | Markdown-safe. Lead with the risk, then evidence location, then impact. |
| `evidence` | One line per evidence item. Include path:line references. |
| `framework_refs` | `<framework>:<control_id>` format. |
| `remediation` | Concrete action. Not advisory ("consider"). |
| `owner_suggestion` | Team or role identifier. Use `<organization>-<team>` convention. |
| `sla_target.resolution_within_days` | Recommended SLA based on severity. |
| `labels` | Lowercase, kebab-case. Include domain, severity, and relevant tech. |

## Recommended SLA defaults

| Severity | Days |
|----------|------|
| `critical` | 1 |
| `high` | 14 |
| `medium` | 30 |
| `low` | 90 |
| `info` | — (backlog) |

Override per organization policy.

## Not in scope

- Live Jira / GitHub / GitLab / Linear API integration — perform this outside the skill, using the skill's tracker handoff JSON as input.
- Credential handling for tracker APIs — never invoke tracker APIs from a skill.
- Comments, attachments, watchers — handle these in the downstream integration.
