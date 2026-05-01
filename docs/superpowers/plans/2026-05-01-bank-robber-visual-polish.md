# Bank Robber Visual Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Improve the game's visual presentation and fix the Level 2 vault doorway bug.

**Architecture:** Keep gameplay logic intact. Add visual helper methods to existing Godot scripts, update HUD/menu theme helpers, and edit Level 2 scene geometry so the doorway visual and collision agree.

**Tech Stack:** Godot 4.6, GDScript, `.tscn` scene text, PowerShell verifier, Godot headless smoke tests.

---

### Task 1: Verification Gate

**Files:**
- Modify: `tests/verify_project.ps1`

- [ ] Require visual helpers in `scripts/game/level.gd`, `scripts/game/prop.gd`, and UI scripts.
- [ ] Require Level 2 to contain `VaultWestTop`, `VaultWestBottom`, and a centered `DoorHint`.
- [ ] Run the verifier and confirm it fails before implementation.

### Task 2: Level Atmosphere

**Files:**
- Modify: `scripts/game/level.gd`
- Modify: `scenes/levels/Level1.tscn`
- Modify: `scenes/levels/Level2.tscn`
- Modify: `scenes/levels/Level3.tscn`

- [ ] Add exported colors for accent, grid, and light bands.
- [ ] Extract `_draw_floor_frame`, `_draw_floor_grid`, and `_draw_light_bands`.
- [ ] Keep floor texture drawing and collision unchanged.
- [ ] Set per-level accent colors in scene files.

### Task 3: Prop And Wall Depth

**Files:**
- Modify: `scripts/game/prop.gd`

- [ ] Draw a soft offset shadow before each wall/prop.
- [ ] Draw subtle top/left highlight and bottom/right edge lines.
- [ ] Preserve solid-wall group behavior and existing texture rendering.

### Task 4: HUD And Menu Theme

**Files:**
- Modify: `scripts/ui/hud.gd`
- Modify: `scripts/menu/main_menu.gd`
- Modify: `scripts/menu/level_select.gd`

- [ ] Add `_panel_style` helpers.
- [ ] Theme HUD panel, alarm bar, labels, menu panels, and buttons.
- [ ] Keep persistent HUD compact and away from the playfield center.

### Task 5: Level 2 Doorway Fix

**Files:**
- Modify: `scenes/levels/Level2.tscn`

- [ ] Replace the solid `VaultWest` with `VaultWestTop` and `VaultWestBottom`.
- [ ] Move `DoorHint` to the doorway center.
- [ ] Leave guard/camera/vault gameplay values unchanged.

### Task 6: Verify, Commit, Push

**Files:**
- Modify: `README.md`

- [ ] Update current scope with visual polish.
- [ ] Run `powershell -ExecutionPolicy Bypass -File tests\verify_project.ps1`.
- [ ] Run Godot runtime smoke.
- [ ] Run Godot headless boot.
- [ ] Run `git diff --check`.
- [ ] Commit and push to `origin main`.
