# Bank Robber Completion Badges Design

## Goal

Make end-of-level results feel more rewarding and replayable.

## Design

After a successful escape, the game awards simple badges based on run quality:

- Ghost: alarm stayed almost untouched.
- Fast: escaped within the level par time.
- Mastermind: earned an S rank.
- Clean Haul: collected required loot and escaped.

Badges are displayed on the result overlay under the score summary.

## Architecture

`GameState` calculates badges after score/rank. `ResultOverlay` reads a display string through `GameState.get_run_badges_text`.

## Testing

Static verification checks badge fields and helper methods. Runtime smoke confirms a winning run receives badge text.
