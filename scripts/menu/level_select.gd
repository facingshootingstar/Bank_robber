extends Control

const MAIN_MENU_SCENE := "res://scenes/ui/MainMenu.tscn"
const LEVEL_ONE_SCENE := "res://scenes/levels/Level1.tscn"

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
	panel.custom_minimum_size = Vector2(460, 420)
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	var title := Label.new()
	title.text = "LEVEL SELECT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	box.add_child(_level_button("Level 1 - First National Bank", true, _on_level_1_pressed))
	box.add_child(_level_button(_slot_text(2), false, Callable()))
	box.add_child(_level_button(_slot_text(3), false, Callable()))

	var back_button := Button.new()
	back_button.text = "Back"
	back_button.custom_minimum_size = Vector2(280, 42)
	back_button.pressed.connect(_on_back_pressed)
	box.add_child(back_button)

func _level_button(text: String, enabled: bool, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(340, 48)
	button.disabled = not enabled
	if enabled:
		button.pressed.connect(callback)
	return button

func _slot_text(level_number: int) -> String:
	if GameState.unlocked_levels >= level_number:
		return "Level " + str(level_number) + " - Planned"
	return "Level " + str(level_number) + " - Locked"

func _on_level_1_pressed() -> void:
	GameState.start_level(1)
	get_tree().change_scene_to_file(LEVEL_ONE_SCENE)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
