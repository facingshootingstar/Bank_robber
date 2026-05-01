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
	panel.custom_minimum_size = Vector2(420, 360)
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	var title := Label.new()
	title.text = "BANK ROBBER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 46)
	box.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Sneak in. Steal the vault. Escape clean."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(subtitle)

	box.add_child(_spacer(18))

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
	return button

func _spacer(height: float) -> Control:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(1, height)
	return spacer

func _on_play_pressed() -> void:
	GameState.start_level(1)
	get_tree().change_scene_to_file(GameState.get_level_path(1))

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_SELECT_SCENE)

func _on_quit_pressed() -> void:
	get_tree().quit()
