extends Node2D

enum GuardState { PATROL, SUSPICIOUS, CHASE, SEARCH }

@export var patrol_points: PackedVector2Array = PackedVector2Array()
@export var speed: float = 95.0
@export var vision_length: float = 170.0
@export var vision_angle_degrees: float = 58.0
@export var wait_time: float = 0.35
@export var texture_path: String = "res://assets/kenney/top-down-shooter/guard_soldier.png"
@export var suspicious_duration: float = 0.65
@export var search_duration: float = 2.2
@export var chase_speed_multiplier: float = 1.35
@export var look_around_angle_degrees: float = 34.0

var _patrol_index := 0
var _wait_left := 0.0
var _home_position := Vector2.ZERO
var _home_patrol_points: PackedVector2Array = PackedVector2Array()
var facing: Vector2 = Vector2.RIGHT
var _sprite: Sprite2D = null
var _player: Node2D = null
var _state := GuardState.PATROL
var _state_timer := 0.0
var _last_known_player_position := Vector2.ZERO
var _look_base_facing := Vector2.RIGHT

func _ready() -> void:
	add_to_group("guards")
	z_index = 12
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if _sprite != null and _sprite.texture == null and texture_path != "":
		_sprite.texture = _load_texture(texture_path)
	_home_position = position
	if patrol_points.is_empty():
		patrol_points = PackedVector2Array([position, position + Vector2(130, 0)])
	_home_patrol_points = patrol_points
	_player = get_parent().get_node_or_null("Player") as Node2D
	_last_known_player_position = global_position
	_set_facing(facing)

func reset_guard() -> void:
	position = _home_position
	patrol_points = _home_patrol_points
	_patrol_index = 0
	_wait_left = 0.0
	_last_known_player_position = global_position
	_look_base_facing = Vector2.RIGHT
	_set_state(GuardState.PATROL)
	_set_facing(Vector2.RIGHT)
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return
	var player_visible := _player != null and can_see_player(_player.global_position)
	if player_visible:
		_last_known_player_position = _player.global_position

	match _state:
		GuardState.PATROL:
			_update_patrol(delta, player_visible)
		GuardState.SUSPICIOUS:
			_update_suspicious(delta, player_visible)
		GuardState.CHASE:
			_update_chase(delta, player_visible)
		GuardState.SEARCH:
			_update_search(delta, player_visible)

	queue_redraw()

func get_alert_state() -> String:
	match _state:
		GuardState.SUSPICIOUS:
			return "Suspicious"
		GuardState.CHASE:
			return "Chased"
		GuardState.SEARCH:
			return "Searching"
	return "Hidden"

func _update_patrol(delta: float, player_visible: bool) -> void:
	if player_visible:
		_set_state(GuardState.SUSPICIOUS)
		return
	if _wait_left > 0.0:
		_wait_left -= delta
		var sweep := sin(Time.get_ticks_msec() * 0.006) * deg_to_rad(look_around_angle_degrees)
		_set_facing(_look_base_facing.rotated(sweep))
		return
	var target := patrol_points[_patrol_index]
	var to_target := target - position
	if to_target.length() <= speed * delta:
		position = target
		_patrol_index = (_patrol_index + 1) % patrol_points.size()
		_wait_left = wait_time
		_look_base_facing = facing
	else:
		_move_toward(target, speed, delta)

func _update_suspicious(delta: float, player_visible: bool) -> void:
	_state_timer += delta
	_face_toward(_last_known_player_position)
	if player_visible and _state_timer >= suspicious_duration:
		_set_state(GuardState.CHASE)
	elif not player_visible and _state_timer >= suspicious_duration:
		_set_state(GuardState.SEARCH)

func _update_chase(delta: float, player_visible: bool) -> void:
	if player_visible:
		_last_known_player_position = _player.global_position
	var distance := global_position.distance_to(_last_known_player_position)
	if distance > 12.0:
		_move_toward(_last_known_player_position, speed * chase_speed_multiplier, delta)
	elif not player_visible:
		_set_state(GuardState.SEARCH)
	else:
		_face_toward(_last_known_player_position)

func _update_search(delta: float, player_visible: bool) -> void:
	if player_visible:
		_set_state(GuardState.CHASE)
		return
	_state_timer += delta
	var distance := global_position.distance_to(_last_known_player_position)
	if distance > 30.0:
		_move_toward(_last_known_player_position, speed * 0.65, delta)
	else:
		var base := (_last_known_player_position - global_position).normalized()
		if base.length() <= 0.01:
			base = _look_base_facing
		var sweep := sin(_state_timer * 7.0) * deg_to_rad(look_around_angle_degrees)
		_set_facing(base.rotated(sweep))
	if _state_timer >= search_duration:
		_set_state(GuardState.PATROL)

func _set_state(next_state: int) -> void:
	if _state == next_state:
		return
	_state = next_state
	_state_timer = 0.0
	_look_base_facing = facing

func _move_toward(target: Vector2, move_speed: float, delta: float) -> void:
	var to_target := target - global_position
	if to_target.length() <= move_speed * delta:
		global_position = target
	else:
		_set_facing(to_target.normalized())
		global_position += facing * move_speed * delta

func _face_toward(target: Vector2) -> void:
	var to_target := target - global_position
	if to_target.length() > 0.01:
		_set_facing(to_target.normalized())

func _set_facing(direction: Vector2) -> void:
	if direction.length() <= 0.01:
		return
	facing = direction.normalized()
	if _sprite != null:
		_sprite.rotation = facing.angle() + PI * 0.5

func can_see_player(player_position: Vector2) -> bool:
	var to_player := player_position - global_position
	var distance := to_player.length()
	if distance > vision_length or distance < 0.01:
		return false
	var angle: float = absf(facing.angle_to(to_player.normalized()))
	if angle > deg_to_rad(vision_angle_degrees * 0.5):
		return false
	var level := get_parent()
	if level != null and level.has_method("line_blocked") and level.line_blocked(global_position, player_position):
		return false
	return true

func _draw() -> void:
	var half_angle := deg_to_rad(vision_angle_degrees * 0.5)
	var left := facing.rotated(-half_angle) * vision_length
	var right := facing.rotated(half_angle) * vision_length
	var cone_color := Color(1.0, 0.12, 0.18, 0.18)
	if _state == GuardState.SUSPICIOUS:
		cone_color = Color(1.0, 0.72, 0.12, 0.22)
	elif _state == GuardState.CHASE:
		cone_color = Color(1.0, 0.05, 0.08, 0.28)
	elif _state == GuardState.SEARCH:
		cone_color = Color(1.0, 0.42, 0.08, 0.2)
	draw_colored_polygon(PackedVector2Array([Vector2.ZERO, left, right]), cone_color)
	draw_circle(Vector2(0, 7), 13.0, Color(0, 0, 0, 0.22))
	if _sprite == null or _sprite.texture == null:
		draw_circle(Vector2.ZERO, 13.0, Color(0.95, 0.12, 0.18))
	draw_line(Vector2.ZERO, facing * 22.0, Color(1.0, 0.85, 0.85), 3.0)

func _load_texture(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
