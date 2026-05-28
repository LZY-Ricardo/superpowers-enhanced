#!/usr/bin/env bash
# Test: subagent-driven-development skill
# Verifies that the skill is loaded and follows correct workflow
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: subagent-driven-development skill ==="
echo ""

run_claude_or_fail() {
    local label="$1"
    local prompt="$2"
    local timeout_seconds="${3:-120}"

    local output
    set +e
    output=$(run_claude "$prompt" "$timeout_seconds" 2>&1)
    local status=$?
    set -e

    if [ "$status" -ne 0 ]; then
        echo "  [FAIL] $label invocation exited with status $status"
        echo "$output" | sed 's/^/    /'
        exit 1
    fi

    printf '%s' "$output"
}

# Test 1: Verify helper contract assumptions
# This fails fast if the shared helper stops using the expected plugin root,
# permission mode, output capture, or timeout behavior.
echo "Test 1: Helper contract..."

plugin_dir="$(get_claude_plugin_dir)"
expected_plugin_dir="/Users/zyb/workspace/person/superpowers-enhanced"

if [ "$plugin_dir" = "$expected_plugin_dir" ]; then
    echo "  [PASS] Helper resolves repo-root plugin dir"
else
    echo "  [FAIL] Helper resolves repo-root plugin dir"
    echo "  Expected: $expected_plugin_dir"
    echo "  Actual:   $plugin_dir"
    exit 1
fi

mock_claude=$(mktemp)
cat > "$mock_claude" <<'EOF'
#!/usr/bin/env bash
sleep 5
printf 'mock claude output\n'
EOF
chmod +x "$mock_claude"
trap 'rm -f "$mock_claude" "$capture_mock_claude"' EXIT

capture_mock_claude=$(mktemp)
cat > "$capture_mock_claude" <<'EOF'
#!/usr/bin/env bash
printf 'captured stdout\n'
printf 'captured stderr\n' >&2
EOF
chmod +x "$capture_mock_claude"

capture_output=""
set +e
capture_output=$(CLAUDE_BIN="$capture_mock_claude" run_claude "simulate capture" 5 2>&1)
capture_status=$?
set -e

if [ "$capture_status" -eq 0 ]; then
    echo "  [PASS] Helper captures stdout/stderr on success"
else
    echo "  [FAIL] Helper captures stdout/stderr on success"
    echo "  Expected: 0"
    echo "  Actual:   $capture_status"
    echo "$capture_output" | sed 's/^/    /'
    exit 1
fi

if assert_contains "$capture_output" "captured stdout" "Helper captures stdout"; then
    :
else
    exit 1
fi

if assert_contains "$capture_output" "captured stderr" "Helper captures stderr"; then
    :
else
    exit 1
fi

timeout_output=""
set +e
timeout_output=$(CLAUDE_BIN="$mock_claude" run_claude "simulate timeout" 1 2>&1)
timeout_status=$?
set -e

if [ "$timeout_status" -eq 124 ]; then
    echo "  [PASS] Helper returns timeout exit code"
else
    echo "  [FAIL] Helper returns timeout exit code"
    echo "  Expected: 124"
    echo "  Actual:   $timeout_status"
    echo "$timeout_output" | sed 's/^/    /'
    exit 1
fi

if assert_contains "$timeout_output" "run_claude timed out after 1s" "Helper prints clear timeout message"; then
    :
else
    exit 1
fi

if assert_contains "$timeout_output" "$expected_plugin_dir" "Helper reports plugin dir on timeout"; then
    :
else
    exit 1
fi

if assert_contains "$timeout_output" "bypassPermissions" "Helper reports permission mode on timeout"; then
    :
else
    exit 1
fi

echo ""

# Test 2: Verify skill can be loaded
# Use a realistic timeout: direct measurements in this repo show the prompt can
# take well over 30 seconds even when the helper contract is correct.
echo "Test 2: Skill loading..."
output=$(run_claude_or_fail "Skill loading" "What is the subagent-driven-development skill? Describe its key steps briefly." 120)

if assert_not_contains "$output" "Warning: no stdin data received in 3s" "Helper does not wait on stdin"; then
    :
else
    exit 1
fi

if assert_contains "$output" "subagent-driven-development\|Subagent-Driven Development\|Subagent Driven\|workflow skill\|fresh subagent" "Skill is recognized"; then
    :
else
    exit 1
fi

if assert_contains "$output" "read the plan once\|read.*plan\|extract.*task\|task list\|implementation plan" "Mentions loading plan"; then
    :
else
    exit 1
fi

echo ""

# Test 3: Verify skill describes correct workflow order
echo "Test 3: Workflow ordering..."
output=$(run_claude_or_fail "Workflow ordering" "In the subagent-driven-development skill, what comes first: spec compliance review or code quality review? Be specific about the order." 120)

