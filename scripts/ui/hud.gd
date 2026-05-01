extends CanvasLayer

var loot_label: Label
var alarm_bar: ProgressBar
var objective_label: Label
var timer_label: Label
var prompt_label: Label
var alert_label: Label

func _ready() -> void:
	_build_ui()
	GameState.loot_changed.connect(_on_loot_changed)
	GameState.alarm_changed.connect(_on_alarm_changed)
	GameState.objective_changed.connect(_on_objective_changed)
	GameState.timer_changed.connect(_on_timer_changed)
	_on_loot_changed(GameState.loot_collected, GameState.loot_required)
	_on_alarm_changed(GameState.alarm, GameState.alarm_max)
	_on_objective_changed("Find the vault cash.")
	_on_timer_changed(0.0)

func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var top := PanelContainer.new()
	top.offset_left = 16
	top.offset_top = 12
	top.offset_right = 944
	top.offset_bottom = 74
	root.add_child(top)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	top.add_child(row)

	objective_label = Label.new()
	objective_label.custom_minimum_size = Vector2(280, 32)
	row.add_child(objective_label)

	loot_label = Label.new()
	loot_label.custom_minimum_size = Vector2(145, 32)
	row.add_child(loot_label)

	alarm_bar = ProgressBar.new()
	alarm_bar.custom_minimum_size = Vector2(200, 26)
	alarm_bar.show_percentage = false
	row.add_child(alarm_bar)

	alert_label = Label.new()
	alert_label.text = "HIDDEN"
	alert_label.custom_minimum_size = Vector2(140, 32)
	alert_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	alert_label.add_theme_font_size_override("font_size", 14)
	row.add_child(alert_label)

	timer_label = Label.new()
	timer_label.custom_minimum_size = Vector2(84, 32)
	row.add_child(timer_label)

	prompt_label = Label.new()
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.add_theme_font_size_override("font_size", 20)
	prompt_label.offset_left = 0
	prompt_label.offset_top = 548
	prompt_label.offset_right = 960
	prompt_label.offset_bottom = 600
	root.add_child(prompt_label)

func _on_loot_changed(current: int, required: int) -> void:
	loot_label.text = "Loot $" + str(current) + " / $" + str(required)

func _on_alarm_changed(current: float, maximum: float) -> void:
	alarm_bar.max_value = maximum
	alarm_bar.value = current

func _on_objective_changed(text: String) -> void:
	objective_label.text = text

func _on_timer_changed(seconds: float) -> void:
	var whole := int(seconds)
	timer_label.text = "%02d:%02d" % [int(whole / 60), whole % 60]

func show_prompt(text: String) -> void:
	prompt_label.text = text

func set_alert_state(state: String) -> void:
	match state:
		"Chased":
			alert_label.text = "CHASE"
			alert_label.add_theme_color_override("font_color", Color(1.0, 0.25, 0.22))
		"Suspicious":
			alert_label.text = "WATCHING"
			alert_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.18))
		"Searching":
			alert_label.text = "SEARCH"
			alert_label.add_theme_color_override("font_color", Color(1.0, 0.52, 0.2))
		_:
			alert_label.text = "HIDDEN"
			alert_label.add_theme_color_override("font_color", Color(0.54, 0.96, 0.72))

func set_detected(is_detected: bool) -> void:
	set_alert_state("Chased" if is_detected else "Hidden")
