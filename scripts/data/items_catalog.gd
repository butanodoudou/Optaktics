class_name ItemsCatalog
# Catalogue de tous les objets consommables du jeu.
# Utiliser get(id) pour récupérer un ItemData par son identifiant.

# ── Nourriture — soins de PV ──────────────────────────────────────────────────
# Utilisés sur soi-même, coûtent 1 ACTION en combat.

static func morceau_viande() -> ItemData:
	return ItemData.make(
		"morceau_viande", "Morceau de viande",
		ItemData.Category.FOOD, ItemData.TargetType.SELF, 0,
		20, false, 0, false, 0, 0,
		50, Color(0.85, 0.35, 0.15)
	)

static func repas_copieux() -> ItemData:
	return ItemData.make(
		"repas_copieux", "Repas copieux",
		ItemData.Category.FOOD, ItemData.TargetType.SELF, 0,
		50, false, 0, false, 0, 0,
		120, Color(0.90, 0.55, 0.20)
	)

static func festin_baratie() -> ItemData:
	return ItemData.make(
		"festin_baratie", "Festin du Baratie",
		ItemData.Category.FOOD, ItemData.TargetType.SELF, 0,
		120, false, 0, false, 0, 0,
		280, Color(0.95, 0.75, 0.30)
	)

static func cuisse_dinde() -> ItemData:
	return ItemData.make(
		"cuisse_dinde", "Cuisse de dinde royale",
		ItemData.Category.FOOD, ItemData.TargetType.SELF, 0,
		0, true, 0, false, 0, 0,  # heal_hp_full = true
		500, Color(1.00, 0.85, 0.45)
	)

# ── Alcool — restauration de NRJ ─────────────────────────────────────────────

static func biere() -> ItemData:
	return ItemData.make(
		"biere", "Bière",
		ItemData.Category.ALCOHOL, ItemData.TargetType.SELF, 0,
		0, false, 2, false, 0, 0,
		40, Color(0.85, 0.70, 0.15)
	)

static func coupe_sake() -> ItemData:
	return ItemData.make(
		"coupe_sake", "Coupe de saké",
		ItemData.Category.ALCOHOL, ItemData.TargetType.SELF, 0,
		0, false, 5, false, 0, 0,
		100, Color(0.70, 0.80, 0.95)
	)

static func giga_bol_sake() -> ItemData:
	return ItemData.make(
		"giga_bol_sake", "Giga bol de saké",
		ItemData.Category.ALCOHOL, ItemData.TargetType.SELF, 0,
		0, false, 0, true, 0, 0,  # restore_nrj_full = true
		250, Color(0.55, 0.65, 1.00)
	)

# ── Boost — amélioration des stats alliées ───────────────────────────────────

static func epices_pimentees() -> ItemData:
	# BUFFED : FOR ×1.30 pendant 2 tours
	return ItemData.make(
		"epices_pimentees", "Épices de Sanji",
		ItemData.Category.BOOST, ItemData.TargetType.SELF, 0,
		0, false, 0, false,
		StatusManager.Status.BUFFED, 2,
		80, Color(1.00, 0.40, 0.10)
	)

static func elixir_rapide() -> ItemData:
	# HASTED : AGI ×1.50 pendant 2 tours (priorité dans l'ordre des tours)
	return ItemData.make(
		"elixir_rapide", "Élixir de rapidité",
		ItemData.Category.BOOST, ItemData.TargetType.SELF, 0,
		0, false, 0, false,
		StatusManager.Status.HASTED, 2,
		120, Color(0.30, 0.90, 0.60)
	)

# ── Débuff — affaiblissement des ennemis ─────────────────────────────────────

static func grenade_fumigene() -> ItemData:
	# BLIND : précision -40% pendant 2 tours
	return ItemData.make(
		"grenade_fumigene", "Grenade fumigène",
		ItemData.Category.DEBUFF, ItemData.TargetType.SINGLE_ENEMY, 3,
		0, false, 0, false,
		StatusManager.Status.BLIND, 2,
		80, Color(0.60, 0.60, 0.60)
	)

static func poudre_epuisement() -> ItemData:
	# WEAKENED : FOR ×0.70 pendant 2 tours
	return ItemData.make(
		"poudre_epuisement", "Poudre d'épuisement",
		ItemData.Category.DEBUFF, ItemData.TargetType.SINGLE_ENEMY, 3,
		0, false, 0, false,
		StatusManager.Status.WEAKENED, 2,
		100, Color(0.70, 0.30, 0.80)
	)

# ── Registre global ───────────────────────────────────────────────────────────

static func all() -> Array[ItemData]:
	return [
		morceau_viande(), repas_copieux(), festin_baratie(), cuisse_dinde(),
		biere(), coupe_sake(), giga_bol_sake(),
		epices_pimentees(), elixir_rapide(),
		grenade_fumigene(), poudre_epuisement(),
	]

static func get_by_id(p_id: String) -> ItemData:
	for item in all():
		if item.id == p_id:
			return item
	return null
