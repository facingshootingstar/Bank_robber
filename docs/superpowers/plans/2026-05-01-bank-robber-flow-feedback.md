# Bank Robber Flow Feedback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add event feedback, next-level flow, and in-session best score display.

**Architecture:** Extend existing UI and state files only. Keep hazards and levels unchanged except for reporting messages through `Level.show_system_message`.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot headless smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `HUD.show_system_message`.
- [ ] Require `Level.show_system_message` and `_go_to_next_or_select`.
- [ ] Require `GameState.best_scores`, `get_best_score`, and `has_next_level`.
- [ ] Require Level Select to call `get_best_score`.
- [ ] Run verifier and confirm it fails first.

### Task 2: HUD Status Chip

**Files:**
- Modify: `scripts/ui/hud.gd`
- Modify: `scripts/game/level.gd`
- Modify: `scripts/game/laser_sensor.gd`

- [ ] Add `system_label`, timer, and `show_system_message`.
- [ ] Call HUD status from camera loop activation.
- [ ] Call Level status when a laser warning fires.

### Task 3: Next-Level Flow

**Files:**
- Modify: `scripts/game_state.gd`
- Modify: `scripts/game/level.gd`
- Modify: `scripts/ui/result_overlay.gd`

- [ ] Add `has_next_level` and `get_next_level_number`.
- [ ] Change result next action to load next level after wins.
- [ ] Keep final-level button going to level select.

### Task 4: Best Scores

**Files:**
- Modify: `scripts/game_state.gd`
- Modify: `scripts/menu/level_select.gd`

- [ ] Add `best_scores` and `best_ranks`.
- [ ] Record best score on win.
- [ ] Show best run in each unlocked level slot.

### Task 5: Verify And Push

**Files:**
- Modify: `README.md`

- [ ] Update README with best scores and flow feedback.
- [ ] Run verifier, runtime smoke, headless boot, and `git diff --check`.
- [ ] Commit and push.
