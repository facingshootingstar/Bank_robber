# Bank Robber Systems Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add camera hacking, laser hazards, scoring/ranks, and two late-game levels.

**Architecture:** Add two focused gameplay scripts and scenes, extend `Level` to own temporary camera loops, extend `SecurityCamera` for looped state, expand `GameState` level/score data, and update verification.

**Tech Stack:** Godot 4.6, GDScript, text `.tscn` scenes, PowerShell verifier, Godot headless smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `scripts/game/hack_terminal.gd` and `scripts/game/laser_sensor.gd`.
- [ ] Require `scenes/game/HackTerminal.tscn`, `scenes/game/LaserSensor.tscn`, `scenes/levels/Level4.tscn`, and `scenes/levels/Level5.tscn`.
- [ ] Require `Level5.tscn` in `GameState.LEVELS`.
- [ ] Require `activate_camera_loop`, `set_looped`, `func _calculate_final_score`, and `final_rank`.
- [ ] Run the verifier and confirm it fails before implementation.

### Task 2: Camera Hacking

**Files:**
- Create: `scripts/game/hack_terminal.gd`
- Create: `scenes/game/HackTerminal.tscn`
- Modify: `scripts/game/level.gd`
- Modify: `scripts/game/security_camera.gd`
- Modify: `scripts/audio/sound_manager.gd`

- [ ] Add terminal interactable with prompt, one-time hack, and simple draw state.
- [ ] Add `Level.activate_camera_loop(seconds)` and timer handling.
- [ ] Add `SecurityCamera.set_looped` and make looped cameras skip detection.
- [ ] Add `SoundManager.play_hack`.

### Task 3: Laser Sensors

**Files:**
- Create: `scripts/game/laser_sensor.gd`
- Create: `scenes/game/LaserSensor.tscn`
- Modify: `scripts/audio/sound_manager.gd`

- [ ] Add static beam detection against the player.
- [ ] Raise alarm while crossed.
- [ ] Draw readable red beam and post markers.
- [ ] Add `SoundManager.play_laser`.

### Task 4: Scoring And Results

**Files:**
- Modify: `scripts/game_state.gd`
- Modify: `scripts/ui/result_overlay.gd`

- [ ] Add `final_score` and `final_rank`.
- [ ] Calculate score/rank on win.
- [ ] Show rank, score, time, loot, and alarm on result overlay.
- [ ] Remove stale “Level 2 is planned” result copy.

### Task 5: Levels 4 And 5

**Files:**
- Modify: `scripts/game_state.gd`
- Create: `scenes/levels/Level4.tscn`
- Create: `scenes/levels/Level5.tscn`

- [ ] Add Level 4 registry entry for Security Core.
- [ ] Add Level 5 registry entry for Penthouse Vault.
- [ ] Build Level 4 with guards, cameras, lasers, terminal, vault, loot, and exit.
- [ ] Build Level 5 as a final dense heist with multiple systems.

### Task 6: Docs, Verification, Push

**Files:**
- Modify: `README.md`

- [ ] Update feature list and controls.
- [ ] Run PowerShell verifier.
- [ ] Run Godot runtime smoke.
- [ ] Run Godot headless boot.
- [ ] Run `git diff --check`.
- [ ] Commit and push `origin main`.
