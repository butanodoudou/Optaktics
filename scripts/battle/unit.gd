class_name Unit
extends Node2D

signal hp_changed(unit: Unit, old_hp: int, new_hp: int)
signal nrj_changed(unit: Unit, old_nrj: int, new_nrj: int)
signal unit_died(unit: Unit)
signal action_finished(unit: Unit)

enum UnitState { IDLE, MOVING, ACTING, WAITING, DEAD }

const TILE_SIZE  := 64
const MOVE_DUR   := 0.16
const NRJ_REGEN  := 3   # NRJ gained at the start of each turn

# ── Template ──────────────────────────────────────────────────────────────────
var data: UnitData
var level: int = 1

# ── Computed stats (set during setup) ────────────────────────────────────────
var max_pv:  int = 0
var for_stat: int = 0
var tec_stat: int = 0
var def_stat: int = 0
var res_stat: int = 0
var agi_stat: int = 0
var vol_stat: int = 0
var nrj_max:  int = 0

# ── Runtime state ─────────────────────────────────────────────────────────────
var current_pv:  int = 0
var current_nrj: int = 0
var state: UnitState = UnitState.IDLE
var has_moved: bool  = false
var has_acted: bool  = false
var is_player: bool  = false
var grid_pos: Vector2i = Vector2i.ZERO
var experience: int  = 0

# Status effects
var statuses: Array = []   # Array[StatusManager.ActiveStatus]

# Boss runtime flags
var armor_broken: bool       = false   # Krieg
var mille_mains_active: bool = false   # Kuro
var mille_mains_turns: int   = 0

# ── Visuals ───────────────────────────────────────────────────────────────────
var _border: ColorRect
var _body:   ColorRect
var _icon:   Label
var _name_lbl: Label
var _status_lbl: Label

static var FACTION_COLORS := {
	"player": Color(0.2, 0.8, 1.0),
	"enemy":  Color(1.0, 0.3, 0.3),
}

# ── Setup ─────────────────────────────────────────────────────────────────────

func setup(p_data: UnitData, tile: Vector2i, p_level: int, p_is_player: bool) -> void:
	data      = p_data
	level     = p_level
	is_player = p_is_player
	grid_pos  = tile
	_compute_stats()
	current_pv  = max_pv
	current_nrj = nrj_max
	position = _tile_to_world(tile)
	_build_visuals()

func _compute_stats() -> void:
	max_pv    = data.pv_at(level)
	for_stat  = data.for_at(level)
	tec_stat  = data.tec_at(level)
	def_stat  = data.def_at(level)
	res_stat  = data.res_at(level)
	agi_stat  = data.agi_at(level)
	vol_stat  = data.vol_at(level)
	nrj_max   = data.nrj_max_at(level)

# ── Visual construction ───────────────────────────────────────────────────────

func _build_visuals() -> void:
	var border_color := FACTION_COLORS["player"] if is_player else FACTION_COLORS["enemy"]

	_border = ColorRect.new()
	_border.size     = Vector2(TILE_SIZE - 4, TILE_SIZE - 4)
	_border.position = Vector2(-(TILE_SIZE - 4) / 2.0, -(TILE_SIZE - 4) / 2.0)
	_border.color    = border_color
	add_child(_border)

	_body = ColorRect.new()
	_body.size     = Vector2(TILE_SIZE - 10, TILE_SIZE - 10)
	_body.position = Vector2(-(TILE_SIZE - 10) / 2.0, -(TILE_SIZE - 10) / 2.0)
	_body.color    = data.portrait_color
	add_child(_body)

	_icon = Label.new()
	_icon.text = data.display_name.substr(0, 1)
	_icon.add_theme_font_size_override("font_size", 22)
	_icon.add_theme_color_override("font_color", Color.WHITE)
	_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_icon.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	_icon.size     = Vector2(TILE_SIZE - 10, TILE_SIZE - 10)
	_icon.position = _body.position
	add_child(_icon)

	_name_lbl = Label.new()
	_name_lbl.text = data.display_name
	_name_lbl.add_theme_font_size_override("font_size", 9)
	_name_lbl.add_theme_color_override("font_color", Color.WHITE)
	_name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_lbl.size     = Vector2(80, 14)
	_name_lbl.position = Vector2(-40.0, -TILE_SIZE / 2.0 - 14.0)
	add_child(_name_lbl)

	_status_lbl = Label.new()
	_status_lbl.add_theme_font_size_override("font_size", 8)
	_status_lbl.add_theme_color_override("font_color", Color.YELLOW)
	_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_lbl.size     = Vector2(80, 12)
	_status_lbl.position = Vector2(-40.0, TILE_SIZE / 2.0)
	add_child(_status_lbl)

# ── Turn lifecycle ────────────────────────────────────────────────────────────

func begin_turn() -> void:
	# NRJ regen
	var old := current_nrj
	current_nrj = min(nrj_max, current_nrj + NRJ_REGEN)
	if current_nrj != old:
		nrj_changed.emit(self, old, current_nrj)

	# Frozen: can't move this turn
	if has_status(StatusManager.Status.FROZEN):
		has_moved = true

	# Stun: skip entire turn
	# (handled in BattleManager before calling this)

func end_turn() -> void:
	StatusManager.tick_all(statuses)
	_update_status_label()
	# Burn damage
	if has_status(StatusManager.Status.BURN):
		var burn_dmg := int(max(1, max_pv * StatusManager.BURN_PERCENT))
		_apply_hp_change(-burn_dmg)

	# Kuro: decrement mille mains
	if mille_mains_active:
		mille_mains_turns -= 1
		if mille_mains_turns <= 0:
			_deactivate_mille_mains()

