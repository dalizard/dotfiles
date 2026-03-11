#!/usr/bin/env bash
# ABOUTME: Claude Code statusline command
# ABOUTME: Outputs model, context %, cost, tokens in/out, duration separated by middots

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "?"')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  ctx=$(printf "ctx %.0f%%" "$used_pct")
else
  ctx="ctx -"
fi

cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$cost_usd" ]; then
  cost=$(printf "$%.2f" "$cost_usd")
else
  cost='$0.00'
fi

fmt_k() {
  local n="${1:-0}"
  if [ "$n" -ge 1000 ] 2>/dev/null; then
    awk "BEGIN { printf \"%.1fK\", $n/1000 }"
  else
    echo "$n"
  fi
}

in_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
out_tok=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
tokens="$(fmt_k "${in_tok:-0}") in $(fmt_k "${out_tok:-0}") out"

dur_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
if [ -n "$dur_ms" ]; then
  total_s=$((dur_ms / 1000))
  m=$((total_s / 60))
  s=$((total_s % 60))
  duration=$(printf "%dm%02ds" "$m" "$s")
else
  duration="0m00s"
fi

printf "%s · %s · %s · %s · %s\n" "$model" "$ctx" "$cost" "$tokens" "$duration"
