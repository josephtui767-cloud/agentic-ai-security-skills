---
name: agent-identity-separation
description: >
  Reviews agentic AI systems for distinct agent identities separate from human
  user identities, with user context propagated as signed token claims rather
  than through role assumption. Catches the common anti-pattern where agents
  inherit a user's full IAM permissions, which collapses the audit trail and
  grants the agent the user's entire permission set for the session. Auto-
  invoked when reviewing authentication, IAM policies, or on-behalf-of flows
  in agentic systems.
tags: [agent-identity, iam, separation, jwt]
role: [ai-security-engineer, identity-engineer]
phase: [design, build, review]
frameworks: [OWASP-Agentic-AI, NIST-SP-800-63B, AWS-Agentic-AI-Lens]
difficulty: advanced
time_estimate: "60-120min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase-or-iam-config]"
---

# Agent Identity Separation Review

Reviews agentic AI systems for distinct agent identities and correct propagation of user context as token claims. Aligned with **OWASP Agentic AI (Identity & Privilege Abuse)**, **NIST SP 800-63B (Authentication and Lifecycle Management)**, and the AWS Well-Architected Agentic AI Lens best practice **AGENTSEC03-BP02: Separate agent and human user permission**.

## The Core Issue

An agent that acts "on behalf of" a user must still be identifiable *as the agent* in logs, audits, and policy evaluation. The common anti-pattern is to have the agent assume the user's role, which collapses the audit trail (every log entry looks like the user did it), grants the agent the user's full permission set (including permissions the agent should never have), and removes the ability to distinguish agent actions from human actions during incident investigation.

The correct pattern:

- The agent runs under its own service identity (distinct IAM role / workload identity, distinct from any human role).
- When acting on behalf of a user, the agent carries user context as **signed token claims** through the call chain. The agent does NOT assume the user's credentials or role.
- Downstream services evaluate authorization against both the agent identity (who is calling) and the user context claim (who authorized this call).

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing an agent that performs actions on behalf of users.**
- **Reviewing IAM roles and policies for agentic systems.**
- **Reviewing "on-behalf-of" authentication flows.**
- **Reviewing CloudTrail / audit log patterns for an agentic workload.**
- **After an incident** where investigators could not tell whether a given API call was made by an agent or a human.

## 2. What to Detect

| Signal | Pattern | Confidence |
|---|---|---|
| Agent assumes user IAM role | Agent code calls `sts:AssumeRole` with a user-tagged role ARN, or passes user credentials to the agent | HIGH |
| Agent reuses human user credentials | Environment variables or config contain `AWS_ACCESS_KEY_ID` from a human user | HIGH |
| Single shared service account for multiple agents | Multiple agent deployments share the same IAM role | MEDIUM |
| Audit log attribution ambiguous | CloudTrail events from agent operations do not include an agent principal tag or identifiable role name convention | HIGH |
| No SCP guardrail between agent and human roles | AWS Organizations SCPs do not deny `sts:AssumeRole` from agent principals to human-tagged roles | MEDIUM |
| User context lost at service boundaries | Agent calls a downstream service without propagating a signed user claim (`onBehalfOf`, `act.sub`, equivalent) | HIGH |
| Role chaining collapses attribution | Delegation chain does not carry parent agent identifier in session names | MEDIUM |

## 3. Rules (Constraints)

- **MUST** verify each agent has a dedicated IAM role or workload identity, distinct from any human user role.
- **MUST** verify a consistent naming convention identifies agent roles (e.g. `agent-role-<name>` prefix) and that all agent roles carry a `PrincipalType: Agent` tag.
- **MUST** verify SCPs or equivalent organization-level controls deny agents from assuming human-operator roles.
- **MUST** verify on-behalf-of flows carry user context as signed JWT claims (`onBehalfOf`, `act`, `delegated_from`, or equivalent) through the call chain, not through role assumption.
- **MUST** verify downstream services evaluate authorization against both agent identity and user context claim.
- **MUST** verify role session names in delegation chains include the parent agent identifier.
- **MUST** verify CloudTrail / audit logs can filter agent activity distinctly from human activity.
- **MUST NOT** flag a workload that uses a single IAM role for the agent's own autonomous operations as an anti-pattern — this is correct. The anti-pattern is reusing a *human* role for the agent.
- **MUST** map every finding to a real control ID from a `frameworks` entry.

## 4. Remediation

When machine-readable output is requested, findings MUST be available as JSON that validates against [`schemas/finding.schema.json`](../../../schemas/finding.schema.json).

**Before (vulnerable):**

```python
# src/agent/auth.py — anti-pattern: assume the user's role
def get_credentials_for_user(user_arn: str):
    sts = boto3.client("sts")
    response = sts.assume_role(
        RoleArn=user_arn,                        # user's human role
        RoleSessionName="agent-session"          # no agent attribution
    )
    return response["Credentials"]               # agent now acts AS the user
```

**After (remediated):**

