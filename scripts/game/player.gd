extends Node2D

const PROMPT_NONE := ""

@export var speed: float = 220.0
@export var radius: float = 14.0

var nearby_interactable: Node = null
var prompt_text: String = PROMPT_NONE
var facing: Vector2 = Vector2.RIGHT

func _ready() -> void:
	z_index = 20

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return

	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector.length() > 0.01:
		facing = input_vector.normalized()
	var motion := input_vector * speed * delta
	var level := get_parent()
	if level != null and level.has_method("move_player_with_collision"):
		position = level.move_player_with_collision(position, motion, radius)
	else:
		position += motion

	if Input.is_action_just_pressed("interact") and nearby_interactable != null:
		if nearby_interactable.has_method("interact"):
			nearby_interactable.interact(self)

	queue_redraw()

func set_interactable(target: Node, prompt: String) -> void:
	nearby_interactable = target
	prompt_text = prompt

func clear_interactable() -> void:
	nearby_interactable = null
	prompt_text = PROMPT_NONE

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(0.1, 0.75, 0.95))
	draw_circle(Vector2.ZERO, radius * 0.55, Color(0.8, 0.98, 1.0))
	draw_line(Vector2.ZERO, facing * (radius + 8.0), Color.WHITE, 3.0)
