---
name: inter-agent-message-signing
description: >
  Reviews multi-agent systems for message-level signing between agents.
  Transport-level encryption (TLS) stops protecting the payload the moment a
  message lands in a queue, event bus, or state machine. Message-level signing
  provides cryptographic proof of sender identity and content integrity that
  persists through intermediary services. Auto-invoked when reviewing agent-
  to-agent communication, A2A protocol usage, SQS/EventBridge-mediated agent
  flows, or Step Functions-orchestrated multi-agent workflows.
tags: [multi-agent, signing, encryption, integrity]
role: [ai-security-engineer]
phase: [build]
frameworks: [OWASP-Agentic-AI, NIST-SP-800-57, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-multi-agent-codebase]"
---

# Inter-Agent Message Signing

Reviews multi-agent systems for message-level signing. Aligned with **OWASP Agentic AI (Multi-Agent Coordination)**, **NIST SP 800-57 (Key Management)**, and the AWS Well-Architected Agentic AI Lens best practice **AGENTSEC06-BP01: Encrypt and sign inter-agent messages**.

## The Core Issue

Two properties matter for inter-agent communication: *who sent the message* and *whether the content is what the sender actually sent*.

Transport-level encryption (TLS) covers the second property only while the message is in transit. The moment the message lands in an SQS queue, EventBridge bus, or Step Functions state, there is no transport to protect it. Any modification between delivery and consumption is invisible to the receiver.

Message-level signing provides cryptographic proof that a specific message was sent by a specific agent and has not been modified, regardless of how many intermediary services it passed through. Pairing message signing with trust-zone-scoped keys limits the blast radius of any single key exposure.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing a multi-agent system** where agents communicate through SQS, EventBridge, Step Functions, Kafka, or any intermediary.
- **Reviewing an A2A protocol implementation.**
- **Reviewing MCP server integrations** where multiple agents call the same server.
- **Reviewing a workflow that passes signed instructions between agents.**
- **After an incident** where one agent received an instruction it shouldn't have, and attribution is unclear.

## 2. What to Detect

| Signal | Pattern | Confidence |
|---|---|---|
| Inter-agent message relies on TLS alone | SQS / EventBridge / Step Functions calls pass content without a signature field | HIGH |
| Single shared signing key across agents | All agents use the same KMS key for signing | HIGH |
| Receiving agent does not verify signature | Receiver consumes message content without calling KMS Verify or equivalent | HIGH |
| Signature not included in queue message attributes | SQS messages carry payload but not a signature attribute | HIGH |
| Automatic key rotation disabled | KMS key used for signing does not have rotation enabled | MEDIUM |
| SQS queue encryption uses AWS-managed key | Customer-managed key not used; tenant isolation not enforced | MEDIUM |
| No alarm on key-usage anomalies | No CloudWatch alarm on unexpected signing operations from agents that should only verify, or signing volume spikes | LOW |

## 3. Rules (Constraints)

- **MUST** verify every inter-agent message that crosses a trust boundary OR traverses an intermediary service (queue, bus, state machine) is signed at the message level.
- **MUST** verify receiving agents call Verify (or equivalent) on the signature BEFORE acting on message content.
- **MUST** verify separate signing keys per trust zone.
- **MUST** verify SQS queues used for inter-agent messaging enable server-side encryption with customer-managed keys scoped per trust zone.
- **MUST** verify signatures are carried in message attributes or an equivalent structural field, not embedded in the payload body.
- **MUST** verify KMS keys used for signing have automatic key rotation enabled.
- **MUST** verify CloudWatch alarms exist for key-usage anomalies.
- **MUST NOT** flag single-trust-zone intra-service agent calls as unsigned if they do not traverse any intermediary and use mTLS end-to-end.
- **MUST** map every finding to a real control ID from a `frameworks` entry.

## 4. Remediation

**Before (vulnerable):**

```python
# src/multi_agent/handoff.py — message in a queue, no signature
import boto3, json
sqs = boto3.client("sqs")

def send_task(target_agent: str, task: dict):
    sqs.send_message(
        QueueUrl=AGENT_QUEUE_URL,
        MessageBody=json.dumps({"target": target_agent, "task": task})
    )

def consume_task():
    msg = sqs.receive_message(QueueUrl=AGENT_QUEUE_URL)["Messages"][0]
    body = json.loads(msg["Body"])
    execute(body["task"])                     # trusts whatever is in the queue
```

**After (remediated) — KMS asymmetric sign + verify:**

```python
# src/multi_agent/signing.py
import boto3, json, base64, hashlib
kms = boto3.client("kms")

def sign_message(trust_zone: str, payload: dict) -> str:
    key_id = SIGNING_KEYS[trust_zone]
    message = json.dumps(payload, sort_keys=True).encode("utf-8")
    response = kms.sign(
        KeyId=key_id,
        Message=hashlib.sha256(message).digest(),
        MessageType="DIGEST",
        SigningAlgorithm="ECDSA_SHA_256"
    )
    return base64.b64encode(response["Signature"]).decode("ascii")

def verify_message(trust_zone: str, payload: dict, signature_b64: str) -> bool:
    key_id = SIGNING_KEYS[trust_zone]
    message = json.dumps(payload, sort_keys=True).encode("utf-8")
    try:
        response = kms.verify(
            KeyId=key_id,
            Message=hashlib.sha256(message).digest(),
            MessageType="DIGEST",
            Signature=base64.b64decode(signature_b64),
            SigningAlgorithm="ECDSA_SHA_256"
        )
        return response["SignatureValid"]
    except kms.exceptions.KMSInvalidSignatureException:
        return False
```

