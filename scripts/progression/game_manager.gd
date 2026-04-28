extends Node

# Central campaign controller — autoload.
# Owns the ordered battle list, injects saved character levels into configs,
# and delegates save I/O to SaveManager.

# ── Arc / battle registry ─────────────────────────────────────────────────────
# Each entry: { "label": String, "battles": Array[Callable] }
# Callables return a BattleConfig (lazily evaluated to avoid loading everything at once).

var _arcs: Array = []

func _ready() -> void:
	_build_arcs()
	if OS.is_debug_build():
		BalanceCalculator.report_all(_arcs)

func _build_arcs() -> void:
	_arcs = [
		{
			"label": "Romance Dawn",
			"battles": [
				Arc01RomanceDawn.battle_01_tutorial,
				Arc01RomanceDawn.battle_02_zoro_rescue,
			]
		},
		{
			"label": "Orange Town",
			"battles": [
				Arc02OrangeTown.battle_01_town_entrance,
				Arc02OrangeTown.battle_02_buggy_showdown,
			]
		},
		{
			"label": "Syrup Village",
			"battles": [
				Arc03SyrupVillage.battle_01_hillside_ambush,
				Arc03SyrupVillage.battle_02_kuro_final,
			]
		},
		{
			"label": "Baratie",
			"battles": [
				Arc04Baratie.battle_01_sea_restaurant,
				Arc04Baratie.battle_02_krieg_boss,
			]
		},
		{
			"label": "Arlong Park",
			"battles": [
				Arc05ArlongPark.battle_01_front_gate,
				Arc05ArlongPark.battle_02_arlong_final,
			]
		},
		{
			"label": "Loguetown",
			"battles": [
				Arc06Loguetown.battle_01_smoker_chase,
			]
		},
	]


# ── Public API ────────────────────────────────────────────────────────────────

# Returns the BattleConfig for the current position, with saved player levels injected.
# Returns null if the campaign is complete.
func get_current_battle() -> BattleConfig:
	var arc_idx := SaveManager.get_current_arc()
	var bat_idx := SaveManager.get_current_battle()

	if arc_idx >= _arcs.size():
		return null   # campaign complete

	var arc: Dictionary   = _arcs[arc_idx]
	var battles: Array    = arc["battles"]

	if bat_idx >= battles.size():
		return null

	var config: BattleConfig = battles[bat_idx].call()
	_inject_saved_levels(config)
	return config

# Called by the "Continuer" button after a victory.
func advance_to_next_battle() -> void:
	var arc_idx := SaveManager.get_current_arc()
	var bat_count: int = _arcs[arc_idx]["battles"].size() if arc_idx < _arcs.size() else 1
	SaveManager.advance_to_next_battle(bat_count)
	if is_campaign_complete():
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/battle/battle_scene.tscn")

# How many battles are in the current arc (used by SaveManager.advance_to_next_battle).
func current_arc_battle_count() -> int:
	var arc_idx := SaveManager.get_current_arc()
	if arc_idx >= _arcs.size():
		return 1
	return _arcs[arc_idx]["battles"].size()

func current_arc_label() -> String:
	var arc_idx := SaveManager.get_current_arc()
	if arc_idx >= _arcs.size():
		return "Fin"
	return _arcs[arc_idx]["label"]

func is_campaign_complete() -> bool:
	return SaveManager.get_current_arc() >= _arcs.size()

# ── Internal ──────────────────────────────────────────────────────────────────

# Overwrites the level of PLAYER units in the config with their saved level,
# so the party grows naturally across the campaign.
# Enemy levels stay as designed for balance.
func _inject_saved_levels(config: BattleConfig) -> void:
	for placement in config.unit_placements:
		if not placement.is_player:
			continue
		var char_id: String = placement.unit_data.id
		if char_id in SaveManager.STRAW_HAT_IDS:
			placement.level = SaveManager.get_character_level(char_id)
