class_name EastBlueAbilities
# All skill definitions for East Blue — levels reflect the early-saga power level.
# abilities[0] = basic attack (nrj_cost = 0)
# abilities[1..n] = skills

# ═══════════════════════════════════════════════════
#  LUFFY  (Gomu Gomu no Mi, no Gear in East Blue)
# ═══════════════════════════════════════════════════

static func luffy_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Frappe caoutchouc",
		"Coup de poing élastique de base.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.0
	)

static func gomu_pistol() -> AbilityData:
	return AbilityData.make(
		"gomu_pistol", "Gomu Gomu no Pistol",
		"Le bras s'étire pour frapper à distance.",
		2, 3, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.5, "punch"
	)

static func gomu_bazooka() -> AbilityData:
	var a := AbilityData.make(
		"gomu_bazooka", "Gomu Gomu no Bazooka",
		"Double poing qui propulse la cible. 30 % d'étourdissement.",
		4, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 2.0, "punch"
	)
	a.apply_status    = StatusManager.Status.STUN
	a.status_chance   = 0.30
	a.status_duration = 1
	return a

static func gomu_gatling() -> AbilityData:
	return AbilityData.make(
		"gomu_gatling", "Gomu Gomu no Gatling",
		"Rafale de coups qui touche toutes les cases adjacentes.",
		5, 1, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.2, "punch"
	)

static func rubber_guard() -> AbilityData:
	var a := AbilityData.make(
		"rubber_guard", "Rubber Guard",
		"Réaction : quand frappé au corps à corps, renvoie 25 % des dégâts.",
		3, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 0.25, "hit"
	)
	a.is_reaction       = true
	a.reaction_trigger  = AbilityData.ReactionTrigger.ON_HIT_MELEE
	return a

# ═══════════════════════════════════════════════════
#  ZORO  (Santoryu basique)
# ═══════════════════════════════════════════════════

static func zoro_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Taillade à une lame",
		"Coup d'estoc basique.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.0, "slash"
	)

static func oni_giri() -> AbilityData:
	return AbilityData.make(
		"oni_giri", "Oni Giri",
		"Triple tranchant en croix — dégâts importants sur une cible.",
		3, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 2.2, "slash"
	)

static func tora_giri() -> AbilityData:
	return AbilityData.make(
		"tora_giri", "Tora Giri",
		"Frappe en ligne sur 3 cases devant Zoro.",
		4, 3, 0,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.6, "slash"
	)

static func tatsumaki() -> AbilityData:
	var a := AbilityData.make(
		"tatsumaki", "Tatsumaki",
		"Tornade de lames — zone 1, 20 % d'affaiblissement.",
		4, 1, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.3, "slash"
	)
	a.apply_status    = StatusManager.Status.WEAKENED
	a.status_chance   = 0.20
	a.status_duration = 2
	return a

static func dragon_twister_reaction() -> AbilityData:
	var a := AbilityData.make(
		"dragon_twister", "Dragon Twister (réaction)",
		"Contre-attaque automatique quand frappé au corps à corps.",
		2, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 0.8, "slash"
	)
	a.is_reaction      = true
	a.reaction_trigger = AbilityData.ReactionTrigger.ON_HIT_MELEE
	return a

# ═══════════════════════════════════════════════════
#  NAMI  (Bâton + talents de voleuse + météo)
# ═══════════════════════════════════════════════════

static func nami_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Coup de bâton",
		"Frappe au bâton de navigation.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 0.7
	)

static func thunderbolt_tempo() -> AbilityData:
	var a := AbilityData.make(
		"thunderbolt_tempo", "Météo : Éclair",
		"Appelle la foudre. Portée 4. 30 % d'étourdissement.",
		4, 4, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.NONE, 1.8, "lightning"
	)
	a.apply_status    = StatusManager.Status.STUN
	a.status_chance   = 0.30
	a.status_duration = 1
	return a

static func clima_fog() -> AbilityData:
	var a := AbilityData.make(
		"clima_fog", "Brouillard de Méteo",
		"Nuage aveuglant — zone 2, ennemis aveugles 2 tours.",
		3, 4, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0, "fog"
	)
	a.apply_status    = StatusManager.Status.BLIND
	a.status_chance   = 0.85
	a.status_duration = 2
	return a

