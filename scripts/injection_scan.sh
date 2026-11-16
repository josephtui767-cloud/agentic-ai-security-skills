#!/usr/bin/env bash
# injection_scan.sh
#
# Prompt-injection / malware / committed-secret scan for this repo.
# Called by .github/workflows/injection-scan.yml and from the Makefile target.
#
# Exits 0 on pass, 1 on any failure.

set -uo pipefail

ROOT="${1:-.}"
cd "$ROOT"

# ----------------------------------------------------------------------
# 1. Build the text-file list (everything except .git / .github)
# ----------------------------------------------------------------------
TMP_LIST="$(mktemp)"
trap 'rm -f "$TMP_LIST"' EXIT

find . -type f \
    \( -name '*.md' -o -name '*.mjs' -o -name '*.js' -o -name '*.ts' \
       -o -name '*.sh' -o -name '*.json' -o -name '*.yaml' -o -name '*.yml' \
       -o -name '*.tf' -o -name '*.py' -o -name '*.toml' -o -name '*.cfg' \
       -o -name '*.txt' -o -name '*.rb' \) \
    -not -path './.git/*' -not -path './.github/*' \
    > "$TMP_LIST"

echo "Scanning $(wc -l < "$TMP_LIST" | tr -d ' ') text file(s)."

# ----------------------------------------------------------------------
# 2. Prompt-injection patterns
# ----------------------------------------------------------------------
# These are imperative phrases directed at the model. SECURITY.md,
# agent-io/indirect-prompt-injection-defense/, and other defensive skills
# legitimately quote these for teaching purposes — those paths are excluded.

PATTERNS=(
    "new directive"
    "system override"
    "forget your instructions"
    "send to http"
    "curl -X POST"
    "api.telegram"
    "discord.com/api/webhooks"
    "hooks.slack.com/services"
    "ignore previous instructions and"
    "ignore all previous instructions"
    "you are now a"
    "you are now in"
    "disregard your"
    "disregard all previous"
)

FOUND_INJECTION=0
while IFS= read -r f; do
    case "$f" in
        ./SECURITY.md) continue ;;
        ./scripts/injection_scan.sh) continue ;;
        ./skills/agent-io/indirect-prompt-injection-defense/*) continue ;;
        ./skills/agent-io/multi-layer-input-validation/*) continue ;;
        ./skills/agent-io/input-obfuscation-stripping/*) continue ;;
        ./skills/agent-lifecycle/coding-agent-steering-security/*) continue ;;
        ./skills/agent-testing/automated-prompt-testing/*) continue ;;
        ./skills/agent-testing/agentic-red-team/*) continue ;;
        ./skills/agent-testing/context-aware-pentest/*) continue ;;
        ./skills/agent-testing/scoped-pentest-sandbox/*) continue ;;
        ./skills/agent-containment/*) continue ;;
    esac
    for pattern in "${PATTERNS[@]}"; do
        LINES=$(grep -in "$pattern" "$f" 2>/dev/null || true)
        [ -z "$LINES" ] && continue

        # Drop clearly defensive / illustrative framings.
        FILTERED=$(echo "$LINES" \
            | grep -v "treat it as" \
            | grep -v "not a command" \
            | grep -v "not as a directive" \
            | grep -v "not obeyed" \
            | grep -v "disregard them" \
            | grep -v "flag it as" \
            | grep -v "report the finding" \
            | grep -v "e\.g\.\," \
            | grep -v "such as" \
            | grep -v "text like" \
            | grep -v "contains text" \
            | grep -v "attack pattern" \
            || true)
        if [ -n "$FILTERED" ]; then
            echo "INJECTION pattern \"$pattern\" in $f:"
            echo "$FILTERED"
            echo ""
            FOUND_INJECTION=1
        fi
    done
done < "$TMP_LIST"

if [ "$FOUND_INJECTION" -ne 0 ]; then
    echo "FAIL: Prompt-injection patterns detected. Review flagged lines above."
    exit 1
fi
echo "PASS: No prompt-injection patterns detected."
echo

# ----------------------------------------------------------------------
# 3. Malware patterns in code/scripts (non-markdown)
# ----------------------------------------------------------------------
MAL=(
    'curl[^|]*\|[[:space:]]*(ba)?sh'
    'wget[^|]*\|[[:space:]]*(ba)?sh'
    '/dev/tcp/'
    'nc -e'
    'bash -i'
    'base64 -d[^|]*\|[[:space:]]*(ba)?sh'
    '"preinstall"'
    '"postinstall"'
    'child_process'
    'new Function\('
)

FOUND_MAL=0
for p in "${MAL[@]}"; do
    M=$(grep -rInE --binary-files=without-match "$p" . \
            --include="*.mjs" --include="*.js" --include="*.ts" --include="*.sh" \
            --include="*.json" --include="*.yaml" --include="*.yml" --include="*.tf" \
            --include="*.py" --include="*.rb" \
            2>/dev/null \
          | grep -vE '(^|/)\.github/' \
          | grep -vE '(^|/)scripts/injection_scan\.sh:' \
          || true)
    if [ -n "$M" ]; then
        echo "MALWARE pattern \"$p\":"
        echo "$M"
        echo ""
        FOUND_MAL=1
    fi
done

if [ "$FOUND_MAL" -ne 0 ]; then
    echo "FAIL: Suspicious executable patterns in non-markdown files. Manual review required."
    exit 1
fi
echo "PASS: No malware patterns in code/scripts."
echo

# ----------------------------------------------------------------------
# 4. Committed secrets (non-markdown)
# ----------------------------------------------------------------------
SEC=(
    'AKIA[0-9A-Z]{16}'
    'sk-[A-Za-z0-9]{20,}'
    'gh[pousr]_[A-Za-z0-9]{36,}'
    'xox[baprs]-[A-Za-z0-9-]{10,}'
    'glpat-[A-Za-z0-9_-]{20,}'
    '-----BEGIN [A-Z ]*PRIVATE KEY-----'
    'AIza[0-9A-Za-z_-]{35}'
)

FOUND_SEC=0
for p in "${SEC[@]}"; do
    M=$(grep -rInE --binary-files=without-match "$p" . \
            --include="*.mjs" --include="*.js" --include="*.ts" --include="*.sh" \
            --include="*.json" --include="*.yaml" --include="*.yml" --include="*.tf" \
            --include="*.env" --include="*.py" --include="*.rb" \
            2>/dev/null \
          | grep -vE '(^|/)\.github/' \
          | grep -vE '(^|/)scripts/injection_scan\.sh:' \
          || true)
    if [ -n "$M" ]; then
        echo "SECRET match \"$p\":"
        echo "$M"
        echo ""
        FOUND_SEC=1
    fi
done

if [ "$FOUND_SEC" -ne 0 ]; then
    echo "FAIL: Possible committed secret. Rotate and remove from git history."
    exit 1
fi
echo "PASS: No committed secret values detected."
