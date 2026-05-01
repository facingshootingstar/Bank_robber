# Bank Robber Asset And Level Upgrade Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Upgrade the Godot prototype with Kenney CC0 assets, three playable levels, and richer level design.

**Architecture:** Keep the current Godot scene structure, but make `GameState` own a three-level registry and make `level.gd` derive walls, interactables, guards, cameras, props, and tuning from each level scene. Use downloaded Kenney PNG assets through Sprite2D nodes while preserving simple polygon vision cones for gameplay clarity.

**Tech Stack:** Godot 4.6, GDScript, Kenney CC0 PNG assets, PowerShell verifier, Godot headless smoke test.

---

### Task 1: Asset Import

**Files:**
- Create: `assets/kenney/ATTRIBUTION.md`
- Create: `assets/kenney/top-down-shooter/`
- Create: `assets/kenney/roguelike-indoors/`

- [ ] Download Kenney Top-down Shooter and Roguelike Indoors packs from Kenney.
- [ ] Extract only needed files plus license/readme content into `assets/kenney/`.
- [ ] Add attribution notes with source URLs and CC0 license.

### Task 2: Data-Driven Level Flow

**Files:**
- Modify: `scripts/game_state.gd`
- Modify: `scripts/menu/level_select.gd`
- Modify: `scripts/game/level.gd`
- Create: `scripts/game/prop.gd`
- Create: `scenes/game/Prop.tscn`

- [ ] Add a three-level registry to `GameState`.
- [ ] Allow level select to show all three levels with names/descriptions and unlock state.
- [ ] Refactor level loading/restart/menu flow so every level scene works through the same scripts.
- [ ] Add decorative props that can use texture assets.

### Task 3: Sprite Upgrade

**Files:**
- Modify: `scripts/game/player.gd`
- Modify: `scripts/game/guard.gd`
- Modify: `scripts/game/security_camera.gd`
- Modify: `scripts/game/loot.gd`
- Modify: `scripts/game/vault.gd`
- Modify: `scripts/game/exit_zone.gd`
- Modify: `scenes/game/*.tscn`

- [ ] Add Sprite2D children/textures to player, guards, cameras, loot, vault, exit, and props.
- [ ] Keep fallback `_draw()` visuals if a texture is missing.
- [ ] Keep detection cones visually strong.

### Task 4: Three Improved Levels

**Files:**
- Modify: `scenes/levels/Level1.tscn`
- Create: `scenes/levels/Level2.tscn`
- Create: `scenes/levels/Level3.tscn`

- [ ] Rebuild Level 1 as Front Lobby.
- [ ] Add Level 2 as Vault Wing.
- [ ] Add Level 3 as Back Alley Escape.
- [ ] Tune loot, alarm, guard patrols, and camera positions per level.

### Task 5: Verification And Push

**Files:**
- Modify: `tests/verify_project.ps1`
- Modify: `tests/runtime_smoke.gd`
- Modify: `README.md`

- [ ] Update verifier for assets, attribution, three levels, and registry.
- [ ] Run PowerShell verifier.
- [ ] Run Godot runtime smoke.
- [ ] Run Godot headless boot.
- [ ] Commit and push to GitHub.