func reset_turn() -> void:
	has_moved = false
	has_acted = false
	state = UnitState.IDLE
	modulate = Color.WHITE

func set_waiting() -> void:
	has_moved = true
	has_acted = true
	state = UnitState.WAITING
	modulate = Color(0.55, 0.55, 0.55)

# ── Combat ────────────────────────────────────────────────────────────────────

func take_damage(amount: int) -> int:
	var actual := max(1, amount)
	_apply_hp_change(-actual)
	_flash(Color.RED)
	# Krieg armor-break check
	if data.armor_break_threshold > 0.0 and not armor_broken:
		if hp_percent() <= data.armor_break_threshold:
			_trigger_armor_break()
	return actual

func receive_heal(amount: int) -> int:
	var gained := min(amount, max_pv - current_pv)
	_apply_hp_change(gained)
	_flash(Color.GREEN)
	return gained

func _apply_hp_change(delta: int) -> void:
	var old := current_pv
	current_pv = clampi(current_pv + delta, 0, max_pv)
	hp_changed.emit(self, old, current_pv)
	if current_pv <= 0 and state != UnitState.DEAD:
		_die()

func spend_nrj(amount: int) -> void:
	var old := current_nrj
	current_nrj = max(0, current_nrj - amount)
	nrj_changed.emit(self, old, current_nrj)

func restore_nrj(amount: int, full: bool = false) -> int:
	var old := current_nrj
	current_nrj = nrj_max if full else min(nrj_max, current_nrj + amount)
	nrj_changed.emit(self, old, current_nrj)
	_flash(Color(0.4, 0.8, 1.0))
	return current_nrj - old

func can_afford(ability: AbilityData) -> bool:
	return current_nrj >= ability.nrj_cost

func _die() -> void:
	state = UnitState.DEAD
	unit_died.emit(self)
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.55)
	tween.tween_callback(queue_free)

# ── Status helpers ────────────────────────────────────────────────────────────

func apply_status(effect: StatusManager.Status, duration: int) -> void:
	StatusManager.apply(statuses, effect, duration)
	_update_status_label()

func has_status(effect: StatusManager.Status) -> bool:
	return StatusManager.has(statuses, effect)

func _update_status_label() -> void:
	if not is_instance_valid(_status_lbl):
		return
	_status_lbl.text = StatusManager.label_string(statuses)

# ── Boss mechanics ────────────────────────────────────────────────────────────

func activate_mille_mains(turns: int = 2) -> void:
	mille_mains_active = true
	mille_mains_turns  = turns
	# Double AGI visually/functionally
	agi_stat = data.agi_at(level) * 2
	_border.color = Color.YELLOW

func _deactivate_mille_mains() -> void:
	mille_mains_active = false
	agi_stat = data.agi_at(level)
	_border.color = Unit.FACTION_COLORS["enemy"]

func _trigger_armor_break() -> void:
	armor_broken = true
	# Permanent WEAKENED + halve DEF
	StatusManager.apply(statuses, StatusManager.Status.WEAKENED, -1, "armor_break")
	def_stat = def_stat / 2
	_update_status_label()
	# Flash effect
	var tween := create_tween()
	for _i in range(4):
		tween.tween_property(_border, "color", Color.ORANGE, 0.1)
		tween.tween_property(_border, "color", Color.RED,    0.1)

func water_regen() -> void:
	if data.water_regen_pv > 0:
		receive_heal(data.water_regen_pv)

func effective_agi() -> int:
	# agi_stat already doubled when mille_mains_active
	var mult := StatusManager.get_agi_multiplier(statuses)
	return int(agi_stat * mult)

# ── Movement ──────────────────────────────────────────────────────────────────

func move_to(new_tile: Vector2i, path: Array[Vector2i]) -> void:
	state    = UnitState.MOVING
	has_moved = true
	grid_pos  = new_tile
	var tween := create_tween()
	for step in path:
		tween.tween_property(self, "position", _tile_to_world(step), MOVE_DUR)
	tween.tween_callback(func() -> void:
		state = UnitState.IDLE
		action_finished.emit(self)
	)

# ── Visual helpers ────────────────────────────────────────────────────────────

func highlight_active() -> void:
	if not is_instance_valid(_border):
		return
	var tween := create_tween().set_loops()
	tween.tween_property(_border, "color", Color.YELLOW, 0.35)
	tween.tween_property(_border, "color",
		FACTION_COLORS["player"] if is_player else FACTION_COLORS["enemy"], 0.35)

func clear_highlight() -> void:
	if is_instance_valid(_border):
		_border.color = FACTION_COLORS["player"] if is_player else FACTION_COLORS["enemy"]

func _flash(color: Color) -> void:
	if not is_instance_valid(_body):
		return
	var tween := create_tween()
	tween.tween_property(_body, "color", color,               0.07)
	tween.tween_property(_body, "color", data.portrait_color, 0.18)

# ── Queries ───────────────────────────────────────────────────────────────────

func is_alive() -> bool:
	return state != UnitState.DEAD and current_pv > 0

func hp_percent() -> float:
	return float(current_pv) / float(max_pv) if max_pv > 0 else 0.0

func nrj_percent() -> float:
	return float(current_nrj) / float(nrj_max) if nrj_max > 0 else 0.0

func can_still_act() -> bool:
	return not has_moved or not has_acted

func _tile_to_world(tile: Vector2i) -> Vector2:
	return Vector2(tile.x * TILE_SIZE + TILE_SIZE / 2.0,
				   tile.y * TILE_SIZE + TILE_SIZE / 2.0)
