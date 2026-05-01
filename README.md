# Bank Robber

Bank Robber is a small Godot 4 top-down stealth game. Sneak into the bank, avoid guards and cameras, collect the vault money, and escape to the van before the alarm fills.

## Controls

- Move: `WASD` or arrow keys
- Interact: `E`
- Pause: `Esc`

## Current Scope

- Main menu
- Level select with 6 playable levels and unlock progression
- Level 1: Front Lobby
- Level 2: Vault Wing
- Level 3: Back Alley Escape
- Level 4: Security Core
- Level 5: Penthouse Vault
- Level 6: Rooftop Getaway
- Guards with patrol, suspicious, chase, and search behavior
- Sweeping security cameras
- Hack terminals that temporarily loop cameras
- Laser sensor beams that pressure the alarm meter
- Power switches that temporarily shut down laser grids
- Cycling thermal vents that punish bad timing
- Loot, vault, exit, alarm, timer, HUD
- Completion score and rank based on loot, speed, and alarm control
- Completion badges for clean, fast, and ghost-like heists
- In-session best score/rank display on level select
- Persistent unlocks and best scores via Godot user save data
- Direct next-level flow after successful escapes
- Main menu Continue Heist button for the highest unlocked level
- Non-blocking level briefing and heist objective text at level start
- Alert HUD states, procedural footsteps, UI clicks, pickups, vault, and alarm pulses
- Player movement bob/sway for a lighter sneaking feel
- Framed floors, subtle security light bands, prop shadows, and polished HUD/menu panels
- Pause, restart, win, lose, and menu return flows
- Kenney CC0 sprites/tiles for characters, props, floors, walls, and heist dressing

Mobile touch controls are intentionally left for a later pass.

## Assets

The project uses CC0 assets from Kenney:

- Top-down Shooter: https://kenney.nl/assets/top-down-shooter
- Roguelike Indoors: https://kenney.nl/assets/roguelike-indoors
- RPG Audio source notes: https://www.kenney.nl/assets/rpg-audio
- Interface Sounds source notes: https://kenney.nl/assets/interface-sounds

See `assets/kenney/ATTRIBUTION.md` for local source notes.

## Verify

Run the static project check:

```powershell
powershell -ExecutionPolicy Bypass -File tests\verify_project.ps1
```
