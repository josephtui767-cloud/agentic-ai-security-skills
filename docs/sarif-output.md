# SARIF 2.1.0 Output Mapping

When SARIF output is requested, skills map normalized findings to SARIF 2.1.0-compatible JSON. The normalized contract in [`normalized-json-output.md`](normalized-json-output.md) remains the source of truth — SARIF is a presentation format.

## Minimal SARIF shape

```json
{
  "version": "2.1.0",
  "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "agentic-ai-security-skills/<skill-name>",
          "version": "1.0.0",
          "informationUri": "https://github.com/agentic-ai-security-skills",
          "rules": [
            {
              "id": "<skill-name>-<rule-id>",
              "name": "<rule-short-name>",
              "shortDescription": { "text": "<one line>" },
              "fullDescription": { "text": "<multi-line description>" },
              "helpUri": "<link to the skill or framework>",
              "defaultConfiguration": { "level": "error" },
              "properties": {
                "frameworks": ["OWASP-Agentic-Top-10-2026", "AWS-Agentic-AI-Lens"],
                "control_ids": ["LLM03", "AGENTSEC01-BP01"]
              }
            }
          ]
        }
      },
      "results": [
        {
          "ruleId": "<skill-name>-<rule-id>",
          "level": "error",
          "message": { "text": "<finding.title>" },
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": { "uri": "src/agent/memory.py" },
                "region": {
                  "startLine": 42,
                  "snippet": { "text": "memory = SharedMemory(namespace='global')" }
                }
              }
            }
          ],
          "properties": {
            "confidence": "high",
            "cwe": ["CWE-668"],
            "remediation": "<finding.remediations[0].guidance>",
            "blast_radius": "<finding.remediations[0].blast_radius>"
          }
        }
      ]
    }
  ]
}
```

## Severity mapping

| Normalized severity | SARIF level |
|---------------------|-------------|
| `critical` | `error` |
| `high` | `error` |
| `medium` | `warning` |
| `low` | `note` |
| `info` | `none` |

## Rule ID convention

`<skill-name>-<rule-id>` where `<rule-id>` is the finding `id` prefix (e.g. `MEM-001` becomes `memory-isolation-MEM-001`).

## Framework references in SARIF

Use `properties.frameworks[]` and `properties.control_ids[]` on each rule and result. Keep the normalized `framework_refs` structure unchanged in the normalized JSON output; SARIF is a parallel representation, not a replacement.
