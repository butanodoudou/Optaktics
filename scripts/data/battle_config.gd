class_name BattleConfig
extends Resource

enum Objective { DEFEAT_ALL_ENEMIES, DEFEAT_BOSS, SURVIVE_N_TURNS, PROTECT_ALLY }

enum TileType {
	NORMAL   = 0,
	WATER    = 1,
	ELEVATED = 2,
	BLOCKED  = 3,
	SAND     = 4,
	WOOD     = 5,
}

class UnitPlacement:
	var unit_data: UnitData
	var start_tile: Vector2i
	var is_player: bool
	var level: int

	func _init(d: UnitData, t: Vector2i, p: bool, lv: int = 1) -> void:
		unit_data  = d
		start_tile = t
		is_player  = p
		level      = lv

@export var battle_id:   String = ""
@export var battle_name: String = ""
@export var arc_name:    String = ""
@export var grid_width:  int    = 14
@export var grid_height: int    = 10
@export var objective: Objective = Objective.DEFEAT_ALL_ENEMIES
@export var background_color: Color = Color(0.13, 0.27, 0.13)

var pre_battle_dialogue:  Array[String] = []
var post_battle_dialogue: Array[String] = []
var unit_placements: Array = []   # Array[UnitPlacement]
var tile_overrides: Dictionary = {}  # Vector2i -> TileType

func add_unit(data: UnitData, tile: Vector2i, is_player: bool, level: int = 1) -> void:
	unit_placements.append(UnitPlacement.new(data, tile, is_player, level))

func set_tile(x: int, y: int, type: TileType) -> void:
	tile_overrides[Vector2i(x, y)] = type

func get_tile_type(x: int, y: int) -> TileType:
	return tile_overrides.get(Vector2i(x, y), TileType.NORMAL)
