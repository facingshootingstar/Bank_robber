extends CanvasLayer

signal resume_requested
signal restart_requested
signal menu_requested

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_build_ui()

func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.62)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(320, 270)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.032, 0.045, 0.95), Color(0.95, 0.65, 0.28, 0.42), 8))
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := Label.new()
	title.text = "PAUSED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.36))
	box.add_child(title)

	var resume := _button("Resume")
	resume.pressed.connect(func() -> void: resume_requested.emit())
	box.add_child(resume)

	var restart := _button("Restart")
	restart.pressed.connect(func() -> void: restart_requested.emit())
	box.add_child(restart)

	var menu := _button("Main Menu")
	menu.pressed.connect(func() -> void: menu_requested.emit())
	box.add_child(menu)

func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(220, 42)
	button.add_theme_stylebox_override("normal", _button_style(Color(0.11, 0.15, 0.17, 1.0), Color(0.95, 0.65, 0.28, 0.25)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.15, 0.21, 0.23, 1.0), Color(1.0, 0.78, 0.36, 0.5)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.07, 0.1, 0.11, 1.0), Color(1.0, 0.58, 0.22, 0.6)))
	button.add_theme_color_override("font_color", Color(0.92, 0.96, 0.96))
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

func show_pause() -> void:
	visible = true
	get_tree().paused = true

func hide_pause() -> void:
	visible = false
	get_tree().paused = false
