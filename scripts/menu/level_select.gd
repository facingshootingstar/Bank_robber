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
	panel.custom_minimum_size = Vector2(560, 470)
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := Label.new()
	title.text = "LEVEL SELECT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	for level_number in GameState.get_level_numbers():
		var is_unlocked := GameState.is_level_unlocked(level_number)
		box.add_child(_level_button(_slot_text(level_number), is_unlocked, func() -> void:
			_start_level(level_number)
		))

	var back_button := Button.new()
	back_button.text = "Back"
	back_button.custom_minimum_size = Vector2(280, 42)
	back_button.pressed.connect(_on_back_pressed)
	box.add_child(back_button)

func _level_button(text: String, enabled: bool, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(440, 58)
	button.disabled = not enabled
	if enabled:
		button.pressed.connect(callback)
	return button

func _slot_text(level_number: int) -> String:
	var prefix := "Level " + str(level_number) + " - " + GameState.get_level_name(level_number)
	if GameState.is_level_unlocked(level_number):
		return prefix + "\n" + GameState.get_level_description(level_number)
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
