extends CanvasLayer

var loot_label: Label
var alarm_bar: ProgressBar
var objective_label: Label
var timer_label: Label
var prompt_label: Label
var alert_label: Label
var system_label: Label
var _system_message_timer := 0.0

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

func _process(delta: float) -> void:
	if _system_message_timer <= 0.0:
		return
	_system_message_timer = maxf(_system_message_timer - delta, 0.0)
	if _system_message_timer <= 0.0:
		system_label.text = ""
		system_label.visible = false

func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var top := PanelContainer.new()
	top.offset_left = 16
	top.offset_top = 12
	top.offset_right = 944
	top.offset_bottom = 74
	top.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.032, 0.04, 0.86), Color(0.95, 0.65, 0.28, 0.34), 6))
	root.add_child(top)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	top.add_child(row)

	objective_label = Label.new()
	objective_label.custom_minimum_size = Vector2(280, 32)
	objective_label.add_theme_color_override("font_color", Color(0.9, 0.94, 0.9))
	row.add_child(objective_label)

	loot_label = Label.new()
	loot_label.custom_minimum_size = Vector2(145, 32)
	loot_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.32))
	row.add_child(loot_label)

	alarm_bar = ProgressBar.new()
	alarm_bar.custom_minimum_size = Vector2(200, 26)
	alarm_bar.show_percentage = false
	alarm_bar.add_theme_stylebox_override("background", _panel_style(Color(0.04, 0.045, 0.052, 1.0), Color(0.0, 0.0, 0.0, 0.3), 4))
	alarm_bar.add_theme_stylebox_override("fill", _panel_style(Color(0.95, 0.12, 0.09, 0.96), Color(1.0, 0.66, 0.35, 0.18), 4))
	row.add_child(alarm_bar)

	alert_label = Label.new()
	alert_label.text = "HIDDEN"
	alert_label.custom_minimum_size = Vector2(140, 32)
	alert_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	alert_label.add_theme_font_size_override("font_size", 14)
	row.add_child(alert_label)

	timer_label = Label.new()
	timer_label.custom_minimum_size = Vector2(84, 32)
	timer_label.add_theme_color_override("font_color", Color(0.82, 0.9, 1.0))
	row.add_child(timer_label)

	prompt_label = Label.new()
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.add_theme_font_size_override("font_size", 20)
	prompt_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.62))
	prompt_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	prompt_label.add_theme_constant_override("shadow_offset_x", 2)
	prompt_label.add_theme_constant_override("shadow_offset_y", 2)
	prompt_label.offset_left = 0
	prompt_label.offset_top = 548
	prompt_label.offset_right = 960
	prompt_label.offset_bottom = 600
	root.add_child(prompt_label)

	system_label = Label.new()
	system_label.visible = false
	system_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	system_label.add_theme_font_size_override("font_size", 16)
	system_label.add_theme_color_override("font_color", Color(0.58, 0.95, 1.0))
	system_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	system_label.add_theme_constant_override("shadow_offset_x", 2)
	system_label.add_theme_constant_override("shadow_offset_y", 2)
	system_label.offset_left = 500
	system_label.offset_top = 82
	system_label.offset_right = 940
	system_label.offset_bottom = 116
	root.add_child(system_label)

func _on_loot_changed(current: int, required: int) -> void:
	loot_label.text = "Loot $" + str(current) + " / $" + str(required)

func _on_alarm_changed(current: float, maximum: float) -> void:
	alarm_bar.max_value = maximum
	alarm_bar.value = current
	var ratio := 0.0
	if maximum > 0.0:
		ratio = clampf(current / maximum, 0.0, 1.0)
	alarm_bar.add_theme_stylebox_override("fill", _panel_style(_alarm_color(ratio), Color(1.0, 0.66, 0.35, 0.18), 4))

func _on_objective_changed(text: String) -> void:
	objective_label.text = text

func _on_timer_changed(seconds: float) -> void:
	var whole := int(seconds)
	timer_label.text = "%02d:%02d" % [int(whole / 60), whole % 60]

func show_prompt(text: String) -> void:
	prompt_label.text = text

func show_system_message(text: String, seconds: float = 1.4) -> void:
	system_label.text = text
	system_label.visible = text != ""
	_system_message_timer = maxf(seconds, 0.0)

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

func _panel_style(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	return style

func _alarm_color(ratio: float) -> Color:
	if ratio >= 0.72:
		return Color(0.95, 0.12, 0.09, 0.96)
	if ratio >= 0.38:
		return Color(1.0, 0.68, 0.18, 0.96)
	return Color(0.24, 0.86, 0.54, 0.94)
