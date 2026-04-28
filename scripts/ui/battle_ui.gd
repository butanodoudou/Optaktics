class_name BattleUI
extends CanvasLayer

signal action_selected(action: String)
signal ability_selected(ability: AbilityData)
signal item_selected(item: ItemData)

var _action_menu:  ActionMenu
var _unit_info:    UnitInfoPanel
var _turn_order:   TurnOrderDisplay
var _ability_lbl:  Label
var _result_panel: PanelContainer
var _result_lbl:   Label

var _battle: BattleManager

func setup(battle: BattleManager) -> void:
	_battle = battle
	battle.damage_dealt.connect(_on_damage_dealt)
	_build_ui()

func _build_ui() -> void:
	# ── Turn order strip (top-left) ──────────────────────────────────────────
	_turn_order = TurnOrderDisplay.new()
	_turn_order.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_turn_order.position = Vector2(8, 8)
	add_child(_turn_order)

	# ── Unit info panel (bottom-left) ────────────────────────────────────────
	_unit_info = UnitInfoPanel.new()
	_unit_info.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_unit_info.anchor_top    = 1.0
	_unit_info.anchor_bottom = 1.0
	_unit_info.offset_top    = -185
	_unit_info.offset_bottom = -8
	_unit_info.offset_left   = 8
	_unit_info.offset_right  = 240
	add_child(_unit_info)

	# ── Action menu (bottom-right) ───────────────────────────────────────────
	_action_menu = ActionMenu.new()
	_action_menu.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	_action_menu.anchor_top    = 1.0
	_action_menu.anchor_bottom = 1.0
	_action_menu.anchor_left   = 1.0
	_action_menu.anchor_right  = 1.0
	_action_menu.offset_top    = -240
	_action_menu.offset_bottom = -8
	_action_menu.offset_left   = -195
	_action_menu.offset_right  = -8
	_action_menu.action_selected.connect(_on_action_selected)
	_action_menu.ability_chosen.connect(_on_ability_chosen)
	_action_menu.item_chosen.connect(_on_item_chosen)
	add_child(_action_menu)

	# ── Ability name flash (top-center) ──────────────────────────────────────
	_ability_lbl = Label.new()
	_ability_lbl.add_theme_font_size_override("font_size", 24)
	_ability_lbl.add_theme_color_override("font_color", Color.YELLOW)
	_ability_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	_ability_lbl.add_theme_constant_override("outline_size", 4)
	_ability_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_ability_lbl.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_ability_lbl.offset_top   = 55
	_ability_lbl.offset_left  = -220
	_ability_lbl.offset_right = 220
	_ability_lbl.hide()
	add_child(_ability_lbl)

	# ── Victory / Defeat panel (center) ──────────────────────────────────────
	_result_panel = PanelContainer.new()
	_result_panel.set_anchors_preset(Control.PRESET_CENTER)
	_result_panel.offset_left   = -220
	_result_panel.offset_right  =  220
	_result_panel.offset_top    = -110
	_result_panel.offset_bottom =  110
	_result_panel.hide()
	add_child(_result_panel)

	var rv := VBoxContainer.new()
	rv.alignment = BoxContainer.ALIGNMENT_CENTER
	rv.add_theme_constant_override("separation", 12)
	_result_panel.add_child(rv)

	_result_lbl = Label.new()
	_result_lbl.add_theme_font_size_override("font_size", 36)
	_result_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rv.add_child(_result_lbl)

	var cont_btn := Button.new()
	cont_btn.text = "Continuer"
	cont_btn.custom_minimum_size = Vector2(180, 44)
	cont_btn.add_theme_font_size_override("font_size", 16)
	cont_btn.pressed.connect(func() -> void: GameManager.advance_to_next_battle())
	rv.add_child(cont_btn)

	var menu_btn := Button.new()
	menu_btn.text = "Retour au menu"
	menu_btn.custom_minimum_size = Vector2(180, 44)
	menu_btn.add_theme_font_size_override("font_size", 16)
	menu_btn.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	)
	rv.add_child(menu_btn)

# ── Public API ────────────────────────────────────────────────────────────────

func show_action_menu(unit: Unit) -> void:
	_action_menu.show_main(unit)

func show_ability_menu(unit: Unit) -> void:
	_action_menu.show_abilities(unit)

func show_item_menu(unit: Unit) -> void:
	_action_menu.show_items(unit)

func hide_action_menu() -> void:
	_action_menu.hide()

func update_action_menu_buttons(unit: Unit) -> void:
	_action_menu.update_buttons(unit)

func show_unit_info(unit: Unit) -> void:
	_unit_info.show_unit(unit)

func update_turn_order(upcoming: Array[Unit]) -> void:
	_turn_order.refresh(upcoming)

func show_ability_name(name: String) -> void:
	_ability_lbl.text = name
	_ability_lbl.modulate.a = 1.0
	_ability_lbl.show()
	var tw := create_tween()
	tw.tween_interval(0.7)
	tw.tween_property(_ability_lbl, "modulate:a", 0.0, 0.35)
	tw.tween_callback(func() -> void: _ability_lbl.hide())

func show_miss(tile: Vector2i) -> void:
	var world := Vector2(tile.x * Unit.TILE_SIZE + Unit.TILE_SIZE / 2.0,
						 tile.y * Unit.TILE_SIZE + Unit.TILE_SIZE / 2.0)
	var lbl := Label.new()
	lbl.text = "ESQUIVÉ"
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	lbl.add_theme_constant_override("outline_size", 3)
	lbl.position = _world_to_screen(world) + Vector2(-20, -45)
	lbl.z_index  = 10
	add_child(lbl)
	var tw := lbl.create_tween().set_parallel()
	tw.tween_property(lbl, "position:y", lbl.position.y - 40, 0.6)
	tw.tween_property(lbl, "modulate:a", 0.0, 0.6).set_delay(0.2)
	tw.tween_callback(lbl.queue_free).set_delay(0.6)

func show_battle_result(victory: bool) -> void:
	_result_lbl.text = "VICTOIRE !" if victory else "DÉFAITE..."
	_result_lbl.add_theme_color_override("font_color", Color.YELLOW if victory else Color.RED)
	_result_panel.show()

# ── Internal ──────────────────────────────────────────────────────────────────

func _on_damage_dealt(tile: Vector2i, amount: int, is_heal: bool) -> void:
	var world := Vector2(tile.x * Unit.TILE_SIZE + Unit.TILE_SIZE / 2.0,
						 tile.y * Unit.TILE_SIZE + Unit.TILE_SIZE / 2.0)
	DamageNumber.spawn(self, _world_to_screen(world), amount, is_heal)

func _world_to_screen(world_pos: Vector2) -> Vector2:
	var vp  := get_viewport()
	var cam := vp.get_camera_2d() if vp else null
	if cam:
		return world_pos - cam.get_screen_center_position() + vp.get_visible_rect().size / 2.0
	return world_pos

func _on_action_selected(action: String) -> void:
	if action == "back":
		if _battle and _battle.active_unit:
			_action_menu.show_main(_battle.active_unit)
	else:
		action_selected.emit(action)

func _on_ability_chosen(ability: AbilityData) -> void:
	ability_selected.emit(ability)

func _on_item_chosen(item: ItemData) -> void:
	item_selected.emit(item)
