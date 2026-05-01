# Bank Robber Completion Badges Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add completion badges to successful heist results.

**Architecture:** Extend `GameState` with badge calculation and expose display text to `ResultOverlay`.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `final_badges`.
- [ ] Require `_calculate_final_badges`.
- [ ] Require `get_run_badges_text`.
- [ ] Require `ResultOverlay` to display badge text.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement Badges

**Files:**
- Modify: `scripts/game_state.gd`
- Modify: `scripts/ui/result_overlay.gd`
- Modify: `README.md`

- [ ] Calculate badges on win.
- [ ] Reset badges on start/reset.
- [ ] Display badges on result overlay.
- [ ] Verify, commit, push.
