# Bank Robber Persistent Progress Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Persist unlocked levels and best scores/ranks across app restarts.

**Architecture:** Add `ConfigFile` save/load helpers to `GameState`; write progress after a winning run records best score.

**Tech Stack:** Godot 4.6, GDScript `ConfigFile`, PowerShell verifier, Godot headless smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `SAVE_PATH`.
- [ ] Require `ConfigFile`.
- [ ] Require `_load_progress` and `_save_progress`.
- [ ] Require runtime smoke to check save helper methods exist.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement Persistence

**Files:**
- Modify: `scripts/game_state.gd`

- [ ] Load progress in `_ready`.
- [ ] Save unlocked level and best scores after win.
- [ ] Clamp unlocked level to the valid registry range.
- [ ] Keep current run state unsaved.

### Task 3: Docs And Verification

**Files:**
- Modify: `README.md`

- [ ] Document persistent unlocks and best scores.
- [ ] Run verifier, runtime smoke, boot, diff check.
- [ ] Commit and push.