```python
# src/multi_agent/handoff.py — signed send + verify
import boto3, json
from .signing import sign_message, verify_message
sqs = boto3.client("sqs")

TRUST_ZONE = "internal-ops"  # per-agent config

def send_task(target_agent: str, task: dict):
    payload = {"target": target_agent, "task": task, "sender": SELF_AGENT_ID}
    signature = sign_message(TRUST_ZONE, payload)
    sqs.send_message(
        QueueUrl=AGENT_QUEUE_URL,
        MessageBody=json.dumps(payload),
        MessageAttributes={
            "signature": {"StringValue": signature, "DataType": "String"},
            "trust_zone": {"StringValue": TRUST_ZONE, "DataType": "String"}
        }
    )

def consume_task():
    msg = sqs.receive_message(
        QueueUrl=AGENT_QUEUE_URL,
        MessageAttributeNames=["signature", "trust_zone"]
    )["Messages"][0]
    payload = json.loads(msg["Body"])
    signature = msg["MessageAttributes"]["signature"]["StringValue"]
    trust_zone = msg["MessageAttributes"]["trust_zone"]["StringValue"]

    if not verify_message(trust_zone, payload, signature):
        metrics.incr("agent.message_rejected", tags={"reason": "invalid_signature"})
        return  # do NOT execute
    execute(payload["task"])
```

SQS queue encryption with customer-managed key per trust zone (Terraform):

```hcl
resource "aws_sqs_queue" "agent_queue_internal" {
  name                              = "agents-internal-ops"
  kms_master_key_id                 = aws_kms_key.agent_trust_internal.id
  kms_data_key_reuse_period_seconds = 300
}
```

**Fix recommendation output:**

```yaml
remediations:
  - guidance: >
      Add KMS asymmetric sign/verify for every inter-agent message that
      crosses a trust boundary or traverses an intermediary service. Use
      separate signing keys per trust zone. Carry signatures in message
      attributes (SQS) or event detail fields (EventBridge). Enable
      customer-managed keys for SQS encryption per trust zone. Enable
      automatic key rotation. Add CloudWatch alarms for signing-key usage
      anomalies.
    confidence: high
    blast_radius: >
      Every agent-to-agent send and receive path. New KMS keys per trust zone.
      Encryption config on SQS/EventBridge. Alarm setup.
    behavior_change_risk: low
    test_strategy:
      summary: "Prove tampered or unsigned messages are rejected by receiving agents."
      recommended_tests:
        - name: unsigned_message_rejected
          type: integration
          purpose: "A message with no signature attribute must be rejected."
          command: "pytest tests/multi_agent/test_signing.py::test_unsigned -v"
          expected_result: "PASSED"
        - name: tampered_message_rejected
          type: integration
          purpose: "A message modified after signing must fail Verify."
          command: "pytest tests/multi_agent/test_signing.py::test_tampered -v"
          expected_result: "PASSED"
        - name: wrong_trust_zone_key_rejected
          type: integration
          purpose: "A message signed with a different trust-zone key must fail Verify."
          command: "pytest tests/multi_agent/test_signing.py::test_wrong_zone -v"
          expected_result: "PASSED"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | Multi-agent codebase + queue/bus configuration |
| **Expected output** | Finding(s) for each inter-agent path missing signing |
| **Pass condition** | Every inter-agent message that traverses an intermediary is signed and verified; separate keys per trust zone; SQS / EventBridge encryption uses customer-managed keys; automatic rotation enabled |
| **Fail condition** | Any inter-agent message traverses an intermediary without a signature, OR receiver acts on payload without calling Verify, OR all agents share a single signing key |

## 6. Gotchas

**False positives**

- **Pattern:** A single-trust-zone deployment where agents communicate only through mTLS over direct connections, never through queues. **Why:** Transport covers the integrity property; signing may be overkill. **Suppress:** Verify no queue, bus, or state machine is in the path.

**Precision traps**

- **Trap:** Message size overhead from signatures can push SQS messages over the 256 KB limit. **Mitigation:** For large payloads, store in S3 with the signed S3 key passing through the queue.
- **Trap:** KMS Sign/Verify adds latency (typically 10-50 ms). **Mitigation:** Batch messages where possible; use ECDSA (faster than RSA).

**Do NOT flag:**

- Fully synchronous RPC agent calls over mTLS with no intermediary.
- Test queues clearly marked non-production.
- Read-only broadcast events where integrity of the event is already attested elsewhere.

## 7. References

- [kms-sign-verify-reference.md](kms-sign-verify-reference.md) — KMS asymmetric sign/verify reference
- [per-trust-zone-key-topology.md](per-trust-zone-key-topology.md) — key topology patterns
- OWASP Agentic AI — Multi-Agent Coordination
- AWS Agentic AI Lens — [AGENTSEC06-BP01](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec06-bp01.html)
- NIST SP 800-57 — Recommendation for Key Management

---

*Agentic AI Security Skills — inter-agent-message-signing v1.0.0*
