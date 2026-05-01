# Bank Robber Level 6 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Level 6 as a final advanced heist route.

**Architecture:** Create one new `.tscn` using existing reusable gameplay scenes and extend GameState registry/par times.

**Tech Stack:** Godot 4.6, text `.tscn`, GDScript registry, PowerShell verifier, Godot smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `scenes/levels/Level6.tscn`.
- [ ] Require `Level6.tscn` in `GameState`.
- [ ] Require runtime smoke to load Level 6.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement Registry

**Files:**
- Modify: `scripts/game_state.gd`

- [ ] Add Level 6 registry entry.
- [ ] Add par time for Level 6.

### Task 3: Build Scene

**Files:**
- Create: `scenes/levels/Level6.tscn`
- Modify: `README.md`

- [ ] Build walls, props, player, exit, loot, vault, guards, cameras, lasers, terminal, switch, vents.
- [ ] Update README level list.
- [ ] Verify, commit, and push.
