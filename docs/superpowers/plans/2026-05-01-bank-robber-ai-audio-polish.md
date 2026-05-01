# Bank Robber AI Audio Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add guard state behavior, player movement bob/sway, and sound feedback to make the game feel more alive.

**Architecture:** Add `SoundManager` as an autoload with procedural audio helpers. Extend `Guard` with a small state machine and expose alert state to `Level`, then show that state in `HUD`. Keep player animation local to `Player` so gameplay movement remains unchanged.

**Tech Stack:** Godot 4.6, GDScript, procedural AudioStreamWAV, PowerShell verifier, Godot headless smoke test.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`

- [ ] Require `scripts/audio/sound_manager.gd`, `SoundManager` autoload, guard state machine methods, player walk animation methods, and HUD alert state.
- [ ] Run the verifier before implementation and confirm it fails for the new missing behavior.

### Task 2: Sound Manager

**Files:**
- Create: `scripts/audio/sound_manager.gd`
- Modify: `project.godot`
- Modify: `assets/kenney/ATTRIBUTION.md`

- [ ] Add `SoundManager` autoload.
- [ ] Implement procedural `play_footstep`, `play_pickup`, `play_vault`, `play_alarm_pulse`, and `play_ui_click`.
- [ ] Add Kenney RPG Audio and Interface Sounds source notes for future audio replacement.

### Task 3: Player Feel

**Files:**
- Modify: `scripts/game/player.gd`

- [ ] Add walk bob/sway variables.
- [ ] Add `_apply_walk_animation`.
- [ ] Trigger `SoundManager.play_footstep` on cadence while moving.
- [ ] Return sprite to neutral when idle.

### Task 4: Guard AI

**Files:**
- Modify: `scripts/game/guard.gd`
- Modify: `scripts/game/level.gd`

- [ ] Add `GuardState` enum and state transition helpers.
- [ ] Implement patrol look-around at waypoints.
- [ ] Implement suspicious, chase, and search state updates.
- [ ] Let level aggregate guard state and report alert state to HUD.

### Task 5: HUD And Gameplay Sounds

**Files:**
- Modify: `scripts/ui/hud.gd`
- Modify: `scripts/game/loot.gd`
- Modify: `scripts/game/vault.gd`
- Modify: `scripts/menu/main_menu.gd`
- Modify: `scripts/menu/level_select.gd`

- [ ] Add `HUD.set_alert_state`.
- [ ] Play pickup/vault/UI sounds.
- [ ] Throttle alarm pulse while danger is active.

### Task 6: Verify, Commit, Push

**Files:**
- Modify: `README.md`

- [ ] Update README controls/features.
- [ ] Run PowerShell verifier.
- [ ] Run Godot runtime smoke.
- [ ] Run Godot headless boot.
- [ ] Commit and push to GitHub.
