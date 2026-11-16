---
name: memory-isolation
description: >
  Reviews agentic AI systems for memory partitioning, tamper detection, and
  cross-session isolation. Catches the shortest path for a single affected
  session to contaminate every other one: shared namespaces used as the
  default, missing integrity checks on memory reads, flat trust models where
  every agent has broad read/write access to the whole memory store. Auto-
  invoked when reviewing code or architecture that uses shared agent memory,
  RAG stores, conversation history, or vector databases with multi-tenant
  access.
tags: [agent-memory, review, isolation, multi-tenant]
role: [ai-security-engineer, ai-architect]
phase: [design, build, review]
frameworks: [OWASP-Agentic-Top-10-2026, OWASP-LLM03-2025, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Agent Memory Isolation Review

Reviews agentic AI systems for memory partitioning, tamper detection, and cross-session isolation. Aligned with **OWASP Agentic Top 10 for 2026 (Memory Poisoning)**, **OWASP LLM03:2025 (Supply Chain / Memory contamination)**, and the AWS Well-Architected Agentic AI Lens capability **AGENTSEC01: Secure agent memory and state**.

## Limitations

- Static analysis cannot prove runtime isolation holds when memory partitioning is determined by configuration loaded at startup. Supplement with runtime validation.
- Treat findings as hypotheses until validated against the agent's deployment configuration and IAM policies.
- Support each finding with concrete artifacts (file:line references, config snippets, IAM policy JSON, memory store schema).
- Escalate immediately for suspected cross-tenant data access, memory poisoning in production, or evidence that one user's context has influenced another's agent responses.

---

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing an agent that uses a shared memory store** — AgentCore Memory, Redis, DynamoDB, Postgres, a vector DB, or any store multiple agent sessions read from.
- **Reviewing a RAG pipeline** — retrieved documents and knowledge bases are memory for this purpose.
- **Reviewing conversation history management** — persisted history across sessions or users.
- **Reviewing multi-tenant agent deployments** — any system where tenant A's data must not leak to tenant B through the agent.
- **After an incident** where one session's content appears to have influenced another, or a model hallucination has been observed to persist across sessions.

## 2. What to Detect

The patterns below indicate a memory isolation gap. Confidence is relative to each pattern; all should be validated against the agent's actual deployment.

| Signal | Pattern | Confidence |
|---|---|---|
| Shared namespace used as default | `namespace=['"](global|shared|default|all)['"]` in memory API calls | HIGH |
| No session/user scoping in memory key | Memory key does not include `{sessionId}`, `{actorId}`, `{tenantId}`, or equivalent | HIGH |
| Flat IAM to memory store | Agent role has `*:GetItem`, `*:PutItem`, `*:Query` with `Resource: "*"` on the memory table/bucket | HIGH |
| Missing integrity check on memory read | Memory read does not verify a signature, hash, or version before use | MEDIUM |
| Model outputs written to long-term memory without grounding | `create_event` / `insert` / `write` of raw model output without a grounding score check | HIGH |
| Memory consolidation bypasses validation | Long-term memory consolidation runs without running the same input validation used on user API | HIGH |
| No append-only guarantee | Memory table supports `DeleteItem` or `UpdateItem` without a versioned history or audit trail | MEDIUM |
| Memory TTL missing or indefinite | No `eventExpiryDuration`, no `TTL` attribute, no cleanup job | LOW |

See [`patterns.md`](patterns.md) for the full detection-pattern library.

## 3. Rules (Constraints)

- **MUST** verify memory is partitioned along the isolation axes that match the workload. The standard set is session, user, tenant, agent, group. The minimum set is session and user for multi-user agents.
- **MUST** verify cross-partition access is an explicit, authorized exception — not the default.
- **MUST** verify IAM policies restrict each agent role to the namespace prefixes it is authorized for. A policy with `Resource: "*"` on the memory store fails this check.
- **MUST** verify integrity checks exist on memory reads for workloads where tamper detection is required (financial, healthcare, legal, safety-critical).
- **MUST** verify the memory store supports an append-only versioned history (outdated records marked as invalid rather than deleted) for workloads that require forensic replay.
- **MUST NOT** flag a shared namespace that is intentionally shared and bounded (e.g. a product knowledge base read by every support agent) as an isolation failure — this is a legitimate design.
- **MUST** map every finding to a real control ID from a `frameworks` entry.

## 4. Remediation

When machine-readable output is requested, findings MUST be available as JSON that validates against [`schemas/finding.schema.json`](../../../schemas/finding.schema.json). See [`docs/normalized-json-output.md`](../../../docs/normalized-json-output.md).

**Before (vulnerable):**

```python
# src/agent/memory.py
from memory_store import SharedMemory

memory = SharedMemory(namespace="global")  # same namespace for every session

def write_turn(session_id: str, text: str):
    memory.put(key=f"turn:{session_id}", value=text)  # key is predictable, no user scope

def read_history():
    return memory.query(prefix="turn:")              # returns every session's turns
```

**After (remediated):**

```python
# src/agent/memory.py
from memory_store import ScopedMemory

def memory_for(actor_id: str, session_id: str) -> ScopedMemory:
    # Hierarchical namespace: /support-agent/{actorId}/sessions/{sessionId}
    return ScopedMemory(
        namespace_template="/support-agent/{actor_id}/sessions/{session_id}",
        actor_id=actor_id,
        session_id=session_id,
        encryption_key_arn=KMS_KEY_ARN,       # customer-managed key
        ttl_seconds=SESSION_TTL_SECONDS,
    )

def write_turn(actor_id: str, session_id: str, text: str):
    mem = memory_for(actor_id, session_id)
    mem.put(key="turn", value=text, hmac=True)       # integrity on write

def read_history(actor_id: str, session_id: str):
    mem = memory_for(actor_id, session_id)
    return mem.list(verify_hmac=True)                # integrity verified on read
```

```json
// infra/iam/agent-role-policy.json — scoped to the actor's namespace only
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["memory:Get", "memory:Put", "memory:List"],
      "Resource": "arn:aws:memory:*:*:namespace/support-agent/${aws:PrincipalTag/ActorId}/*"
    }
  ]
}
```

**Fix recommendation output:**

```yaml
remediations:
  - guidance: >
      Partition memory using a hierarchical namespace template that includes
      both actor (user/tenant) and session identifiers. Add IAM policies
      restricting the agent role to the namespace prefix matching its
      authorized actor. Enable HMAC integrity signing on every write and
      verify on every read for workloads where tamper detection is required.
    confidence: high
    blast_radius: >
      Memory module + every call site that reads/writes memory. For a typical
      agent this is ~5-20 locations. Refactor is contained to the memory
      abstraction layer; call-site changes are mechanical.
    behavior_change_risk: medium
    test_strategy:
      summary: "Prove cross-session and cross-tenant memory isolation holds."
      recommended_tests:
        - name: cross_session_isolation
          type: integration
          purpose: "Session A write must not be visible to Session B."
          command: "pytest tests/agent/test_memory_isolation.py::test_cross_session -v"
          expected_result: "test_cross_session PASSED"
        - name: cross_tenant_isolation
          type: integration
          purpose: "Tenant A write must not be visible to Tenant B's agent role."
          command: "pytest tests/agent/test_memory_isolation.py::test_cross_tenant -v"
          expected_result: "test_cross_tenant PASSED"
        - name: iam_scoping
          type: static
          purpose: "Agent role policy must not grant Resource:* on the memory store."
          command: "python scripts/check_iam_memory_scoping.py infra/iam/"
          expected_result: "exit code 0"
      generated_tests:
        - name: hmac_tamper_detection
          path: "tests/agent/test_memory_integrity.py"
          type: regression
          purpose: "A memory record modified outside the normal write path must fail HMAC verification on read."
          command: "pytest tests/agent/test_memory_integrity.py -v"
          expected_result: "test_hmac_tamper PASSED"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | Any agent repository with memory store code |
| **Expected output** | Finding(s) with evidence file:line, severity, remediation, and test strategy |
| **Pass condition** | Every memory read and write in the code is traceable to a scoped namespace that includes both actor and session identifiers |
| **Fail condition** | At least one memory operation uses an unscoped namespace, OR the agent IAM role grants `Resource: "*"` on the memory store, OR integrity is not verified on read for workloads requiring tamper detection |

Step-by-step confirmation the fix held:

1. Re-scan the modified files with the §2 patterns.
2. Confirm no matches for the HIGH-confidence patterns.
3. Run the integration tests in §4 `test_strategy.recommended_tests[]`.
4. Verify IAM policies show no `Resource: "*"` on memory resources.

## 6. Gotchas (self-improvement loop)

**False positives**

- **Pattern:** A read-only shared knowledge base (`namespace="product-knowledge"`) matched by the shared-namespace regex. **Why:** This is a legitimate intentional shared partition. **Suppress:** The reviewer verifies IAM policy grants only `Read` and the namespace is explicitly documented as shared in a comment or module docstring.
- **Pattern:** Test fixtures that use `namespace="test"`. **Why:** Test code is not production memory. **Suppress:** Exclude paths matching `**/tests/**`, `**/test/**`, `**/__tests__/**`.
- **Pattern:** Development scaffolding that uses a single namespace to simplify local iteration. **Why:** Dev config, not production. **Suppress:** Verify the namespace is gated by an environment variable that enforces per-session scoping in staging and production.

**Precision traps**

- **Trap:** Moving a shared knowledge base to per-user namespaces to "fix" the shared-default pattern will break intended access (every user needs the same product data). **Mitigation:** Distinguish *intentional shared read-only* namespaces from *accidental shared write* namespaces. The finding is only about the second.
- **Trap:** Enabling HMAC signing on an existing memory store without a migration plan can break reads of pre-existing records. **Mitigation:** Phase the migration — allow unsigned records to be read for a defined window while all new writes are signed.

**Do NOT flag:**

- `namespace="{user_id}"` or similar templating that resolves to a scoped value at call time.
- Shared read-only reference data (product catalogs, documentation corpora) with read-only IAM.
- In-memory caches with no persistence across sessions.
- Explicitly bounded team namespaces like `/team-{team_id}/shared/working-context` where the sharing boundary matches the trust zone.

## 7. References (progressive disclosure)

- [patterns.md](patterns.md) — extended detection patterns per memory store technology (AgentCore Memory, Redis, DynamoDB, Postgres, vector DBs)
- [kms-hmac-integrity.md](kms-hmac-integrity.md) — implementation reference for KMS HMAC per memory record
- OWASP Agentic Top 10 for 2026 — [Memory Poisoning](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026/)
- AWS Well-Architected Agentic AI Lens — [AGENTSEC01: Secure agent memory and state](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec01.html)

---

*Agentic AI Security Skills — memory-isolation v1.0.0*
