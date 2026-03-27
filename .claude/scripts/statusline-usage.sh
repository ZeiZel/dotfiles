#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${HOME}/.claude/session-usage.json"

input=$(cat)

# Extract usage data and write atomically (mktemp + mv)
if command -v jq &>/dev/null; then
  tmp=$(mktemp)
  printf '%s' "$input" | jq -c '{
    five_hour_pct: (.rate_limits.five_hour.used_percentage // null),
    five_hour_resets_at: (.rate_limits.five_hour.resets_at // null),
    seven_day_pct: (.rate_limits.seven_day.used_percentage // null),
    cost_usd: (.cost.total_cost_usd // null),
    context_pct: (.context_window.used_percentage // null),
    model: (.model.display_name // null),
    ts: now | todate
  }' > "$tmp" 2>/dev/null && mv "$tmp" "$STATE_FILE" || rm -f "$tmp"
fi

# Display via ccusage (bunx -> npx -> silent fallback)
printf '%s' "$input" | bunx ccusage@latest statusline 2>/dev/null \
  || printf '%s' "$input" | npx -y ccusage@latest statusline 2>/dev/null \
  || true
