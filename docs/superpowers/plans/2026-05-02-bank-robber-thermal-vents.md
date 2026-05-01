# Bank Robber Thermal Vents Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add cycling thermal vent hazards to late-game routes.

**Architecture:** Add one reusable hazard scene and script. The vent reads the existing Player node, raises alarm through GameState, reports short HUD messages through Level, and uses SoundManager for a hiss.

**Tech Stack:** Godot 4.6, GDScript, PowerShell verifier, Godot headless smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `scripts/game/thermal_vent.gd`.
- [ ] Require `scenes/game/ThermalVent.tscn`.
- [ ] Require `func _player_in_heat`.
- [ ] Require `SoundManager.play_vent`.
- [ ] Require `ThermalVent` placements in Level 3 and Level 5.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement Vent

**Files:**
- Create: `scripts/game/thermal_vent.gd`
- Create: `scenes/game/ThermalVent.tscn`
- Modify: `scripts/audio/sound_manager.gd`

- [ ] Add cycle timing.
- [ ] Add alarm pressure while active.
- [ ] Draw idle and active states.
- [ ] Add procedural vent sound.

### Task 3: Level Placement

**Files:**
- Modify: `scenes/levels/Level3.tscn`
- Modify: `scenes/levels/Level5.tscn`
- Modify: `README.md`

- [ ] Place vents where they add timing pressure without blocking required routes.
- [ ] Update README feature list.
- [ ] Verify, commit, and push.
