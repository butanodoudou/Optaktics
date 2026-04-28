class_name ActionMenu
extends PanelContainer

signal action_selected(action: String)
signal ability_chosen(ability: AbilityData)
signal item_chosen(item: ItemData)

var _vbox: VBoxContainer
var _in_ability_submenu: bool = false

func _ready() -> void:
	custom_minimum_size = Vector2(172, 0)
	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 2)
	add_child(_vbox)
	hide()

# ── Main menu: MOVE / ATTACK / ABILITY / WAIT ─────────────────────────────────
# Each option is greyed if the unit has already used that action this turn.

func show_main(unit: Unit) -> void:
	_in_ability_submenu = false
	_clear()

	var can_move   := not unit.has_moved
	var can_act    := not unit.has_acted
	var has_skills := unit.data.abilities.size() > 1
	var has_items  := not InventoryManager.get_available().is_empty()

	_btn("Déplacer",    "move",    can_move)
	_btn("Attaquer",    "attack",  can_act)
	_btn("Compétence",  "ability", can_act and has_skills)
	_btn("Objet",       "item",    can_act and has_items)
	_separator()
	_btn("Passer",      "wait",    true)

	show()

# ── Ability sub-menu ──────────────────────────────────────────────────────────

func show_abilities(unit: Unit) -> void:
	_in_ability_submenu = true
	_clear()

	# Skip abilities[0] (basic attack) — that's the "Attaquer" button
	for i in range(1, unit.data.abilities.size()):
		var ab := unit.data.abilities[i]
		if ab.is_reaction:
			continue   # reactions are passive, don't show in menu
		var can_use := unit.can_afford(ab) and not unit.has_acted
		var label := "%s  [%d NRJ]" % [ab.display_name, ab.nrj_cost]
		var btn := _make_btn(label, can_use)
		btn.pressed.connect(func() -> void:
			if can_use:
				ability_chosen.emit(ab)
				hide()
		)
		_vbox.add_child(btn)

	_separator()
	var back := _make_btn("← Retour", true)
	back.pressed.connect(func() -> void: action_selected.emit("back"))
	_vbox.add_child(back)
	show()

# ── Item sub-menu ─────────────────────────────────────────────────────────────

func show_items(unit: Unit) -> void:
	_in_ability_submenu = false
	_clear()

	var items := InventoryManager.get_available()
	for item in items:
		var qty   := InventoryManager.count(item.id)
		var label := "%s  ×%d" % [item.display_name, qty]
		var btn   := _make_btn(label, not unit.has_acted)
		btn.pressed.connect(func() -> void:
			if not unit.has_acted:
				item_chosen.emit(item)
				hide()
		)
		_vbox.add_child(btn)

	_separator()
	var back := _make_btn("← Retour", true)
	back.pressed.connect(func() -> void: action_selected.emit("back"))
	_vbox.add_child(back)
	show()

func update_buttons(unit: Unit) -> void:
	if not _in_ability_submenu:
		show_main(unit)

# ── Helpers ───────────────────────────────────────────────────────────────────

func _btn(label: String, action: String, enabled: bool) -> void:
	var b := _make_btn(label, enabled)
	b.pressed.connect(func() -> void:
		if enabled: action_selected.emit(action)
	)
	_vbox.add_child(b)

func _make_btn(label: String, enabled: bool) -> Button:
	var b := Button.new()
	b.text = label
	b.disabled = not enabled
	b.custom_minimum_size = Vector2(0, 36)
	b.add_theme_font_size_override("font_size", 13)
	return b

func _separator() -> void:
	var sep := HSeparator.new()
	_vbox.add_child(sep)

func _clear() -> void:
	for c in _vbox.get_children():
		c.queue_free()
