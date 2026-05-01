# Bank Robber

Bank Robber is a small Godot 4 top-down stealth game. Sneak into the bank, avoid guards and cameras, collect the vault money, and escape to the van before the alarm fills.

## Controls

- Move: `WASD` or arrow keys
- Interact: `E`
- Pause: `Esc`

## Current Scope

- Main menu
- Level select with locked/planned level slots
- One playable stealth level
- Patrol guards and sweeping security camera
- Loot, vault, exit, alarm, timer, HUD
- Pause, restart, win, lose, and menu return flows

Mobile touch controls are intentionally left for a later pass.

## Verify

Run the static project check:

```powershell
powershell -ExecutionPolicy Bypass -File tests\verify_project.ps1
```
