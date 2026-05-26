# Review Log: Testing System Upgrade

### Review Cycle 1 — 2026-05-26 19:05

**Cycle ID:** RC-1
**Reviewer type:** CODE_QUALITY
**Reviewer:** manual review
**Scope:** Subproject D implementation slice
**Preceded by:** —
**Re-check of:** —
**Original reviewer:** manual review
**Re-check reviewer:** manual review

#### Findings

| # | Severity | Description | Resolution | Re-check status | Commit | Cross-task? |
|---|----------|-------------|------------|-----------------|--------|-------------|
| 1 | IMPORTANT | The legacy fast-suite blocker was not only a timeout issue; the helper contract and multiple brittle wording assertions were making the old `test-subagent-driven-development.sh` both unstable and misleading. | FIXED | VERIFIED_FIXED | — | — |
| 2 | IMPORTANT | The fast suite previously mixed long-running Claude-heavy behavior checks with cheap structural checks, so one slow legacy test could invalidate the entire structural health signal. | FIXED | VERIFIED_FIXED | — | — |
| 3 | IMPORTANT | The system previously lacked behavior-level proof that init materializes the newer guidance artifacts (`status.md`, `version.json`) in a temp project. | FIXED | VERIFIED_FIXED | — | — |
| 4 | IMPORTANT | The system previously had no explicit behavior test for legacy project metadata backfill, leaving the `initializedAt: "legacy"` contract unproven. | FIXED | VERIFIED_FIXED | — | — |
| 5 | IMPORTANT | The newer decomposition/status work had structure checks, but not stronger artifact-level behavior checks showing they function as macro-map and recovery-entry surfaces. | FIXED | VERIFIED_FIXED | — | — |

#### Re-check Summary

- **Finding #1:** Verified fixed by hardening `run_claude()`, preventing stdin-related false hangs, improving timeout/output diagnostics, and widening several old assertions to match stable correct semantics.
- **Finding #2:** Verified fixed by reclassifying the heavy legacy subagent-driven-development test out of the fast structural suite.
- **Finding #3:** Verified fixed by extending the init test with a temp-project behavior scenario that checks real artifact materialization.
- **Finding #4:** Verified fixed by adding a deterministic legacy upgrade metadata backfill behavior test.
- **Finding #5:** Verified fixed by strengthening decomposition and status tests so they check usable artifact behavior, not just file existence.
- **Verification evidence reviewed:** legacy helper/behavior test PASS; fast structural suite PASS; init behavior PASS; legacy upgrade metadata backfill PASS; decomposition/status behavior checks PASS.

---
