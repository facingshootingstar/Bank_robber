extends Control

const MAIN_MENU_SCENE := "res://scenes/ui/MainMenu.tscn"

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.035, 0.045, 0.06)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(590, 560)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.024, 0.03, 0.04, 0.94), Color(0.45, 0.86, 0.68, 0.32), 8))
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := Label.new()
	title.text = "LEVEL SELECT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", Color(0.74, 1.0, 0.78))
	box.add_child(title)

	for level_number in GameState.get_level_numbers():
		var is_unlocked := GameState.is_level_unlocked(level_number)
		box.add_child(_level_button(_slot_text(level_number), is_unlocked, func() -> void:
			_start_level(level_number)
		))

	var back_button := Button.new()
	back_button.text = "Back"
	back_button.custom_minimum_size = Vector2(280, 42)
	_apply_button_style(back_button)
	back_button.pressed.connect(_on_back_pressed)
	box.add_child(back_button)

func _level_button(text: String, enabled: bool, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(440, 58)
	button.disabled = not enabled
	_apply_button_style(button)
	if enabled:
		button.pressed.connect(callback)
	return button

func _apply_button_style(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _button_style(Color(0.11, 0.15, 0.17, 1.0), Color(0.46, 0.9, 0.68, 0.24)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.15, 0.21, 0.23, 1.0), Color(0.62, 1.0, 0.78, 0.46)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.075, 0.1, 0.11, 1.0), Color(0.44, 0.86, 0.64, 0.6)))
	button.add_theme_stylebox_override("disabled", _button_style(Color(0.065, 0.07, 0.078, 1.0), Color(0.2, 0.24, 0.25, 0.55)))
	button.add_theme_color_override("font_color", Color(0.9, 0.96, 0.92))
	button.add_theme_color_override("font_disabled_color", Color(0.42, 0.48, 0.48))

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

func _slot_text(level_number: int) -> String:
	var prefix := "Level " + str(level_number) + " - " + GameState.get_level_name(level_number)
	if GameState.is_level_unlocked(level_number):
		var best := ""
		if GameState.get_best_score(level_number) > 0:
			best = " | Best " + GameState.get_best_rank(level_number) + " " + str(GameState.get_best_score(level_number))
		return prefix + best + "\n" + GameState.get_level_description(level_number)
	return prefix + " (Locked)"

func _start_level(level_number: int) -> void:
	if not GameState.is_level_unlocked(level_number):
		return
	SoundManager.play_ui_click()
	GameState.start_level(level_number)
	get_tree().change_scene_to_file(GameState.get_level_path(level_number))

func _on_back_pressed() -> void:
	SoundManager.play_ui_click()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
