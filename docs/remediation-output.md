# Remediation Output

Every finding MUST include at least one remediation. This document covers the conventions remediations follow across all skills in this repository.

## Required fields per remediation

| Field | Convention |
|-------|------------|
| `guidance` | Concrete action. Not "consider" or "may". Specify exactly what to change. |
| `confidence` | `low` / `medium` / `high` — how certain is this remediation to resolve the finding |
| `blast_radius` | Files, users, systems, integrations, or workflows affected by applying this remediation |
| `behavior_change_risk` | `low` / `medium` / `high` — chance the remediation changes functional behavior |
| `test_strategy` | How to prove the remediation worked |

## Optional fields

| Field | Use |
|-------|-----|
| `patch_path` | File path for the remediation patch |
| `patch_diff` | Unified diff of the remediation change |

## Guidance writing rules

Good:
> Partition memory by `actorId` and `sessionId` using a hierarchical namespace template `/agent/{actorId}/preferences`. Scope each agent role's IAM policy to the namespace prefix it's authorized for.

Bad:
> Consider improving memory isolation.

Rules:
- Use imperative mood ("Partition...", "Add...", "Remove...").
- Name the specific file, config, control, or policy to change.
- Include the "why" only if it's needed to pick between alternatives.
- Don't repeat the finding — assume the reader knows what's wrong.

## When there are multiple paths forward

Emit multiple remediations ordered from preferred to fallback:

```yaml
remediations:
  - guidance: "Partition memory using AgentCore Memory namespaces..."
    confidence: high
    blast_radius: "memory module + 12 call sites"
    behavior_change_risk: medium
    ...
  - guidance: "If AgentCore Memory is not available, implement the same hierarchical namespace pattern on your existing memory store (Redis / DynamoDB) with IAM-scoped access per prefix."
    confidence: medium
    blast_radius: "same as above, plus bespoke IAM scaffolding"
    behavior_change_risk: medium
    ...
```

## Automated fix generation

If the skill produces an automated fix (patch), it MUST:

1. Isolate the patch to the finding. No incidental changes.
2. Include the patch as `patch_diff` and reference the file in `patch_path`.
3. Set `behavior_change_risk` honestly. A patch that changes a function signature is not low risk.
4. Include a regression test in `test_strategy.generated_tests[]` that proves the vulnerable behavior is gone.
5. Not apply the patch itself — leave application to the orchestrating workflow.

## Fixer policy for agents that can apply changes

If the invoking agent can modify code or configuration:

- **Non-controversial fixes** (adding a schema check, enabling a guardrail, tightening an IAM policy that is provably overbroad): the agent may apply directly if the workflow permits, with the patch and test in the handoff.
- **Behavioral fixes** (changing how an agent handles errors, restructuring a tool call, modifying memory access patterns): the agent MUST request human approval via the normal approval flow before applying.
- **Destructive or irreversible fixes** (deleting data, revoking credentials outside a defined break-glass runbook, changing production config): the agent MUST surface the recommendation and NOT apply.

## Test strategy conventions

Every remediation's test strategy MUST include at minimum:

- `summary` — one line describing what the test proves

Preferably also:

- `recommended_tests[]` — tests a human should run
- `generated_tests[]` — tests the skill generated and placed in the repo

Each test entry:

- `name` — identifier
- `type` — `static` / `unit` / `integration` / `e2e` / `regression` / `manual`
- `purpose` — what the test proves
- `expected_result` — binary passing outcome

Example:

```yaml
test_strategy:
  summary: "Prove that an agent in one session cannot read memory belonging to another session."
  recommended_tests:
    - name: cross_session_isolation
      type: integration
      purpose: "Session A writes memory; Session B retrieval must return empty."
      command: "pytest tests/agent/test_memory_isolation.py::test_cross_session -v"
      expected_result: "test_cross_session PASSED"
  generated_tests:
    - name: cross_session_isolation_regression
      path: "tests/agent/test_memory_isolation.py"
      type: regression
      purpose: "Regression guard for the specific CVE pattern this finding addressed."
      command: "pytest tests/agent/test_memory_isolation.py -v"
      expected_result: "all tests PASSED"
```
