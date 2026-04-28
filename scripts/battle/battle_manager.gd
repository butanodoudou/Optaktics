class_name BattleManager
extends Node

# ── State machine ─────────────────────────────────────────────────────────────
enum State {
	INIT,
	PRE_BATTLE_DIALOGUE,
	CALC_NEXT_TURN,
	PLAYER_CHOOSING,        # action menu open, unit can MOVE and/or ACT
	PLAYER_SELECT_MOVE,
	PLAYER_SELECT_TARGET,
	EXECUTING_ACTION,
	ENEMY_TURN,
	POST_BATTLE_DIALOGUE,
	VICTORY,
	DEFEAT,
}

signal state_changed(s: State)
signal battle_ended(victory: bool)
signal damage_dealt(tile: Vector2i, amount: int, is_heal: bool)
signal unit_turn_started(unit: Unit)
signal ability_used(caster: Unit, ability: AbilityData, targets: Array)

# ── Scene refs ────────────────────────────────────────────────────────────────
@onready var grid:       GridManager = $GridManager
@onready var units_node: Node2D      = $UnitsLayer
@onready var camera:     Camera2D   = $Camera2D
@onready var ui:         BattleUI   = $UILayer/BattleUI
@onready var dialogue:   DialogueBox = $UILayer/DialogueBox

# ── Runtime ───────────────────────────────────────────────────────────────────
var current_state: State = State.INIT
var config: BattleConfig
var all_units: Array[Unit] = []
var active_unit: Unit = null
var pending_ability: AbilityData = null
var move_range_tiles: Array[Vector2i] = []
var target_range_tiles: Array[Vector2i] = []

var turn_manager: TurnManager
var ai: AIController

# ── Boot ──────────────────────────────────────────────────────────────────────

func _ready() -> void:
	turn_manager = TurnManager.new()
	grid.tile_clicked.connect(_on_tile_clicked)
	grid.tile_hovered.connect(_on_tile_hovered)
	ui.action_selected.connect(_on_action_selected)
	ui.ability_selected.connect(_on_ability_selected)
	var cfg := GameManager.get_current_battle()
	if cfg != null:
		call_deferred("start_battle", cfg)
	else:
		push_error("BattleManager: no BattleConfig from GameManager")

func start_battle(p_config: BattleConfig) -> void:
	config = p_config
	grid.setup(config)
	ai = AIController.new(grid)
	_spawn_units()
	_center_camera()
	ui.setup(self)
	_change_state(State.PRE_BATTLE_DIALOGUE)
	_run_dialogue(config.pre_battle_dialogue, func() -> void:
		_change_state(State.CALC_NEXT_TURN)
	)

func _spawn_units() -> void:
	for placement in config.unit_placements:
		var unit := Unit.new()
		units_node.add_child(unit)
		unit.setup(placement.unit_data, placement.start_tile,
				   placement.get("level") if placement.get("level") else 1,
				   placement.is_player)
		unit.unit_died.connect(_on_unit_died)
		turn_manager.register(unit)
		all_units.append(unit)

func _center_camera() -> void:
	camera.position = Vector2(
		config.grid_width  * Unit.TILE_SIZE / 2.0,
		config.grid_height * Unit.TILE_SIZE / 2.0
	)

# ── State machine ─────────────────────────────────────────────────────────────

func _change_state(s: State) -> void:
	current_state = s
	state_changed.emit(s)
	match s:
		State.CALC_NEXT_TURN:   _calc_next_turn()
		State.PLAYER_CHOOSING:  _enter_player_choosing()
		State.ENEMY_TURN:       _run_enemy_turn()

func _calc_next_turn() -> void:
	if _check_battle_end():
		return
	active_unit = turn_manager.get_next_unit()
	if active_unit == null:
		return
	active_unit.reset_turn()
	unit_turn_started.emit(active_unit)
	var order := turn_manager.peek_order()
	order.push_front(active_unit)
	ui.update_turn_order(order)
	ui.show_unit_info(active_unit)

	# Start-of-turn effects
	_process_turn_start(active_unit)

	if active_unit.is_player:
		_change_state(State.PLAYER_CHOOSING)
	else:
		_change_state(State.ENEMY_TURN)

