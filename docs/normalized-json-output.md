# Normalized Finding JSON Output

Every skill in this repository MUST be able to emit findings as normalized JSON that validates against [`schemas/finding.schema.json`](../schemas/finding.schema.json).

## Envelope

```json
{
  "run": {
    "skill": "memory-isolation",
    "version": "1.0.0",
    "started_at": "2026-11-16T10:00:00Z",
    "completed_at": "2026-11-16T10:45:00Z",
    "target": "repo:acme/agents-platform@main",
    "agent_id": "agent-pm-001",
    "session_id": "sess-7fb11c"
  },
  "findings": [ ... ]
}
```

### Required `run` fields

| Field | Type | Description |
|-------|------|-------------|
| `skill` | string | kebab-case skill name; must match the skill directory |
| `version` | string | skill version at the time of the run |
| `started_at` | ISO 8601 datetime | when the run started |
| `target` | string | what was reviewed (repo URL, module path, agent ID, etc.) |

### Optional `run` fields

| Field | Description |
|-------|-------------|
| `completed_at` | when the run finished |
| `agent_id` | identifier of the agent that ran the skill |
| `session_id` | correlation ID for the invocation session |

## Finding

Each entry in `findings[]` has this shape:

```json
{
  "id": "MEM-001",
  "title": "Shared memory namespace used as default across users",
  "severity": "high",
  "confidence": "high",
  "framework_refs": [
    { "framework": "OWASP-Agentic-Top-10-2026", "control_id": "LLM03", "url": "https://..." },
    { "framework": "AWS-Agentic-AI-Lens", "control_id": "AGENTSEC01-BP01" }
  ],
  "cwe_refs": ["CWE-668"],
  "evidence": [
    {
      "type": "file",
      "path": "src/agent/memory.py",
      "line": 42,
      "snippet": "memory = SharedMemory(namespace='global')",
      "description": "Single shared namespace used by all user sessions"
    }
  ],
  "remediations": [
    {
      "guidance": "Partition memory by actorId and sessionId. Use a hierarchical namespace template like /support-agent/{actorId}/preferences to scope each user automatically. Add IAM policies that restrict the agent role to its authorized namespace prefixes.",
      "confidence": "high",
      "blast_radius": "src/agent/memory.py and all call sites using the shared namespace (12 locations)",
      "behavior_change_risk": "medium",
      "patch_path": "src/agent/memory.py",
      "test_strategy": {
        "summary": "Prove that an agent in one session cannot read or write memory belonging to another session.",
        "recommended_tests": [
          {
            "name": "test_cross_session_memory_isolation",
            "type": "integration",
            "purpose": "Session A writes memory; Session B must not be able to retrieve it.",
            "command": "pytest tests/test_memory_isolation.py -v",
            "expected_result": "test_cross_session_memory_isolation PASSED"
          }
        ]
      }
    }
  ]
}
```

### Required finding fields

| Field | Description |
|-------|-------------|
| `id` | Stable identifier for this finding (skill-local). |
| `title` | One-line human-readable summary. |
| `severity` | `info` / `low` / `medium` / `high` / `critical` |
| `framework_refs` | Array of real framework + control_id pairs. Each `control_id` must resolve in the cited framework. |
| `evidence` | At least one evidence item. See below. |
| `remediations` | At least one remediation. Each remediation MUST include `guidance`, `confidence`, `blast_radius`, `behavior_change_risk`, and `test_strategy`. |

### Evidence types

| Type | Use case |
|------|----------|
| `file` | Source file reference with path, optional line, and snippet |
| `log` | Log line or trace span |
| `config` | Config file or infrastructure definition |
| `api_call` | HTTP request or API invocation that demonstrates the issue |
| `screenshot` | Reference to a screenshot file |
| `trace` | Distributed trace or OpenTelemetry span ID |
| `metric` | Metric value or threshold breach |
| `note` | Analyst observation when no machine artifact exists |

### Severity

Use the following guidance to pick severity consistently across skills:

- `critical` — Active compromise, authentication bypass, unmitigated remote code execution, exposed secrets with blast radius ≥ one team, agent capable of unmitigated real-world side effects on third parties.
- `high` — Exploitable with realistic attacker effort, significant data or availability impact, control failure with no compensating defense.
- `medium` — Exploitable with specialized knowledge, limited blast radius, or defense-in-depth gap where another control still holds.
- `low` — Hardening opportunity. Would strengthen posture but no realistic attack chain today.
- `info` — Context for the human reviewer. Not a finding that must be remediated.

### Confidence

- `high` — The pattern is matched directly or the control is provably absent.
- `medium` — Strong indicator but requires human disposition.
- `low` — Heuristic only. Treat as a research prompt rather than a finding.

### Remediation fields

Every remediation MUST include:

- `guidance` — concrete remediation steps or patch guidance
- `confidence` — `low` / `medium` / `high` in whether this remediation resolves the finding
- `blast_radius` — files, users, systems, integrations, or workflows affected by applying the remediation
- `behavior_change_risk` — `low` / `medium` / `high` chance the remediation changes functional behavior
- `test_strategy` — at least a `summary`; preferably with `recommended_tests[]` and/or `generated_tests[]`

### Test strategy

Each test entry MUST include:

- `name` — test identifier
- `type` — `static` / `unit` / `integration` / `e2e` / `regression` / `manual`
- `purpose` — what vulnerable behavior or regression this test proves
- `expected_result` — binary passing result

Optional:
- `path` — path to the generated test file
- `command` — the command or manual check to run

## Multiple findings

One run produces a single JSON document with one or more findings:

```json
{
  "run": { "skill": "tool-parameter-validation", "version": "1.0.0", ... },
  "findings": [
    { "id": "TPV-001", ... },
    { "id": "TPV-002", ... },
    { "id": "TPV-003", ... }
  ]
}
```

## Invariants

- Every `framework_refs[].control_id` MUST resolve in [`data/frameworks.yaml`](../data/frameworks.yaml).
- `cwe_refs[]` entries MUST match the pattern `^CWE-\d+$`.
- Severity is normative. Pick the lowest severity that still reflects the risk honestly.
- Evidence snippets MUST NOT include secrets in cleartext. Redact as `<REDACTED:<reason>>`.

## See also

- [`sarif-output.md`](sarif-output.md) — mapping normalized findings to SARIF 2.1.0
- [`tracker-handoff.md`](tracker-handoff.md) — mapping normalized findings to Jira / GitHub / GitLab / Linear work items
- [`remediation-output.md`](remediation-output.md) — remediation emission conventions
