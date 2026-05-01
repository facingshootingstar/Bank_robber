# Bank Robber Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build and push a complete first playable Godot 4 stealth game with menu, level select, one level, pause, result flow, and desktop keyboard gameplay.

**Architecture:** Use a small scene-based Godot 4 structure. `GameState` is an autoload for shared run/progress state, while each gameplay object owns its own script. Level 1 is a composed scene with reusable entities.

**Tech Stack:** Godot 4.6 project files, GDScript, PowerShell static verifier, Git/GitHub.

---

### Task 1: Project Verification Harness

**Files:**
- Create: `tests/verify_project.ps1`
- Modify: `project.godot`

- [ ] Add a PowerShell verifier that checks required scenes, scripts, input actions, and autoload configuration.
- [ ] Run `powershell -ExecutionPolicy Bypass -File tests/verify_project.ps1` before implementation and confirm it fails because required files are missing.
- [ ] Keep this verifier as the repeatable check before commit and push.

### Task 2: Core State And Scene Flow

**Files:**
- Create: `scripts/game_state.gd`
- Create: `scripts/menu/main_menu.gd`
- Create: `scripts/menu/level_select.gd`
- Create: `scenes/ui/MainMenu.tscn`
- Create: `scenes/ui/LevelSelect.tscn`
- Modify: `project.godot`

- [ ] Add `GameState` as an autoload.
- [ ] Set `MainMenu.tscn` as the main scene.
- [ ] Add keyboard input actions for movement, interact, and pause.
- [ ] Implement Play, Level Select, locked slot handling, and Quit.

### Task 3: Gameplay Entities

**Files:**
- Create: `scripts/game/player.gd`
- Create: `scripts/game/guard.gd`
- Create: `scripts/game/security_camera.gd`
- Create: `scripts/game/loot.gd`
- Create: `scripts/game/vault.gd`
- Create: `scripts/game/exit_zone.gd`
- Create: `scenes/game/Player.tscn`
- Create: `scenes/game/Guard.tscn`
- Create: `scenes/game/SecurityCamera.tscn`
- Create: `scenes/game/Loot.tscn`
- Create: `scenes/game/Vault.tscn`
- Create: `scenes/game/ExitZone.tscn`

- [ ] Implement keyboard movement and interaction range for the player.
- [ ] Implement guard waypoint patrol and vision cone detection.
- [ ] Implement camera sweep and vision cone detection.
- [ ] Implement loot/vault collection and exit win condition.

### Task 4: Level, HUD, Pause, Result

**Files:**
- Create: `scripts/game/level.gd`
- Create: `scripts/ui/hud.gd`
- Create: `scripts/ui/pause_overlay.gd`
- Create: `scripts/ui/result_overlay.gd`
- Create: `scenes/ui/HUD.tscn`
- Create: `scenes/ui/PauseOverlay.tscn`
- Create: `scenes/ui/ResultOverlay.tscn`
- Create: `scenes/levels/Level1.tscn`

- [ ] Compose Level 1 with walls, floor, player, guards, cameras, loot, vault, exit, HUD, pause, and result overlay.
- [ ] Implement alarm rise/decay, timer, objective text, restart, menu, and result buttons.
- [ ] Ensure restart resets state and returns all entities to their initial state.

### Task 5: Verification, Git, Push

**Files:**
- Modify: `.gitignore`
- Modify: `README.md`

- [ ] Add a README with controls and scope.
- [ ] Run the PowerShell verifier and fix every failure.
- [ ] If a Godot executable is available, run a headless/project validation command.
- [ ] Initialize git if needed, connect `https://github.com/facingshootingstar/Bank_robber.git`, commit, and push.
