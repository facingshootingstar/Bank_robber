# Bank Robber Visual Polish Design

## Goal

Make the current gameplay look cleaner and more intentional without changing the core stealth loop, and fix the small Level 2 vault entrance map bug.

## Scope

- Keep the existing Godot 4 runtime and Kenney asset set.
- Do a lightweight art pass through runtime drawing and scene layout edits.
- Avoid mobile controls and broad gameplay redesign in this pass.

## Level 2 Map Fix

Level 2 currently reads as if the vault has a door on the west side, but the solid `VaultWest` wall blocks that route and the east-side approach is cramped. Split the west vault wall into top and bottom wall pieces, leaving a clear middle doorway aligned with the door marker. Move the `DoorHint` to the new doorway center so the visual cue and collision match.

## Visual Direction

The game should feel like a small top-down heist map instead of flat debug geometry:

- Darker outer backdrop with a framed playable floor.
- Subtle floor grid and tinted floor texture per level.
- Diagonal translucent light bands to suggest security lighting.
- Props and walls get small shadows and highlights so they sit on the floor.
- HUD gets a darker translucent panel, clearer alarm bar, and stronger alert colors.
- Menus get the same dark bank-heist material language but stay simple.

## Architecture

Use the existing drawing hooks:

- `level.gd` owns floor/background atmosphere.
- `prop.gd` owns wall/prop shadow and edge treatment.
- `hud.gd`, `main_menu.gd`, and `level_select.gd` own UI theme helpers.
- `Level2.tscn` owns the map doorway collision fix.

No new imported assets are required, which keeps headless verification stable.

## Testing

Extend the PowerShell verifier to require the new visual helper methods and the Level 2 split vault doorway. Keep the Godot runtime smoke and boot checks as final verification.
