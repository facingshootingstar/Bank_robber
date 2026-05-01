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
	center.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 34)
	box.add_child(title_label)

	detail_label = Label.new()
	detail_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_label.custom_minimum_size = Vector2(320, 72)
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
	return button

func show_result(won: bool) -> void:
	visible = true
	if won:
		title_label.text = "HEIST COMPLETE"
		detail_label.text = "Rank " + GameState.get_run_rank() + "  |  Score " + str(GameState.get_run_score()) + "\n" + _run_summary()
		next_button.text = "Level Select"
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
