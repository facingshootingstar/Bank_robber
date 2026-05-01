extends Node2D

const PROMPT_NONE := ""

@export var speed: float = 220.0
@export var radius: float = 14.0
@export var texture_path: String = "res://assets/kenney/top-down-shooter/player_blue.png"
@export var walk_bob_amount: float = 3.5
@export var walk_sway_amount: float = 0.13
@export var footstep_interval: float = 0.28

var nearby_interactable: Node = null
var prompt_text: String = PROMPT_NONE
var facing: Vector2 = Vector2.RIGHT
var _sprite: Sprite2D = null
var _walk_phase: float = 0.0
var _footstep_timer: float = 0.0

func _ready() -> void:
	z_index = 20
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if _sprite != null and _sprite.texture == null and texture_path != "":
		_sprite.texture = _load_texture(texture_path)

func _physics_process(delta: float) -> void:
	if not GameState.run_active:
		return

	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_moving := input_vector.length() > 0.01
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

	_apply_walk_animation(delta, is_moving)
	queue_redraw()

func _apply_walk_animation(delta: float, is_moving: bool) -> void:
	if _sprite == null:
		return
	var base_rotation := facing.angle() + PI * 0.5
	if is_moving:
		_walk_phase += delta * 11.0
		_footstep_timer -= delta
		if _footstep_timer <= 0.0:
			SoundManager.play_footstep()
			_footstep_timer = footstep_interval
		var bob := sin(_walk_phase * 2.0) * walk_bob_amount
		var sway := sin(_walk_phase) * walk_sway_amount
		_sprite.position = Vector2(0.0, bob)
		_sprite.rotation = base_rotation + sway
	else:
		_footstep_timer = 0.0
		_sprite.position = _sprite.position.lerp(Vector2.ZERO, min(delta * 10.0, 1.0))
		_sprite.rotation = lerp_angle(_sprite.rotation, base_rotation, min(delta * 10.0, 1.0))

func set_interactable(target: Node, prompt: String) -> void:
	nearby_interactable = target
	prompt_text = prompt

func clear_interactable() -> void:
	nearby_interactable = null
	prompt_text = PROMPT_NONE

func _draw() -> void:
	draw_circle(Vector2(0, 7), radius * 0.85, Color(0, 0, 0, 0.22))
	if _sprite == null or _sprite.texture == null:
		draw_circle(Vector2.ZERO, radius, Color(0.1, 0.75, 0.95))
		draw_circle(Vector2.ZERO, radius * 0.55, Color(0.8, 0.98, 1.0))
	draw_line(Vector2.ZERO, facing * (radius + 8.0), Color.WHITE, 3.0)

func _load_texture(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)
