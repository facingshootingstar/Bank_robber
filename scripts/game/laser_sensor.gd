extends Node2D

@export var beam_length: float = 190.0
@export var beam_width: float = 11.0
@export var alarm_rate: float = 42.0
@export var pulse_speed: float = 5.0

var _player: Node2D = null
var _sound_timer := 0.0
var _time := 0.0
var _disabled := false

func _ready() -> void:
	add_to_group("sensors")
	z_index = 11
	_player = get_parent().get_node_or_null("Player") as Node2D
	queue_redraw()

func set_disabled(disabled: bool) -> void:
	_disabled = disabled
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return
	_time += delta
	if _disabled:
		queue_redraw()
		return
	_sound_timer = maxf(_sound_timer - delta, 0.0)
	if _player != null and _player_crosses_beam(_player.global_position):
		GameState.add_alarm(alarm_rate * delta)
		if _sound_timer <= 0.0:
			SoundManager.play_laser()
			var level := get_parent()
			if level != null and level.has_method("show_system_message"):
				level.show_system_message("LASER TRIPPED", 0.65)
			_sound_timer = 0.35
	queue_redraw()

func _player_crosses_beam(player_position: Vector2) -> bool:
	var start := global_position
	var direction := Vector2.RIGHT.rotated(global_rotation)
	var local := player_position - start
	var along := local.dot(direction)
	if along < 0.0 or along > beam_length:
		return false
	var closest := start + direction * along
	if player_position.distance_to(closest) > beam_width:
		return false
	var level := get_parent()
	if level != null and level.has_method("line_blocked") and level.line_blocked(start, player_position):
		return false
	return true

func _draw() -> void:
	var pulse := 0.55 + 0.35 * sin(_time * pulse_speed)
	var beam_color := Color(1.0, 0.05, 0.08, 0.32 + pulse * 0.2)
	var core_color := Color(1.0, 0.65, 0.55, 0.76)
	if _disabled:
		beam_color = Color(0.28, 0.82, 1.0, 0.13)
		core_color = Color(0.58, 0.95, 1.0, 0.42)
	draw_line(Vector2.ZERO, Vector2.RIGHT * beam_length, beam_color, beam_width)
	draw_line(Vector2.ZERO, Vector2.RIGHT * beam_length, core_color, 2.0)
	draw_circle(Vector2.ZERO, 9.0, Color(0.16, 0.02, 0.03))
	draw_circle(Vector2.RIGHT * beam_length, 9.0, Color(0.16, 0.02, 0.03))
	var node_color := Color(0.35, 0.9, 1.0) if _disabled else Color(1.0, 0.2, 0.16)
	draw_circle(Vector2.ZERO, 4.0, node_color)
	draw_circle(Vector2.RIGHT * beam_length, 4.0, node_color)