func _process_turn_start(unit: Unit) -> void:
	# STUN: skip turn entirely
	if unit.has_status(StatusManager.Status.STUN):
		unit.begin_turn()
		unit.end_turn()
		unit.set_waiting()
		_change_state(State.CALC_NEXT_TURN)
		return
	unit.begin_turn()
	# Arlong water regen
	if unit.data.water_regen_pv > 0:
		var tile_type := config.get_tile_type(unit.grid_pos.x, unit.grid_pos.y)
		if tile_type == BattleConfig.TileType.WATER:
			unit.water_regen()

# ── Player turn: 2-action system ──────────────────────────────────────────────

func _enter_player_choosing() -> void:
	active_unit.highlight_active()
	grid.clear_overlays()
	ui.show_action_menu(active_unit)

func _on_action_selected(action: String) -> void:
	match action:
		"move":    _enter_move_select()
		"attack":  _start_basic_attack()
		"ability": ui.show_ability_menu(active_unit)
		"wait":    _do_wait()
		"back":
			_change_state(State.PLAYER_CHOOSING)
			ui.show_action_menu(active_unit)

func _on_ability_selected(ability: AbilityData) -> void:
	pending_ability = ability
	_enter_target_select()

func _start_basic_attack() -> void:
	# Basic attack = abilities[0], always free
	if active_unit.data.abilities.is_empty():
		return
	pending_ability = active_unit.data.abilities[0]
	_enter_target_select()

func _enter_move_select() -> void:
	_change_state(State.PLAYER_SELECT_MOVE)
	move_range_tiles = grid.get_reachable_tiles(
		active_unit.grid_pos, active_unit.data.base_mov, _occupied(active_unit)
	)
	grid.clear_overlays()
	grid.show_move_range(move_range_tiles)

func _enter_target_select() -> void:
	if pending_ability == null:
		_change_state(State.PLAYER_CHOOSING)
		return
	_change_state(State.PLAYER_SELECT_TARGET)
	target_range_tiles = grid.get_tiles_in_range(active_unit.grid_pos, pending_ability.range)
	grid.clear_overlays()
	grid.show_attack_range(target_range_tiles)

func _on_tile_clicked(tile: Vector2i) -> void:
	match current_state:
		State.PLAYER_SELECT_MOVE:   _try_move(tile)
		State.PLAYER_SELECT_TARGET: _try_use_ability(tile)
		State.PLAYER_CHOOSING:
			var u := _unit_at(tile)
			if u != null:
				ui.show_unit_info(u)

func _on_tile_hovered(tile: Vector2i) -> void:
	match current_state:
		State.PLAYER_SELECT_MOVE:
			if tile in move_range_tiles:
				var path := grid.find_path(active_unit.grid_pos, tile, _occupied(active_unit))
				grid.clear_overlays()
				grid.show_move_range(move_range_tiles)
				grid.show_path(path)
		State.PLAYER_SELECT_TARGET:
			grid.clear_overlays()
			grid.show_attack_range(target_range_tiles)
			if pending_ability and pending_ability.aoe_radius > 0 and tile in target_range_tiles:
				grid.show_ability_range(grid.get_tiles_in_aoe(tile, pending_ability.aoe_radius))

func _try_move(tile: Vector2i) -> void:
	if tile not in move_range_tiles:
		return
	_change_state(State.EXECUTING_ACTION)
	grid.clear_overlays()
	var path := grid.find_path(active_unit.grid_pos, tile, _occupied(active_unit))
	active_unit.move_to(tile, path)
	await active_unit.action_finished
	# After move: return to choosing if can still act, else wait
	if not active_unit.has_acted:
		_change_state(State.PLAYER_CHOOSING)
	else:
		_do_wait()

