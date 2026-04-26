class_name EastBlueCharacters
# All character templates for East Blue.
# Stats are base values at level 1; use UnitData.stat_at_level() for actual values.
# Growth rates follow Fire Emblem convention: % chance of +1 per level.

# ═══════════════════════════════════════════════════
#  STRAW HAT PIRATES
# ═══════════════════════════════════════════════════

static func luffy() -> UnitData:
	#         id       name      faction                    cat                     color
	var d := UnitData.make(
		"luffy", "Luffy",
		UnitData.Faction.STRAW_HATS, UnitData.Category.PROTAGONIST, Color(0.85, 0.15, 0.15),
		# PV  FOR TEC DEF RES AGI VOL MOV
		 50,  12,  4,  8,  5,  8, 10,  5,
		# gPV  gFOR gTEC gDEF gRES gAGI gVOL
		  70,   60,  20,  40,  25,  50,  45,
		80
	)
	d.abilities = [
		EastBlueAbilities.luffy_basic(),
		EastBlueAbilities.gomu_pistol(),
		EastBlueAbilities.gomu_bazooka(),
		EastBlueAbilities.gomu_gatling(),
		EastBlueAbilities.rubber_guard(),
	]
	return d

static func zoro() -> UnitData:
	var d := UnitData.make(
		"zoro", "Zoro",
		UnitData.Faction.STRAW_HATS, UnitData.Category.PROTAGONIST, Color(0.15, 0.55, 0.15),
		55, 14,  4, 10,  4,  6,  8,  4,
		65, 70,  15, 50, 20, 40, 35,
		80
	)
	d.basic_tag = AbilityData.DamageTag.SLASH
	d.abilities = [
		EastBlueAbilities.zoro_basic(),
		EastBlueAbilities.oni_giri(),
		EastBlueAbilities.tora_giri(),
		EastBlueAbilities.tatsumaki(),
		EastBlueAbilities.dragon_twister_reaction(),
	]
	return d

static func nami() -> UnitData:
	var d := UnitData.make(
		"nami", "Nami",
		UnitData.Faction.STRAW_HATS, UnitData.Category.PROTAGONIST, Color(1.0, 0.65, 0.0),
		35,  5, 12,  4, 10, 12, 14,  5,
		45, 20, 65,  20, 50, 60, 65,
		60
	)
	d.abilities = [
		EastBlueAbilities.nami_basic(),
		EastBlueAbilities.thunderbolt_tempo(),
		EastBlueAbilities.clima_fog(),
		EastBlueAbilities.pick_pocket(),
		EastBlueAbilities.nami_heal(),
	]
	return d

static func usopp() -> UnitData:
	var d := UnitData.make(
		"usopp", "Usopp",
		UnitData.Faction.STRAW_HATS, UnitData.Category.PROTAGONIST, Color(0.55, 0.38, 0.15),
		38,  6, 10,  5,  8, 10, 10,  4,
		50, 30, 55,  25, 40, 55, 50,
		60
	)
	d.basic_range = 4
	d.basic_type  = AbilityData.DamageType.TECHNICAL
	d.basic_tag   = AbilityData.DamageTag.PIERCE
	d.abilities = [
		EastBlueAbilities.usopp_basic(),
		EastBlueAbilities.firebird_star(),
		EastBlueAbilities.smoke_star(),
		EastBlueAbilities.kabuto_shot(),
	]
	return d

static func sanji() -> UnitData:
	var d := UnitData.make(
		"sanji", "Sanji",
		UnitData.Faction.STRAW_HATS, UnitData.Category.PROTAGONIST, Color(0.95, 0.88, 0.25),
		48, 13,  6,  8,  6, 11,  9,  5,
		60, 65,  25, 40, 30, 60, 40,
		80
	)
	d.abilities = [
		EastBlueAbilities.sanji_basic(),
		EastBlueAbilities.collier_shoot(),
		EastBlueAbilities.party_table_kick(),
		EastBlueAbilities.veau_shot(),
		EastBlueAbilities.mutton_shot(),
	]
	return d

# ═══════════════════════════════════════════════════
#  ARC 1 — ROMANCE DAWN : Bandits de Higuma
# ═══════════════════════════════════════════════════

static func higuma() -> UnitData:
	var d := UnitData.make(
		"higuma", "Higuma",
		UnitData.Faction.BANDITS, UnitData.Category.DEVIL_FRUIT_USER, Color(0.4, 0.25, 0.15),
		60, 14,  4, 10,  5,  5,  8,  4,
		60, 45,  15, 45, 20, 25, 30,
		120
	)
	d.is_boss = true
	d.basic_tag = AbilityData.DamageTag.SLASH
	d.abilities = [
		EastBlueAbilities.higuma_basic(),
		EastBlueAbilities.higuma_intimidate(),
		EastBlueAbilities.higuma_slash_wave(),
	]
	return d

# ═══════════════════════════════════════════════════
#  ARC 2 — ORANGE TOWN : Buggy (Bara Bara no Mi)
# ═══════════════════════════════════════════════════

