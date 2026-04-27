extends Node

# Persists campaign progress to user://optaktics_save.json
# Format: { version, current_arc, current_battle, characters, talent_points, completed_battles }

const SAVE_PATH    := "user://optaktics_save.json"
const SAVE_VERSION := 1

# XP needed to go from level N to N+1 = 50 * N
# Totals: L5 = 500 xp, L10 = 2250 xp, L20 = 9500 xp
const STRAW_HAT_IDS := ["luffy", "zoro", "nami", "usopp", "sanji"]

var _data: Dictionary = {}

# ── Boot ──────────────────────────────────────────────────────────────────────

func _ready() -> void:
	load_game()

# ── Public read ───────────────────────────────────────────────────────────────

func get_current_arc() -> int:
	return int(_data.get("current_arc", 0))

func get_current_battle() -> int:
	return int(_data.get("current_battle", 0))

func get_talent_points() -> int:
	return int(_data.get("talent_points", 0))

func get_character_level(char_id: String) -> int:
	return int(_char(char_id).get("level", 1))

func get_character_exp(char_id: String) -> int:
	return int(_char(char_id).get("exp", 0))

func get_character_skill_nodes(char_id: String) -> Array:
	return _char(char_id).get("skill_nodes", [])

func has_completed(battle_id: String) -> bool:
	return battle_id in _data.get("completed_battles", [])

# ── Public write ──────────────────────────────────────────────────────────────

func advance_to_next_battle(arc_battle_count: int) -> void:
	var arc   := get_current_arc()
	var bat   := get_current_battle() + 1
	if bat >= arc_battle_count:
		arc  += 1
		bat   = 0
		_data["talent_points"] = get_talent_points() + 1  # 1 point per arc cleared
	_data["current_arc"]    = arc
	_data["current_battle"] = bat
	save_game()

func mark_battle_complete(battle_id: String) -> void:
	var done: Array = _data.get("completed_battles", [])
	if battle_id not in done:
		done.append(battle_id)
	_data["completed_battles"] = done
	save_game()

# Awards exp to all listed character ids; handles level-ups; saves.
# Returns a Dictionary { char_id -> levels_gained } for UI display.
func award_exp(char_ids: Array[String], amount_each: int) -> Dictionary:
	var result := {}
	for id in char_ids:
		var gained := _add_exp(id, amount_each)
		result[id] = gained
	save_game()
	return result

func unlock_skill_node(char_id: String, node_id: String) -> void:
	var nodes: Array = _char(char_id).get("skill_nodes", [])
	if node_id not in nodes:
		nodes.append(node_id)
	_data["characters"][char_id]["skill_nodes"] = nodes
	var pts := get_talent_points()
	if pts > 0:
		_data["talent_points"] = pts - 1
	save_game()

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	_new_game()

# ── IO ────────────────────────────────────────────────────────────────────────

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: cannot write " + SAVE_PATH + " — " + str(FileAccess.get_open_error()))
		return
	file.store_string(JSON.stringify(_data, "\t"))
	file.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_new_game()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		_new_game()
		return
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed == null or typeof(parsed) != TYPE_DICTIONARY:
		push_warning("SaveManager: corrupted save, starting new game")
		_new_game()
		return
	_data = parsed

# ── Internal ──────────────────────────────────────────────────────────────────

func _new_game() -> void:
	_data = {
		"version":            SAVE_VERSION,
		"current_arc":        0,
		"current_battle":     0,
		"talent_points":      0,
		"completed_battles":  [],
		"characters":         {},
	}
	for id in STRAW_HAT_IDS:
		_data["characters"][id] = { "level": 1, "exp": 0, "skill_nodes": [] }
	save_game()

func _char(id: String) -> Dictionary:
	if "characters" not in _data:
		_data["characters"] = {}
	if id not in _data["characters"]:
		_data["characters"][id] = { "level": 1, "exp": 0, "skill_nodes": [] }
	return _data["characters"][id]

# Returns number of levels gained
func _add_exp(char_id: String, amount: int) -> int:
	var c     := _char(char_id)
	var level := int(c.get("level", 1))
	var exp   := int(c.get("exp",   0)) + amount
	var gained := 0
	while level < 100:
		var threshold := 50 * level   # XP needed for next level
		if exp < threshold:
			break
		exp   -= threshold
		level += 1
		gained += 1
	c["level"] = level
	c["exp"]   = exp
	_data["characters"][char_id] = c
	return gained
