class_name ArchetypeData
# Static factory for generic enemy unit templates.
# Each archetype has 4 pool abilities; a specific instance uses 2 (basic + 1 skill).

static func tank(faction: UnitData.Faction, level: int = 1) -> UnitData:
	var d := UnitData.make(
		"arch_tank", "Garde",
		faction, UnitData.Category.ARCHETYPE, Color(0.45, 0.45, 0.50),
		55, 7, 3, 14, 8, 4, 8, 3,
		65, 30, 15, 60, 30, 20, 35, 15
	)
	d.basic_tag = AbilityData.DamageTag.BLUNT
	d.abilities = [
		_basic("Coup de bouclier", AbilityData.DamageTag.BLUNT, 1),
		_skill_stun("Choc de masse", 1, 1.3, 3, 0.30),
	]
	return d

static func dps_melee_slash(faction: UnitData.Faction, level: int = 1) -> UnitData:
	var d := UnitData.make(
		"arch_slash", "Combattant",
		faction, UnitData.Category.ARCHETYPE, Color(0.55, 0.20, 0.15),
		38, 11, 3, 6, 4, 8, 6, 4,
		50, 55, 15, 25, 15, 45, 25, 20
	)
	d.basic_tag = AbilityData.DamageTag.SLASH
	d.abilities = [
		_basic("Taillade", AbilityData.DamageTag.SLASH, 1),
		_skill("Frappe croisée", 1, AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.8, 3),
	]
	return d

static func dps_melee_blunt(faction: UnitData.Faction, level: int = 1) -> UnitData:
	var d := UnitData.make(
		"arch_blunt", "Brute",
		faction, UnitData.Category.ARCHETYPE, Color(0.50, 0.30, 0.10),
		42, 10, 3, 7, 4, 6, 6, 4,
		55, 50, 15, 30, 15, 35, 25, 20
	)
	d.basic_tag = AbilityData.DamageTag.BLUNT
	d.abilities = [
		_basic("Coup de poing", AbilityData.DamageTag.BLUNT, 1),
		_skill_weakened("Écrasement", 1, 1.6, 3, 0.30),
	]
	return d

static func dps_ranged(faction: UnitData.Faction, level: int = 1) -> UnitData:
	var d := UnitData.make(
		"arch_ranged", "Tireur",
		faction, UnitData.Category.ARCHETYPE, Color(0.25, 0.45, 0.30),
		32, 5, 9, 4, 7, 9, 9, 4,
		45, 20, 55, 18, 40, 50, 45, 20
	)
	d.basic_range = 4
	d.basic_type  = AbilityData.DamageType.TECHNICAL
	d.basic_tag   = AbilityData.DamageTag.PIERCE
	d.abilities = [
		_basic_ranged("Tir précis", AbilityData.DamageTag.PIERCE, 4),
		_skill("Tir groupé", 3, AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.5, 3),
	]
	return d

static func support(faction: UnitData.Faction, level: int = 1) -> UnitData:
	var d := UnitData.make(
		"arch_support", "Médecin",
		faction, UnitData.Category.ARCHETYPE, Color(0.20, 0.65, 0.40),
		30, 3, 10, 3, 9, 8, 14, 4,
		42, 15, 55, 15, 48, 42, 70, 18
	)
	d.abilities = [
		_basic("Bâton", AbilityData.DamageTag.BLUNT, 1),
		_heal("Premiers soins", 2, 0.7, 3),
	]
	return d

# ── Private builders ────────────────────────────────────────────────────────

static func _basic(name: String, tag: AbilityData.DamageTag, range_val: int) -> AbilityData:
	return AbilityData.make(
		"basic", name, "Attaque basique.",
		0, range_val, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, tag, 1.0
	)

static func _basic_ranged(name: String, tag: AbilityData.DamageTag, range_val: int) -> AbilityData:
	return AbilityData.make(
		"basic", name, "Attaque basique à distance.",
		0, range_val, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, tag, 1.0
	)

static func _skill(
	name: String, range_val: int,
	dtype: AbilityData.DamageType, dtag: AbilityData.DamageTag,
	mult: float, nrj: int
) -> AbilityData:
	return AbilityData.make(
		"skill_" + name.to_lower().replace(" ", "_"), name, "",
		nrj, range_val, 0,
		AbilityData.TargetType.SINGLE_ENEMY, dtype, dtag, mult
	)

static func _skill_stun(name: String, range_val: int, mult: float, nrj: int, chance: float) -> AbilityData:
	var a := _skill(name, range_val, AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, mult, nrj)
	a.apply_status = StatusManager.Status.STUN
	a.status_chance = chance
	a.status_duration = 1
	return a

static func _skill_weakened(name: String, range_val: int, mult: float, nrj: int, chance: float) -> AbilityData:
	var a := _skill(name, range_val, AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, mult, nrj)
	a.apply_status = StatusManager.Status.WEAKENED
	a.status_chance = chance
	a.status_duration = 2
	return a

static func _heal(name: String, range_val: int, vol_mult: float, nrj: int) -> AbilityData:
	var a := AbilityData.make(
		"heal", name, "Soigne un allié.",
		nrj, range_val, 0,
		AbilityData.TargetType.SINGLE_ALLY,
		AbilityData.DamageType.HEAL, AbilityData.DamageTag.NONE, 0.0
	)
	a.heal_vol_multiplier = vol_mult
	return a