static func buggy() -> UnitData:
	var d := UnitData.make(
		"buggy", "Buggy",
		UnitData.Faction.PIRATES, UnitData.Category.DEVIL_FRUIT_USER, Color(0.85, 0.15, 0.85),
		70, 15, 12,  8, 10,  6, 10,  4,
		65, 50, 55,  35, 45, 30, 45,
		150
	)
	d.is_boss = true
	# Buggy est immunisé aux dégâts tranchants (son corps est segmenté)
	d.damage_immunities = [AbilityData.DamageTag.SLASH]
	# +30 % dégâts reçus depuis les techniques
	d.damage_vulnerabilities = { AbilityData.DamageTag.NONE: 1.3 }
	d.abilities = [
		EastBlueAbilities.buggy_basic(),
		EastBlueAbilities.bara_bara_chop(),
		EastBlueAbilities.bara_bara_cannon(),
		EastBlueAbilities.muggy_ball(),
	]
	return d

# ═══════════════════════════════════════════════════
#  ARC 3 — SYRUP VILLAGE : Capitaine Kuro (Mille Mains)
# ═══════════════════════════════════════════════════

static func kuro() -> UnitData:
	var d := UnitData.make(
		"kuro", "Capitaine Kuro",
		UnitData.Faction.PIRATES, UnitData.Category.DEVIL_FRUIT_USER, Color(0.05, 0.05, 0.05),
		80, 18,  6, 12,  8, 14, 10,  6,
		60, 65,  20, 50, 30, 55, 35,
		200
	)
	d.is_boss = true
	d.mille_mains_agi_mult = 2.0
	d.basic_tag = AbilityData.DamageTag.SLASH
	d.abilities = [
		EastBlueAbilities.kuro_basic(),
		EastBlueAbilities.kuro_black_claw(),
		EastBlueAbilities.kuro_mille_mains(),
	]
	return d

# ═══════════════════════════════════════════════════
#  ARC 4 — BARATIE : Don Krieg (Armure brisée)
# ═══════════════════════════════════════════════════

static func krieg() -> UnitData:
	var d := UnitData.make(
		"krieg", "Don Krieg",
		UnitData.Faction.PIRATES, UnitData.Category.DEVIL_FRUIT_USER, Color(0.45, 0.45, 0.50),
		110, 20,  5, 22, 10,  4, 12,  3,
		65, 55,  15, 40, 25, 20, 40,
		250
	)
	d.is_boss = true
	# À 50 % PV, l'armure se brise : WEAKENED permanent + DEF divisée par 2
	d.armor_break_threshold = 0.50
	d.basic_tag = AbilityData.DamageTag.BLUNT
	d.abilities = [
		EastBlueAbilities.krieg_basic(),
		EastBlueAbilities.krieg_spear(),
		EastBlueAbilities.krieg_gas_bomb(),
	]
	return d

# ═══════════════════════════════════════════════════
#  ARC 5 — ARLONG PARK : Arlong (Regen sur l'eau)
# ═══════════════════════════════════════════════════

static func arlong() -> UnitData:
	var d := UnitData.make(
		"arlong", "Arlong",
		UnitData.Faction.PIRATES, UnitData.Category.DEVIL_FRUIT_USER, Color(0.05, 0.35, 0.55),
		130, 26,  8, 14, 12,  8, 10,  5,
		70, 70,  25, 50, 35, 35, 40,
		300
	)
	d.is_boss = true
	# Régénère 15 PV par tour s'il est sur une case eau
	d.water_regen_pv = 15
	d.basic_tag = AbilityData.DamageTag.SLASH
	d.abilities = [
		EastBlueAbilities.arlong_basic(),
		EastBlueAbilities.shark_on_tooth(),
		EastBlueAbilities.shark_on_darts(),
		EastBlueAbilities.kiribachi_slash(),
	]
	return d

# ═══════════════════════════════════════════════════
#  ARC 6 — LOGUETOWN : Smoker (Réduction physique)
# ═══════════════════════════════════════════════════

static func smoker() -> UnitData:
	var d := UnitData.make(
		"smoker", "Smoker",
		UnitData.Faction.MARINES, UnitData.Category.DEVIL_FRUIT_USER, Color(0.85, 0.85, 0.85),
		120, 20, 18, 16, 16, 10, 14,  5,
		65, 55,  60, 50, 55, 45, 55,
		280
	)
	d.is_boss = true
	# Corps de fumée : tous les dégâts PHYSIQUES sont réduits de 50 %
	# Implémenté via une DEF très élevée contre les physiques
	# (ou via un flag spécial dans damage_calculator — on utilise vulnérabilité inverse)
	d.damage_vulnerabilities = {
		AbilityData.DamageTag.SLASH: 0.5,
		AbilityData.DamageTag.BLUNT: 0.5,
		AbilityData.DamageTag.PIERCE: 0.5,
	}
	d.abilities = [
		EastBlueAbilities.smoker_basic(),
		EastBlueAbilities.smoker_white_out(),
		EastBlueAbilities.smoker_smoke_charge(),
		EastBlueAbilities.smoker_stun_hold(),
	]
	return d
