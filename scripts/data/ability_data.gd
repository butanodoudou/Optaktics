class_name AbilityData
extends Resource

enum DamageType  { PHYSICAL, TECHNICAL, HEAL, STATUS_ONLY }
enum DamageTag   { NONE, SLASH, BLUNT, PIERCE }
enum TargetType  { SINGLE_ENEMY, SINGLE_ALLY, SELF, AOE_ENEMIES, AOE_ALLIES, AOE_ALL }
enum ReactionTrigger { NONE, ON_HIT_MELEE, ON_HIT_ANY, ON_ALLY_HIT }

@export var id: String = ""
@export var display_name: String = ""
@export var description: String = ""

@export var nrj_cost: int = 0
@export var range: int = 1
@export var aoe_radius: int = 0
@export var target_type: TargetType = TargetType.SINGLE_ENEMY
@export var damage_type: DamageType = DamageType.PHYSICAL
@export var damage_tag: DamageTag = DamageTag.BLUNT
@export var damage_multiplier: float = 1.0

# Healing (scales with VOL of the caster)
@export var heal_vol_multiplier: float = 0.0

# Status on hit
@export var apply_status: int = 0       # StatusManager.Status enum value
@export var status_chance: float = 0.0  # 0.0 – 1.0
@export var status_duration: int = 2    # turns

# Special flags
@export var ignores_half_mitigation: bool = false  # true = ignore half of DEF/RES
@export var knockback: int = 0                      # tiles pushed back
@export var self_buff_agi_multiplier: float = 1.0  # e.g. 2.0 = double AGI for duration

# Reaction
@export var is_reaction: bool = false
@export var reaction_trigger: ReactionTrigger = ReactionTrigger.NONE
@export var reaction_damage_multiplier: float = 0.8

@export var animation_id: String = "hit"

static func make(
	p_id: String, p_name: String, p_desc: String,
	p_nrj: int, p_range: int, p_aoe: int,
	p_target: TargetType, p_dtype: DamageType, p_dtag: DamageTag,
	p_dmult: float, p_anim: String = "hit"
) -> AbilityData:
	var a := AbilityData.new()
	a.id            = p_id
	a.display_name  = p_name
	a.description   = p_desc
	a.nrj_cost      = p_nrj
	a.range         = p_range
	a.aoe_radius    = p_aoe
	a.target_type   = p_target
	a.damage_type   = p_dtype
	a.damage_tag    = p_dtag
	a.damage_multiplier = p_dmult
	a.animation_id  = p_anim
	return a
