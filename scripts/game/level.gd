extends Node2D

const MAIN_MENU_SCENE := "res://scenes/ui/MainMenu.tscn"
@export var level_number: int = 1
@export var level_title: String = "Front Lobby"
@export var alarm_rise_rate: float = 38.0
@export var alarm_decay_rate: float = 12.0
@export var floor_texture: Texture2D
@export var floor_texture_path: String = "res://assets/kenney/roguelike-indoors/tiles/floor_brown.png"
@export var floor_tint: Color = Color(0.85, 0.78, 0.68)
@export var floor_rect: Rect2 = Rect2(48, 48, 864, 544)
@export var accent_color: Color = Color(0.95, 0.68, 0.32)
@export var grid_color: Color = Color(0.0, 0.0, 0.0, 0.1)
@export var light_band_color: Color = Color(1.0, 0.92, 0.68, 0.08)

@onready var player: Node2D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var pause_overlay: CanvasLayer = $PauseOverlay
@onready var result_overlay: CanvasLayer = $ResultOverlay

var walls: Array[Rect2] = []
var _interactables: Array[Node] = []
var _guards: Array[Node] = []
var _cameras: Array[Node] = []
var _runtime_floor_texture: Texture2D = null
var _alert_state := "Hidden"
var _alarm_pulse_timer := 0.0
var _camera_loop_timer := 0.0
var _camera_loop_active := false

func _ready() -> void:
	_runtime_floor_texture = floor_texture
	if _runtime_floor_texture == null and floor_texture_path != "":
		_runtime_floor_texture = _load_texture(floor_texture_path)
	walls = get_wall_rects()
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
	result_overlay.next_requested.connect(_go_to_next_or_select)
	if hud.has_method("set_alert_state"):
		hud.set_alert_state(_alert_state)
	_set_camera_loop_active(false)
	queue_redraw()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and GameState.run_active:
		pause_overlay.show_pause()
		return
	if not GameState.run_active:
		return
	_alarm_pulse_timer = maxf(_alarm_pulse_timer - delta, 0.0)
	_update_camera_loop(delta)
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

func get_wall_rects() -> Array[Rect2]:
	var rects: Array[Rect2] = []
	for node in get_tree().get_nodes_in_group("walls"):
		if is_instance_valid(node) and node.has_method("get_rect_global"):
			rects.append(node.get_rect_global())
	return rects

func activate_camera_loop(duration: float) -> void:
	_camera_loop_timer = maxf(_camera_loop_timer, duration)
	_set_camera_loop_active(true)
	GameState.objective_changed.emit("Cameras looped for " + str(int(ceil(_camera_loop_timer))) + " seconds.")
	show_system_message("CAMERA LOOP " + str(int(ceil(_camera_loop_timer))) + "s", 1.6)

func show_system_message(text: String, seconds: float = 1.4) -> void:
	if hud != null and hud.has_method("show_system_message"):
		hud.show_system_message(text, seconds)

func _required_loot() -> int:
	var total := 0
	for node in get_tree().get_nodes_in_group("interactables"):
		var value = node.get("value")
		if value != null:
			total += int(value)
	return total

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
	var alert_state := "Hidden"
	for guard in _guards:
		if not is_instance_valid(guard):
			continue
		if guard.has_method("get_alert_state"):
			alert_state = _stronger_alert(alert_state, guard.get_alert_state())
		elif guard.has_method("can_see_player") and guard.can_see_player(player.global_position):
			alert_state = _stronger_alert(alert_state, "Chased")

	for camera in _cameras:
		if is_instance_valid(camera) and camera.has_method("can_see_player") and camera.can_see_player(player.global_position):
			alert_state = _stronger_alert(alert_state, "Chased")
			break

	match alert_state:
		"Chased":
			GameState.add_alarm(alarm_rise_rate * delta)
			_play_alarm_pulse(0.48)
		"Suspicious":
			GameState.add_alarm(alarm_rise_rate * 0.45 * delta)
			_play_alarm_pulse(0.78)
		"Searching":
			GameState.add_alarm(alarm_rise_rate * 0.16 * delta)
			_play_alarm_pulse(1.05)
		_:
			GameState.decay_alarm(alarm_decay_rate * delta)
	_set_alert_state(alert_state)

