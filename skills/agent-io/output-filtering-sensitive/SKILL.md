---
name: output-filtering-sensitive
description: >
  Reviews agentic AI systems for sensitive-data filtering on EVERY outbound
  path, not just the user-facing response. Catches the common gap where PII
  and credentials are filtered on responses to end users but flow unchecked
  through inter-agent messages, memory writes, audit logs, and tool
  invocations. Auto-invoked when reviewing agent output handling, DLP
  configurations, or multi-agent message flows.
tags: [agent-io, output, pii, dlp]
role: [ai-security-engineer, grc]
phase: [build, operate, review]
frameworks: [OWASP-LLM02-2025, NIST-SP-800-53-Rev5, AWS-Agentic-AI-Lens]
difficulty: intermediate
time_estimate: "30-60min"
version: "1.0.0"
author: agentic-ai-skills
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true
argument-hint: "[target-agent-codebase]"
---

# Output Filtering for Sensitive Data

Reviews agentic AI systems for sensitive-data filtering on every outbound path. Aligned with **OWASP LLM02:2025 (Sensitive Information Disclosure)**, **NIST SP 800-53 SC-8 (Transmission Confidentiality and Integrity)**, and the AWS Well-Architected Agentic AI Lens best practice **AGENTSEC08-BP02: Output filtering for sensitive information**.

## The Core Issue

Teams routinely filter sensitive data on responses to end users. The same filter is rarely applied to the other three channels agents produce outputs on:

1. **Inter-agent messages** — Agent A sends unfiltered content to Agent B.
2. **Memory writes** — Agent writes PII into long-term memory where later sessions retrieve it.
3. **Audit logs** — Agent reasoning chain containing PII lands in log storage.

Prompt-injection attacks specifically target the channel teams don't filter. An attacker that cannot exfiltrate through the user-facing response may be able to exfiltrate through an inter-agent message if those are not filtered.

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **Reviewing an agent that processes any PII, credentials, or regulated data.**
- **Reviewing multi-agent handoffs** where content passes between agents.
- **Reviewing memory writes** in agents that persist data across sessions.
- **Reviewing audit log configurations** that capture agent reasoning or tool outputs.
- **After a DLP finding** or suspected data exfiltration incident involving an agent.

## 2. What to Detect

| Signal | Pattern | Confidence |
|---|---|---|
| Output filter applied only to end-user response | Output pipeline has `guardrails.filter(response)` at user boundary, but no filter on inter-agent messages or memory writes | HIGH |
| Memory write path unfiltered | `memory.create_event(user_input)` or `memory.put(agent_output)` without a sensitive-info filter | HIGH |
| Inter-agent message unfiltered | Agent A invokes Agent B passing raw content without filtering | HIGH |
| Audit log captures PII in cleartext | Log statements that include prompt or response content without masking | HIGH |
| Model-generated content copied into email / webhook without filter | Tool invocation sends model output directly to external endpoint | HIGH |
| No explicit action per category | Filter configured but no MASK / BLOCK distinction for different sensitivity levels | MEDIUM |
| Custom entity recognizers absent for org-specific sensitive types | Only built-in PII categories filtered; organization-specific identifiers unprotected | LOW |

## 3. Rules (Constraints)

- **MUST** verify every outbound path from the agent passes through a sensitive-information filter: user-facing responses, inter-agent messages, memory writes, audit logs, and tool invocations that reach external systems.
- **MUST** verify the filter action is calibrated per data category: MASK for most PII, BLOCK for credentials, private keys, and highest-sensitivity identifiers.
- **MUST** verify logs mask sensitive data before persistence (e.g. CloudWatch Logs data protection policies or equivalent).
- **MUST** verify a signal path exists to alert on elevated sensitive-data detection rates (a trending increase in filter hits is a prompt-injection or exfiltration signal).
- **MUST** verify custom entity recognizers (Amazon Comprehend custom entities, Presidio custom recognizers, or equivalent) cover organization-specific sensitive data types.
- **MUST NOT** flag an output path as unprotected if the data classification policy explicitly permits the content on that path.
- **MUST** map every finding to a real control ID from a `frameworks` entry.

## 4. Remediation

**Before (vulnerable):**

```python
# src/agent/respond.py
def respond(user_query: str) -> str:
    reasoning = model.generate(user_query)        # internal reasoning chain
    log.info(f"Agent reasoning: {reasoning}")     # unfiltered log with potential PII
    memory.create_event(session_id=sid, content=reasoning)  # unfiltered memory write
    final = model.generate(reasoning)             # response generation
    return guardrails.filter(final)               # filter only here
```

**After (remediated):**

