#!/bin/sh
# ABOUTME: PostToolUse hook that re-injects the comment rules after each code edit.
# ABOUTME: Emits additionalContext JSON so the rule stays recent in Claude's context.
file=$(jq -r '.tool_input.file_path // empty')
case "$file" in
  *.rb|*.erb|*.ts|*.tsx|*.js|*.jsx|*.go|*.py|*.sh|*.fish|*.lua|*.swift)
    cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Comment rules: default is zero comments (ABOUTME header excepted). A comment is allowed only for a constraint the code cannot show (rationale, invariant, workaround). Never narrate code, never justify the change, no change history. Re-check the edit you just made and delete any comment that fails this test."}}
EOF
    ;;
esac
exit 0
