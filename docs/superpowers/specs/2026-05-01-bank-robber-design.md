# Bank Robber Design

## Goal

Build a small but complete Godot 4 desktop-first stealth game called "Bank Robber". The first playable release should feel like a simple product, not only a prototype: it needs a main menu, level select, one complete level, pause, win, lose, and restart flows.

Mobile touch controls are out of scope for this pass. Input should be structured so touch buttons or a virtual joystick can be added later without rewriting gameplay.

## Player Experience

The player is a robber entering a bank at night. They move through a top-down 2D map, avoid guards and security cameras, steal money from the vault, and escape to the van. Being seen increases the alarm meter. If the alarm fills, the player loses. If they return to the van after collecting the required loot, they win and unlock the next level slot.

The intended first-session length is 2 to 5 minutes. The level should be readable at a glance: walls block movement, yellow loot marks the objective, red cones are danger, and the exit van is the final destination.

## Scene Flow

- `MainMenu`: Play, Level Select, Quit.
- `LevelSelect`: Level 1 available, later level slots visible but locked.
- `GameLevel`: Runs the active stealth level.
- `PauseOverlay`: Resume, Restart, Main Menu.
- `ResultOverlay`: Shows win or lose state with Retry, Next Level when available, and Main Menu.

## Gameplay

- Movement uses keyboard input: WASD and arrow keys.
- Interact uses `E`.
- Pause uses `Esc`.
- The player can collect loose cash and interact with the vault.
- Level win condition: required loot collected and the player reaches the exit.
- Level loss condition: alarm reaches its maximum.
- Guards patrol between waypoints and detect the player inside a vision cone when line of sight is clear enough for this first pass.
- Security cameras rotate or sweep a fixed cone and increase alarm when the player is inside the cone.
- Detection should be forgiving: alarm rises while seen and decays slowly when hidden.

## Architecture

- `GameState` autoload stores selected level, unlocked level count, run result, loot, alarm, and helper methods for start, win, lose, and reset.
- Gameplay entities are separate scenes/scripts where practical:
  - `Player`
  - `Guard`
  - `SecurityCamera`
  - `Loot`
  - `Vault`
  - `Exit`
  - `HUD`
- Level 1 is a scene composed from those entities. Future levels can be added by duplicating the level scene and adjusting positions, patrol points, and loot targets.

## Visual Direction

Use Godot-native 2D shapes and labels for this pass. The game should be readable rather than asset-heavy:

- Dark bank floor and clear walls.
- Cyan or blue player.
- Red guards and camera detection cones.
- Yellow loot and vault highlights.
- Green exit van area.
- Compact HUD showing objective, loot, alarm, and timer.

## Error Handling And Edge Cases

- Restart should fully reset loot, alarm, guard positions, camera sweep, timer, and result state.
- Returning to menu from pause or result should not leave stale gameplay state.
- Interact prompts should appear only near interactable objects.
- Level select should prevent locked levels from starting.
- Quit should work on exported desktop builds and should be harmless in editor.

## Testing

Manual verification is enough for this pass because the project is a small Godot prototype:

- Launch the project and confirm it opens to `MainMenu`.
- Start Level 1 from Play and from Level Select.
- Move with WASD and arrow keys.
- Collect loot and win by reaching the exit.
- Trigger detection and lose when alarm fills.
- Pause, resume, restart, return to menu.
- Confirm locked level slots do not start.
- Restart after win and after loss to ensure state resets.

## Out Of Scope

- Mobile touch controls.
- Multiple fully playable levels.
- Save files beyond in-memory unlocks for this session.
- External art, animation pipelines, sound effects, or music.
- Sophisticated pathfinding or physics-heavy stealth simulation.
