extends Node2D

@export var sweep_degrees: float = 85.0
@export var sweep_speed: float = 0.9
@export var vision_length: float = 190.0
@export var vision_angle_degrees: float = 50.0
@export var texture_path: String = "res://assets/kenney/top-down-shooter/camera_lens.png"

var _base_rotation := 0.0
var _time := 0.0
var _sprite: Sprite2D = null

func _ready() -> void:
	add_to_group("cameras")
	z_index = 10
	_base_rotation = rotation
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if _sprite != null and _sprite.texture == null and texture_path != "":
		_sprite.texture = _load_texture(texture_path)

func reset_camera() -> void:
	_time = 0.0
	rotation = _base_rotation
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return
	_time += delta
	var sweep := sin(_time * sweep_speed) * deg_to_rad(sweep_degrees * 0.5)
	rotation = _base_rotation + sweep
	queue_redraw()

func can_see_player(player_position: Vector2) -> bool:
	var origin := global_position
	var forward := Vector2.RIGHT.rotated(global_rotation)
	var to_player := player_position - origin
	var distance := to_player.length()
	if distance > vision_length or distance < 0.01:
		return false
	var angle: float = absf(forward.angle_to(to_player.normalized()))
	if angle > deg_to_rad(vision_angle_degrees * 0.5):
		return false
	var level := get_parent()
	if level != null and level.has_method("line_blocked") and level.line_blocked(origin, player_position):
		return false
	return true

func _draw() -> void:
	var half_angle := deg_to_rad(vision_angle_degrees * 0.5)
	var left := Vector2.RIGHT.rotated(-half_angle) * vision_length
	var right := Vector2.RIGHT.rotated(half_angle) * vision_length
	draw_colored_polygon(PackedVector2Array([Vector2.ZERO, left, right]), Color(1.0, 0.72, 0.1, 0.16))
	if _sprite == null or _sprite.texture == null:
		draw_rect(Rect2(Vector2(-11, -9), Vector2(22, 18)), Color(0.95, 0.75, 0.15))
	draw_line(Vector2.ZERO, Vector2.RIGHT * 22.0, Color.WHITE, 3.0)

func _load_texture(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
