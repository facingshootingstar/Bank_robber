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
    "scripts/menu/main_menu.gd",
    "scripts/menu/level_select.gd",
    "scripts/game/player.gd",
    "scripts/game/guard.gd",
    "scripts/game/security_camera.gd",
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
    "scenes/game/Loot.tscn",
    "scenes/game/Vault.tscn",
    "scenes/game/ExitZone.tscn",
    "scenes/game/Prop.tscn",
    "scenes/levels/Level1.tscn",
    "scenes/levels/Level2.tscn",
    "scenes/levels/Level3.tscn",
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
Require-Text "project.godot" '\[input\]' "Input actions section must exist"
Require-Text "scripts/game_state.gd" 'signal alarm_changed' "GameState must expose alarm_changed signal"
Require-Text "scripts/game_state.gd" 'func win_level' "GameState must implement win_level"
Require-Text "scripts/game_state.gd" 'func lose_level' "GameState must implement lose_level"
Require-Text "scripts/game_state.gd" 'LEVELS := \{' "GameState must define a 3-level registry"
Require-Text "scripts/game_state.gd" 'Level3.tscn' "GameState registry must include Level 3"
Require-Text "scripts/game/player.gd" 'func _physics_process' "Player must implement physics movement"
Require-Text "scripts/game/guard.gd" 'func can_see_player' "Guard must implement player detection"
Require-Text "scripts/game/security_camera.gd" 'func can_see_player' "SecurityCamera must implement player detection"
Require-Text "scripts/game/level.gd" 'func restart_level' "Level must implement restart_level"
Require-Text "scripts/game/level.gd" 'func get_wall_rects' "Level must read wall rectangles from level scenes"
Require-Text "scripts/ui/hud.gd" 'func _on_alarm_changed' "HUD must react to alarm changes"
Require-Text "assets/kenney/ATTRIBUTION.md" 'Creative Commons Zero, CC0' "Attribution must record CC0 license"

if ($failures.Count -gt 0) {
    Write-Host "Project verification failed:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host " - $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Project verification passed." -ForegroundColor Green