func _try_use_ability(tile: Vector2i) -> void:
	if tile not in target_range_tiles or pending_ability == null:
		_change_state(State.PLAYER_CHOOSING)
		return
	_change_state(State.EXECUTING_ACTION)
	grid.clear_overlays()
	await _execute_ability(active_unit, pending_ability, tile)
	pending_ability = null
	if not active_unit.is_alive():
		_change_state(State.CALC_NEXT_TURN)
		return
	# After action: return to choosing if can still move, else wait
	if not active_unit.has_moved:
		_change_state(State.PLAYER_CHOOSING)
	else:
		_do_wait()

func _do_wait() -> void:
	active_unit.end_turn()
	active_unit.set_waiting()
	active_unit.clear_highlight()
	grid.clear_overlays()
	ui.hide_action_menu()
	_change_state(State.CALC_NEXT_TURN)

# ── Ability execution ─────────────────────────────────────────────────────────

func _execute_ability(caster: Unit, ability: AbilityData, target_tile: Vector2i) -> void:
	if ability.nrj_cost > 0:
		caster.spend_nrj(ability.nrj_cost)
	caster.has_acted = true

	ability_used.emit(caster, ability, [])
	ui.show_ability_name(ability.display_name)

	# Kuro: Mille Mains self-buff
	if ability.id == "mille_mains":
		caster.activate_mille_mains(2)
		await get_tree().create_timer(0.35).timeout
		return

	var hit_tiles := grid.get_tiles_in_aoe(target_tile, ability.aoe_radius)
	var targets: Array[Unit] = _collect_targets(caster, ability, hit_tiles)

	for tgt in targets:
		_resolve_hit(caster, ability, tgt)

	await get_tree().create_timer(0.45).timeout

func _collect_targets(caster: Unit, ability: AbilityData, hit_tiles: Array[Vector2i]) -> Array[Unit]:
	var result: Array[Unit] = []
	for tile in hit_tiles:
		var u := _unit_at(tile)
		if u == null or not u.is_alive():
			continue
		match ability.target_type:
			AbilityData.TargetType.SINGLE_ENEMY, AbilityData.TargetType.AOE_ENEMIES:
				if u.is_player != caster.is_player: result.append(u)
			AbilityData.TargetType.SINGLE_ALLY, AbilityData.TargetType.AOE_ALLIES:
				if u.is_player == caster.is_player and u != caster: result.append(u)
			AbilityData.TargetType.SELF:
				if u == caster: result.append(u)
			AbilityData.TargetType.AOE_ALL:
				if u != caster: result.append(u)
	# Mille Mains: also hit all units adjacent to caster's tile
	if caster.mille_mains_active and ability.target_type == AbilityData.TargetType.SINGLE_ENEMY:
		var adj := grid.get_neighbors(caster.grid_pos)
		for tile in adj:
			var u := _unit_at(tile)
			if u != null and u.is_alive() and u.is_player != caster.is_player and u not in result:
				result.append(u)
	return result

func _resolve_hit(caster: Unit, ability: AbilityData, tgt: Unit) -> void:
	# Miss check (skip for HEAL / STATUS_ONLY)
	if ability.damage_type not in [AbilityData.DamageType.HEAL, AbilityData.DamageType.STATUS_ONLY]:
		if not DamageCalculator.roll_hit(caster.agi_stat, tgt.agi_stat, caster.statuses):
			ui.show_miss(tgt.grid_pos)
			return

	var amount := DamageCalculator.resolve(
		ability,
		caster.for_stat, caster.tec_stat, caster.vol_stat,
		caster.statuses,
		tgt.def_stat, tgt.res_stat, tgt.data, tgt.statuses
	)

	if ability.damage_type == AbilityData.DamageType.HEAL:
		var healed := tgt.receive_heal(amount)
		damage_dealt.emit(tgt.grid_pos, healed, true)
	elif ability.damage_type == AbilityData.DamageType.STATUS_ONLY:
		pass
	else:
		var dmg := tgt.take_damage(amount)
		damage_dealt.emit(tgt.grid_pos, dmg, false)

	# Apply status effect
	if ability.apply_status != StatusManager.Status.NONE and randf() < ability.status_chance:
		tgt.apply_status(ability.apply_status as StatusManager.Status, ability.status_duration)

	# Knockback
	if ability.knockback > 0:
		_apply_knockback(caster, tgt, ability.knockback)

