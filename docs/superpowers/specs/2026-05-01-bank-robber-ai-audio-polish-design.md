# Bank Robber AI Audio Polish Design

## Goal

Make Bank Robber feel more alive by prioritizing gameplay systems: guards should react in stages instead of only patrolling, the player should have subtle movement animation and footstep rustle, and the game should include basic sound feedback.

## Direction

The chosen direction is systems-first. This pass improves the feel of play before doing a larger art overhaul. Visual work is intentionally modest: keep the existing asset maps, but improve readability with alert-state feedback and small mood adjustments.

## Guard Behavior

Guards use a state machine:

- `patrol`: follow waypoints.
- `suspicious`: when the player is glimpsed, face the last known position and raise alarm faster.
- `chase`: move toward the player's last known position while the player is visible or recently visible.
- `search`: when sight is lost, inspect the last known position for a short time.

At patrol waypoints, guards pause and look around with a small left/right sweep. This creates life even before the player is detected.

## Player Movement Feel

When moving, the player sprite should bob up/down and sway/tilt slightly left and right. When the player stops, the sprite returns smoothly to neutral. Footstep/rustle sounds should play on a timed cadence while moving and never spam every frame.

## Audio

Use a lightweight `SoundManager` autoload. It can play short procedural sounds so the project works in headless verification without relying on Godot editor imports:

- footstep/rustle
- cash pickup
- vault open
- alarm pulse
- UI click / general confirm

Kenney CC0 audio sources are noted in attribution for future replacement with richer files:

- RPG Audio: https://www.kenney.nl/assets/rpg-audio
- Interface Sounds: https://kenney.nl/assets/interface-sounds

## HUD And Feedback

HUD should show alert state text: `Hidden`, `Suspicious`, `Chased`, or `Searching`. Detection cones remain readable. Alarm pulse sound should be throttled so it communicates danger without becoming annoying.

## Testing

- Static verifier checks `SoundManager`, guard state machine methods, player walk animation methods, alert HUD method, and audio attribution.
- Runtime smoke loads the project and confirms the new autoload exists.
- Godot headless boot must complete without script errors.
