# Bank Robber Continue Menu Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a main-menu continue button for the highest unlocked level.

**Architecture:** Reuse existing `GameState` level registry and scene transition logic inside `main_menu.gd`.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`

- [ ] Require `func _on_continue_pressed` in `scripts/menu/main_menu.gd`.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement Continue

**Files:**
- Modify: `scripts/menu/main_menu.gd`
- Modify: `README.md`

- [ ] Add `Continue Heist` button.
- [ ] Start `GameState.unlocked_levels`.
- [ ] Update README current scope.
- [ ] Verify, commit, and push.
