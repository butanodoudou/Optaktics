extends Node

# Persists campaign progress to user://optaktics_save.json
# Format: { version, current_arc, current_battle, characters, talent_points, completed_battles }
# Each character: { level, exp, skill_nodes, stat_bonuses }
# stat_bonuses accumulates probabilistic growth from level-ups and is added to base stats.

const SAVE_PATH    := "user://optaktics_save.json"
const SAVE_VERSION := 1

const STRAW_HAT_IDS := ["luffy", "zoro", "nami", "usopp", "sanji"]

# XP threshold to go from level N to N+1 = ceil(80 * N^1.5)
# Approx totals: L5 ≈ 6680, L10 ≈ 38670, L20 ≈ 218000

# Starter stat bonuses for Luffy and Zoro (L3 at new game = 2 pre-rolled levels).
# Values are expected-value approximations of 2 probabilistic rolls each.
const _LUFFY_START_BONUS := {"pv": 1, "for": 1, "tec": 0, "def": 1, "res": 0, "agi": 1, "vol": 1}
const _ZORO_START_BONUS  := {"pv": 1, "for": 2, "tec": 1, "def": 1, "res": 0, "agi": 1, "vol": 0}

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

func get_character_stat_bonuses(char_id: String) -> Dictionary:
	return _char(char_id).get("stat_bonuses", _zero_bonuses())

func has_completed(battle_id: String) -> bool:
	return battle_id in _data.get("completed_battles", [])

func is_straw_hat(char_id: String) -> bool:
	return char_id in STRAW_HAT_IDS

# ── Public write ──────────────────────────────────────────────────────────────

func advance_to_next_battle(arc_battle_count: int) -> void:
	var arc   := get_current_arc()
	var bat   := get_current_battle() + 1
	if bat >= arc_battle_count:
		arc  += 1
		bat   = 0
		_data["talent_points"] = get_talent_points() + 1
	_data["current_arc"]    = arc
	_data["current_battle"] = bat
	save_game()

func mark_battle_complete(battle_id: String) -> void:
	var done: Array = _data.get("completed_battles", [])
	if battle_id not in done:
		done.append(battle_id)
	_data["completed_battles"] = done
	save_game()

# Awards exp to characters; char_amounts = { char_id -> xp_amount }.
# Returns { char_id -> levels_gained } for caller to apply growth rolls.
func award_exp(char_amounts: Dictionary) -> Dictionary:
	var result := {}
	for id in char_amounts:
		var gained := _add_exp(id, int(char_amounts[id]))
		result[id] = gained
	save_game()
	return result

# Applies probabilistic growth rolls for `levels` level-ups.
# growth_rates: { "pv": 70, "for": 65, ... }  (0–100 integer %)
# Returns { stat -> gains } for debug display.
func apply_growth_rolls(char_id: String, growth_rates: Dictionary, levels: int) -> Dictionary:
	if levels <= 0:
		return {}
	var c     := _char(char_id)
	var bonus: Dictionary = c.get("stat_bonuses", _zero_bonuses()).duplicate()
	var gains := _zero_bonuses()
	for _i in range(levels):
		for stat in gains:
			var rate: int = growth_rates.get(stat, 0)
			if randi() % 100 < rate:
				bonus[stat] = bonus.get(stat, 0) + 1
				gains[stat] += 1
	c["stat_bonuses"] = bonus
	_data["characters"][char_id] = c
	save_game()
	return gains

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
		_data["characters"][id] = {
			"level": 1, "exp": 0, "skill_nodes": [], "stat_bonuses": _zero_bonuses()
		}
	# Luffy and Zoro start at L3 (already trained before Arc 01)
	_data["characters"]["luffy"]["level"] = 3
	_data["characters"]["luffy"]["stat_bonuses"] = _LUFFY_START_BONUS.duplicate()
	_data["characters"]["zoro"]["level"] = 3
	_data["characters"]["zoro"]["stat_bonuses"] = _ZORO_START_BONUS.duplicate()
	save_game()

func _char(id: String) -> Dictionary:
	if "characters" not in _data:
		_data["characters"] = {}
	if id not in _data["characters"]:
		_data["characters"][id] = {
			"level": 1, "exp": 0, "skill_nodes": [], "stat_bonuses": _zero_bonuses()
		}
	# Migrate old saves that lack stat_bonuses
	var c: Dictionary = _data["characters"][id]
	if "stat_bonuses" not in c:
		c["stat_bonuses"] = _zero_bonuses()
		_data["characters"][id] = c
	return c

# Returns number of levels gained
func _add_exp(char_id: String, amount: int) -> int:
	var c      := _char(char_id)
	var level  := int(c.get("level", 1))
	var exp    := int(c.get("exp",   0)) + amount
	var gained := 0
	while level < 100:
		var threshold := ceili(80.0 * pow(level, 1.5))
		if exp < threshold:
			break
		exp   -= threshold
		level += 1
		gained += 1
	c["level"] = level
	c["exp"]   = exp
	_data["characters"][char_id] = c
	return gained

func _zero_bonuses() -> Dictionary:
	return {"pv": 0, "for": 0, "tec": 0, "def": 0, "res": 0, "agi": 0, "vol": 0}
