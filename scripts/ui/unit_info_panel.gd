class_name UnitInfoPanel
extends PanelContainer

var _name_lbl:   Label
var _level_lbl:  Label
var _hp_bar:     HpBar
var _nrj_bar:    HpBar
var _hp_lbl:     Label
var _nrj_lbl:    Label
var _stats_lbl:  Label
var _status_lbl: Label

func _ready() -> void:
	custom_minimum_size = Vector2(220, 0)
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)
	add_child(vbox)

	var header := HBoxContainer.new()
	_name_lbl  = _lbl("", 15)
	_level_lbl = _lbl("", 11)
	_level_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	header.add_child(_name_lbl)
	header.add_child(_level_lbl)
	vbox.add_child(header)

	_hp_bar  = HpBar.new()
	_nrj_bar = HpBar.new()
	vbox.add_child(_hp_bar)
	vbox.add_child(_nrj_bar)

	_hp_lbl     = _lbl("", 11)
	_nrj_lbl    = _lbl("", 11)
	_stats_lbl  = _lbl("", 10)
	_status_lbl = _lbl("", 9)
	_status_lbl.add_theme_color_override("font_color", Color.YELLOW)

	vbox.add_child(_hp_lbl)
	vbox.add_child(_nrj_lbl)
	vbox.add_child(_stats_lbl)
	vbox.add_child(_status_lbl)

func show_unit(unit: Unit) -> void:
	_name_lbl.text = unit.data.display_name
	_name_lbl.add_theme_color_override("font_color",
		Color(0.4, 0.9, 1.0) if unit.is_player else Color(1.0, 0.5, 0.5))

	_level_lbl.text = "  Niv.%d" % unit.level

	_hp_bar.update(unit.hp_percent())
	_nrj_bar.update(unit.nrj_percent(), Color(0.3, 0.5, 1.0))

	_hp_lbl.text  = "PV  %d / %d" % [unit.current_pv,  unit.max_pv]
	_nrj_lbl.text = "NRJ %d / %d" % [unit.current_nrj, unit.nrj_max]

	_stats_lbl.text = (
		"FOR:%d  TEC:%d  DEF:%d\nRES:%d  AGI:%d  VOL:%d"
	) % [unit.for_stat, unit.tec_stat, unit.def_stat,
		 unit.res_stat, unit.agi_stat, unit.vol_stat]

	var status_str := StatusManager.label_string(unit.statuses)
	_status_lbl.text = status_str if status_str != "" else ""
	show()

func _lbl(text: String, size: int) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	return l
