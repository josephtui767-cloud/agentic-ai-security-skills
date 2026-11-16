---
name: decision-artifact-logging
description: >
  Reviews agentic AI systems for tamper-evident logging of agent decisions,
  reasoning chains, and tool invocations. Catches the common gaps: logs stored
  in the same account as the agent (so the agent can modify them), only final
  outputs captured (no "why"), unmasked sensitive data in long-term storage,
  no queryable index. Auto-invoked when reviewing agent observability, audit
  logging, or compliance evidence stores.
tags: [agent-observability, logging, non-repudiation, forensics]
role: [ai-security-engineer, grc]
phase: [build, operate]
frameworks: [NIST-SP-800-53-Rev5, NIST-AI-RMF-1.0, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-infrastructure]"
---

# Agent Decision Artifact Logging

Reviews agentic AI systems for tamper-evident decision-artifact logging. Aligned with **NIST SP 800-53 AU (Audit and Accountability)**, **NIST AI RMF 1.0 (MEASURE and MANAGE functions)**, and the AWS Well-Architected Agentic AI Lens best practice **AGENTSEC05-BP01: Implement comprehensive logging and decision artifact storage**.

## The Core Issue

Agent logging has three requirements that ordinary application logging doesn't:

1. **Completeness** — the reasoning chain, not just the outputs. If you can only see what the agent did and not why, you can't reconstruct a decision.
2. **Immutability** — the agent whose behavior is under investigation must not control its own audit record. Logs in the same AWS account as the agent, with write permissions the agent holds, are not tamper-evident.
3. **Queryability at investigation speed** — S3 object scans aren't fast enough. Investigation queries like "find all decisions by agent X involving tool Y between times A and B" must complete in seconds.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing an agent that makes autonomous decisions with real-world side effects.**
- **Reviewing compliance posture for AI RMF, ISO 42001, SOC 2, or any audit regime.**
- **Reviewing observability for an agentic workload.**
- **After an incident** where investigators could not reconstruct the agent's reasoning.

## 2. What to Detect

| Signal | Pattern | Confidence |
|---|---|---|
| Logs stored in same account as agent | Log destination bucket is in the agent's AWS account | HIGH |
| Agent IAM role can delete logs | Agent role policies grant `s3:DeleteObject`, `logs:DeleteLogGroup`, or equivalent on the log destination | HIGH |
| Only final outputs logged | Logging statements capture `response` but not the reasoning chain, tool invocations, or memory operations | HIGH |
| No log-file integrity validation | CloudTrail / audit trail does not have log-file validation (SHA-256 + RSA signatures) enabled | MEDIUM |
| Mutable log storage | No Object Lock, versioning, MFA delete, or append-only guarantee on log store | HIGH |
| Sensitive data unmasked in logs | Log statements include prompts or responses that contain PII without masking | HIGH |
| No initiator attribution | Log entries do not capture the trigger (human session, upstream event ID, alarm ARN, schedule ARN, calling agent) | HIGH |
| No queryable index | Logs in S3 with no Glue Catalog / Athena setup; investigation requires grep across objects | MEDIUM |
| No retention tier policy | All logs retained forever at hot-storage cost, or deleted on short arbitrary schedule | LOW |

## 3. Rules (Constraints)

- **MUST** verify logs land in a dedicated Log Archive account separate from the agent's operational account, with cross-account policies that deny delete and overwrite operations from the agent account.
- **MUST** verify reasoning chain, tool invocations, memory operations, and decision artifacts are captured — not only final outputs.
- **MUST** verify the audit trail has cryptographic integrity validation (log-file validation or equivalent).
- **MUST** verify sensitive data (PII, credentials, regulated fields) is masked or redacted BEFORE logs reach long-term storage.
- **MUST** verify log entries capture initiator attributes: human session, upstream event ID, alarm ARN, schedule ARN, calling agent ID, as structured fields.
- **MUST** verify a queryable index exists (Glue Catalog + Athena, or equivalent) so investigation queries complete in seconds.
- **MUST** verify tiered retention with automated lifecycle policies.
- **MUST** verify customer-managed encryption keys with rotation enabled on every logging destination.
- **MUST NOT** flag the agent's operational log destination as insufficient if a separate immutable audit store receives duplicates of the same data.
- **MUST** map every finding to a real control ID from a `frameworks` entry.

## 4. Remediation

**Before (vulnerable):**

```python
# src/agent/log.py — logs go to the same account; agent can delete them
import logging
log = logging.getLogger("agent")

def respond(user_query):
    reasoning = model.generate(...)
    log.info(f"Response: {reasoning[-200:]}")      # only last 200 chars of final output
    # no tool invocation log
    # no reasoning chain log
    # no sensitive-data masking
    return reasoning
```

**After (remediated):**

