# Bank Robber Laser Counterplay Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add one-use power switches that temporarily disable laser sensors.

**Architecture:** Add a new focused interactable, let `Level` own the shutdown timer, and let `LaserSensor` expose a disabled state. Place switches in Level 4 and Level 5.

**Tech Stack:** Godot 4.6, GDScript, text `.tscn` scenes, PowerShell verifier, Godot headless smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `scripts/game/power_switch.gd` and `scenes/game/PowerSwitch.tscn`.
- [ ] Require `Level.activate_laser_shutdown`.
- [ ] Require `LaserSensor.set_disabled`.
- [ ] Require `SoundManager.play_power_down`.
- [ ] Run verifier and confirm failure first.

### Task 2: Implement System

**Files:**
- Create: `scripts/game/power_switch.gd`
- Create: `scenes/game/PowerSwitch.tscn`
- Modify: `scripts/game/level.gd`
- Modify: `scripts/game/laser_sensor.gd`
- Modify: `scripts/audio/sound_manager.gd`

- [ ] Add interact prompt and one-use switch state.
- [ ] Add shutdown timer to Level.
- [ ] Skip laser alarm while disabled.
- [ ] Draw disabled lasers in blue.

### Task 3: Level Placement

**Files:**
- Modify: `scenes/levels/Level4.tscn`
- Modify: `scenes/levels/Level5.tscn`
- Modify: `README.md`

- [ ] Add PowerSwitch resource and nodes to Level 4 and Level 5.
- [ ] Update README feature list.
- [ ] Verify, commit, and push.
