# Bank Robber Overlay Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Polish pause and result overlays.

**Architecture:** Add local style helpers to each overlay script and apply them to panels, buttons, and labels.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`

- [ ] Require `_panel_style` in pause and result overlays.
- [ ] Run verifier and confirm failure first.

### Task 2: Overlay Styles

**Files:**
- Modify: `scripts/ui/pause_overlay.gd`
- Modify: `scripts/ui/result_overlay.gd`

- [ ] Style panels.
- [ ] Style buttons.
- [ ] Style title/detail labels.
- [ ] Verify, commit, push.
