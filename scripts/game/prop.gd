extends Node2D

@export var size: Vector2 = Vector2(64, 64)
@export var texture: Texture2D
@export var texture_path: String = ""
@export var tint: Color = Color.WHITE
@export var fallback_color: Color = Color(0.28, 0.22, 0.16)
@export var solid: bool = false
@export var tiled: bool = true
@export var z_layer: int = 1

var _runtime_texture: Texture2D = null

func _ready() -> void:
	z_index = z_layer
	_runtime_texture = texture
	if _runtime_texture == null and texture_path != "":
		_runtime_texture = _load_texture(texture_path)
	if solid:
		add_to_group("walls")
	else:
		add_to_group("props")
	queue_redraw()

func get_rect_global() -> Rect2:
	return Rect2(global_position - size * 0.5, size)

func _draw() -> void:
	var rect := Rect2(-size * 0.5, size)
	_draw_shadow(rect)
	if _runtime_texture != null:
		draw_texture_rect(_runtime_texture, rect, tiled, tint)
	else:
		draw_rect(rect, fallback_color)
	_draw_highlight(rect)
	if solid:
		draw_rect(rect, Color(0.03, 0.025, 0.02, 0.38), false, 2.0)

func _draw_shadow(rect: Rect2) -> void:
	var shadow_rect := rect
	shadow_rect.position += Vector2(4.0, 5.0)
	draw_rect(shadow_rect, Color(0.0, 0.0, 0.0, 0.18))

func _draw_highlight(rect: Rect2) -> void:
	var top_left := rect.position
	var top_right := rect.position + Vector2(rect.size.x, 0.0)
	var bottom_left := rect.position + Vector2(0.0, rect.size.y)
	var bottom_right := rect.position + rect.size
	draw_line(top_left, top_right, Color(1.0, 1.0, 1.0, 0.12), 1.0)
	draw_line(top_left, bottom_left, Color(1.0, 1.0, 1.0, 0.08), 1.0)
	draw_line(bottom_left, bottom_right, Color(0.0, 0.0, 0.0, 0.2), 1.0)
	draw_line(top_right, bottom_right, Color(0.0, 0.0, 0.0, 0.16), 1.0)

func _load_texture(path: String) -> Texture2D:
	var texture := ResourceLoader.load(path)
	if texture is Texture2D:
		return texture as Texture2D
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