if assert_contains "$output" "Spec compliance review comes first\|code quality review comes second\|Never start code quality review before spec compliance" "Spec compliance before code quality"; then
    :
else
    exit 1
fi

echo ""

# Test 4: Verify self-review is mentioned
echo "Test 4: Self-review requirement..."
output=$(run_claude_or_fail "Self-review requirement" "Does the subagent-driven-development skill require implementers to do self-review? What should they check?" 120)

if assert_contains "$output" "self-review\|self review" "Mentions self-review"; then
    :
else
    exit 1
fi

if assert_contains "$output" "Completeness\|fully implemented\|miss.*required\|DONE_WITH_CONCERNS\|self.review.*check\|implementer.*check\|check.*before\|what.*check\|intended.*check" "Checks completeness"; then
    :
else
    exit 1
fi

echo ""

# Test 5: Verify plan is read once
echo "Test 5: Plan reading efficiency..."
output=$(run_claude_or_fail "Plan reading efficiency" "In subagent-driven-development, how many times should the controller read the plan file? When does this happen?" 120)

if assert_contains "$output" "once\|Once\|one time\|single" "Read plan once"; then
    :
else
    exit 1
fi

if assert_contains "$output" "Step 1\|beginning\|start\|Load Plan\|upfront\|before dispatching any implementer" "Read at beginning"; then
    :
else
    exit 1
fi

echo ""

# Test 6: Verify spec compliance reviewer is skeptical
echo "Test 6: Spec compliance reviewer mindset..."
output=$(run_claude_or_fail "Spec compliance reviewer mindset" "What is the spec compliance reviewer's attitude toward the implementer's report in subagent-driven-development?" 120)

if assert_contains "$output" "not trust\|don't trust\|skeptical\|verify.*independently\|suspiciously\|Skeptical and independent\|independently check the code" "Reviewer is skeptical"; then
    :
else
    exit 1
fi

if assert_contains "$output" "read.*code\|inspect.*code\|verify.*code" "Reviewer reads code"; then
    :
else
    exit 1
fi

echo ""

# Test 7: Verify review loops
echo "Test 7: Review loop requirements..."
output=$(run_claude_or_fail "Review loop requirements" "In subagent-driven-development, what happens if a reviewer finds issues? Is it a one-time review or a loop?" 120)

if assert_contains "$output" "loop\|again\|repeat\|until.*approved\|until.*compliant" "Review loops mentioned"; then
    :
else
    exit 1
fi

if assert_contains "$output" "implementer.*fix\|fix.*issues" "Implementer fixes issues"; then
    :
else
    exit 1
fi

echo ""

# Test 8: Verify full task text is provided
echo "Test 8: Task context provision..."
output=$(run_claude_or_fail "Task context provision" "In subagent-driven-development, how does the controller provide task information to the implementer subagent? Does it make them read a file or provide it directly?" 120)

if assert_contains "$output" "provide.*directly\|full.*text\|paste\|include.*prompt" "Provides text directly"; then
    :
else
    exit 1
fi

if assert_contains "$output" "read the plan itself\|full task text.*context\|not.*read.*plan file\|controller.*passes.*task\|dispatch.*full task text\|provide full task text directly\|do not make them read files\|giving them the extracted task text" "Doesn't make subagent read file"; then
    :
else
    exit 1
fi

echo ""

# Test 9: Verify worktree requirement
echo "Test 9: Worktree requirement..."
output=$(run_claude_or_fail "Worktree requirement" "What workflow skills are required before using subagent-driven-development? List any prerequisites or required skills." 120)

if assert_contains "$output" "using-git-worktrees\|worktree" "Mentions worktree requirement"; then
    :
else
    exit 1
fi

echo ""

# Test 10: Verify main branch warning
echo "Test 10: Main branch red flag..."
output=$(run_claude_or_fail "Main branch red flag" "In subagent-driven-development, is it okay to start implementation directly on the main branch?" 120)

if assert_contains "$output" "worktree\|feature.*branch\|not.*main\|never.*main\|avoid.*main\|don't.*main\|consent\|permission" "Warns against main branch"; then
    :
else
    exit 1
fi

echo ""

# Test 11: Writing-plans should recommend inline execution by default
echo "Test 11: writing-plans execution default..."
output=$(run_claude_or_fail "writing-plans execution default" "In the writing-plans skill, which execution mode is the default recommendation now: Inline Execution or Subagent-Driven? Answer briefly." 120)

if assert_contains "$output" "Inline Execution\|inline execution\|inline by default\|default.*inline" "writing-plans recommends inline execution"; then
    :
else
    exit 1
fi

if assert_not_contains "$output" "Subagent-Driven \(recommended\)\|Subagent-Driven is recommended\|subagent-driven.*default" "writing-plans does not present subagent-driven as the default"; then
    :
else
    exit 1
fi

echo ""

echo "=== All subagent-driven-development skill tests passed ==="
