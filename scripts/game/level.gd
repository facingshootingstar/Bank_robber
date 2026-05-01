extends Node2D

const MAIN_MENU_SCENE := "res://scenes/ui/MainMenu.tscn"

@export var level_number: int = 1
@export var alarm_rise_rate: float = 38.0
@export var alarm_decay_rate: float = 12.0

@onready var player: Node2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var pause_overlay: CanvasLayer = $PauseOverlay
@onready var result_overlay: CanvasLayer = $ResultOverlay

var walls: Array[Rect2] = []
var _interactables: Array[Node] = []
var _guards: Array[Node] = []
var _cameras: Array[Node] = []

func _ready() -> void:
	walls = _build_walls()
	_interactables = get_tree().get_nodes_in_group("interactables")
	_guards = get_tree().get_nodes_in_group("guards")
	_cameras = get_tree().get_nodes_in_group("cameras")
	GameState.start_level(level_number, _required_loot())
	GameState.result_changed.connect(_on_result_changed)
	pause_overlay.resume_requested.connect(_on_resume_requested)
	pause_overlay.restart_requested.connect(restart_level)
	pause_overlay.menu_requested.connect(_go_to_menu)
	result_overlay.retry_requested.connect(restart_level)
	result_overlay.menu_requested.connect(_go_to_menu)
	result_overlay.next_requested.connect(_go_to_level_select)
	queue_redraw()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and GameState.run_active:
		pause_overlay.show_pause()
		return
	if not GameState.run_active:
		return
	GameState.tick_timer(delta)
	_update_interaction_prompt()
	_update_detection(delta)

func move_player_with_collision(start_position: Vector2, motion: Vector2, radius: float) -> Vector2:
	var next_position := start_position
	var x_position := Vector2(start_position.x + motion.x, start_position.y)
	if not _circle_hits_wall(x_position, radius):
		next_position.x = x_position.x
	var y_position := Vector2(next_position.x, start_position.y + motion.y)
	if not _circle_hits_wall(y_position, radius):
		next_position.y = y_position.y
	return next_position

func line_blocked(from: Vector2, to: Vector2) -> bool:
	var steps := 24
	for i in range(1, steps):
		var point := from.lerp(to, float(i) / float(steps))
		for wall in walls:
			if wall.has_point(point):
				return true
	return false

func restart_level() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _required_loot() -> int:
	var total := 0
	for node in get_tree().get_nodes_in_group("interactables"):
		var value = node.get("value")
		if value != null:
			total += int(value)
	return total

func _build_walls() -> Array[Rect2]:
	return [
		Rect2(40, 40, 880, 24),
		Rect2(40, 576, 880, 24),
		Rect2(40, 40, 24, 560),
		Rect2(896, 40, 24, 560),
		Rect2(214, 40, 24, 360),
		Rect2(214, 470, 24, 130),
		Rect2(420, 176, 24, 280),
		Rect2(600, 40, 24, 210),
		Rect2(600, 330, 24, 270),
		Rect2(720, 250, 176, 24),
		Rect2(720, 408, 176, 24),
	]

func _circle_hits_wall(center: Vector2, radius: float) -> bool:
	for wall in walls:
		var closest := Vector2(
			clampf(center.x, wall.position.x, wall.position.x + wall.size.x),
			clampf(center.y, wall.position.y, wall.position.y + wall.size.y)
		)
		if center.distance_to(closest) < radius:
			return true
	return false

func _update_interaction_prompt() -> void:
	var best: Node = null
	var best_distance := INF
	var fallback_prompt := ""
	for interactable in _interactables:
		if not is_instance_valid(interactable) or not interactable.visible:
			continue
		if not interactable.has_method("get_prompt"):
			continue
		var distance := player.global_position.distance_to(interactable.global_position)
		if interactable.has_method("can_interact") and interactable.can_interact(player.global_position):
			if distance < best_distance:
				best = interactable
				best_distance = distance
		elif interactable.name == "ExitZone" and distance <= 58.0:
			fallback_prompt = interactable.get_prompt()
	if best != null:
		player.set_interactable(best, best.get_prompt())
		hud.show_prompt(best.get_prompt())
	elif fallback_prompt != "":
		player.clear_interactable()
		hud.show_prompt(fallback_prompt)
	else:
		player.clear_interactable()
		hud.show_prompt("")

func _update_detection(delta: float) -> void:
	var seen := false
	for guard in _guards:
		if is_instance_valid(guard) and guard.has_method("can_see_player") and guard.can_see_player(player.global_position):
			seen = true
			break
	if not seen:
		for camera in _cameras:
			if is_instance_valid(camera) and camera.has_method("can_see_player") and camera.can_see_player(player.global_position):
				seen = true
				break
	if seen:
		GameState.add_alarm(alarm_rise_rate * delta)
	else:
		GameState.decay_alarm(alarm_decay_rate * delta)
	hud.set_detected(seen)

func _on_result_changed(result: String) -> void:
	if result == "win":
		result_overlay.show_result(true)
	elif result == "lose":
		result_overlay.show_result(false)

func _on_resume_requested() -> void:
	pause_overlay.hide_pause()

func _go_to_menu() -> void:
	get_tree().paused = false
	GameState.reset_run()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

func _go_to_level_select() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/LevelSelect.tscn")

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(960, 640)), Color(0.055, 0.065, 0.085))
	draw_rect(Rect2(Vector2(64, 64), Vector2(832, 512)), Color(0.11, 0.13, 0.16))
	for x in range(80, 880, 40):
		draw_line(Vector2(x, 64), Vector2(x, 576), Color(1, 1, 1, 0.025), 1.0)
	for y in range(80, 560, 40):
		draw_line(Vector2(64, y), Vector2(896, y), Color(1, 1, 1, 0.025), 1.0)
	for wall in walls:
		draw_rect(wall, Color(0.36, 0.42, 0.5))
		draw_rect(wall.grow(-4.0), Color(0.22, 0.26, 0.32))
	draw_rect(Rect2(84, 118, 96, 36), Color(0.42, 0.26, 0.13))
	draw_rect(Rect2(84, 184, 96, 36), Color(0.42, 0.26, 0.13))
	draw_rect(Rect2(84, 250, 96, 36), Color(0.42, 0.26, 0.13))
	draw_rect(Rect2(654, 300, 210, 84), Color(0.16, 0.19, 0.24))
	draw_rect(Rect2(654, 300, 210, 84), Color(0.7, 0.78, 0.88, 0.2), false, 2.0)
