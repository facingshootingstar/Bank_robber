# Bank Robber Level 6 Design

## Goal

Add a late-game level that uses every stealth system added so far.

## Design

Level 6, Rooftop Getaway, is a final escape route after the penthouse vault. It combines:

- Multiple guards.
- Cameras with hack terminal counterplay.
- Laser grid with power switch counterplay.
- Thermal vents for timing pressure.
- High-value vault and side loot.

The route starts bottom-left and exits top-right to feel like climbing out of the bank.

## Architecture

Add `Level6.tscn`, expand `GameState.LEVELS`, add a par time, and update verification/runtime smoke. No new gameplay scripts are required.

## Testing

Static verifier requires Level 6 in files and registry. Runtime smoke loads the scene.
