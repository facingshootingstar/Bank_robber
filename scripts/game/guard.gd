extends Node2D

@export var patrol_points: PackedVector2Array = PackedVector2Array()
@export var speed: float = 95.0
@export var vision_length: float = 170.0
@export var vision_angle_degrees: float = 58.0
@export var wait_time: float = 0.35
@export var texture_path: String = "res://assets/kenney/top-down-shooter/guard_soldier.png"

var _patrol_index := 0
var _wait_left := 0.0
var _home_position := Vector2.ZERO
var _home_patrol_points: PackedVector2Array = PackedVector2Array()
var facing: Vector2 = Vector2.RIGHT
var _sprite: Sprite2D = null

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

func reset_guard() -> void:
	position = _home_position
	patrol_points = _home_patrol_points
	_patrol_index = 0
	_wait_left = 0.0
	facing = Vector2.RIGHT
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return
	if _wait_left > 0.0:
		_wait_left -= delta
		return
	var target := patrol_points[_patrol_index]
	var to_target := target - position
	if to_target.length() <= speed * delta:
		position = target
		_patrol_index = (_patrol_index + 1) % patrol_points.size()
		_wait_left = wait_time
	else:
		facing = to_target.normalized()
		if _sprite != null:
			_sprite.rotation = facing.angle() + PI * 0.5
		position += facing * speed * delta
	queue_redraw()

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
	draw_colored_polygon(PackedVector2Array([Vector2.ZERO, left, right]), Color(1.0, 0.12, 0.18, 0.18))
	draw_circle(Vector2(0, 7), 13.0, Color(0, 0, 0, 0.22))
	if _sprite == null or _sprite.texture == null:
		draw_circle(Vector2.ZERO, 13.0, Color(0.95, 0.12, 0.18))
	draw_line(Vector2.ZERO, facing * 22.0, Color(1.0, 0.85, 0.85), 3.0)

func _load_texture(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
