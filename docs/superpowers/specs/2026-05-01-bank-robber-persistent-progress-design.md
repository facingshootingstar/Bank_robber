# Bank Robber Persistent Progress Design

## Goal

Make unlock progression and best scores survive app restarts.

## Design

Use Godot `ConfigFile` at `user://bank_robber_save.cfg`. Save only durable progression:

- Highest unlocked level.
- Best score per level.
- Best rank per level.

Run-specific values like current alarm, timer, and current loot are not saved.

## Architecture

`GameState` loads progress in `_ready` after input setup, records best runs on win, and saves immediately after a completed level. Level select already reads from `GameState`, so it automatically reflects persisted best runs.

## Testing

Static verification checks the save/load helpers and ConfigFile usage. Runtime smoke confirms the helpers exist while continuing to avoid depending on machine-specific save contents.
