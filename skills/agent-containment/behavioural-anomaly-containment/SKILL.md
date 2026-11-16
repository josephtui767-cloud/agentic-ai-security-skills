---
name: behavioural-anomaly-containment
description: >
  Reviews agentic AI systems for automated containment of agents exhibiting
  anomalous behavior. Catches the gap between "we detect rogue agent
  behavior" and "we actually stop it before it causes impact." Verifies per-
  agent behavioral baselines, automated containment sequence (forensic
  snapshot → credential revocation → quarantine broadcast), and dependent-
  workflow circuit breakers. Auto-invoked when reviewing agent monitoring,
  incident response, or kill-switch implementations.
tags: [agent-containment, response, automation, anomaly]
role: [ai-incident-responder, ai-security-engineer]
phase: [operate, respond]
frameworks: [NIST-SP-800-61r2, MITRE-ATLAS, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "45-90min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-infrastructure]"
---

# Behavioural Anomaly Containment

Reviews agentic AI systems for automated containment of rogue agents. Aligned with **NIST SP 800-61r2 (Incident Handling)**, **MITRE ATLAS**, and the AWS Well-Architected Agentic AI Lens best practice **AGENTSEC07-BP04: Behavioral anomaly detection and agent containment**.

## The Core Issue

Detection is necessary but not sufficient. An agent operating outside its intended scope for an hour while responders mobilize can cause as much damage as an undetected one. The design pattern is automated containment on threshold exceedance:

1. **Forensic snapshot** — capture agent memory, active sessions, and pending operations to durable storage BEFORE isolation, so investigators have evidence independent of the agent's own state.
2. **Credential revocation** — attach a deny-all policy to the agent's IAM role, preserving the role for forensic analysis rather than deleting it.
3. **Quarantine broadcast** — emit a quarantine event so dependent workflows activate circuit-breaker logic and route to fallback paths.
4. **Multi-person authorization for restoration** — prevent premature re-activation after containment.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing agent monitoring configurations.**
- **Reviewing incident response playbooks for agentic systems.**
- **Reviewing kill-switch implementations.**
- **Reviewing CloudWatch alarms and EventBridge rules tied to agent behavior.**
- **After an agent-related incident** to assess whether containment responded in time.

## 2. What to Detect

| Signal | Pattern | Confidence |
|---|---|---|
| Kill switch requires human action | Containment runbook requires a human to execute commands rather than firing automatically on threshold | HIGH |
| No forensic preservation before isolation | Containment deletes or disables the agent without first snapshotting memory, sessions, logs | HIGH |
| Generic thresholds rather than agent-type baselines | Same anomaly thresholds applied to coding agent, customer-support agent, and data-analysis agent | HIGH |
| No behavioral metrics tracked | Only infrastructure metrics (CPU, memory) exposed; no agent-level metrics (API call rate, data access volume, decision frequency, error rate) | HIGH |
| No circuit breakers on dependent workflows | Workflows that invoke the agent do not have Catch states or fallback paths when the agent is unavailable | HIGH |
| Restoration is single-person | Re-activation after containment can be done by one operator | MEDIUM |
| No containment drills | Containment procedure has never been tested; first execution would be during a real incident | HIGH |
| IAM role deleted on containment | Containment deletes the agent IAM role, destroying forensic evidence | MEDIUM |

## 3. Rules (Constraints)

- **MUST** verify behavioral baselines exist per agent type and per metric, with dynamic thresholds that adapt to normal variation.
- **MUST** verify containment triggers automatically when anomaly severity exceeds configured thresholds — not via a manual runbook.
- **MUST** verify the containment sequence captures forensic state BEFORE isolation (memory, sessions, pending operations, recent tool invocations).
- **MUST** verify containment revokes credentials by attaching a deny-all policy (not by deleting the IAM role).
- **MUST** verify a quarantine event is broadcast so dependent workflows activate circuit-breaker logic.
- **MUST** verify dependent workflows have Catch states that route to safe fallback paths on agent unavailability.
- **MUST** verify restoration requires multi-person authorization.
- **MUST** verify containment drills are run on a defined cadence (quarterly minimum) to validate isolation and circuit breakers work end-to-end.
- **MUST NOT** flag an agent as uncontained solely because manual intervention is possible — the question is whether automated containment exists when the threshold fires.
- **MUST** map every finding to a real control ID from a `frameworks` entry.

## 4. Remediation

**Before (vulnerable):**

```yaml
# Incident response runbook (manual only)
- step: Observe anomaly alert in Slack
- step: On-call engineer logs in and investigates
- step: If malicious, engineer disables agent via console
# No forensic preservation step
# No automation
# Agent continues running while responder mobilizes
```

**After (remediated) — AWS reference implementation:**

```yaml
# High-level flow
# CloudWatch Alarm (behavioral metric exceeds anomaly threshold)
#   → EventBridge Rule
#     → Step Functions state machine "agent-containment"
#       1. Capture forensic snapshot → S3
#       2. Attach deny-all policy to agent IAM role (preserve role)
#       3. Broadcast quarantine event → EventBridge
#       4. Notify responders → SNS
# Downstream workflows subscribe to quarantine events and activate Catch states
```

```python
# containment/handler.py (Lambda invoked by Step Functions)
import boto3, json, uuid, time

iam = boto3.client("iam")
s3 = boto3.client("s3")
events = boto3.client("events")
sns = boto3.client("sns")

FORENSIC_BUCKET = "agent-forensics-<account>-<region>"
DENY_ALL_POLICY = json.dumps({
    "Version": "2012-10-17",
    "Statement": [{"Effect": "Deny", "Action": "*", "Resource": "*"}]
})

def contain(event):
    agent_id = event["agent_id"]
    agent_role = event["agent_role_arn"]
    reason = event["reason"]
    incident_id = f"inc-{uuid.uuid4()}"

    # 1. Forensic snapshot BEFORE anything else
    snapshot = capture_forensic_state(agent_id)   # memory, sessions, recent tool calls
    s3.put_object(
        Bucket=FORENSIC_BUCKET,
        Key=f"{incident_id}/{agent_id}/snapshot.json",
        Body=json.dumps(snapshot),
        ServerSideEncryption="aws:kms"
    )

    # 2. Revoke credentials by attaching deny-all inline policy; preserve role
    iam.put_role_policy(
        RoleName=agent_role.split("/")[-1],
        PolicyName=f"quarantine-{incident_id}",
        PolicyDocument=DENY_ALL_POLICY
    )

    # 3. Broadcast quarantine event
    events.put_events(Entries=[{
        "Source": "agent.containment",
        "DetailType": "AgentQuarantined",
        "Detail": json.dumps({
            "incident_id": incident_id,
            "agent_id": agent_id,
            "reason": reason,
            "timestamp": time.time()
        })
    }])

    # 4. Notify responders
    sns.publish(
        TopicArn=RESPONDER_TOPIC,
        Subject=f"[CONTAINED] Agent {agent_id}",
        Message=f"Agent {agent_id} contained. Incident {incident_id}. Reason: {reason}"
    )
    return {"incident_id": incident_id, "status": "contained"}
```

Dependent workflow circuit-breaker pattern:

```json
// Step Functions state machine fragment for a workflow that invokes an agent
{
  "States": {
    "InvokeAgent": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:function:invoke-agent",
      "Catch": [
        {
          "ErrorEquals": ["AgentQuarantinedError", "AgentUnavailableError"],
          "Next": "SafeFallback"
        }
      ],
      "Next": "Continue"
    },
    "SafeFallback": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:function:safe-fallback-handler",
      "End": true
    }
  }
}
```

**Fix recommendation output:**

```yaml
remediations:
  - guidance: >
      Implement automated containment sequence triggered by CloudWatch alarms
      on per-agent behavioral baselines. Sequence must be: (1) forensic
      snapshot to S3 BEFORE isolation; (2) deny-all inline policy on the agent
      IAM role (preserve the role); (3) quarantine event broadcast via
      EventBridge; (4) responder notification via SNS. Add Catch states in
      dependent workflows that route to safe-fallback handlers on quarantine.
      Require multi-person authorization for restoration. Run containment
      drills quarterly.
    confidence: high
    blast_radius: >
      New Step Functions state machine, Lambda handler, EventBridge rules,
      SNS topics. Catch states added to every dependent workflow (typically
      3-10 state machines). Containment drills added to operational cadence.
    behavior_change_risk: medium
    test_strategy:
      summary: "Prove automated containment fires on threshold, captures evidence, isolates the agent, and dependent workflows degrade gracefully."
      recommended_tests:
        - name: containment_fires_automatically
          type: integration
          purpose: "A simulated anomaly above threshold triggers containment within SLA."
          command: "./scripts/drill_simulate_anomaly.sh"
          expected_result: "containment-SLA met; forensic snapshot exists in S3; deny-all policy attached"
        - name: dependent_workflows_degrade
          type: integration
          purpose: "A workflow invoking the quarantined agent routes to SafeFallback without failing."
          command: "aws stepfunctions start-execution --state-machine-arn <dependent> --input ..."
          expected_result: "execution completes via SafeFallback state"
        - name: restoration_requires_two
          type: integration
          purpose: "Single-person restoration attempt must be denied."
          command: "./scripts/test_restore_single_person.sh"
          expected_result: "DENIED"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | Agent infrastructure configuration + incident response runbooks |
| **Expected output** | Finding(s) for each missing containment element |
| **Pass condition** | All of: automated trigger on threshold, forensic snapshot before isolation, deny-all policy (not role deletion), quarantine event broadcast, Catch states in dependent workflows, multi-person restoration, drills run in the last 90 days |
| **Fail condition** | Any of the above is missing, OR drills have never been run, OR containment deletes the IAM role |

## 6. Gotchas

**False positives**

- **Pattern:** A development environment where containment is intentionally relaxed. **Why:** Non-production. **Suppress:** Verify production has the full sequence.
- **Pattern:** A low-risk informational agent (read-only, no side effects) with simpler containment. **Why:** Risk profile may justify. **Suppress:** Verify the agent genuinely has no write capability and cannot be used as a pivot.

**Precision traps**

- **Trap:** Deny-all policies can race with in-flight requests, which may partially complete before credentials are revoked. **Mitigation:** Containment must also pause dependent workflows and/or wait for in-flight requests to drain.
- **Trap:** Forensic snapshot can itself leak sensitive data if the snapshot location is not access-controlled. **Mitigation:** Forensic bucket must use stricter access controls than the agent's own account; cross-account write with deny-delete.

**Do NOT flag:**

- Development scaffolding clearly marked non-production.
- Agents in a sandboxed test environment where containment has different requirements.
- Role deletion on decommissioning (that's intentional, not a containment event).

## 7. References

- [drill-playbook.md](drill-playbook.md) — quarterly containment drill script
- [forensic-snapshot-schema.md](forensic-snapshot-schema.md) — schema for forensic snapshots
- NIST SP 800-61r2 — Computer Security Incident Handling Guide
- AWS Agentic AI Lens — [AGENTSEC07-BP04](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec07-bp04.html)
- MITRE ATLAS

---

*Agentic AI Security Skills — behavioural-anomaly-containment v1.0.0*
