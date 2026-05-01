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
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := Label.new()
	title.text = "PAUSED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
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
	return button

func show_pause() -> void:
	visible = true
	get_tree().paused = true

func hide_pause() -> void:
	visible = false
	get_tree().paused = false
