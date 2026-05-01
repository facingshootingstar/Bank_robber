extends Node2D

@export var interact_radius: float = 46.0
@export var shutdown_duration: float = 7.0

var used := false

func _ready() -> void:
	add_to_group("interactables")
	z_index = 9
	queue_redraw()

func can_interact(player_position: Vector2) -> bool:
	return not used and global_position.distance_to(player_position) <= interact_radius

func get_prompt() -> String:
	if used:
		return "Laser grid already bypassed"
	return "Press E to cut laser power (" + str(int(shutdown_duration)) + "s)"

func interact(_player: Node) -> void:
	if used:
		return
	used = true
	var level := get_parent()
	if level != null and level.has_method("activate_laser_shutdown"):
		level.activate_laser_shutdown(shutdown_duration)
	SoundManager.play_power_down()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(4, 8), 18.0, Color(0.0, 0.0, 0.0, 0.22))
	var body := Color(0.1, 0.11, 0.12) if not used else Color(0.06, 0.18, 0.22)
	var lever := Color(1.0, 0.26, 0.16) if not used else Color(0.38, 0.9, 1.0)
	draw_rect(Rect2(Vector2(-17, -17), Vector2(34, 34)), body)
	draw_rect(Rect2(Vector2(-11, -9), Vector2(22, 7)), Color(0.02, 0.03, 0.035))
	draw_line(Vector2(-4, 8), Vector2(8, -8 if not used else 8), lever, 4.0)
	draw_circle(Vector2(8, -8 if not used else 8), 5.0, lever)
