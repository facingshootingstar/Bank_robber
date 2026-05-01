# Bank Robber Laser Counterplay Design

## Goal

Add an active counterplay tool for laser-heavy levels so late-game routes have tactical decisions, not only hazard avoidance.

## Design

Power switches are one-use interactables that shut down every laser sensor in the current level for a short duration. Disabled lasers draw in a cold blue tone, stop raising alarm, and then restore automatically when the timer expires.

This mirrors camera hacking but targets sensors instead of cameras, which gives the player two readable stealth tools:

- Hack terminals loop cameras.
- Power switches shut down lasers.

## Architecture

- `power_switch.gd` is an interactable that calls `Level.activate_laser_shutdown`.
- `Level` owns the shutdown timer and propagates disabled state to sensor nodes.
- `LaserSensor` exposes `set_disabled`.
- `SoundManager` adds a short power-down sound.
- Level 4 and Level 5 each receive at least one switch.

## Testing

Static verification requires the new script, scene, sound method, level method, and sensor disabled method. Runtime smoke loads the new scene.
