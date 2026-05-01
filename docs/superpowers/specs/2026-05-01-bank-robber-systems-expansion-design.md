# Bank Robber Systems Expansion Design

## Goal

Push the game beyond the current three-level prototype by adding new stealth tools, hazards, scoring, and late-game levels while preserving the existing top-down heist controls.

## Autonomous Scope

The user explicitly asked for continued autonomous development while away. This pass uses that as approval to prioritize stable, high-impact systems:

- Hack terminals that temporarily loop cameras.
- Laser sensors that raise alarm when crossed.
- Score and rank on level completion.
- Two additional late-game levels that combine guards, cameras, lasers, and terminals.
- Verification updates so future passes keep these systems intact.

Mobile controls, online services, save files, and full art replacement stay out of this pass.

## Gameplay Design

Hack terminals are optional interactables. They give the player a short tactical window by disabling camera detection and tinting cameras as looped. Lasers are static security beams that increase alarm pressure when crossed, forcing route planning even when guards are avoided.

The new levels escalate cleanly:

- Level 4, Security Core: introduces hack terminals and laser timing in a dense control-room route.
- Level 5, Penthouse Vault: final multi-system heist with higher loot requirement, multiple guards, cameras, lasers, and a long escape route.

## Scoring

When the player escapes, the run receives a score and rank based on loot, speed, and remaining alarm headroom. The result overlay shows score, rank, time, and alarm pressure so replaying for cleaner runs has meaning.

## Architecture

- `scripts/game/hack_terminal.gd`: interactable terminal that calls `Level.activate_camera_loop`.
- `scripts/game/laser_sensor.gd`: hazard beam that raises alarm while the player crosses it.
- `scripts/game/security_camera.gd`: supports looped state and skips detection while looped.
- `scripts/game/level.gd`: owns camera-loop timer and propagates state to cameras.
- `scripts/game_state.gd`: tracks final score/rank and expands the level registry.
- `scripts/ui/result_overlay.gd`: displays run summary.

## Testing

The static verifier requires the new scripts, scenes, level registry entries, and key methods. Runtime smoke loads all levels and verifies score/rank helpers exist.
