# Bank Robber Level Briefing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add non-blocking level briefing feedback at level start.

**Architecture:** Add one helper to `level.gd` and reuse existing HUD/system message infrastructure.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`

- [ ] Require `func _show_level_briefing` in `scripts/game/level.gd`.
- [ ] Require use of `level_title` in the level objective.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement Briefing

**Files:**
- Modify: `scripts/game/level.gd`
- Modify: `README.md`

- [ ] Call `_show_level_briefing` after `GameState.start_level`.
- [ ] Emit objective text that includes the level title.
- [ ] Show transient HUD message with level number and title.
- [ ] Verify, commit, and push.