static func pick_pocket() -> AbilityData:
	var a := AbilityData.make(
		"pick_pocket", "Vol de Nami",
		"Technique de voleuse — drène 3 NRJ à la cible.",
		2, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0
	)
	# Special: drained NRJ handled in battle_manager via apply_status
	# Using WEAKENED as proxy (reduce enemy action power)
	a.apply_status    = StatusManager.Status.WEAKENED
	a.status_chance   = 0.70
	a.status_duration = 1
	return a

static func nami_heal() -> AbilityData:
	var a := AbilityData.make(
		"nami_heal", "Premiers Secours",
		"Soigne un allié en portée 2.",
		3, 2, 0,
		AbilityData.TargetType.SINGLE_ALLY,
		AbilityData.DamageType.HEAL, AbilityData.DamageTag.NONE, 0.0, "heal"
	)
	a.heal_vol_multiplier = 0.9
	return a

# ═══════════════════════════════════════════════════
#  USOPP  (Fronde + accessoires)
# ═══════════════════════════════════════════════════

static func usopp_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Tir de fronde",
		"Tir standard à la fronde.",
		0, 4, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.0, "projectile"
	)

static func firebird_star() -> AbilityData:
	var a := AbilityData.make(
		"firebird_star", "Étoile Oiseau de Feu",
		"Projectile enflammé. 40 % de brûlure 3 tours.",
		3, 5, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.3, "fire"
	)
	a.apply_status    = StatusManager.Status.BURN
	a.status_chance   = 0.40
	a.status_duration = 3
	return a

static func smoke_star() -> AbilityData:
	var a := AbilityData.make(
		"smoke_star", "Étoile de Fumée",
		"Bombe fumigène — aveugle les ennemis en zone 2.",
		3, 5, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0, "smoke"
	)
	a.apply_status    = StatusManager.Status.BLIND
	a.status_chance   = 0.70
	a.status_duration = 2
	return a

static func kabuto_shot() -> AbilityData:
	var a := AbilityData.make(
		"kabuto_shot", "Tir Kabuto",
		"Précision maximale. Portée 6. Ignore 50 % de la RES.",
		5, 6, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 2.2, "projectile"
	)
	a.ignores_half_mitigation = true
	return a

# ═══════════════════════════════════════════════════
#  SANJI  (Coups de pied — pas de Diable Jambe)
# ═══════════════════════════════════════════════════

static func sanji_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Kick rapide",
		"Coup de pied éclair.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.0, "kick"
	)

static func collier_shoot() -> AbilityData:
	return AbilityData.make(
		"collier_shoot", "Collier Shoot",
		"Coup précis à la gorge.",
		2, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.8, "kick"
	)

static func party_table_kick() -> AbilityData:
	return AbilityData.make(
		"party_table_kick", "Party Table Kick",
		"Pirouette — frappe toutes les cases adjacentes.",
		3, 1, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.4, "kick"
	)

static func veau_shot() -> AbilityData:
	var a := AbilityData.make(
		"veau_shot", "Veau Shot",
		"Coup de pied estampillé — 25 % d'affaiblissement.",
		3, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.6, "kick"
	)
	a.apply_status    = StatusManager.Status.WEAKENED
	a.status_chance   = 0.25
	a.status_duration = 2
	return a

static func mutton_shot() -> AbilityData:
	var a := AbilityData.make(
		"mutton_shot", "Mutton Shot",
		"Coup de pied dévastateur — repousse la cible d'1 case.",
		4, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 2.0, "kick"
	)
	a.knockback = 1
	return a

# ═══════════════════════════════════════════════════
#  BOSS ABILITIES
# ═══════════════════════════════════════════════════

# ── Higuma ──────────────────────────────────────────
static func higuma_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Épée de bandit",
		"Coup tranchant de base.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.0
	)

