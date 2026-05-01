extends Node

signal loot_changed(current: int, required: int)
signal alarm_changed(current: float, maximum: float)
signal objective_changed(text: String)
signal timer_changed(seconds: float)
signal result_changed(result: String)

const SAVE_PATH := "user://bank_robber_save.cfg"

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
	4: {
		"name": "Security Core",
		"description": "Hack the control room, cross laser grids, and rob the guarded core vault.",
		"scene": "res://scenes/levels/Level4.tscn",
	},
	5: {
		"name": "Penthouse Vault",
		"description": "A final heist route with layered cameras, lasers, patrols, and a long escape.",
		"scene": "res://scenes/levels/Level5.tscn",
	},
}

const PAR_TIMES := {
	1: 55.0,
	2: 75.0,
	3: 85.0,
	4: 105.0,
	5: 130.0,
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
var final_score: int = 0
var final_rank: String = ""
var final_badges := PackedStringArray()
var best_scores: Dictionary = {}
var best_ranks: Dictionary = {}

func _ready() -> void:
	_ensure_default_input_actions()
	_load_progress()

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
	final_score = 0
	final_rank = ""
	final_badges = PackedStringArray()
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

func get_run_score() -> int:
	return final_score

func get_run_rank() -> String:
	return final_rank

func get_run_badges_text() -> String:
	return ", ".join(final_badges)

func get_best_score(level_number: int) -> int:
	return int(best_scores.get(level_number, 0))

func get_best_rank(level_number: int) -> String:
	return str(best_ranks.get(level_number, ""))

func has_next_level() -> bool:
	return selected_level < get_level_numbers().back()

func get_next_level_number() -> int:
	return mini(selected_level + 1, get_level_numbers().back())

func win_level() -> void:
	if not run_active or result != "":
		return
	_calculate_final_score()
	_calculate_final_badges()
	result = "win"
	run_active = false
	unlocked_levels = mini(maxi(unlocked_levels, selected_level + 1), LEVELS.size())
	_record_best_run()
	_save_progress()
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
	final_score = 0
	final_rank = ""
	final_badges = PackedStringArray()
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

func _calculate_final_score() -> void:
	var par_time := float(PAR_TIMES.get(selected_level, 100.0))
	var time_efficiency := clampf(1.0 - (run_timer / maxf(par_time * 2.0, 1.0)), 0.0, 1.0)
	var alarm_efficiency := clampf(1.0 - (alarm / maxf(alarm_max, 1.0)), 0.0, 1.0)
	var loot_efficiency := 1.0
	if loot_required > 0:
		loot_efficiency = clampf(float(loot_collected) / float(loot_required), 0.0, 1.0)
	var efficiency := loot_efficiency * 0.25 + time_efficiency * 0.35 + alarm_efficiency * 0.4
	final_score = maxi(0, loot_collected + selected_level * 175 + int(round(time_efficiency * 600.0)) + int(round(alarm_efficiency * 750.0)))
	final_rank = _rank_for_efficiency(efficiency)

func _rank_for_efficiency(efficiency: float) -> String:
	if efficiency >= 0.92:
		return "S"
	if efficiency >= 0.8:
		return "A"
	if efficiency >= 0.66:
		return "B"
	if efficiency >= 0.5:
		return "C"
	return "D"

func _calculate_final_badges() -> void:
	final_badges = PackedStringArray()
	if alarm <= 1.0:
		final_badges.append("Ghost")
	var par_time := float(PAR_TIMES.get(selected_level, 100.0))
	if run_timer <= par_time:
		final_badges.append("Fast")
	if final_rank == "S":
		final_badges.append("Mastermind")
	if can_escape():
		final_badges.append("Clean Haul")

func _record_best_run() -> void:
	var previous_score := get_best_score(selected_level)
	if final_score > previous_score:
		best_scores[selected_level] = final_score
		best_ranks[selected_level] = final_rank

func _load_progress() -> void:
	var config := ConfigFile.new()
	var error := config.load(SAVE_PATH)
	if error != OK:
		return
	unlocked_levels = mini(maxi(int(config.get_value("progress", "unlocked_levels", unlocked_levels)), 1), LEVELS.size())
	best_scores.clear()
	best_ranks.clear()
	for level_number in get_level_numbers():
		var key := str(level_number)
		var score := int(config.get_value("best_scores", key, 0))
		if score <= 0:
			continue
		best_scores[level_number] = score
		best_ranks[level_number] = str(config.get_value("best_ranks", key, ""))

func _save_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "unlocked_levels", unlocked_levels)
	for level_number in get_level_numbers():
		var score := get_best_score(level_number)
		if score <= 0:
			continue
		var key := str(level_number)
		config.set_value("best_scores", key, score)
		config.set_value("best_ranks", key, get_best_rank(level_number))
	config.save(SAVE_PATH)