func _set_alert_state(next_state: String) -> void:
	_alert_state = next_state
	if hud != null and hud.has_method("set_alert_state"):
		hud.set_alert_state(_alert_state)

func _stronger_alert(current: String, candidate: String) -> String:
	if _alert_priority(candidate) > _alert_priority(current):
		return candidate
	return current

func _alert_priority(state: String) -> int:
	match state:
		"Chased":
			return 3
		"Suspicious":
			return 2
		"Searching":
			return 1
	return 0

func _play_alarm_pulse(cooldown: float) -> void:
	if _alarm_pulse_timer > 0.0:
		return
	SoundManager.play_alarm_pulse()
	_alarm_pulse_timer = cooldown

func _update_camera_loop(delta: float) -> void:
	if _camera_loop_timer <= 0.0:
		if _camera_loop_active:
			_set_camera_loop_active(false)
		return
	_camera_loop_timer = maxf(_camera_loop_timer - delta, 0.0)
	if _camera_loop_timer <= 0.0:
		_set_camera_loop_active(false)

func _set_camera_loop_active(active: bool) -> void:
	_camera_loop_active = active
	for camera in _cameras:
		if is_instance_valid(camera) and camera.has_method("set_looped"):
			camera.set_looped(active)

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

func _go_to_next_or_select() -> void:
	get_tree().paused = false
	if GameState.result == "win" and GameState.has_next_level():
		var next_level := GameState.get_next_level_number()
		get_tree().change_scene_to_file(GameState.get_level_path(next_level))
	else:
		get_tree().change_scene_to_file("res://scenes/ui/LevelSelect.tscn")

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(960, 640)), Color(0.035, 0.04, 0.05))
	_draw_floor_frame()
	_draw_floor_surface()
	_draw_floor_grid()
	_draw_light_bands()

func _draw_floor_frame() -> void:
	for step in range(6):
		var spread := float(6 - step) * 3.0
		draw_rect(floor_rect.grow(spread), Color(0.0, 0.0, 0.0, 0.035), false, 2.0)
	var outer := accent_color.darkened(0.42)
	outer.a = 0.24
	draw_rect(floor_rect.grow(7.0), outer, false, 3.0)
	var inner := Color(1.0, 1.0, 1.0, 0.08)
	draw_rect(floor_rect.grow(1.0), inner, false, 1.0)

func _draw_floor_surface() -> void:
	if _runtime_floor_texture != null:
		draw_texture_rect(_runtime_floor_texture, floor_rect, true, floor_tint)
	else:
		draw_rect(floor_rect, Color(0.18, 0.16, 0.13))
	var wash := accent_color
	wash.a = 0.055
	draw_rect(floor_rect, wash)

func _draw_floor_grid() -> void:
	var left := int(floor_rect.position.x + 32.0)
	var right := int(floor_rect.position.x + floor_rect.size.x)
	var top := int(floor_rect.position.y + 32.0)
	var bottom := int(floor_rect.position.y + floor_rect.size.y)
	for x in range(left, right, 40):
		draw_line(Vector2(x, floor_rect.position.y + 16.0), Vector2(x, floor_rect.position.y + floor_rect.size.y - 16.0), grid_color, 1.0)
	for y in range(top, bottom, 40):
		draw_line(Vector2(floor_rect.position.x + 16.0, y), Vector2(floor_rect.position.x + floor_rect.size.x - 16.0, y), grid_color, 1.0)

func _draw_light_bands() -> void:
	for index in range(4):
		var start_x := floor_rect.position.x - 150.0 + float(index) * 280.0
		var top_y := floor_rect.position.y
		var bottom_y := floor_rect.position.y + floor_rect.size.y
		var band := PackedVector2Array([
			Vector2(start_x, top_y),
			Vector2(start_x + 92.0, top_y),
			Vector2(start_x + 342.0, bottom_y),
			Vector2(start_x + 214.0, bottom_y)
		])
		draw_colored_polygon(band, light_band_color)

func _load_texture(path: String) -> Texture2D:
	var texture := ResourceLoader.load(path)
	if texture is Texture2D:
		return texture as Texture2D
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
