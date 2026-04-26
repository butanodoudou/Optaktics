class_name DamageCalculator

# All damage / healing / hit-rate formulas live here.
# References StatusManager for modifier lookups.

const VARIANCE_LOW  := 0.92
const VARIANCE_HIGH := 1.08
const BASE_HIT_RATE := 0.85
const AGI_HIT_STEP  := 0.03   # per AGI point of difference
const HIT_CAP_LOW   := 0.10
const HIT_CAP_HIGH  := 0.99

# ── Hit / Miss ────────────────────────────────────────────────────────────────

static func hit_rate(attacker_agi: int, defender_agi: int, attacker_statuses: Array) -> float:
	var rate := BASE_HIT_RATE + (attacker_agi - defender_agi) * AGI_HIT_STEP
	rate += StatusManager.get_hit_penalty(attacker_statuses)
	return clampf(rate, HIT_CAP_LOW, HIT_CAP_HIGH)

static func roll_hit(attacker_agi: int, defender_agi: int, attacker_statuses: Array) -> bool:
	return randf() < hit_rate(attacker_agi, defender_agi, attacker_statuses)


# ── Physical damage ───────────────────────────────────────────────────────────
# raw = FOR * multiplier
# mitigation = DEF / 2  (statusDEFx2 if FROZEN)
# base_dmg = max(1, raw - mitigation)
# damage = int(max(1, round(base_dmg * variance * tag_modifier)))

static func physical(
	for_stat: int,
	def_stat: int,
	multiplier: float,
	atk_tag: AbilityData.DamageTag,
	def_data: UnitData,
	attacker_statuses: Array,
	def_statuses: Array,
	ignores_half_mit: bool = false
) -> int:
	# Immunity check
	if atk_tag != AbilityData.DamageTag.NONE and atk_tag in def_data.damage_immunities:
		return 0

	var for_mult  := StatusManager.get_for_multiplier(attacker_statuses)
	var def_mult  := StatusManager.get_def_multiplier(def_statuses)
	var tag_mult  := float(def_data.damage_vulnerabilities.get(atk_tag, 1.0))

	var raw := for_stat * multiplier * for_mult
	var mit := def_stat * def_mult / (1.0 if ignores_half_mit else 2.0)
	var base := maxf(1.0, raw - mit)
	var variance := randf_range(VARIANCE_LOW, VARIANCE_HIGH)

	return int(max(1, round(base * variance * tag_mult)))


# ── Technical damage ──────────────────────────────────────────────────────────
# Same formula but uses TEC vs RES

static func technical(
	tec_stat: int,
	res_stat: int,
	multiplier: float,
	atk_tag: AbilityData.DamageTag,
	def_data: UnitData,
	_attacker_statuses: Array,
	_def_statuses: Array,
	ignores_half_mit: bool = false
) -> int:
	var tag_mult := float(def_data.damage_vulnerabilities.get(atk_tag, 1.0))
	var mit := res_stat / (1.0 if ignores_half_mit else 2.0)
	var base := maxf(1.0, tec_stat * multiplier - mit)
	var variance := randf_range(VARIANCE_LOW, VARIANCE_HIGH)
	return int(max(1, round(base * variance * tag_mult)))


# ── Healing ───────────────────────────────────────────────────────────────────
# heal = int(round(vol * vol_multiplier * variance))

static func heal_amount(vol_stat: int, vol_multiplier: float) -> int:
	var base := vol_stat * vol_multiplier
	var variance := randf_range(VARIANCE_LOW, VARIANCE_HIGH)
	return int(max(1, round(base * variance)))


# ── Dispatch: given an ability and two units, return damage dealt ─────────────

static func resolve(
	ability: AbilityData,
	attacker_for: int, attacker_tec: int, attacker_vol: int,
	attacker_statuses: Array,
	defender_def: int, defender_res: int,
	defender_data: UnitData, defender_statuses: Array
) -> int:
	match ability.damage_type:
		AbilityData.DamageType.PHYSICAL:
			return physical(
				attacker_for, defender_def, ability.damage_multiplier,
				ability.damage_tag, defender_data,
				attacker_statuses, defender_statuses,
				ability.ignores_half_mitigation
			)
		AbilityData.DamageType.TECHNICAL:
			return technical(
				attacker_tec, defender_res, ability.damage_multiplier,
				ability.damage_tag, defender_data,
				attacker_statuses, defender_statuses,
				ability.ignores_half_mitigation
			)
		AbilityData.DamageType.HEAL:
			return heal_amount(attacker_vol, ability.heal_vol_multiplier)
	return 0
