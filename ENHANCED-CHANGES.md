# Enhanced Changes to Original Skills

This file tracks all modifications to upstream (original) Superpowers skills.
After merging upstream updates, use this file to verify and re-apply changes.

## Status

Last synced with upstream: `2026-05-22`

## Modified Files

### skills/using-superpowers/SKILL.md

**Marker:** `ENHANCED: added-enhanced-workflow-ref`
**Location:** After "Skill Priority" section, before "Skill Types" section (~line 106)
**Added content:**
```markdown
## Enhanced Workflow

This fork includes enhanced skills that add documentation at every phase. Check for these skills:

- **`using-enhanced-workflow`** — Master flow reference with complete phase map
- **`init-enhanced-workflow`** — One-time project setup (run once per project)
- **`decomposing-requirements`** — Break large requirements before brainstorming
- **`documenting-*`** — Record execution, verification, debugging, review, and completion

If this project has `docs/superpowers/` directory, the enhanced workflow is active. Follow `using-enhanced-workflow` for the complete flow.
```
**Reason:** The original `using-superpowers` skill is the first skill loaded at session start. Adding a reference here ensures the AI discovers the enhanced workflow immediately, rather than relying on description-based discovery alone.
