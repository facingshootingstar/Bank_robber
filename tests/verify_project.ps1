$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$failures = New-Object System.Collections.Generic.List[string]

function Require-File($relativePath) {
    $path = Join-Path $root $relativePath
    if (-not (Test-Path -LiteralPath $path)) {
        $failures.Add("Missing file: $relativePath")
    }
}

function Require-Text($relativePath, $pattern, $message) {
    $path = Join-Path $root $relativePath
    if (-not (Test-Path -LiteralPath $path)) {
        $failures.Add("Missing file for text check: $relativePath")
        return
    }
    $content = Get-Content -Raw -LiteralPath $path
    if ($content -notmatch $pattern) {
        $failures.Add($message)
    }
}

$requiredFiles = @(
    "README.md",
    "project.godot",
    "scripts/game_state.gd",
    "scripts/audio/sound_manager.gd",
    "scripts/menu/main_menu.gd",
    "scripts/menu/level_select.gd",
    "scripts/game/player.gd",
    "scripts/game/guard.gd",
    "scripts/game/security_camera.gd",
    "scripts/game/hack_terminal.gd",
    "scripts/game/laser_sensor.gd",
    "scripts/game/power_switch.gd",
    "scripts/game/loot.gd",
    "scripts/game/vault.gd",
    "scripts/game/exit_zone.gd",
    "scripts/game/prop.gd",
    "scripts/game/level.gd",
    "scripts/ui/hud.gd",
    "scripts/ui/pause_overlay.gd",
    "scripts/ui/result_overlay.gd",
    "scenes/ui/MainMenu.tscn",
    "scenes/ui/LevelSelect.tscn",
    "scenes/ui/HUD.tscn",
    "scenes/ui/PauseOverlay.tscn",
    "scenes/ui/ResultOverlay.tscn",
    "scenes/game/Player.tscn",
    "scenes/game/Guard.tscn",
    "scenes/game/SecurityCamera.tscn",
    "scenes/game/HackTerminal.tscn",
    "scenes/game/LaserSensor.tscn",
    "scenes/game/PowerSwitch.tscn",
    "scenes/game/Loot.tscn",
    "scenes/game/Vault.tscn",
    "scenes/game/ExitZone.tscn",
    "scenes/game/Prop.tscn",
    "scenes/levels/Level1.tscn",
    "scenes/levels/Level2.tscn",
    "scenes/levels/Level3.tscn",
    "scenes/levels/Level4.tscn",
    "scenes/levels/Level5.tscn",
    "assets/kenney/ATTRIBUTION.md",
    "assets/kenney/top-down-shooter/player_blue.png",
    "assets/kenney/top-down-shooter/guard_soldier.png",
    "assets/kenney/top-down-shooter/robber_black.png",
    "assets/kenney/roguelike-indoors/tiles/floor_brown.png",
    "assets/kenney/roguelike-indoors/tiles/wall_brown.png",
    "assets/kenney/roguelike-indoors/tiles/safe.png"
)

foreach ($file in $requiredFiles) {
    Require-File $file
}

