class_name UnitData
extends Resource

enum Faction  { STRAW_HATS, RED_HAIR_PIRATES, MARINES, PIRATES, BANDITS, CIVILIANS }
enum Category { PROTAGONIST, DEVIL_FRUIT_USER, ARCHETYPE }

@export var id: String = ""
@export var display_name: String = ""
@export var faction: Faction = Faction.PIRATES
@export var category: Category = Category.ARCHETYPE
@export var portrait_color: Color = Color.WHITE

# ── Base stats (level 1) ───────────────────────────────────────────────────────
@export var base_pv:  int = 40   # Hit Points
@export var base_for: int = 8    # Physical Strength   (physical damage)
@export var base_tec: int = 5    # Technique           (skill damage)
@export var base_def: int = 5    # Physical Defense    (reduces physical dmg)
@export var base_res: int = 4    # Resistance          (reduces technical dmg)
@export var base_agi: int = 6    # Agility             (turn order + hit/evade)
@export var base_vol: int = 8    # Willpower           (NRJ max = ceil(vol/2))
@export var base_mov: int = 4    # Movement tiles per turn

# ── Growth rates (0–100 : % chance of +1 per level) ─────────────────────────
@export var growth_pv:  int = 50
@export var growth_for: int = 35
@export var growth_tec: int = 25
@export var growth_def: int = 30
@export var growth_res: int = 20
@export var growth_agi: int = 30
@export var growth_vol: int = 30

# ── Basic attack (always free, uses abilities[0] slot) ────────────────────────
@export var basic_range: int = 1
@export var basic_type: AbilityData.DamageType = AbilityData.DamageType.PHYSICAL
@export var basic_tag:  AbilityData.DamageTag  = AbilityData.DamageTag.BLUNT

# ── Damage immunities / vulnerabilities ──────────────────────────────────────
# e.g. ["SLASH"] means immune to all SLASH damage
var damage_immunities:     Array[AbilityData.DamageTag] = []
# Multiplicative bonus damage received (e.g. 1.3 = +30%)
var damage_vulnerabilities: Dictionary = {}  # DamageTag -> float multiplier

# ── Boss mechanic flags ────────────────────────────────────────────────────────
@export var is_boss: bool = false
@export var armor_break_threshold: float = 0.0   # 0=off; e.g. 0.5 = triggers at 50% HP
@export var water_regen_pv: int = 0              # Arlong: PV healed per turn on water tile
@export var mille_mains_agi_mult: float = 1.0    # Kuro: AGI multiplier when mode active

@export var exp_reward: int = 160

var abilities: Array[AbilityData] = []  # abilities[0] = basic attack (free)

# ── Stat at given level ────────────────────────────────────────────────────────
static func stat_at_level(base: int, growth: int, level: int) -> int:
	if level <= 1:
		return base
	var l := level - 1
	var scale := 1.0 + 0.008 * l
	return base + int(ceil((growth / 100.0) * l * scale))

func pv_at(level: int)  -> int: return stat_at_level(base_pv,  growth_pv,  level)
func for_at(level: int) -> int: return stat_at_level(base_for, growth_for, level)
func tec_at(level: int) -> int: return stat_at_level(base_tec, growth_tec, level)
func def_at(level: int) -> int: return stat_at_level(base_def, growth_def, level)
func res_at(level: int) -> int: return stat_at_level(base_res, growth_res, level)
func agi_at(level: int) -> int: return stat_at_level(base_agi, growth_agi, level)
func vol_at(level: int) -> int: return stat_at_level(base_vol, growth_vol, level)
func nrj_max_at(level: int) -> int: return ceili(vol_at(level) / 2.0)

func get_growth_rates() -> Dictionary:
	return {"pv": growth_pv, "for": growth_for, "tec": growth_tec,
			"def": growth_def, "res": growth_res, "agi": growth_agi, "vol": growth_vol}

# ── Factory helper ─────────────────────────────────────────────────────────────
static func make(
	p_id: String, p_name: String,
	p_faction: Faction, p_category: Category, p_color: Color,
	p_pv: int, p_for: int, p_tec: int, p_def: int,
	p_res: int, p_agi: int, p_vol: int, p_mov: int,
	p_g_pv: int, p_g_for: int, p_g_tec: int, p_g_def: int,
	p_g_res: int, p_g_agi: int, p_g_vol: int,
	p_exp: int = 20
) -> UnitData:
	var d := UnitData.new()
	d.id = p_id;           d.display_name = p_name
	d.faction = p_faction; d.category = p_category; d.portrait_color = p_color
	d.base_pv = p_pv;   d.base_for = p_for; d.base_tec = p_tec
	d.base_def = p_def; d.base_res = p_res; d.base_agi = p_agi
	d.base_vol = p_vol; d.base_mov = p_mov
	d.growth_pv = p_g_pv; d.growth_for = p_g_for; d.growth_tec = p_g_tec
	d.growth_def = p_g_def; d.growth_res = p_g_res; d.growth_agi = p_g_agi
	d.growth_vol = p_g_vol
	d.exp_reward = p_exp
	return d
