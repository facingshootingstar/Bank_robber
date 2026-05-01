# Bank Robber Thermal Vents Design

## Goal

Add a timed environmental hazard that creates a different stealth rhythm from guards, cameras, and lasers.

## Design

Thermal vents cycle between idle and active steam bursts. When active, the vent raises alarm if the player stands inside its radius. The vent is readable from animation and color:

- Idle: low, cool grate.
- Warning/active: bright steam plume and orange hot core.

The hazard does not block movement; it pressures timing and route choice.

## Architecture

- `thermal_vent.gd` owns the cycle, alarm pressure, player overlap, drawing, and sound cadence.
- `SoundManager.play_vent` provides a short procedural hiss.
- `ThermalVent.tscn` is the reusable scene.
- Level 3 and Level 5 use vents to add timing pressure to storage/final routes.

## Testing

Static verifier requires the new script, scene, sound method, and key detection method. Runtime smoke loads the vent scene and calls the sound method.
