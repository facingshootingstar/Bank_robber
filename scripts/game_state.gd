extends Node

signal loot_changed(current: int, required: int)
signal alarm_changed(current: float, maximum: float)
signal objective_changed(text: String)
signal timer_changed(seconds: float)
signal result_changed(result: String)

const LEVELS := {
	1: {
		"name": "Front Lobby",
		"description": "Slip through the front lobby, learn the patrol timing, grab quick cash, and reach the van.",
		"scene": "res://scenes/levels/Level1.tscn",
	},
	2: {
		"name": "Vault Wing",
		"description": "Work through offices and camera sweeps to crack the deeper vault.",
		"scene": "res://scenes/levels/Level2.tscn",
	},
	3: {
		"name": "Back Alley Escape",
		"description": "Escape through storage and garage corridors after the robbery.",
		"scene": "res://scenes/levels/Level3.tscn",
	},
}

var selected_level: int = 1
var unlocked_levels: int = 1
var loot_collected: int = 0
var loot_required: int = 0
var alarm: float = 0.0
var alarm_max: float = 100.0
var run_timer: float = 0.0
var run_active: bool = false
var result: String = ""

func _ready() -> void:
	_ensure_default_input_actions()

func _ensure_default_input_actions() -> void:
	_add_keys("move_left", [KEY_A, KEY_LEFT])
	_add_keys("move_right", [KEY_D, KEY_RIGHT])
	_add_keys("move_up", [KEY_W, KEY_UP])
	_add_keys("move_down", [KEY_S, KEY_DOWN])
	_add_keys("interact", [KEY_E])
	_add_keys("pause_game", [KEY_ESCAPE])

func _add_keys(action: String, keys: Array[int]) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for keycode in keys:
		var already_bound := false
		for event in InputMap.action_get_events(action):
			if event is InputEventKey and event.physical_keycode == keycode:
				already_bound = true
				break
		if already_bound:
			continue
		var key := InputEventKey.new()
		key.physical_keycode = keycode
		InputMap.action_add_event(action, key)

func start_level(level_number: int, required_loot: int = 0) -> void:
	selected_level = level_number
	loot_collected = 0
	loot_required = required_loot
	alarm = 0.0
	run_timer = 0.0
	run_active = true
	result = ""
	loot_changed.emit(loot_collected, loot_required)
	alarm_changed.emit(alarm, alarm_max)
	timer_changed.emit(run_timer)
	objective_changed.emit("Find the cash.")
	result_changed.emit(result)

func get_level_numbers() -> Array:
	var numbers := LEVELS.keys()
	numbers.sort()
	return numbers

func get_level_data(level_number: int) -> Dictionary:
	return LEVELS.get(level_number, LEVELS[1])

func get_level_path(level_number: int) -> String:
	return str(get_level_data(level_number).get("scene", LEVELS[1]["scene"]))

func get_level_name(level_number: int) -> String:
	return str(get_level_data(level_number).get("name", "Level " + str(level_number)))

func get_level_description(level_number: int) -> String:
	return str(get_level_data(level_number).get("description", ""))

func is_level_unlocked(level_number: int) -> bool:
	return level_number <= unlocked_levels

func set_loot_required(required: int) -> void:
	loot_required = max(required, 0)
	loot_changed.emit(loot_collected, loot_required)
	_emit_objective()

func add_loot(amount: int) -> void:
	if not run_active:
		return
	loot_collected = min(loot_collected + amount, max(loot_required, loot_collected + amount))
	loot_changed.emit(loot_collected, loot_required)
	_emit_objective()

func add_alarm(amount: float) -> void:
	if not run_active or result != "":
		return
	alarm = clampf(alarm + amount, 0.0, alarm_max)
	alarm_changed.emit(alarm, alarm_max)
	if alarm >= alarm_max:
		lose_level()

func decay_alarm(amount: float) -> void:
	if not run_active or result != "":
		return
	var new_alarm := clampf(alarm - amount, 0.0, alarm_max)
	if not is_equal_approx(new_alarm, alarm):
		alarm = new_alarm
		alarm_changed.emit(alarm, alarm_max)

func tick_timer(delta: float) -> void:
	if not run_active or result != "":
		return
	run_timer += delta
	timer_changed.emit(run_timer)

func can_escape() -> bool:
	return loot_required > 0 and loot_collected >= loot_required

func win_level() -> void:
	if not run_active or result != "":
		return
	result = "win"
	run_active = false
	unlocked_levels = mini(maxi(unlocked_levels, selected_level + 1), LEVELS.size())
	objective_changed.emit("Escaped with the money.")
	result_changed.emit(result)

func lose_level() -> void:
	if not run_active or result != "":
		return
	result = "lose"
	run_active = false
	objective_changed.emit("The alarm is blown.")
	result_changed.emit(result)

func reset_run() -> void:
	loot_collected = 0
	loot_required = 0
	alarm = 0.0
	run_timer = 0.0
	run_active = false
	result = ""
	loot_changed.emit(loot_collected, loot_required)
	alarm_changed.emit(alarm, alarm_max)
	timer_changed.emit(run_timer)
	objective_changed.emit("")
	result_changed.emit(result)

func _emit_objective() -> void:
	if can_escape():
		objective_changed.emit("Return to the getaway van.")
	else:
		var remaining: int = maxi(loot_required - loot_collected, 0)
		objective_changed.emit("Steal $" + str(remaining) + " more.")
