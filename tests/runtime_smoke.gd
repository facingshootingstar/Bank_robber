extends SceneTree

const SCENES := [
	"res://scenes/ui/MainMenu.tscn",
	"res://scenes/ui/LevelSelect.tscn",
	"res://scenes/ui/HUD.tscn",
	"res://scenes/ui/PauseOverlay.tscn",
	"res://scenes/ui/ResultOverlay.tscn",
	"res://scenes/game/Player.tscn",
	"res://scenes/game/Guard.tscn",
	"res://scenes/game/SecurityCamera.tscn",
	"res://scenes/game/Loot.tscn",
	"res://scenes/game/Vault.tscn",
	"res://scenes/game/ExitZone.tscn",
	"res://scenes/game/Prop.tscn",
	"res://scenes/levels/Level1.tscn",
	"res://scenes/levels/Level2.tscn",
	"res://scenes/levels/Level3.tscn",
]

var _failures: Array[String] = []

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	for scene_path in SCENES:
		var resource: PackedScene = ResourceLoader.load(scene_path)
		if resource == null:
			_failures.append("Could not load " + scene_path)
			continue
		var instance: Node = resource.instantiate()
		if instance == null:
			_failures.append("Could not instantiate " + scene_path)
			continue
		root.add_child(instance)
		await process_frame
		instance.queue_free()
		await process_frame

	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_failures.append("GameState autoload missing at /root/GameState")
	else:
		game_state.start_level(1, 700)
		game_state.add_loot(700)
		if not game_state.can_escape():
			_failures.append("GameState can_escape failed after collecting required loot")
		game_state.win_level()
		if game_state.result != "win":
			_failures.append("GameState win_level did not set result")

	var sound_manager := root.get_node_or_null("SoundManager")
	if sound_manager == null:
		_failures.append("SoundManager autoload missing at /root/SoundManager")
	elif not sound_manager.has_method("play_footstep"):
		_failures.append("SoundManager missing play_footstep")
	else:
		sound_manager.play_footstep()
		sound_manager.play_pickup()
		sound_manager.play_vault()
		sound_manager.play_alarm_pulse()
		sound_manager.play_ui_click()
		await process_frame
		await create_timer(0.35).timeout
		if sound_manager.has_method("stop_all"):
			sound_manager.stop_all()
			await process_frame

	if _failures.is_empty():
		print("Runtime smoke passed.")
		quit(0)
	else:
		push_error("Runtime smoke failed:\n - " + "\n - ".join(_failures))
		quit(1)
