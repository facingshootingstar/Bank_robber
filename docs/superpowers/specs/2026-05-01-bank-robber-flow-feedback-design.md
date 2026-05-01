# Bank Robber Flow Feedback Design

## Goal

Improve player feedback and replay flow after the systems expansion without adding more map complexity.

## Scope

- Add transient HUD system messages for camera loops and laser trips.
- Let the result overlay advance directly to the next unlocked level after a win.
- Track best score/rank for each level during the current session.
- Display best rank/score on level select.

Persistent save files and mobile UI remain out of scope.

## Architecture

- `HUD` owns the visual status chip and hides it after a timer.
- `Level` exposes `show_system_message` so hazards/interactables can report events without knowing UI internals.
- `LaserSensor` reports laser trips through the level when its warning sound fires.
- `GameState` owns in-session best scores/ranks and next-level helpers.
- `LevelSelect` reads best runs from `GameState`.
- `ResultOverlay` updates copy based on whether another level exists.

## Testing

The verifier checks the new helper methods and state fields. Runtime smoke confirms winning records a best score and next-level helper exists.
