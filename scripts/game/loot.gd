extends Node2D

@export var value: int = 100
@export var interact_radius: float = 42.0
@export var texture_path: String = "res://assets/kenney/roguelike-indoors/tiles/cash.png"

var collected := false
var _sprite: Sprite2D = null

func _ready() -> void:
	add_to_group("interactables")
	z_index = 8
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if _sprite != null and _sprite.texture == null and texture_path != "":
		_sprite.texture = _load_texture(texture_path)

func can_interact(player_position: Vector2) -> bool:
	return not collected and global_position.distance_to(player_position) <= interact_radius

func get_prompt() -> String:
	return "Press E to grab cash ($" + str(value) + ")"

func interact(_player: Node) -> void:
	if collected:
		return
	collected = true
	visible = false
	SoundManager.play_pickup()
	GameState.add_loot(value)

func reset_loot() -> void:
	collected = false
	visible = true

func _draw() -> void:
	if _sprite == null or _sprite.texture == null:
		draw_rect(Rect2(Vector2(-16, -10), Vector2(32, 20)), Color(0.98, 0.83, 0.18))
		draw_rect(Rect2(Vector2(-10, -5), Vector2(20, 10)), Color(0.25, 0.55, 0.25))

func _load_texture(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