```python
# src/agent/log.py — cross-account artifact store, full chain, masked, queryable
import boto3, json, uuid, datetime
from guardrails import SensitiveInfoFilter

s3 = boto3.client("s3", region_name=AUDIT_REGION)
ARTIFACT_BUCKET = "audit-agent-decisions-<audit-account>"
FILTER = SensitiveInfoFilter(mask_all_pii=True)

def log_decision(agent_id, session_id, decision):
    """
    decision = {
      "reasoning_chain": [...],
      "tool_invocations": [...],
      "memory_operations": [...],
      "final_output": "...",
      "initiator": {
         "type": "human_session" | "event" | "alarm" | "schedule" | "agent",
         "id": "...",
         "source": "..."
      }
    }
    """
    artifact = {
        "id": str(uuid.uuid4()),
        "agent_id": agent_id,
        "session_id": session_id,
        "decision_type": decision["decision_type"],
        "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
        "initiator": decision["initiator"],
        "reasoning_chain": [FILTER.mask(step) for step in decision["reasoning_chain"]],
        "tool_invocations": [{
            **inv,
            "arguments": FILTER.mask_json(inv.get("arguments", {})),
            "response": FILTER.mask_json(inv.get("response", {}))
        } for inv in decision["tool_invocations"]],
        "memory_operations": decision["memory_operations"],
        "final_output_masked": FILTER.mask(decision["final_output"]),
    }
    # Key schema: agentId/sessionId/timestamp/decisionType for Athena partitioning
    key = f"{agent_id}/{session_id}/{artifact['timestamp']}/{decision['decision_type']}/{artifact['id']}.json"
    s3.put_object(
        Bucket=ARTIFACT_BUCKET,
        Key=key,
        Body=json.dumps(artifact),
        ServerSideEncryption="aws:kms",
        SSEKMSKeyId=AUDIT_KMS_KEY_ARN
    )
    return artifact["id"]
```

Cross-account bucket policy (in the Audit account) — agent can write but not delete:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAgentAccountWrite",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::<agent-account>:root"},
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::audit-agent-decisions-<audit-account>/*"
    },
    {
      "Sid": "DenyDeleteFromAgentAccount",
      "Effect": "Deny",
      "Principal": "*",
      "Action": ["s3:DeleteObject", "s3:DeleteObjectVersion"],
      "Resource": "arn:aws:s3:::audit-agent-decisions-<audit-account>/*",
      "Condition": {
        "StringEquals": {"aws:PrincipalAccount": "<agent-account>"}
      }
    }
  ]
}
```

**Fix recommendation output:**

```yaml
remediations:
  - guidance: >
      Move the decision artifact store to a dedicated Log Archive account.
      Cross-account bucket policy denies Delete and Overwrite from the agent
      account. Enable versioning and MFA delete on the bucket. Capture
      reasoning chain, tool invocations, memory operations, initiator
      attributes (session, event, alarm, schedule, calling agent), and final
      output — not just final output. Apply CloudWatch Logs data protection
      policies and mask PII before writing. Enable CloudTrail log-file
      validation. Set up Glue Catalog + Athena for queryable artifact search.
      Apply tiered retention with S3 lifecycle policies (hot → warm → cold).
    confidence: high
    blast_radius: "Audit account infrastructure (new); agent logging code paths (refactor); CloudTrail, Glue, Athena setup."
    behavior_change_risk: low
    test_strategy:
      summary: "Prove agents cannot modify their own audit record and that investigators can reconstruct any decision."
      recommended_tests:
        - name: agent_cannot_delete_artifacts
          type: integration
          purpose: "Agent IAM role attempt to delete an artifact must be denied."
          command: "pytest tests/audit/test_cross_account_integrity.py -v"
          expected_result: "DENIED"
        - name: reasoning_chain_captured
          type: integration
          purpose: "A decision artifact contains the full reasoning chain, not just the final output."
          command: "pytest tests/audit/test_completeness.py -v"
          expected_result: "PASSED"
        - name: pii_masked
          type: unit
          purpose: "PII in reasoning chain or tool arguments is masked in the persisted artifact."
          command: "pytest tests/audit/test_masking.py -v"
          expected_result: "PASSED"
        - name: athena_query_investigator
          type: integration
          purpose: "Standard investigation query returns artifacts in seconds."
          command: "./scripts/athena_investigate.sh --agent-id test-agent --from 2026-11-16"
          expected_result: "returns results within 10s"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | Agent infrastructure + log configuration |
| **Expected output** | Finding(s) for each missing logging element |
| **Pass condition** | Separate Log Archive account with cross-account deny-delete policy; full reasoning + tool + memory chain captured; PII masked at write; log-file validation on; Glue + Athena queryable; tiered retention with automated lifecycle |
| **Fail condition** | Logs in same account as agent, OR only final outputs captured, OR PII unmasked in stored logs, OR no queryable index, OR agent role has delete permissions on logs |

## 6. Gotchas

**False positives**

- **Pattern:** Development logs in the agent's own account. **Why:** Dev not prod. **Suppress:** Verify production ships to the Audit account.
- **Pattern:** CloudWatch Logs in the agent's account that ALSO stream via subscription filter to a cross-account Kinesis or Firehose destination. **Why:** The durable store is cross-account; CloudWatch is the operational mirror. **Suppress:** Verify the subscription + destination exist.

**Precision traps**

- **Trap:** Enabling S3 Object Lock in compliance mode is irreversible and can prevent legitimate right-to-be-forgotten operations. **Mitigation:** Default to governance mode; use compliance mode only where a specific regulation requires it.
- **Trap:** Masking at write time but not at ingest time leaves unmasked data briefly in CloudWatch. **Mitigation:** Apply CloudWatch Logs data protection policies that mask in-place, in addition to write-time masking.

**Do NOT flag:**

- Ephemeral debug logs with no retention.
- Test fixtures.
- Operational metrics (CloudWatch metrics are not decision artifacts).

## 7. References

- [cross-account-pattern.md](cross-account-pattern.md) — Log Archive account reference architecture
- [athena-investigation-queries.md](athena-investigation-queries.md) — standard investigation query library
- NIST SP 800-53 — AU (Audit and Accountability) control family
- NIST AI RMF 1.0 — MEASURE and MANAGE functions
- AWS Agentic AI Lens — [AGENTSEC05-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec05-bp01.html)

---

*Agentic AI Security Skills — decision-artifact-logging v1.0.0*
