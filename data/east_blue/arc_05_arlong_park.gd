class_name Arc05ArlongPark

# ── Bataille 1 : Portail d'entrée ─────────────────────────────────────────────
# Équipage complet (15) vs hommes-poissons
# Composition DIFFICILE : 3 DPS + 1 Tank + 1 Soutien
static func battle_01_front_gate() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_05_01"
	c.battle_name = "Arlong Park — Portail d'entrée"
	c.arc_name    = "Arlong Park"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.08, 0.22, 0.35)

	for x in range(0, 14):
		c.set_tile(x, 8, BattleConfig.TileType.WATER)
		c.set_tile(x, 9, BattleConfig.TileType.WATER)
	for y in range(5, 10):
		c.set_tile(0, y, BattleConfig.TileType.WATER)
	for y in range(0, 6):
		c.set_tile(12, y, BattleConfig.TileType.BLOCKED)
		c.set_tile(13, y, BattleConfig.TileType.BLOCKED)

	c.pre_battle_dialogue = [
		"Luffy : « ARLONG ! Rends le village de Nami ! »",
		"Hatchan : « Tu oses venir à Arlong Park ?! Style à six sabres ! »",
		"Nami : « Luffy… tu es venu pour moi. »",
		"Luffy : « Bien sûr. Tu es ma navigatrice ! »",
	]
	c.post_battle_dialogue = [
		"Hatchan : « Impossible… nous les hommes-poissons… plus forts que les humains… »",
		"Zoro : « Pas aujourd'hui. »",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(1, 4), true, 15)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(1, 6), true, 15)
	c.add_unit(EastBlueCharacters.nami(),   Vector2i(2, 3), true, 14)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(2, 7), true, 14)
	c.add_unit(EastBlueCharacters.sanji(),  Vector2i(1, 5), true, 15)

	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES), Vector2i(8,  2), false, 14)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES), Vector2i(10, 5), false, 14)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.PIRATES), Vector2i(8,  7), false, 14)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),            Vector2i(9,  4), false, 14)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),         Vector2i(11, 3), false, 13)
	return c


# ── Bataille 2 : Le Trône d'Arlong ───────────────────────────────────────────
# Arlong régénère 15 PV/tour sur cases eau — stratégie clé de le forcer hors de l'eau
static func battle_02_arlong_final() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_05_02"
	c.battle_name = "Arlong Park — Le Trône d'Arlong"
	c.arc_name    = "Arlong Park"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.05, 0.15, 0.30)
	c.objective   = BattleConfig.Objective.DEFEAT_BOSS

	# Canaux d'eau — Arlong se régénère dessus !
	for y in range(0, 10):
		c.set_tile(6, y, BattleConfig.TileType.WATER)
	for x in range(0, 14):
		c.set_tile(x, 5, BattleConfig.TileType.WATER)
	# Plateformes
	for x in range(0, 5):
		for y in range(0, 4):
			c.set_tile(x, y, BattleConfig.TileType.NORMAL)
	for x in range(0, 5):
		for y in range(6, 10):
			c.set_tile(x, y, BattleConfig.TileType.NORMAL)
	for x in range(7, 14):
		for y in range(0, 10):
			c.set_tile(x, y, BattleConfig.TileType.NORMAL)

	c.pre_battle_dialogue = [
		"Arlong : « Vous pensez pouvoir me battre ? Je suis Arlong des Pirates du Soleil ! »",
		"Nami : « Arlong… tu m'as forcée à voler pendant HUIT ANS ! »",
		"Luffy : « La salle des cartes de Nami… il l'a DÉTRUITE ! »",
		"Arlong : « Ces cartes m'appartenaient ! Tout ce qu'elle a m'appartient ! »",
		"Luffy : « Nami est mon amie — GOMU GOMU NO… »",
	]
	c.post_battle_dialogue = [
		"Arlong : « Un humain… m'a battu… »",
		"Nami : « Luffy… merci. »",
		"Luffy : « Je te l'avais dit. Tu es ma navigatrice. »",
		"Nami : « Je veux… dessiner une carte du monde entier ! »",
		"Luffy : « Alors partons ! »",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(2, 1), true, 17)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(2, 3), true, 17)
	c.add_unit(EastBlueCharacters.nami(),   Vector2i(3, 2), true, 16)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(1, 7), true, 16)
	c.add_unit(EastBlueCharacters.sanji(),  Vector2i(3, 8), true, 17)

	c.add_unit(EastBlueCharacters.arlong(),                              Vector2i(11, 4), false, 18)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(9,  2), false, 15)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(9,  6), false, 15)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(12, 3), false, 15)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(12, 7), false, 15)
	return c