static func higuma_intimidate() -> AbilityData:
	var a := AbilityData.make(
		"intimidate", "Intimidation",
		"Cri de guerre — affaiblit la cible 2 tours.",
		3, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0
	)
	a.apply_status    = StatusManager.Status.WEAKENED
	a.status_chance   = 0.90
	a.status_duration = 2
	return a

static func higuma_slash_wave() -> AbilityData:
	return AbilityData.make(
		"slash_wave", "Vague de Lame",
		"Tranchant puissant à portée 2.",
		3, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.5
	)

# ── Buggy (Bara Bara no Mi) ──────────────────────────
# Buggy's basic uses BLUNT (flying fist), NOT slash (immune to his own power)
static func buggy_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Poing Bara Bara",
		"Poing détaché propulsé sur la cible.",
		0, 3, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.0
	)

static func bara_bara_chop() -> AbilityData:
	return AbilityData.make(
		"bara_bara_chop", "Bara Bara Chop",
		"Poing volant renforcé à portée 3.",
		3, 3, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.5
	)

static func bara_bara_cannon() -> AbilityData:
	return AbilityData.make(
		"bara_bara_cannon", "Bara Bara Cannon",
		"Membres propulsés en zone 1.",
		4, 2, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.3
	)

static func muggy_ball() -> AbilityData:
	return AbilityData.make(
		"muggy_ball", "Muggy Ball",
		"Balle explosive technique — portée 4.",
		5, 4, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.NONE, 2.0, "explosion"
	)

# ── Captain Kuro ─────────────────────────────────────
static func kuro_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Griffes du Chat Noir",
		"Taillade avec les griffes-couteaux.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.2
	)

static func kuro_black_claw() -> AbilityData:
	return AbilityData.make(
		"black_claw", "Griffe Noire",
		"Frappe dévastatrice à une cible.",
		4, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 2.5
	)

static func kuro_mille_mains() -> AbilityData:
	# Self-buff: doubles AGI and makes attacks AOE for 2 turns
	var a := AbilityData.make(
		"mille_mains", "Mille Mains",
		"Mode Shakushi — AGI doublée, attaques touchent toutes cases adjacentes.",
		5, 0, 0,
		AbilityData.TargetType.SELF,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0
	)
	a.self_buff_agi_multiplier = 2.0
	return a

# ── Don Krieg ────────────────────────────────────────
static func krieg_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Masse de Fer",
		"Coup de masse blindée.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.0
	)

static func krieg_spear() -> AbilityData:
	return AbilityData.make(
		"battle_spear", "Lance de Bataille",
		"Projectile explosif à portée 4.",
		3, 4, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.PIERCE, 1.8
	)

static func krieg_gas_bomb() -> AbilityData:
	var a := AbilityData.make(
		"gas_bomb", "Bombe MH5",
		"Gaz poison zone 2 — affaiblit et brûle les cibles.",
		5, 3, 2,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.NONE, 0.8, "fog"
	)
	a.apply_status    = StatusManager.Status.WEAKENED
	a.status_chance   = 0.80
	a.status_duration = 3
	return a

# ── Arlong ────────────────────────────────────────────
static func arlong_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Frappe de requin",
		"Coup de Kiribachi (épée dentée).",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.2
	)

static func shark_on_tooth() -> AbilityData:
	return AbilityData.make(
		"shark_on_tooth", "Shark on Tooth",
		"Frappe dents en avant — portée 2.",
		3, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 2.0
	)

static func shark_on_darts() -> AbilityData:
	return AbilityData.make(
		"shark_on_darts", "Shark on Darts",
		"Dents projetées en zone.",
		4, 2, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.5
	)

static func kiribachi_slash() -> AbilityData:
	return AbilityData.make(
		"kiribachi", "Kiribachi",
		"Épée dentée géante — dégâts massifs.",
		5, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 2.8
	)

# ── Smoker (Moku Moku no Mi) ────────────────────────
static func smoker_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Jitte en seastone",
		"Coup de jitte — particulièrement dangereux pour Luffy.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.0
	)

