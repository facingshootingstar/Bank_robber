extends Node2D

@export var heat_radius: float = 46.0
@export var active_duration: float = 1.25
@export var idle_duration: float = 2.2
@export var alarm_rate: float = 34.0
@export var phase_offset: float = 0.0

var _player: Node2D = null
var _time := 0.0
var _sound_timer := 0.0

func _ready() -> void:
	add_to_group("sensors")
	z_index = 10
	_player = get_parent().get_node_or_null("Player") as Node2D
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return
	_time += delta
	_sound_timer = maxf(_sound_timer - delta, 0.0)
	if _is_active() and _player != null and _player_in_heat(_player.global_position):
		GameState.add_alarm(alarm_rate * delta)
		if _sound_timer <= 0.0:
			SoundManager.play_vent()
			var level := get_parent()
			if level != null and level.has_method("show_system_message"):
				level.show_system_message("STEAM BURST", 0.55)
			_sound_timer = 0.45
	queue_redraw()

func _player_in_heat(player_position: Vector2) -> bool:
	return global_position.distance_to(player_position) <= heat_radius

func _is_active() -> bool:
	var cycle := maxf(active_duration + idle_duration, 0.1)
	return fmod(_time + phase_offset, cycle) <= active_duration

func _draw() -> void:
	var active := _is_active()
	var base_color := Color(0.08, 0.09, 0.1)
	var core_color := Color(1.0, 0.38, 0.14, 0.72) if active else Color(0.18, 0.32, 0.36, 0.55)
	var steam_color := Color(1.0, 0.74, 0.46, 0.18) if active else Color(0.4, 0.8, 0.95, 0.08)
	draw_circle(Vector2(4, 8), heat_radius * 0.42, Color(0.0, 0.0, 0.0, 0.2))
	draw_circle(Vector2.ZERO, heat_radius, steam_color)
	draw_rect(Rect2(Vector2(-22, -13), Vector2(44, 26)), base_color)
	draw_rect(Rect2(Vector2(-18, -9), Vector2(36, 18)), core_color)
	for x in range(-15, 16, 10):
		draw_line(Vector2(x, -9), Vector2(x, 9), Color(0.0, 0.0, 0.0, 0.32), 2.0)
	if active:
		for index in range(3):
			var offset := float(index - 1) * 12.0
			draw_line(Vector2(offset, -10), Vector2(offset + sin(_time * 8.0 + index) * 7.0, -34.0), Color(1.0, 0.82, 0.56, 0.42), 3.0)
