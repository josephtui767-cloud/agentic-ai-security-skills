<!--
Agentic AI Security Skills — Skill Template (v1)
Copy this file to skills/<domain>/<skill-name>/SKILL.md and fill it in.
Domains: agent-architecture · agent-memory · agent-tools · agent-identity ·
         agent-alignment · agent-observability · multi-agent · agent-containment ·
         agent-io · agent-testing · agent-threat-detection · agent-lifecycle ·
         agent-data · agent-infrastructure · agent-recovery
-->
---
name: my-skill-name                       # kebab-case, MUST match the directory name
description: >                            # 2-4 sentences: what it does + when it auto-invokes.
  One-line summary of the security outcome, then the trigger conditions
  ("Auto-invoked when the user ... or asks ..."). This is what an agent reads
  to decide whether to load the skill, so lead with behavior, not jargon.
tags: [ai-security, agentic-ai]           # domain + activity keywords
role: [ai-security-engineer]              # role bundles that should include this skill
phase: [design, build, review]            # design | build | deploy | operate | respond | review
frameworks: [OWASP-Agentic-AI, OWASP-LLM01-2025]  # frameworks cited — REAL control IDs only
difficulty: intermediate                  # beginner | intermediate | advanced
time_estimate: "30-60min"
version: "1.0.0"
author: your-handle
license: MIT
allowed-tools: Read, Grep, Glob
injection-hardened: true                  # true only after SECURITY.md review
argument-hint: "[target-agent-or-directory]"
---

# <Skill Name> — <Methodology / Framework>

## 1. When to Use

If a target is provided via arguments, focus the review on: $ARGUMENTS

Invoke this skill when:

- **<Trigger 1>** — concrete situation that should activate the skill.
- **<Trigger 2>** — another concrete situation.
- **<Trigger 3>** — ...

## 2. What to Detect

What signals tell the agent this issue is present? Be precise — give patterns the agent can match, not just descriptions.

| Signal | Pattern | Confidence |
|---|---|---|
| Regex | `<pattern>` | HIGH |
| Structural | `<structural indicator>` | HIGH |
| Behavioral | `<behavior to observe>` | MEDIUM |

> For long pattern libraries, put them in a sibling reference file (see §7) and link here.

## 3. Rules (Constraints)

Hard rules only — falsifiable and enforceable. No "consider" / "may" language.

- **MUST** map every finding to a real control ID from a `frameworks` entry.
- **MUST NOT** emit a control ID that doesn't resolve in the cited framework.
- **MUST** <skill-specific hard rule>.
- **MUST NOT** <skill-specific hard rule>.

## 4. Remediation

When machine-readable output is requested, findings MUST be available as JSON that validates against [`schemas/finding.schema.json`](../../../schemas/finding.schema.json). See [`docs/normalized-json-output.md`](../../../docs/normalized-json-output.md).

**Before (vulnerable):**
```
<minimal vulnerable example>
```

**After (remediated):**
```
<what the agent should produce>
```

**Fix recommendation output:**
```yaml
remediations:
  - guidance: "<concrete remediation steps>"
    confidence: high
    blast_radius: "<affected files, users, systems>"
    behavior_change_risk: medium
    test_strategy:
      summary: "<what proves this remediation fixed the finding>"
      recommended_tests:
        - name: "<test name>"
          type: regression
          purpose: "<vulnerable behavior this test proves>"
          command: "<command or manual check>"
          expected_result: "<binary passing result>"
```

## 5. Verification (falsifiable)

| | |
|---|---|
| **Input** | minimal vulnerable case |
| **Expected output** | what the remediated version produces |
| **Pass condition** | specific + binary |
| **Fail condition** | specific + binary |

## 6. Gotchas (self-improvement loop)

**False positives**
- **Pattern:** <what trips it> — **Why:** <context> — **Suppress:** <guidance>
- **Pattern:** ... — **Why:** ... — **Suppress:** ...

**Precision traps**
- **Trap:** where the remediation breaks behavior — **Mitigation:** how to preserve intent.

**Do NOT flag:** <explicit list of safe patterns>.

## 7. References (progressive disclosure)

When content exceeds ~500 lines, split detail into sibling files:

```
skills/<domain>/<skill-name>/
├── SKILL.md                 ← this file (lean entrypoint)
├── patterns.md              ← full detection-pattern library
└── <platform>.md            ← platform-specific guidance
```

- [patterns.md](patterns.md) — extended detection patterns

---

*Agentic AI Security Skills — Skill Template v1*