```python
# src/agent/output.py — shared output filter applied to every outbound surface
from guardrails import SensitiveInfoFilter

FILTER = SensitiveInfoFilter(
    categories={
        # BLOCK: never let these leave the agent
        "AWS_ACCESS_KEY": "BLOCK",
        "PRIVATE_KEY":    "BLOCK",
        "API_TOKEN":      "BLOCK",
        # MASK: preserve utility while protecting the content
        "EMAIL":          "MASK",
        "PHONE":          "MASK",
        "SSN":            "MASK",
        "CREDIT_CARD":    "MASK",
        "ADDRESS":        "MASK",
        # Custom entity recognizers for org-specific IDs
        "CUSTOMER_ID":    "MASK",
        "EMPLOYEE_ID":    "MASK",
    }
)

def filter_outbound(content: str, destination: str) -> str:
    result = FILTER.apply(content)
    if result.blocked_categories:
        metrics.incr("agent.output_blocked",
                     tags={"destination": destination,
                           "categories": result.blocked_categories})
    return result.masked_content

# src/agent/respond.py
def respond(user_query: str) -> str:
    reasoning = model.generate(user_query)

    # Every outbound path is filtered
    log.info(f"Agent reasoning: {filter_outbound(reasoning, destination='log')}")
    memory.create_event(session_id=sid,
                        content=filter_outbound(reasoning, destination='memory'))

    final = model.generate(reasoning)
    return filter_outbound(final, destination='user_response')

# src/agent/multi_agent.py
def invoke_downstream(agent_id: str, payload: str):
    filtered = filter_outbound(payload, destination=f'agent:{agent_id}')
    return a2a_client.invoke(agent_id, payload=filtered)
```

**Fix recommendation output:**

```yaml
remediations:
  - guidance: >
      Centralize output filtering into a single shared function and apply it to
      every outbound surface: user responses, inter-agent messages, memory
      writes, log statements, and external tool invocations. Use MASK for most
      PII categories to preserve utility, BLOCK for credentials and private
      keys. Add CloudWatch alarms on elevated detection rates per destination
      category — spikes are prompt-injection or exfiltration signals. Add
      custom entity recognizers for organization-specific identifiers.
    confidence: high
    blast_radius: "All outbound paths across the agent. Typically 5-15 call sites refactored to use a shared filter."
    behavior_change_risk: low
    test_strategy:
      summary: "Prove no sensitive data leaves the agent through any channel without being masked or blocked."
      recommended_tests:
        - name: credentials_blocked_everywhere
          type: integration
          purpose: "API tokens and private keys must be BLOCKED on every outbound surface."
          command: "pytest tests/agent/test_output_filter.py::test_credentials_blocked -v"
          expected_result: "all passed"
        - name: pii_masked_on_memory_write
          type: integration
          purpose: "Emails, phones, SSNs persisted in memory must be masked at write time."
          command: "pytest tests/agent/test_output_filter.py::test_memory_masking -v"
          expected_result: "PASSED"
        - name: pii_masked_on_log
          type: unit
          purpose: "Log lines containing PII are masked before reaching the log sink."
          command: "pytest tests/agent/test_output_filter.py::test_log_masking -v"
          expected_result: "PASSED"
        - name: alarm_on_elevated_detections
          type: integration
          purpose: "Elevated sensitive-data detection rate fires an alarm."
          command: "pytest tests/agent/test_output_filter.py::test_detection_alarm -v"
          expected_result: "PASSED"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | Any agent with multiple outbound surfaces |
| **Expected output** | Finding(s) for each outbound surface missing the sensitive-info filter |
| **Pass condition** | Every outbound path uses a shared filter configured with explicit MASK/BLOCK actions per category |
| **Fail condition** | Any outbound surface (log, memory write, inter-agent message, external tool call) does not pass through the filter |

## 6. Gotchas

**False positives**

- **Pattern:** Internal debug logs behind a feature flag off in production. **Why:** Non-production path. **Suppress:** Verify the flag is enforced off in production manifests.
- **Pattern:** Audit logs that intentionally store some PII because of a regulatory retention requirement (right to be forgotten, GDPR records of processing). **Why:** Explicit policy decision. **Suppress:** Confirm the retention policy is documented and the audit log itself has stronger access controls.

**Precision traps**

- **Trap:** Masking identifiers used as lookup keys will break downstream operations that need to resolve them. **Mitigation:** Use tokenization (deterministic, reversible with keys) for lookup keys; use masking for display values.
- **Trap:** Applying the filter at the model-invocation layer but not at the write-to-memory layer — the raw content is still in memory. **Mitigation:** Filter on egress from the agent, not just on model invocation.

**Do NOT flag:**

- Test fixtures and sample data.
- Documentation showing redacted examples.
- Development-only tooling marked clearly.

## 7. References

- [patterns.md](patterns.md) — language and platform-specific filter integration patterns
- [custom-entity-recognizers.md](custom-entity-recognizers.md) — how to add Comprehend / Presidio custom recognizers
- OWASP LLM Top 10 — [LLM02:2025 Sensitive Information Disclosure](https://genai.owasp.org/llmrisk/llm02-sensitive-information-disclosure/)
- AWS Agentic AI Lens — [AGENTSEC08-BP02](https://docs.aws.amazon.com/wellarchitected/latest/agentic-ai-lens/agentsec08-bp02.html)
- NIST SP 800-53 SC-8 — Transmission Confidentiality and Integrity

---

*Agentic AI Security Skills — output-filtering-sensitive v1.0.0*
