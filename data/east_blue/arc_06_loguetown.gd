class_name Arc06Loguetown

# ── Bataille finale : Loguetown — La chasse de Smoker ─────────────────────────
# Smoker réduit tous les dégâts physiques de 50 % — Nami et Usopp sont essentiels
# Composition DIFFICILE : 3 DPS + 1 Tank + 1 Soutien + Smoker (boss)
static func battle_01_smoker_chase() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_06_01"
	c.battle_name = "Loguetown — La Ville du Commencement et de la Fin"
	c.arc_name    = "Loguetown"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.20, 0.22, 0.28)
	c.objective   = BattleConfig.Objective.DEFEAT_BOSS

	# Place publique et échafaud
	for x in range(3, 11):
		c.set_tile(x, 4, BattleConfig.TileType.WOOD)
		c.set_tile(x, 5, BattleConfig.TileType.WOOD)
	c.set_tile(6, 3, BattleConfig.TileType.ELEVATED)
	c.set_tile(7, 3, BattleConfig.TileType.ELEVATED)
	for x in range(0, 3):
		c.set_tile(x, 0, BattleConfig.TileType.BLOCKED)
	for x in range(11, 14):
		c.set_tile(x, 0, BattleConfig.TileType.BLOCKED)

	c.pre_battle_dialogue = [
		"Smoker : « Chapeau de Paille Luffy. Prime de 30 000 000 Berrys. Rendez-vous. »",
		"Luffy : « Non ! Je pars pour la Grand Line ! »",
		"Smoker : « Aucun pirate ne quitte Loguetown. Smoky ! »",
		"Zoro : « C'est un utilisateur de Logia — on ne peut pas le toucher directement. »",
		"Luffy : « Les détails ! Allons-y — »",
		"Smoker : « Le caoutchouc ne peut pas blesser la fumée. C'est terminé pour toi. »",
		"Luffy : « Pas encore ! Tout le monde — au navire ! »",
	]
	c.post_battle_dialogue = [
		"Smoker : « …Je n'oublierai pas ça, Chapeau de Paille. »",
		"Luffy : « À bientôt dans la Grand Line, Smoker ! »",
		"Nami : « Un éclair… comme c'est pratique. »",
		"Luffy : « Hahahaha ! C'était Shanks — j'en suis sûr ! »",
		"─── Saga East Blue Terminée ! ───",
		"Les Chapeaux de Paille mettent cap sur la Grand Line !",
	]

	c.add_unit(EastBlueCharacters.luffy(),  Vector2i(1, 5), true, 19)
	c.add_unit(EastBlueCharacters.zoro(),   Vector2i(1, 7), true, 19)
	c.add_unit(EastBlueCharacters.nami(),   Vector2i(2, 3), true, 18)
	c.add_unit(EastBlueCharacters.usopp(),  Vector2i(2, 8), true, 18)
	c.add_unit(EastBlueCharacters.sanji(),  Vector2i(1, 6), true, 19)

	c.add_unit(EastBlueCharacters.smoker(),                              Vector2i(10, 4), false, 20)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.MARINES),       Vector2i(9,  2), false, 17)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.MARINES),  Vector2i(11, 3), false, 17)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.MARINES),  Vector2i(9,  6), false, 17)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.MARINES),             Vector2i(12, 5), false, 17)
	c.add_unit(ArchetypeData.support(UnitData.Faction.MARINES),          Vector2i(11, 7), false, 16)
	return c
