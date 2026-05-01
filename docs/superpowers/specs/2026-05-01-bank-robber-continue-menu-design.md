# Bank Robber Continue Menu Design

## Goal

Make persistent progress useful immediately from the main menu.

## Design

Add a `Continue Heist` button that starts the highest unlocked level. Keep `Play Level 1` for replaying from the beginning and `Level Select` for explicit choice.

The button uses existing `GameState.unlocked_levels` and `GameState.get_level_path`; no new save data is needed.

## Testing

Static verification checks that the main menu exposes `_on_continue_pressed`.