func _apply_knockback(caster: Unit, tgt: Unit, tiles: int) -> void:
	var dir := (tgt.grid_pos - caster.grid_pos).sign()
	var new_pos := tgt.grid_pos + dir * tiles
	if grid.is_valid(new_pos) and grid.get_move_cost(new_pos) < 99 and _unit_at(new_pos) == null:
		tgt.move_to(new_pos, [new_pos])

# ── Enemy AI turn ─────────────────────────────────────────────────────────────

func _run_enemy_turn() -> void:
	active_unit.highlight_active()
	ui.show_unit_info(active_unit)
	await get_tree().create_timer(0.35).timeout

	var decision := ai.decide(active_unit, all_units)

	match decision.type:
		AIController.AIDecision.Type.WAIT:
			pass
		AIController.AIDecision.Type.MOVE:
			var path := grid.find_path(active_unit.grid_pos, decision.move_target, _occupied(active_unit))
			active_unit.move_to(decision.move_target, path)
			await active_unit.action_finished
		AIController.AIDecision.Type.USE_ABILITY:
			await _execute_ability(active_unit, decision.ability, decision.ability_target)
		AIController.AIDecision.Type.MOVE_THEN_ABILITY:
			var path := grid.find_path(active_unit.grid_pos, decision.move_target, _occupied(active_unit))
			active_unit.move_to(decision.move_target, path)
			await active_unit.action_finished
			await _execute_ability(active_unit, decision.ability, decision.ability_target)

	await get_tree().create_timer(0.25).timeout
	active_unit.end_turn()
	active_unit.set_waiting()
	active_unit.clear_highlight()
	_change_state(State.CALC_NEXT_TURN)

# ── Victory / Defeat ──────────────────────────────────────────────────────────

func _check_battle_end() -> bool:
	var players_alive := all_units.any(func(u: Unit) -> bool: return u.is_player and u.is_alive())
	var enemies_alive := all_units.any(func(u: Unit) -> bool: return not u.is_player and u.is_alive())

	if not players_alive:
		_change_state(State.DEFEAT)
		battle_ended.emit(false)
		ui.show_battle_result(false)
		return true

	if not enemies_alive:
		_change_state(State.VICTORY)
		_award_exp()
		SaveManager.mark_battle_complete(config.battle_id)
		_run_dialogue(config.post_battle_dialogue, func() -> void:
			battle_ended.emit(true)
			ui.show_battle_result(true)
		)
		return true

	return false

func _award_exp() -> void:
	var total_exp := 0
	for u in all_units:
		if not u.is_player:
			total_exp += u.data.exp_reward
	if total_exp <= 0:
		return
	var survivors: Array[String] = []
	for u in all_units:
		if u.is_player and u.is_alive() and u.data.id in SaveManager.STRAW_HAT_IDS:
			survivors.append(u.data.id)
	if survivors.is_empty():
		return
	SaveManager.award_exp(survivors, total_exp)

func _on_unit_died(unit: Unit) -> void:
	turn_manager.unregister(unit)
	all_units.erase(unit)
	_check_battle_end()

# ── Dialogue ──────────────────────────────────────────────────────────────────

func _run_dialogue(lines: Array[String], on_done: Callable) -> void:
	if lines.is_empty():
		on_done.call()
	else:
		dialogue.show_dialogue(lines, on_done)

# ── Helpers ───────────────────────────────────────────────────────────────────

func _unit_at(tile: Vector2i) -> Unit:
	for u in all_units:
		if u.is_alive() and u.grid_pos == tile:
			return u
	return null

func _occupied(exclude: Unit) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for u in all_units:
		if u != exclude and u.is_alive():
			tiles.append(u.grid_pos)
	return tiles
