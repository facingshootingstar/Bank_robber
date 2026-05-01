extends CanvasLayer

signal retry_requested
signal next_requested
signal menu_requested

var title_label: Label
var detail_label: Label
var next_button: Button

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_build_ui()

func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.72)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(390, 310)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.032, 0.045, 0.96), Color(0.95, 0.65, 0.28, 0.42), 8))
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 34)
	title_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.36))
	box.add_child(title_label)

	detail_label = Label.new()
	detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_label.custom_minimum_size = Vector2(320, 72)
	detail_label.add_theme_color_override("font_color", Color(0.86, 0.92, 0.92))
	box.add_child(detail_label)

	var retry := _button("Retry")
	retry.pressed.connect(func() -> void: retry_requested.emit())
	box.add_child(retry)

	next_button = _button("Next Level")
	next_button.pressed.connect(func() -> void: next_requested.emit())
	box.add_child(next_button)

	var menu := _button("Main Menu")
	menu.pressed.connect(func() -> void: menu_requested.emit())
	box.add_child(menu)

func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(250, 42)
	button.add_theme_stylebox_override("normal", _button_style(Color(0.11, 0.15, 0.17, 1.0), Color(0.95, 0.65, 0.28, 0.25)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.15, 0.21, 0.23, 1.0), Color(1.0, 0.78, 0.36, 0.5)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.07, 0.1, 0.11, 1.0), Color(1.0, 0.58, 0.22, 0.6)))
	button.add_theme_stylebox_override("disabled", _button_style(Color(0.06, 0.07, 0.08, 1.0), Color(0.2, 0.22, 0.24, 0.55)))
	button.add_theme_color_override("font_color", Color(0.92, 0.96, 0.96))
	button.add_theme_color_override("font_disabled_color", Color(0.42, 0.48, 0.48))
	return button

func _panel_style(fill: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	return style

func _button_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := _panel_style(fill, border, 6)
	style.set_border_width_all(2)
	return style

func show_result(won: bool) -> void:
	visible = true
	if won:
		title_label.text = "HEIST COMPLETE"
		detail_label.text = "Rank " + GameState.get_run_rank() + "  |  Score " + str(GameState.get_run_score()) + "\n" + _run_summary() + "\nBadges: " + GameState.get_run_badges_text()
		next_button.text = "Next Level" if GameState.has_next_level() else "Level Select"
		next_button.disabled = false
	else:
		title_label.text = "ALARM TRIPPED"
		detail_label.text = "The bank locked down before you escaped.\n" + _run_summary()
		next_button.text = "Next Level Locked"
		next_button.disabled = true

func _run_summary() -> String:
	return "Loot $" + str(GameState.loot_collected) + " / $" + str(GameState.loot_required) + "  |  Time " + _format_time(GameState.run_timer) + "  |  Alarm " + str(int(round(GameState.alarm))) + "%"

func _format_time(seconds: float) -> String:
	var whole := int(seconds)
	return "%02d:%02d" % [int(whole / 60), whole % 60]
