# Testing System Upgrade Design

## Context

Subprojects A, B, G, and C all succeeded in adding new structure, templates, metadata, and recovery surfaces, but each one encountered the same underlying testing limitation: the fast suite is not a dependable health signal because an older `test-subagent-driven-development.sh` path can hang and block the suite. At the same time, the recent subprojects were only able to add mostly structural checks, not higher-value transcript-level behavior checks that prove the workflow really works end to end.

The purpose of this sub-project is to stabilize the existing test-running foundation first, then add a small set of high-value dynamic behavior tests for the most important Enhanced Superpowers guarantees.

## Goal

Upgrade the testing system so that:
- the fast suite is stable enough to serve as a useful structural health check
- headless Claude invocations use a consistent, reliable contract
- a small but meaningful set of behavior tests proves the new enhanced workflow features actually work in realistic scenarios

## Non-Goals

This sub-project does **not**:
- fully redesign the entire test directory layout
- rewrite all existing tests
- add behavior coverage for every skill in the repository
- convert every structural test into a transcript/e2e test
- solve template-version automation

## Chosen Approach

Use a two-layer upgrade strategy:

1. **Foundation stabilization**
   - fix the common test helper and runner expectations
   - stabilize or isolate the legacy fast-suite blocker
   - make clear which tests belong in fast structural checks vs slower behavior/integration checks

2. **Targeted behavior coverage**
   - add transcript/e2e tests only for the most valuable new system guarantees:
     - init behavior
     - legacy upgrade behavior
     - decomposition tracked output behavior
     - status recovery behavior

This avoids a broad testing rewrite while still moving from static phrase checks toward actual behavioral confidence.

## Scope

### In scope
- `tests/claude-code/test-helpers.sh`
- `tests/claude-code/run-skill-tests.sh`
- `tests/claude-code/test-subagent-driven-development.sh`
- strengthening behavior tests for:
  - `init-enhanced-workflow`
  - `upgrading-enhanced-workflow-project` (legacy path)
  - `decomposing-requirements`
  - `status.md` recovery flow

### Out of scope
- full taxonomy or folder reorganization of every test type
- rewriting all old tests for style consistency
- CI pipeline redesign outside what is necessary to run the upgraded local suite

## Primary Problems to Solve

### 1. Fast suite instability
The fast suite currently includes a legacy subagent-driven-development test path that can hang before even exercising the newer structural tests. This makes the suite unreliable as a baseline signal.

### 2. Inconsistent headless invocation assumptions
Headless `claude -p` usage depends on stable assumptions around:
- `--plugin-dir`
- `--permission-mode bypassPermissions`
- timeout behavior
- output capture and failure reporting

These assumptions should live in one well-defined helper contract.

### 3. Structural-only confidence
Recent subprojects added important structure, but many checks still only prove that text or files exist. They do not yet prove that realistic sessions behave correctly.

## Recommended Test Model

### Layer 1: Fast structural suite
Purpose: confirm repository structure and skill text contracts quickly.

Characteristics:
- shell-based
- deterministic
- low token cost
- no long-running conversation dependence

This suite should include:
- skill structure checks
- template existence checks
- metadata/status/decomposition structural checks
- only those Claude invocations that are known to be stable and fast

### Layer 2: Behavior tests
Purpose: verify that the workflow behaves correctly in real scenarios.

Characteristics:
- slower
- can invoke Claude in temporary projects
- produce stronger confidence for critical flows

Initial required behavior tests:
1. `init-enhanced-workflow` creates the expected project guidance set, including `version.json` and `status.md`
2. legacy project upgrade backfills `version.json` correctly
3. decomposition produces tracked output format with overview/state fields
4. a recovery-oriented scenario can use `status.md` as the first entrypoint

## Design Decisions

### A. Stabilize before expanding
Do not pile more behavior tests on top of a runner that still has unresolved hang behavior.

### B. Isolate legacy blocker if necessary
If `test-subagent-driven-development.sh` cannot be made reliably fast and non-hanging without disproportionate effort, it should be moved out of the fast suite into a slower or separately-invoked class. The point is a healthy suite, not preserving historical categorization.

### C. Keep behavior coverage narrow but meaningful
Only add transcript/e2e tests for the newly introduced core guarantees. Avoid turning this sub-project into a repository-wide test explosion.

## Risks

1. **Over-expansion risk:** testing work can grow into a full framework rewrite if not constrained.
2. **Model variability risk:** transcript-level tests may be more brittle than structural tests.
3. **Suite categorization risk:** moving or changing old tests can create confusion if the new suite contract is not documented.

## Mitigations

- keep the first behavior-test set small
- prefer deterministic assertions on created files, explicit markers, and logged outputs
- document fast vs behavior suite responsibilities clearly in the runner and test README
- treat legacy unstable tests pragmatically: stabilize if cheap, isolate if not

## Success Criteria

This sub-project is complete when:
1. the fast suite no longer gets blocked by the legacy subagent-driven-development timeout in normal use
2. the common test helper defines one stable headless Claude invocation contract
3. at least one behavior test exists for each of these guarantees:
   - init
   - legacy upgrade metadata backfill
   - tracked decomposition output
   - status-based recovery entrypoint
4. future subprojects can add tests on top of a more stable base instead of re-encountering the same runner problems

## Verification Strategy

- verify the fast suite runs and clearly reports its intended scope
- verify the legacy blocker is either fixed or intentionally reclassified out of the fast path
- verify new behavior tests pass in temporary project scenarios
- verify structural tests remain cheap and deterministic
