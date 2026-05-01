# Bank Robber Alarm Readability Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Color the alarm bar according to alarm pressure.

**Architecture:** Keep logic inside `HUD`; recompute the fill style in `_on_alarm_changed`.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`

- [ ] Require `func _alarm_color` in `scripts/ui/hud.gd`.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement HUD Color

**Files:**
- Modify: `scripts/ui/hud.gd`

- [ ] Add `_alarm_color`.
- [ ] Update alarm bar fill when alarm changes.
- [ ] Verify, commit, and push.
