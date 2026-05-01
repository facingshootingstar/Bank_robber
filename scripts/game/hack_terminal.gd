extends Node2D

@export var interact_radius: float = 48.0
@export var loop_duration: float = 8.0
@export var texture_path: String = "res://assets/kenney/roguelike-indoors/tiles/terminal.png"

var hacked := false
var _sprite: Sprite2D = null

func _ready() -> void:
	add_to_group("interactables")
	z_index = 9
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if _sprite != null and _sprite.texture == null and texture_path != "":
		_sprite.texture = _load_texture(texture_path)
	queue_redraw()

func can_interact(player_position: Vector2) -> bool:
	return not hacked and global_position.distance_to(player_position) <= interact_radius

func get_prompt() -> String:
	if hacked:
		return "Camera loop uploaded"
	return "Press E to loop cameras (" + str(int(loop_duration)) + "s)"

func interact(_player: Node) -> void:
	if hacked:
		return
	hacked = true
	var level := get_parent()
	if level != null and level.has_method("activate_camera_loop"):
		level.activate_camera_loop(loop_duration)
	SoundManager.play_hack()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(4, 8), 18.0, Color(0.0, 0.0, 0.0, 0.22))
	if _sprite != null and _sprite.texture != null:
		if hacked:
			draw_circle(Vector2.ZERO, 20.0, Color(0.2, 0.95, 1.0, 0.18))
		return
	var body := Color(0.12, 0.18, 0.2) if not hacked else Color(0.05, 0.32, 0.36)
	var screen := Color(0.4, 1.0, 0.76) if hacked else Color(0.25, 0.8, 1.0)
	draw_rect(Rect2(Vector2(-18, -15), Vector2(36, 30)), body)
	draw_rect(Rect2(Vector2(-11, -9), Vector2(22, 14)), screen)
	draw_line(Vector2(-12, 14), Vector2(12, 14), Color(0.0, 0.0, 0.0, 0.35), 3.0)

func _load_texture(path: String) -> Texture2D:
	var texture := ResourceLoader.load(path)
	if texture is Texture2D:
		return texture as Texture2D
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
