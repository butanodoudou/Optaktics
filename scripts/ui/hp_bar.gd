class_name HpBar
extends Control

var _bg:   ColorRect
var _fill: ColorRect

const BAR_W := 60.0
const BAR_H :=  6.0

func _ready() -> void:
	_bg   = _rect(Color(0.15, 0.15, 0.15), Vector2(BAR_W, BAR_H), Vector2.ZERO)
	_fill = _rect(Color(0.1, 0.85, 0.2),   Vector2(BAR_W, BAR_H), Vector2.ZERO)
	custom_minimum_size = Vector2(BAR_W, BAR_H)

func _rect(color: Color, sz: Vector2, pos: Vector2) -> ColorRect:
	var r := ColorRect.new()
	r.color = color; r.size = sz; r.position = pos
	add_child(r)
	return r

# pct in [0, 1]; optional tint overrides auto color
func update(pct: float, tint: Color = Color.TRANSPARENT) -> void:
	var clamped := clampf(pct, 0.0, 1.0)
	create_tween().tween_property(_fill, "size:x", BAR_W * clamped, 0.22)
	if tint != Color.TRANSPARENT:
		_fill.color = tint
	else:
		_fill.color = (
			Color(0.1, 0.85, 0.2) if clamped > 0.5 else
			Color(0.9, 0.75, 0.1) if clamped > 0.25 else
			Color(0.9, 0.1, 0.1)
		)
