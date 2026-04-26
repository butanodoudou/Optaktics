class_name Arc02OrangeTown

# ── Bataille 1 : Entrée de la ville ──────────────────────────────────────────
# Luffy (6) + Zoro (6) + Nami (5)  vs Pirates de Buggy
# Composition MOYEN : 2 DPS + 1 Tank + 1 Soutien
static func battle_01_town_entrance() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_02_01"
	c.battle_name = "Orange Town — Entrée"
	c.arc_name    = "Orange Town"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.25, 0.20, 0.10)

	for x in range(4, 10):
		c.set_tile(x, 4, BattleConfig.TileType.WOOD)
		c.set_tile(x, 5, BattleConfig.TileType.WOOD)
	c.set_tile(1,  2, BattleConfig.TileType.BLOCKED)
	c.set_tile(2,  2, BattleConfig.TileType.BLOCKED)
	c.set_tile(11, 7, BattleConfig.TileType.BLOCKED)
	c.set_tile(12, 7, BattleConfig.TileType.BLOCKED)

	c.pre_battle_dialogue = [
		"Luffy : « Cette ville est complètement déserte… »",
		"Zoro : « Quelqu'un nous observe. »",
		"Nami : « Ce sont des Pirates de Buggy — je me tire ! »",
		"Luffy : « Attends, t'es qui toi ? Rejoins mon équipage ! »",
		"Nami : « QUOI?! Bats-les d'abord, idiot ! »",
	]
	c.post_battle_dialogue = [
		"Nami : « Vous deux, vous êtes fous. Mais… utiles. »",
		"Luffy : « Tu vois ? Tu devrais nous rejoindre ! »",
	]

	c.add_unit(EastBlueCharacters.luffy(), Vector2i(2, 4), true, 6)
	c.add_unit(EastBlueCharacters.zoro(),  Vector2i(2, 6), true, 6)
	c.add_unit(EastBlueCharacters.nami(),  Vector2i(1, 5), true, 5)

	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.PIRATES),  Vector2i(8,  3), false, 5)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(9,  5), false, 5)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(11, 4), false, 5)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),          Vector2i(10, 2), false, 4)
	return c


# ── Bataille 2 : Grand Chapiteau de Buggy ────────────────────────────────────
# Composition DIFFICILE : 3 DPS + 1 Tank + 1 Soutien + Buggy (boss)
static func battle_02_buggy_showdown() -> BattleConfig:
	var c := BattleConfig.new()
	c.battle_id   = "eb_02_02"
	c.battle_name = "Orange Town — Le Grand Chapiteau"
	c.arc_name    = "Orange Town"
	c.grid_width  = 14
	c.grid_height = 10
	c.background_color = Color(0.28, 0.18, 0.08)
	c.objective   = BattleConfig.Objective.DEFEAT_BOSS

	for x in range(5, 9):
		for y in range(3, 7):
			c.set_tile(x, y, BattleConfig.TileType.WOOD)

	c.pre_battle_dialogue = [
		"Buggy : « Vous OSEZ défier le Grand Capitaine Buggy ?! »",
		"Luffy : « Rends ce que tu as volé aux habitants ! »",
		"Buggy : « HAHAHA ! Bara Bara no Mi — tes attaques tranchantes sont INUTILES ! »",
		"Nami : « Il a raison, Luffy — les attaques normales ne marchent pas ! »",
		"Luffy : « Je trouverai quelque chose. Allons-y ! »",
	]
	c.post_battle_dialogue = [
		"Buggy : « I-Impossible ! Battu par un homme en caoutchouc ?! »",
		"Luffy : « On y va — prochain arrêt : Grand Line ! »",
		"Nami : « …Je suppose que je reste encore un peu. »",
	]

	c.add_unit(EastBlueCharacters.luffy(), Vector2i(2, 4), true, 7)
	c.add_unit(EastBlueCharacters.zoro(),  Vector2i(2, 6), true, 7)
	c.add_unit(EastBlueCharacters.nami(),  Vector2i(1, 5), true, 6)

	c.add_unit(EastBlueCharacters.buggy(),                               Vector2i(11, 4), false, 8)
	c.add_unit(ArchetypeData.dps_melee_slash(UnitData.Faction.PIRATES),  Vector2i(9,  3), false, 6)
	c.add_unit(ArchetypeData.dps_melee_blunt(UnitData.Faction.PIRATES),  Vector2i(8,  6), false, 6)
	c.add_unit(ArchetypeData.dps_ranged(UnitData.Faction.PIRATES),       Vector2i(10, 2), false, 6)
	c.add_unit(ArchetypeData.tank(UnitData.Faction.PIRATES),             Vector2i(9,  6), false, 6)
	c.add_unit(ArchetypeData.support(UnitData.Faction.PIRATES),          Vector2i(8,  2), false, 5)
	return c
