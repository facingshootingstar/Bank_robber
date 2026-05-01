# Bank Robber Asset And Level Upgrade Design

## Goal

Upgrade Bank Robber from a shape-based prototype into a stronger playable build with real CC0 assets, a clearer bank/heist look, and three distinct levels.

## Asset Direction

Use Kenney's CC0 asset packs:

- `Roguelike Indoors` for floor, wall, interior, vault-like, door, and room dressing sprites.
- `Top-down Shooter` for top-down characters, furniture, crates, props, and visual variety.

Store downloaded packs under `assets/kenney/` and include a local attribution/license note with the source URLs. Even though CC0 does not require attribution, keeping the source in the repo makes the asset history clear.

## Level Design

### Level 1: Front Lobby

A readable tutorial-like level. It teaches movement, interact, alarm, a short guard patrol, one camera, and cash pickup. The player can win within 1-2 minutes.

### Level 2: Vault Wing

A denser bank interior with more walls, longer guard patrols, two cameras, more cash, and a vault objective. This level rewards route planning and waiting for patrol timing.

### Level 3: Back Alley Escape

An escape route through storage/garage corridors after the robbery. It has less vault play and more movement pressure: staggered guards, camera sightlines, and a longer path to the exit van.

## Architecture

- Add a level registry to `GameState` with 3 playable levels and unlock progression.
- Refactor `level.gd` so it can read walls, props, entities, and tuning from child nodes/scenes rather than being locked to Level 1's layout.
- Keep guard, camera, loot, vault, and exit as reusable scenes.
- Add a lightweight prop scene/script for decorative sprites that do not affect gameplay.
- Preserve detection cones as transparent gameplay overlays for readability.

## Visual Direction

Use asset sprites for the bank environment and entities, while keeping strong color-coded gameplay readability:

- Floors and walls use Kenney indoor tiles/sprites.
- Player, guards, loot, vault, furniture, desks, crates, and exit props use sprites when available.
- Alarm/detection remains red/orange and easy to parse.
- Menus and HUD stay clean but get more polished labels and level descriptions.

## Testing

- Static verifier must require downloaded asset folders, 3 level scenes, level registry, and source attribution.
- Runtime smoke must instantiate all 3 levels.
- Godot headless boot must still load the main menu without script errors.

## Out Of Scope

- Mobile touch controls.
- Full tilemap authoring workflow.
- Audio/music.
- Save files across app restarts.
- Combat, shooting, or enemy AI beyond patrol/detection.
