# Contributing to Agentic AI Security Skills

Thanks for contributing. This repository holds structured security skills for AI coding agents, agentic AI platforms, and multi-agent systems. Every skill must meet the quality bar described below and cite real published framework controls.

## Quality Bar

Every merged skill must:

1. **Cite real frameworks and real control IDs.** No invented controls, no hallucinated references. Every ID in `frameworks` frontmatter must resolve in [`data/frameworks.yaml`](data/frameworks.yaml).
2. **Be injection-hardened.** Reviewed against OWASP LLM01:2025 before `injection-hardened: true` is set. See [`SECURITY.md`](SECURITY.md).
3. **Be falsifiable.** Section 5 (Verification) must specify a binary pass/fail test.
4. **Emit normalized findings.** Findings must be available as JSON that validates against [`schemas/finding.schema.json`](schemas/finding.schema.json).
5. **Handle progressive disclosure.** When content exceeds ~500 lines, split into sibling reference files.
6. **Not contain internal tool names, organization-specific terms, or non-public identifiers.** Skills must be usable by anyone.

## How to Add a Skill

1. Copy [`SKILL_TEMPLATE.md`](SKILL_TEMPLATE.md) to `skills/<domain>/<skill-name>/SKILL.md`.
2. Fill in the frontmatter. `name` must match the directory name (kebab-case).
3. Fill in sections 1-7. Keep `SKILL.md` lean; long detail goes in sibling files.
4. Add an entry to [`index.yaml`](index.yaml) under the correct domain.
5. Validate locally:

   ```bash
   ruby scripts/validate_skill_schema.rb
   ruby scripts/validate_framework_registry.rb
   ruby scripts/validate_index.rb
   ```

6. Open a PR with a clear description. Use the title format `feat(skill): <skill-name> — <what it covers>`.

## Domains

Current domains:

- `agent-architecture` — agent scoping, LLM-use minimization, session isolation
- `agent-memory` — memory isolation, input validation, hallucination propagation
- `agent-tools` — tool authorization, parameter validation, MCP governance
- `agent-identity` — identity separation, least privilege, adaptive auth
- `agent-alignment` — guardrails, HITL, multi-reviewer consensus
- `agent-observability` — decision logging, distributed tracing, baselines
- `multi-agent` — message signing, orchestration security, trust boundaries
- `agent-containment` — anomaly containment, emergency shutdown, forensics
- `agent-io` — input validation, indirect prompt injection, output filtering
- `agent-testing` — automated testing, red team, pen test, SDLC scanning
- `agent-threat-detection` — runtime correlation, guardrail metrics
- `agent-lifecycle` — prompts as code, CI/CD gates, portfolio governance
- `agent-data` — fine-tune pipelines, DLP, data governance
- `agent-infrastructure` — isolation, edge protection, CNAPP
- `agent-recovery` — BCP, automated recovery, checkpointing

Propose new domains via issue before adding skills under them.

## Framework Registry

All framework IDs cited in skill frontmatter must exist in [`data/frameworks.yaml`](data/frameworks.yaml). When adding a new framework reference:

1. Add it to the registry with family, name, version, URL, date reviewed, and owner domain.
2. Update the `required_families` list if it's a new family.
3. Run `ruby scripts/validate_framework_registry.rb` to verify.

## Role Bundles

Role bundles in `roles/<role>/SKILL.md` orchestrate multiple skills for a specific engagement. When adding or changing a role bundle:

1. The skills in the bundle must already exist.
2. The order matters — bundles describe the sequence for the engagement.
3. Update the role table in `README.md`.

## Testing Skills

Each skill should have a falsifiable verification test (Section 5 of `SKILL.md`). For skills with detection patterns, add a fixture:

```
skills/<domain>/<skill-name>/
├── SKILL.md
└── fixtures/
    ├── vulnerable/              # samples the skill must flag
    └── safe/                    # samples the skill must NOT flag
```

Run fixture tests with:

```bash
ruby scripts/test_skill_fixtures.rb
```

## PR Checklist

- [ ] Directory is `skills/<domain>/<skill-name>/`
- [ ] Frontmatter complete and valid against `schemas/skill.schema.json`
- [ ] `name` matches directory
- [ ] Every framework ID resolves in `data/frameworks.yaml`
- [ ] At least one machine-matchable detection signal
- [ ] Findings documented as normalized JSON
- [ ] Rules are hard constraints (no "consider" or "may")
- [ ] Before/after remediation example
- [ ] Falsifiable verification (binary pass/fail)
- [ ] ≥2 false positives + ≥1 precision trap in Gotchas
- [ ] `SKILL.md` stays lean; long detail in reference files
- [ ] `injection-hardened: true` only after SECURITY.md review
- [ ] Entry added to `index.yaml`
- [ ] No internal / organization-specific terms

## Code of Conduct

Be constructive. Review skills for technical correctness, not style preferences. Challenge framework citations and detection patterns with evidence. Keep discussions on the issue tracker or PR.

## License

By contributing, you agree your contributions are licensed under the MIT License.