Require-Text "project.godot" 'run/main_scene="res://scenes/ui/MainMenu.tscn"' "Main scene must be MainMenu.tscn"
Require-Text "project.godot" 'GameState="\*res://scripts/game_state.gd"' "GameState autoload must be configured"
Require-Text "project.godot" 'SoundManager="\*res://scripts/audio/sound_manager.gd"' "SoundManager autoload must be configured"
Require-Text "project.godot" '\[input\]' "Input actions section must exist"
Require-Text "scripts/game_state.gd" 'signal alarm_changed' "GameState must expose alarm_changed signal"
Require-Text "scripts/game_state.gd" 'func win_level' "GameState must implement win_level"
Require-Text "scripts/game_state.gd" 'func lose_level' "GameState must implement lose_level"
Require-Text "scripts/game_state.gd" 'LEVELS := \{' "GameState must define a 3-level registry"
Require-Text "scripts/game_state.gd" 'Level3.tscn' "GameState registry must include Level 3"
Require-Text "scripts/game_state.gd" 'Level5.tscn' "GameState registry must include Level 5"
Require-Text "scripts/game_state.gd" 'func _calculate_final_score' "GameState must calculate score on completion"
Require-Text "scripts/game_state.gd" 'final_rank' "GameState must track final rank"
Require-Text "scripts/game_state.gd" 'best_scores' "GameState must track in-session best scores"
Require-Text "scripts/game_state.gd" 'func get_best_score' "GameState must expose best score lookup"
Require-Text "scripts/game_state.gd" 'func has_next_level' "GameState must expose next-level flow"
Require-Text "scripts/game_state.gd" 'SAVE_PATH' "GameState must define a persistent save path"
Require-Text "scripts/game_state.gd" 'ConfigFile' "GameState must use ConfigFile for progress persistence"
Require-Text "scripts/game_state.gd" 'func _load_progress' "GameState must load persistent progress"
Require-Text "scripts/game_state.gd" 'func _save_progress' "GameState must save persistent progress"
Require-Text "scripts/audio/sound_manager.gd" 'func play_footstep' "SoundManager must implement footstep audio"
Require-Text "scripts/audio/sound_manager.gd" 'func play_alarm_pulse' "SoundManager must implement alarm pulse audio"
Require-Text "scripts/audio/sound_manager.gd" 'func play_hack' "SoundManager must implement hack audio"
Require-Text "scripts/audio/sound_manager.gd" 'func play_laser' "SoundManager must implement laser audio"
Require-Text "scripts/audio/sound_manager.gd" 'func play_power_down' "SoundManager must implement power switch audio"
Require-Text "scripts/game/player.gd" 'func _physics_process' "Player must implement physics movement"
Require-Text "scripts/game/player.gd" 'func _apply_walk_animation' "Player must implement walk bob/sway animation"
Require-Text "scripts/game/player.gd" 'play_footstep' "Player must trigger footstep audio"
Require-Text "scripts/game/player.gd" 'ResourceLoader\.load' "Player texture loading should prefer imported Texture2D resources"
Require-Text "scripts/game/prop.gd" 'ResourceLoader\.load' "Prop texture loading should prefer imported Texture2D resources"
Require-Text "scripts/game/level.gd" 'ResourceLoader\.load' "Level floor texture loading should prefer imported Texture2D resources"
Require-Text "scripts/game/guard.gd" 'func can_see_player' "Guard must implement player detection"
Require-Text "scripts/game/guard.gd" 'enum GuardState' "Guard must define behavior states"
Require-Text "scripts/game/guard.gd" 'func _update_suspicious' "Guard must implement suspicious behavior"
Require-Text "scripts/game/guard.gd" 'func _update_chase' "Guard must implement chase behavior"
Require-Text "scripts/game/guard.gd" 'func _update_search' "Guard must implement search behavior"
Require-Text "scripts/game/security_camera.gd" 'func can_see_player' "SecurityCamera must implement player detection"
Require-Text "scripts/game/security_camera.gd" 'func set_looped' "SecurityCamera must support camera loop hacking"
Require-Text "scripts/game/hack_terminal.gd" 'func interact' "HackTerminal must be interactable"
Require-Text "scripts/game/laser_sensor.gd" 'func _player_crosses_beam' "LaserSensor must detect beam crossing"
Require-Text "scripts/game/laser_sensor.gd" 'func set_disabled' "LaserSensor must support temporary shutdown"
Require-Text "scripts/game/power_switch.gd" 'func interact' "PowerSwitch must be interactable"
Require-Text "scripts/game/level.gd" 'func restart_level' "Level must implement restart_level"
Require-Text "scripts/game/level.gd" 'func get_wall_rects' "Level must read wall rectangles from level scenes"
Require-Text "scripts/game/level.gd" 'func activate_camera_loop' "Level must activate camera loop hacks"
Require-Text "scripts/game/level.gd" 'func activate_laser_shutdown' "Level must activate laser shutdowns"
Require-Text "scripts/game/level.gd" 'func show_system_message' "Level must relay system messages to HUD"
Require-Text "scripts/game/level.gd" 'func _go_to_next_or_select' "Level must route result overlay to the next level"
Require-Text "scripts/game/level.gd" 'func _set_alert_state' "Level must aggregate alert state"
Require-Text "scripts/game/level.gd" 'func _draw_floor_frame' "Level must draw a framed playfield"
Require-Text "scripts/game/level.gd" 'func _draw_light_bands' "Level must draw atmospheric light bands"
Require-Text "scripts/game/prop.gd" 'func _draw_shadow' "Props and walls must draw depth shadows"
Require-Text "scripts/game/prop.gd" 'func _draw_highlight' "Props and walls must draw edge highlights"
Require-Text "scripts/ui/hud.gd" 'func _on_alarm_changed' "HUD must react to alarm changes"
Require-Text "scripts/ui/hud.gd" 'func set_alert_state' "HUD must display guard alert state"
Require-Text "scripts/ui/hud.gd" 'func show_system_message' "HUD must display transient system feedback"
Require-Text "scripts/ui/hud.gd" 'func _panel_style' "HUD must define a polished panel style"
Require-Text "scripts/menu/main_menu.gd" 'func _panel_style' "Main menu must define a polished panel style"
Require-Text "scripts/menu/level_select.gd" 'func _panel_style' "Level select must define a polished panel style"
Require-Text "scripts/menu/level_select.gd" 'get_best_score' "Level select must display best score data"
Require-Text "scenes/levels/Level2.tscn" 'VaultWestTop' "Level 2 vault west wall must be split for a doorway"
Require-Text "scenes/levels/Level2.tscn" 'VaultWestBottom' "Level 2 vault west wall must have a lower split segment"
Require-Text "scenes/levels/Level2.tscn" 'name="DoorHint"[\s\S]*?position = Vector2\(592, 332\)' "Level 2 door hint must be centered on the fixed vault doorway"
Require-Text "assets/kenney/ATTRIBUTION.md" 'Creative Commons Zero, CC0' "Attribution must record CC0 license"
Require-Text "assets/kenney/ATTRIBUTION.md" 'RPG Audio' "Attribution must include Kenney RPG Audio source"

if ($failures.Count -gt 0) {
    Write-Host "Project verification failed:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host " - $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Project verification passed." -ForegroundColor Green
