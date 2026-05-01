extends Node2D

@export var value: int = 400
@export var interact_radius: float = 56.0
@export var texture_path: String = "res://assets/kenney/roguelike-indoors/tiles/safe.png"

var opened := false
var _sprite: Sprite2D = null

func _ready() -> void:
	add_to_group("interactables")
	z_index = 7
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if _sprite != null and _sprite.texture == null and texture_path != "":
		_sprite.texture = _load_texture(texture_path)

func can_interact(player_position: Vector2) -> bool:
	return not opened and global_position.distance_to(player_position) <= interact_radius

func get_prompt() -> String:
	return "Press E to crack vault ($" + str(value) + ")"

func interact(_player: Node) -> void:
	if opened:
		return
	opened = true
	SoundManager.play_vault()
	GameState.add_loot(value)
	queue_redraw()

func reset_vault() -> void:
	opened = false
	queue_redraw()

func _draw() -> void:
	if _sprite != null and _sprite.texture != null:
		if opened:
			draw_rect(Rect2(Vector2(10, -22), Vector2(24, 44)), Color(0.05, 0.06, 0.08, 0.8))
		return
	var body_color := Color(0.44, 0.5, 0.58) if not opened else Color(0.24, 0.3, 0.36)
	draw_rect(Rect2(Vector2(-34, -30), Vector2(68, 60)), body_color)
	draw_rect(Rect2(Vector2(-24, -20), Vector2(48, 40)), Color(0.1, 0.12, 0.15))
	draw_circle(Vector2.ZERO, 9.0, Color(0.95, 0.72, 0.2))
	if opened:
		draw_rect(Rect2(Vector2(8, -22), Vector2(22, 44)), Color(0.05, 0.06, 0.08))

func _load_texture(path: String) -> Texture2D:
	var texture := ResourceLoader.load(path)
	if texture is Texture2D:
		return texture as Texture2D
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
