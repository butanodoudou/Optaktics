class_name BalanceCalculator
# Outil de diagnostic d'équilibre des batailles.
# Calcule un score de Puissance de Combat (PC) par unité, puis compare les deux camps.
#
# Formule PC :
#   durabilite  = PV × (1 + (DEF + RES) / 30)
#   offense     = max(FOR, TEC) × meilleur_multiplicateur_dégâts
#   tempo       = 1 + AGI / 40
#   bonus_range = 1.0 / 1.15 / 1.30 selon portée max d'attaque
#   PC = (durabilite × offense × tempo × bonus_range) / NORMALISATION
#
# Ratio effectif = ratio_stats × sqrt(ratio_count)
# Le sqrt(ratio_count) capture l'avantage d'action économy sans l'exagérer.
#
# Verdicts :
#   < 0.60  → TROP FACILE
#   < 0.80  → Facile
#   ≤ 1.10  → Équilibré
#   ≤ 1.35  → Difficile
#   > 1.35  → TROP DUR

const _NORM := 1000.0

# ── Score d'une unité à un niveau donné ───────────────────────────────────────
static func unit_cp(data: UnitData, level: int) -> float:
	var pv   := data.pv_at(level)
	var atk  := maxi(data.for_at(level), data.tec_at(level))
	var def_ := data.def_at(level)
	var res  := data.res_at(level)
	var agi  := data.agi_at(level)

	var durability  := pv * (1.0 + (def_ + res) / 30.0)
	var offense     := atk * _best_dmg_multiplier(data)
	var tempo       := 1.0 + agi / 40.0
	var range_mult  := _range_bonus(_best_attack_range(data))

	return (durability * offense * tempo * range_mult) / _NORM


# ── Scores et comptes d'équipe ────────────────────────────────────────────────
static func team_score(placements: Array, is_player: bool) -> float:
	var total := 0.0
	for p in placements:
		if p.is_player == is_player:
			total += unit_cp(p.unit_data, p.level)
	return total

static func team_count(placements: Array, is_player: bool) -> int:
	var n := 0
	for p in placements:
		if p.is_player == is_player:
			n += 1
	return n


# ── Rapport pour une bataille ─────────────────────────────────────────────────
static func report(config: BattleConfig) -> void:
	var p_score := team_score(config.unit_placements, true)
	var e_score := team_score(config.unit_placements, false)
	var p_count := team_count(config.unit_placements, true)
	var e_count := team_count(config.unit_placements, false)

	var raw_ratio   := e_score / p_score if p_score > 0.0 else 0.0
	var count_ratio := float(e_count) / float(p_count) if p_count > 0 else 0.0
	var eff_ratio   := raw_ratio * sqrt(count_ratio)

	var label := "%s — %s" % [config.arc_name, config.battle_name]
	print("[Balance] %-45s | J:%d(%.1f) vs E:%d(%.1f) | stats:%.2f  count:%.2f  eff:%.2f  → %s" % [
		label,
		p_count, p_score,
		e_count, e_score,
		raw_ratio, count_ratio, eff_ratio,
		_verdict(eff_ratio),
	])


# ── Rapport complet (passe le tableau _arcs du GameManager) ───────────────────
static func report_all(arcs: Array) -> void:
	print("\n╔══════════════════════════════════════════════════════════════════════╗")
	print("║              RAPPORT D'ÉQUILIBRE — OPTAKTICS                        ║")
	print("╚══════════════════════════════════════════════════════════════════════╝")
	for arc in arcs:
		for callable: Callable in arc["battles"]:
			report(callable.call())
	print("════════════════════════════════════════════════════════════════════════\n")


# ── Interne ───────────────────────────────────────────────────────────────────
static func _verdict(ratio: float) -> String:
	if ratio < 0.60: return "TROP FACILE"
	if ratio < 0.80: return "Facile"
	if ratio <= 1.10: return "Équilibré"
	if ratio <= 1.35: return "Difficile"
	return "TROP DUR"

static func _best_dmg_multiplier(data: UnitData) -> float:
	var best := 1.0
	for ab: AbilityData in data.abilities:
		if ab.damage_type == AbilityData.DamageType.PHYSICAL \
		or ab.damage_type == AbilityData.DamageType.TECHNICAL:
			if ab.damage_multiplier > best:
				best = ab.damage_multiplier
	return best

static func _best_attack_range(data: UnitData) -> int:
	var best := data.basic_range
	for ab: AbilityData in data.abilities:
		if ab.damage_type == AbilityData.DamageType.PHYSICAL \
		or ab.damage_type == AbilityData.DamageType.TECHNICAL:
			if ab.range > best:
				best = ab.range
	return best

static func _range_bonus(range_val: int) -> float:
	if range_val >= 4: return 1.30
	if range_val >= 2: return 1.15
	return 1.0
