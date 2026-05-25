---
name: init-enhanced-workflow
description: Use when starting a new project or onboarding an existing project to the Enhanced Superpowers workflow. Creates directory structure, project CLAUDE.md rules, and README documentation.
---

# Init Enhanced Workflow

One-command setup for the Enhanced Superpowers workflow in a project. Run once per project.

**Announce at start:** "I'm using the init-enhanced-workflow skill to set up the project."

## Checklist

Complete in order:

1. **Verify project root** — confirm you're in a git repository with `git rev-parse --git-dir`
2. **Create directory structure**
3. **Write project CLAUDE.md** — concise rules, highest AI priority
4. **Write docs/superpowers/README.md** — detailed workflow reference
5. **Commit** — commit the initialization separately from any code changes

## Step 2: Create Directory Structure

```bash
mkdir -p docs/superpowers/{decomposition,specs,plans,execution-log,debugging-log,review-log,completion}
```

## Step 3: Write Project CLAUDE.md

Write or **append** the following to the project's `CLAUDE.md`. If CLAUDE.md already exists, append below existing content.

Do NOT overwrite existing CLAUDE.md content — only append.

Content to write/append:

````markdown
<!-- Append this to CLAUDE.md -->

## Enhanced Superpowers Workflow

This project uses the Enhanced Superpowers workflow. The following rules are MANDATORY for all AI agents.

### Mandatory Rules

1. **Before writing ANY code**, invoke `brainstorming` skill (Superpowers). No exceptions.
2. **Before executing**, invoke `writing-plans` skill (Superpowers). No exceptions.
3. **After each task commit**, invoke `documenting-execution` skill.
4. **After each verification run**, invoke `documenting-verification` skill.
5. **After each code review cycle**, invoke `documenting-review` skill.
6. **If review finds issues, fix them, run verification, then prefer the original reviewer for re-check.** If the original reviewer is unavailable or still lacks context after a concise recap, fall back to a fresh reviewer.
7. **After resolving any bug**, invoke `documenting-debugging` skill.
8. **Before merge or PR**, invoke `documenting-completion` skill.
9. **For large requirements** (3+ features or subsystems), invoke `decomposing-requirements` skill BEFORE brainstorming.

### Strict Prohibitions

- Do NOT write code before brainstorming is approved by the human partner.
- Do NOT claim work is complete without running verification commands.
- Do NOT silently drop review findings. Every finding = FIXED, DEFERRED (with reason), or REJECTED (with evidence).
- Do NOT skip verification before re-review.
- Do NOT replace re-review with implementer self-assertion. Prefer the original reviewer; use a fresh reviewer only as fallback.
- Do NOT merge or create PR before the completion summary is written.
- Do NOT leave documentation updates uncommitted at session end.

### Documentation

- All workflow docs go in `docs/superpowers/` — see `docs/superpowers/README.md` for full details.
- Documentation is MANDATORY when using this workflow. Ad-hoc changes under 30 minutes are exempt.
````

## Step 4: Write docs/superpowers/ Docs

Copy three template files from this plugin's `using-enhanced-workflow` skill directory:

```bash
TEMPLATE_DIR=~/.claude/plugins/cache/superpowers-enhanced/latest/skills/using-enhanced-workflow

cp "$TEMPLATE_DIR/docs-superpowers-README-template.md" docs/superpowers/README.md
cp "$TEMPLATE_DIR/docs-superpowers-workflow-template.md" docs/superpowers/workflow.md
cp "$TEMPLATE_DIR/docs-superpowers-conventions-template.md" docs/superpowers/conventions.md
```

Then customize the Active Features table in `README.md` with the project's first feature (if known), or leave it as a template.

## Step 5: Commit

```bash
git add docs/superpowers/ CLAUDE.md
git commit -m "chore: initialize Enhanced Superpowers workflow documentation structure"
```

## When to Re-Run

Do NOT re-run if `docs/superpowers/README.md` already exists. This is a one-time setup.

If the directory structure exists but README.md is missing (e.g., created by Auto-Init without the full template), re-run Step 4 only.
