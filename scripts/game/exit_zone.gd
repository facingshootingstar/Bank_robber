extends Node2D

@export var interact_radius: float = 58.0

func _ready() -> void:
	add_to_group("interactables")
	z_index = 6

func can_interact(player_position: Vector2) -> bool:
	return GameState.can_escape() and global_position.distance_to(player_position) <= interact_radius

func get_prompt() -> String:
	if GameState.can_escape():
		return "Press E to escape"
	return "Need more loot before escaping"

func interact(_player: Node) -> void:
	if GameState.can_escape():
		GameState.win_level()

func _draw() -> void:
	draw_rect(Rect2(Vector2(-42, -24), Vector2(84, 48)), Color(0.1, 0.65, 0.34))
	draw_rect(Rect2(Vector2(-25, -16), Vector2(50, 26)), Color(0.18, 0.9, 0.48))
	draw_circle(Vector2(-24, 25), 8.0, Color(0.04, 0.05, 0.06))
	draw_circle(Vector2(24, 25), 8.0, Color(0.04, 0.05, 0.06))
