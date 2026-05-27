# Review Log: Workflow Version Automation

### Review Cycle 1 — 2026-05-27 10:55

**Cycle ID:** RC-1
**Reviewer type:** CODE_QUALITY
**Reviewer:** manual review
**Scope:** Subproject F implementation slice
**Preceded by:** —
**Re-check of:** —
**Original reviewer:** manual review
**Re-check reviewer:** manual review

#### Findings

| # | Severity | Description | Resolution | Commit | Cross-task? |
|---|----------|-------------|------------|--------|-------------|
| 1 | IMPORTANT | The repository originally had no dedicated root-level source of truth for workflow template version, so the template-version side of project metadata had no automation anchor. | FIXED | VERIFIED_FIXED | — | — |
| 2 | IMPORTANT | `.version-bump.json` originally did not know about `workflowTemplateVersion`, so even if a source file existed, the version automation system would ignore it. | FIXED | VERIFIED_FIXED | — | — |
| 3 | IMPORTANT | `scripts/bump-version.sh` was unusable in the current environment because it hard-depended on `jq`, which was not installed, and then cascaded into an additional shell failure. | FIXED | VERIFIED_FIXED | — | — |
| 4 | IMPORTANT | The repository originally had no verified path proving that `--check` and `--audit` understand the workflow template version source. | FIXED | VERIFIED_FIXED | — | — |
| 5 | IMPORTANT | The synchronized bump step was intentionally left as an operational release decision rather than being forced during this engineering-upgrade workstream. | REJECTED | REJECTED | — | — |

#### Rejected Items

**Finding #5:** [The synchronized bump step was intentionally left as an operational release decision rather than being forced during this engineering-upgrade workstream.]
- **Reason:** This is not an unaddressed defect; it is a deliberate boundary choice. The sub-project goal was to wire and validate the automation channel, not to force a real release-number change during the engineering-upgrade series.
- **Evidence:** `workflow-template-version.json` now exists, is declared in `.version-bump.json`, and `bump-version.sh --check` / `--audit` both succeed and include it in the managed version set.

#### Re-check Summary

- **Finding #1:** Verified fixed by creating `workflow-template-version.json` as the root template-version source.
- **Finding #2:** Verified fixed by adding `workflow-template-version.json -> workflowTemplateVersion` to `.version-bump.json`.
- **Finding #3:** Verified fixed by replacing the `jq` dependency in `scripts/bump-version.sh` with `python3`-based JSON read/write/config parsing and adding a clearer empty-version guard.
- **Finding #4:** Verified fixed by running `bash scripts/bump-version.sh --check` and `bash scripts/bump-version.sh --audit` successfully in the current environment.
- **Finding #5:** Rejected as a bug; keeping the repo at `5.1.0` in this workstream is an intentional release-management decision, not a correctness failure.
- **Verification evidence reviewed:** version source parse PASS; `--check` PASS; `--audit` PASS.

---
