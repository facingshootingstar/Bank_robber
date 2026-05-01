extends Control

const LEVEL_SELECT_SCENE := "res://scenes/ui/LevelSelect.tscn"

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.045, 0.055, 0.075)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(420, 410)
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.025, 0.032, 0.045, 0.94), Color(0.95, 0.65, 0.28, 0.38), 8))
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	var title := Label.new()
	title.text = "BANK ROBBER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 46)
	title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.36))
	box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Sneak in. Steal the vault. Escape clean."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color(0.78, 0.86, 0.9))
	box.add_child(subtitle)

	box.add_child(_spacer(18))

	var continue_button := _button("Continue Heist - Level " + str(GameState.unlocked_levels))
	continue_button.pressed.connect(_on_continue_pressed)
	box.add_child(continue_button)

	var play_button := _button("Play Level 1")
	play_button.pressed.connect(_on_play_pressed)
	box.add_child(play_button)

	var level_button := _button("Level Select")
	level_button.pressed.connect(_on_level_select_pressed)
	box.add_child(level_button)

	var quit_button := _button("Quit")
	quit_button.pressed.connect(_on_quit_pressed)
	box.add_child(quit_button)

func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(260, 44)
	button.add_theme_stylebox_override("normal", _button_style(Color(0.12, 0.16, 0.18, 1.0), Color(0.9, 0.62, 0.24, 0.28)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.16, 0.22, 0.24, 1.0), Color(1.0, 0.78, 0.32, 0.52)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.08, 0.11, 0.12, 1.0), Color(1.0, 0.58, 0.22, 0.62)))
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

func _spacer(height: float) -> Control:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(1, height)
	return spacer

func _on_play_pressed() -> void:
	SoundManager.play_ui_click()
	GameState.start_level(1)
	get_tree().change_scene_to_file(GameState.get_level_path(1))

func _on_continue_pressed() -> void:
	SoundManager.play_ui_click()
	var level_number := mini(maxi(GameState.unlocked_levels, 1), GameState.get_level_numbers().back())
	GameState.start_level(level_number)
	get_tree().change_scene_to_file(GameState.get_level_path(level_number))

func _on_level_select_pressed() -> void:
	SoundManager.play_ui_click()
	get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)

func _on_quit_pressed() -> void:
	SoundManager.play_ui_click()
	get_tree().quit()
