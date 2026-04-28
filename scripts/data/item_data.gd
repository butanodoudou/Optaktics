class_name ItemData
extends Resource

enum Category { FOOD, ALCOHOL, BOOST, DEBUFF }
enum TargetType { SELF, SINGLE_ALLY, SINGLE_ENEMY }

@export var id:           String   = ""
@export var display_name: String   = ""
@export var category:     Category = Category.FOOD
@export var target_type:  TargetType = TargetType.SELF
@export var range:        int      = 0   # 0 = self-only; >0 = tile range for ally/enemy

# ── Effects ───────────────────────────────────────────────────────────────────
@export var heal_hp:        int   = 0      # flat HP restored
@export var heal_hp_full:   bool  = false  # restore to max HP
@export var restore_nrj:    int   = 0      # flat NRJ restored
@export var restore_nrj_full: bool = false # restore to max NRJ
@export var apply_status:   int   = 0      # StatusManager.Status (0 = none)
@export var status_duration: int  = 2

# ── Meta ──────────────────────────────────────────────────────────────────────
@export var berry_cost: int   = 100
@export var icon_color: Color = Color.WHITE

static func make(
	p_id: String, p_name: String,
	p_cat: Category, p_target: TargetType, p_range: int,
	p_heal_hp: int, p_heal_full: bool,
	p_restore_nrj: int, p_nrj_full: bool,
	p_status: int, p_status_dur: int,
	p_cost: int, p_color: Color
) -> ItemData:
	var d := ItemData.new()
	d.id           = p_id
	d.display_name = p_name
	d.category     = p_cat
	d.target_type  = p_target
	d.range        = p_range
	d.heal_hp      = p_heal_hp
	d.heal_hp_full = p_heal_full
	d.restore_nrj  = p_restore_nrj
	d.restore_nrj_full = p_nrj_full
	d.apply_status = p_status
	d.status_duration = p_status_dur
	d.berry_cost   = p_cost
	d.icon_color   = p_color
	return d