```python
# src/agent/auth.py — correct: agent uses its own identity, carries user context as claim
import jwt
from datetime import datetime, timedelta, timezone

def get_agent_token_for_user(user_jwt: str) -> str:
    # Verify user token
    user_claims = jwt.decode(user_jwt, key=USER_JWT_PUBLIC_KEY, algorithms=["RS256"])

    # Agent identity is signed by the workload identity service
    now = datetime.now(timezone.utc)
    agent_claims = {
        "sub": AGENT_WORKLOAD_IDENTITY,          # the agent's own identity
        "iss": AGENT_IDENTITY_ISSUER,
        "iat": int(now.timestamp()),
        "exp": int((now + timedelta(minutes=15)).timestamp()),
        # Standard RFC 8693 "act" claim carries the acting-for-user context
        "act": {
            "sub": user_claims["sub"],
            "iss": user_claims["iss"]
        }
    }
    return jwt.encode(agent_claims, key=AGENT_PRIVATE_KEY, algorithm="RS256")
```

Downstream service authorization must evaluate both claims:

```python
# src/downstream/authz.py
def authorize_request(token):
    claims = jwt.decode(token, key=AGENT_PUBLIC_KEY, algorithms=["RS256"])
    agent_id = claims["sub"]
    acting_user = claims.get("act", {}).get("sub")

    # Both must be checked
    if not is_approved_agent(agent_id):
        return deny("unknown agent identity")
    if acting_user and not user_can_perform(acting_user, request.action, request.resource):
        return deny("user not authorized for this action")
    if not agent_can_perform(agent_id, request.action, request.resource):
        return deny("agent not authorized for this action")
    return allow()
```

SCP example (AWS Organizations) — deny agents from assuming human-tagged roles:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAgentAssumingHumanRoles",
      "Effect": "Deny",
      "Action": "sts:AssumeRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalTag/PrincipalType": "Agent",
          "aws:ResourceTag/PrincipalType": "Human"
        }
      }
    }
  ]
}
```

**Fix recommendation output:**

```yaml
remediations:
  - guidance: >
      Create a dedicated IAM role per agent with naming convention
      `agent-role-<name>` and PrincipalType:Agent tag. Replace sts:AssumeRole
      flows with signed JWT claims (RFC 8693 'act' claim or equivalent) that
      carry user context without delegating credentials. Add SCP guardrails
      that deny agents from assuming human-tagged roles. Update downstream
      authorization to evaluate both agent identity and user context claim.
    confidence: high
    blast_radius: >
      Every on-behalf-of flow, every downstream service that authorizes based
      on the caller, IAM roles for all agents, organization SCPs. Medium-sized
      refactor touching auth, IAM, and downstream services.
    behavior_change_risk: high
    test_strategy:
      summary: "Prove agent identity is distinct, user context propagates, and SCPs block cross-type role assumption."
      recommended_tests:
        - name: agent_identity_distinct
          type: integration
          purpose: "Agent action must log with agent role ARN, never human role ARN."
          command: "pytest tests/auth/test_agent_identity.py::test_distinct -v"
          expected_result: "PASSED"
        - name: user_context_propagates
          type: integration
          purpose: "Downstream service receives and validates 'act' claim."
          command: "pytest tests/auth/test_agent_identity.py::test_user_context -v"
          expected_result: "PASSED"
        - name: scp_blocks_human_role
          type: integration
          purpose: "Agent cannot assume a role tagged PrincipalType:Human."
          command: "pytest tests/iam/test_scp_boundaries.py -v"
          expected_result: "PASSED"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | Any agent repository + IAM config |
| **Expected output** | Findings for each identity-separation gap with evidence |
| **Pass condition** | All three hold: (1) agents have dedicated roles with naming + tag convention; (2) user context flows as token claims, not role assumption; (3) SCPs block agent-to-human role assumption |
| **Fail condition** | Any agent assumes a human user's role, OR any on-behalf-of flow passes user credentials rather than claims, OR CloudTrail cannot filter agent-vs-human activity |

## 6. Gotchas (self-improvement loop)

**False positives**

- **Pattern:** Development scaffolding where a single developer's credentials are used for local agent iteration. **Why:** Dev environment. **Suppress:** Only if production uses the correct pattern.
- **Pattern:** Multi-tenant SaaS agents that use a single IAM role scoped by resource tag. **Why:** Legitimate if the agent identity itself is the role; user context flows separately via claims.

**Precision traps**

- **Trap:** Replacing `AssumeRole` flows mid-production can break downstream services that only look at the caller role. **Mitigation:** Stage the migration — introduce JWT claim propagation first, update downstream authz to accept both patterns, then remove role-assumption paths.
- **Trap:** Role naming conventions alone don't enforce the separation — the SCP is what makes it binding. **Mitigation:** Always require both the naming/tag convention AND the SCP.

**Do NOT flag:**

- Agents that run fully autonomously under a single dedicated agent role with no user context — this is the correct pattern for autonomous workloads.
- IAM Identity Center configurations where humans authenticate independently of the agent.
- Reference examples clearly labeled as dev-only.

## 7. References (progressive disclosure)

- [patterns.md](patterns.md) — language and cloud-platform-specific patterns
- [jwt-act-claim-rfc8693.md](jwt-act-claim-rfc8693.md) — reference for RFC 8693 act claim usage
- OWASP Agentic AI — [Identity & Privilege Abuse](https://genai.owasp.org/resource/agentic-ai-threats-and-mitigations/)
- AWS Agentic AI Lens — [AGENTSEC03-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec03-bp02.html)
- [RFC 8693: OAuth 2.0 Token Exchange](https://datatracker.ietf.org/doc/html/rfc8693) — section 4.1 covers the `act` claim
- NIST SP 800-63B — Digital Identity Guidelines

---

*Agentic AI Security Skills — agent-identity-separation v1.0.0*
