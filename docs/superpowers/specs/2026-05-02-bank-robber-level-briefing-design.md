# Bank Robber Level Briefing Design

## Goal

Give each level a clearer start state so players understand what they are entering.

## Design

When a level starts, the HUD shows a transient briefing chip with the level number and title. The objective text also names the current heist instead of using generic copy.

This improves onboarding without adding modal popups or interrupting movement.

## Architecture

`Level` owns `_show_level_briefing` after `GameState.start_level`. It reuses `HUD.show_system_message` and `GameState.objective_changed`.

## Testing

Static verification requires `_show_level_briefing` and `level_title` objective usage.