static func smoker_white_out() -> AbilityData:
	var a := AbilityData.make(
		"white_out", "White Out",
		"Nuage de fumée dense — aveugle zone 2.",
		4, 3, 2,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0, "fog"
	)
	a.apply_status    = StatusManager.Status.BLIND
	a.status_chance   = 0.90
	a.status_duration = 2
	return a

static func smoker_smoke_charge() -> AbilityData:
	return AbilityData.make(
		"smoke_charge", "Charge de Fumée",
		"Smash de fumée compressée — dégâts techniques.",
		4, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.NONE, 2.0, "fog"
	)

static func smoker_stun_hold() -> AbilityData:
	var a := AbilityData.make(
		"stun_hold", "Prise de Fumée",
		"Immobilise une cible — étourdissement garanti.",
		5, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0
	)
	a.apply_status    = StatusManager.Status.STUN
	a.status_chance   = 0.95
	a.status_duration = 1
	return a

# ── Generic grunt basic attacks ───────────────────────────────────────────────
static func grunt_slash() -> AbilityData:
	return AbilityData.make(
		"basic", "Coup de sabre",
		"Attaque tranchante générique.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.0
	)

static func grunt_blunt() -> AbilityData:
	return AbilityData.make(
		"basic", "Coup de masse",
		"Attaque contondante générique.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.0
	)

# ═══════════════════════════════════════════════════
#  SHANKS  (Capitaine des Pirates aux Cheveux Rouges)
# ═══════════════════════════════════════════════════

static func shanks_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Taille",
		"Coup de sabre rapide et précis.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 1.2
	)

static func shanks_sovereign_slash() -> AbilityData:
	var a := AbilityData.make(
		"sovereign_slash", "Taille Souveraine",
		"Frappe dévastratrice qui repousse l'ennemi.",
		3, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 2.4
	)
	a.knockback = 2
	return a

# Haki du Conquérant : terrasse tous les ennemis proches
static func shanks_conqueror_haki() -> AbilityData:
	var a := AbilityData.make(
		"conqueror_haki", "Haki du Conquérant",
		"Pression de la volonté — étourdit les ennemis dans un rayon de 2 cases.",
		4, 1, 2,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0
	)
	a.apply_status  = 1  # STUN
	a.status_chance = 0.50
	a.status_duration = 1
	return a

# Frappe de la Mer Rouge : coup chargé, perce les défenses
static func shanks_red_sea_strike() -> AbilityData:
	var a := AbilityData.make(
		"red_sea_strike", "Frappe de la Mer Rouge",
		"Coup concentré qui transperce toute défense.",
		5, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.SLASH, 3.0
	)
	a.ignores_half_mitigation = true
	return a

# Regard Royal : réaction — quand Shanks est frappé, chance d'étourdir l'attaquant
static func shanks_royal_gaze_reaction() -> AbilityData:
	var a := AbilityData.make(
		"royal_gaze", "Regard Royal",
		"Le regard du Conquérant — paralyse l'attaquant au contact.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.STATUS_ONLY, AbilityData.DamageTag.NONE, 0.0
	)
	a.is_reaction       = true
	a.reaction_trigger  = AbilityData.ReactionTrigger.ON_HIT_MELEE
	a.apply_status      = 1  # STUN
	a.status_chance     = 0.65
	a.status_duration   = 1
	return a

# ═══════════════════════════════════════════════════
#  BECKMANN  (Premier Officier)
# ═══════════════════════════════════════════════════

static func beckmann_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Tir Standard",
		"Tir de pistolet précis à portée moyenne.",
		0, 3, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.0
	)

static func beckmann_headshot() -> AbilityData:
	var a := AbilityData.make(
		"headshot", "Tir à la Tête",
		"Tir ciblé qui étourdit la cible.",
		3, 5, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 2.0
	)
	a.apply_status  = 1  # STUN
	a.status_chance = 0.35
	return a

static func beckmann_covering_fire() -> AbilityData:
	var a := AbilityData.make(
		"covering_fire", "Feu de Couverture",
		"Salve qui aveugle tous les ennemis dans une zone.",
		4, 4, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.1
	)
	a.apply_status  = 4  # BLIND
	a.status_chance = 0.40
	return a

