## Summary

<!-- One or two lines describing the change. -->

## Change type

- [ ] New skill
- [ ] Skill improvement (patterns, remediation, references)
- [ ] New framework in `data/frameworks.yaml`
- [ ] New role bundle
- [ ] Documentation / schema / tooling
- [ ] Other (describe)

## Skill PR checklist

Only required if this PR adds or modifies a skill.

- [ ] Directory is `skills/<domain>/<skill-name>/`
- [ ] `name` frontmatter matches the directory name
- [ ] Every framework ID resolves in `data/frameworks.yaml`
- [ ] At least one machine-matchable detection signal (regex / structural)
- [ ] Findings documented as normalized JSON per `docs/normalized-json-output.md`
- [ ] Rules are hard constraints (no "consider" / "may")
- [ ] Before / after remediation example present
- [ ] `test_strategy` present on every remediation
- [ ] Falsifiable verification test (binary pass/fail) defined
- [ ] At least 2 false positives + 1 precision trap in Gotchas
- [ ] `SKILL.md` body stays lean — long detail moved to reference files
- [ ] `injection-hardened: true` only after SECURITY.md review
- [ ] `index.yaml` updated

## Validation

Run before pushing:

```bash
make validate
```

Local pass:

- [ ] `make lint` passes
- [ ] `make index` passes
- [ ] `make frameworks` passes
- [ ] `make injection` passes

## Related

<!-- Related issues, prior PRs, or external references (OWASP / NIST / MITRE / AWS). -->