static func beckmann_deadeye() -> AbilityData:
	var a := AbilityData.make(
		"deadeye", "Œil du Maître",
		"Tir parfait — ignore toute protection.",
		5, 5, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 2.6
	)
	a.ignores_half_mitigation = true
	return a

# Réaction : contre-tir si un allié adjacent est frappé
static func beckmann_counter_shot_reaction() -> AbilityData:
	var a := AbilityData.make(
		"counter_shot", "Riposte de l'Officier",
		"Tire sur l'attaquant quand un allié est touché.",
		0, 4, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.2
	)
	a.is_reaction      = true
	a.reaction_trigger = AbilityData.ReactionTrigger.ON_ALLY_HIT
	return a

# ═══════════════════════════════════════════════════
#  LUCKY ROO  (Homme toujours affamé, toujours dangereux)
# ═══════════════════════════════════════════════════

static func lucky_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Coup de Poing",
		"Coup massif de la main droite.",
		0, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.1
	)

static func lucky_pistol_blast() -> AbilityData:
	return AbilityData.make(
		"pistol_blast", "Tir Rapproché",
		"Sort son pistolet et tire à bout portant.",
		2, 2, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 2.2
	)

static func lucky_body_slam() -> AbilityData:
	var a := AbilityData.make(
		"body_slam", "Écrasement",
		"Se jette dans la mêlée et renverse tous les ennemis proches.",
		3, 1, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 1.6
	)
	a.apply_status  = 1  # STUN
	a.status_chance = 0.25
	return a

# Lucky Roo mange pour récupérer des PV — toujours en train de manger
static func lucky_feast() -> AbilityData:
	var a := AbilityData.make(
		"feast", "Festin !",
		"S'arrête pour manger — récupère des PV.",
		2, 1, 0,
		AbilityData.TargetType.SELF,
		AbilityData.DamageType.HEAL, AbilityData.DamageTag.NONE, 0.0
	)
	a.heal_vol_multiplier = 1.8
	return a

static func lucky_point_blank() -> AbilityData:
	var a := AbilityData.make(
		"point_blank", "Tir au Canon",
		"Colle le canon de son arme sur l'ennemi. Dévastateur.",
		5, 1, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.PHYSICAL, AbilityData.DamageTag.BLUNT, 3.2
	)
	a.ignores_half_mitigation = true
	return a

# ═══════════════════════════════════════════════════
#  YASSOP  (Meilleur tireur de l'Est Blue — père d'Usopp)
# ═══════════════════════════════════════════════════

static func yassop_basic() -> AbilityData:
	return AbilityData.make(
		"basic", "Tir de Précision",
		"Tir à longue portée d'une précision chirurgicale.",
		0, 5, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.0
	)

static func yassop_vital_shot() -> AbilityData:
	var a := AbilityData.make(
		"vital_shot", "Cible Vitale",
		"Vise un point précis qui double la douleur.",
		3, 5, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 2.2
	)
	a.ignores_half_mitigation = true
	return a

static func yassop_curved_shot() -> AbilityData:
	var a := AbilityData.make(
		"curved_shot", "Tir Dévié",
		"Trajectoire courbe qui aveugle la cible.",
		3, 5, 0,
		AbilityData.TargetType.SINGLE_ENEMY,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.6
	)
	a.apply_status  = 4  # BLIND
	a.status_chance = 0.55
	return a

static func yassop_warning_shot() -> AbilityData:
	var a := AbilityData.make(
		"warning_shot", "Tir d'Avertissement",
		"Salve rapide qui aveugle une zone entière.",
		4, 4, 1,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.0
	)
	a.apply_status  = 4  # BLIND
	a.status_chance = 0.60
	return a

static func yassop_thousand_shots() -> AbilityData:
	return AbilityData.make(
		"thousand_shots", "Mille Tirs",
		"Barrage de balles qui couvre une zone entière.",
		5, 4, 2,
		AbilityData.TargetType.AOE_ENEMIES,
		AbilityData.DamageType.TECHNICAL, AbilityData.DamageTag.PIERCE, 1.3
	)
